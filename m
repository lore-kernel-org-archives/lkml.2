Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1BQTCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:02:48 -0500
Received: from imr3.ericy.com ([198.24.6.13]:55099 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768Ab1BQTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:01:45 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v4 0/5] hwmon: PMBus device driver
Date: Thu, 17 Feb 2011 11:00:12 -0800
Message-ID: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for hardware monitoring features of PMBus devices.

---
I did not get significant feedback from the previous submission, so here it is
again with extended audience. Only change since v3 is a minor fix in Kconfig.

I understand this is a large patch set. Question is if it would make sense
to create its own subdirectory for pmbus devices, and to split pmbus.c and
pmbus_core.c into more files. I'd be more than happy to do that if it helps
for the review process.

There is still some work to be done. Fan support is only rudimentary,
and the PHASE command is still not supported. However, the driver
is now stable enough to be useful, so it is worth going ahead.

v4 changes:
- Fixed PMBUS entry in Kconfig

v3 changes:
  Tested with real hardware (bmr453, bmr454, ltc2978, max8688, max16064,
  max34441).
  Changes are too numerous to count. Lots of bug fixes. Code was completely
  rearranged to permit addition of chips without having to modify the core
  pmbus driver. Split main driver into pmbus_core.c for core support and
  pmbus.c as front-end driver to support generic PMBus chips.
  Support for additional chips can now be added by writing small front-end
  drivers which basically describe chip capabilities.

v2 changes:
- Calculate maximum number of attributes / sensors / booleans / labels instead
  of using defines
- Increased maximum number of supported pages to the PMBus maximum of 32.
- Replaced most fixed size arrays with dynamically allocated arrays/structures.
- Added comments and clarifications
- Renamed local defines to start with PB_ or PMBUS_ prefix
- Removed pages module parameter. Replaced with code to auto-detect the number
  of supported pages.
- Split probe code into several functions to make it better readable
- Replaced _fault attributes with _lcrit_alarm and _crit_alarm attributes
- Several other minor changes to address review feedback
- PMBus emulator: Fixed fault status detection code. Also use more reasonable
  power limits (eg 200W instead of 2kW).
