class DateUtil {
  static const int DAYS_IN_WEEK = 7;

  static const List<String> MONTH_LABEL = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> SHORT_MONTH_LABEL = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _WEEK_LABEL_BASE = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  /// Generate week labels starting from [startWeekday].
  ///
  /// [startWeekday] follows [DateTime]'s convention where Monday is 1 and
  /// Sunday is 7. The returned list always starts with an empty string so the
  /// labels can be accessed using 1-based indexing like the original
  /// [WEEK_LABEL] constant.
  static List<String> weekLabels(int startWeekday) {
    assert(startWeekday >= DateTime.monday &&
        startWeekday <= DateTime.sunday);
    return [
      '',
      for (int i = 0; i < DAYS_IN_WEEK; i++)
        _WEEK_LABEL_BASE[(startWeekday - 1 + i) % DAYS_IN_WEEK]
    ];
  }

  /// Get start day of month.
  static DateTime startDayOfMonth(final DateTime referenceDate) =>
      DateTime(referenceDate.year, referenceDate.month, 1);

  /// Get last day of month.
  static DateTime endDayOfMonth(final DateTime referenceDate) =>
      DateTime(referenceDate.year, referenceDate.month + 1, 0);

  /// Get exactly one year before of [referenceDate].
  static DateTime oneYearBefore(final DateTime referenceDate) =>
      DateTime(referenceDate.year - 1, referenceDate.month, referenceDate.day);

  /// Separate [referenceDate]'s month to List of every weeks.
  static List<Map<DateTime, DateTime>> separatedMonth(final DateTime referenceDate,
      {int startWeekday = DateTime.sunday}) {
    DateTime _startDate = startDayOfMonth(referenceDate);
    DateTime _endDate = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day +
            DAYS_IN_WEEK -
            weekdayOffset(_startDate.weekday, startWeekday) -
            1);
    DateTime _finalDate = endDayOfMonth(referenceDate);
    List<Map<DateTime, DateTime>> _savedMonth = [];

    while (_startDate.isBefore(_finalDate) || _startDate == _finalDate) {
      _savedMonth.add({_startDate: _endDate});
      _startDate = changeDay(_endDate, 1);
      DateTime tentativeEnd = changeDay(_startDate, DAYS_IN_WEEK - 1);
      _endDate = tentativeEnd.month == _startDate.month
          ? tentativeEnd
          : endDayOfMonth(_startDate);
    }
    return _savedMonth;
  }

  /// Change day of [referenceDate].
  static DateTime changeDay(final DateTime referenceDate, final int dayCount) =>
      DateTime(referenceDate.year, referenceDate.month,
          referenceDate.day + dayCount);

  /// Change month of [referenceDate].
  static DateTime changeMonth(final DateTime referenceDate, int monthCount) =>
      DateTime(referenceDate.year, referenceDate.month + monthCount,
          referenceDate.day);

  //#region unused methods.

  // static int weekCount(final DateTime referenceDate) {
  //   return ((startDayOfMonth(referenceDate).weekday % DAYS_IN_WEEK +
  //               endDayOfMonth(referenceDate).day) /
  //           DAYS_IN_WEEK)
  //       .ceil();
  // }

  // static int weekPos(final DateTime referenceDate) =>
  //     (referenceDate.day +
  //         startDayOfMonth(referenceDate).weekday % DAYS_IN_WEEK) ~/
  //     DAYS_IN_WEEK;

  // static DateTime startDayOfWeek(final DateTime referenceDate) =>
  //     weekPos(referenceDate) == 0
  //         ? startDayOfMonth(referenceDate)
  //         : DateTime(referenceDate.year, referenceDate.month,
  //             referenceDate.day - referenceDate.weekday % DAYS_IN_WEEK);

  // static DateTime endDayOfWeek(final DateTime referenceDate) {
  //   return weekPos(referenceDate) != (weekCount(referenceDate) - 1)
  //       ? DateTime(referenceDate.year, referenceDate.month,
  //           referenceDate.day - referenceDate.weekday % DAYS_IN_WEEK + 6)
  //       : endDayOfMonth(referenceDate);
  // }

  // static DateTime changeWeek(final DateTime referenceDate, int weekCount) =>
  //     DateTime(referenceDate.year, referenceDate.month,
  //         1 + DAYS_IN_WEEK * weekCount);

  // static bool compareDate(final DateTime first, final DateTime second) =>
  //     first.year == second.year &&
  //     first.month == second.month &&
  //     first.day == second.day;

  // static bool isStartDayOfMonth(final DateTime referenceDate) =>
  //     compareDate(referenceDate, startDayOfMonth(referenceDate));

  /// Convert [weekday] into index based on [startWeekday].
  /// Returns 0 for the first day of the week and 6 for the last.
  static int weekdayOffset(int weekday, int startWeekday) {
    assert(weekday >= DateTime.monday && weekday <= DateTime.sunday);
    assert(startWeekday >= DateTime.monday &&
        startWeekday <= DateTime.sunday);
    return (weekday - startWeekday + DAYS_IN_WEEK) % DAYS_IN_WEEK;
  }

  //#endregion
}
