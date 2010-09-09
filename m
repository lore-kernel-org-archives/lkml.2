Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0IINWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:22:20 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58431 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0IINWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:22:17 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 0/7] hwmon: Add support for MAX6695/6696 to lm90 driver
Date: Thu, 9 Sep 2010 06:25:43 -0700
Message-ID: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the lm90 driver and adds support for
Maxim MAX6695/6696 temperature sensors.

In detail,
- Add support for tempX_emergency_alarm ABI attribute
- Introduce device feature bits to reduce runtime overhead
- Introduce function to delete sysfs files
- Simplify calculations in set_temp11()
- Introduce 3rd set of upper temperature limits (named 'emergency' limits)
- Add max6659 support for those limits, and add support for max6659 address 0x4e
- Add max6695/96 support

The patchset depends on the previously submitted lm90 driver cleanup patch.

v2 changes:
- Split patch into multiple parts
- Add support for max6659 address 0x4e and extra features
- Improved max6695/96 device detection code
- max6695/96 does not support extended external limits, so don't try to
  read them for the 3rd sensor
- Other changes to address review feedback
  - Updated Documentation/hwmon/lm90 and drivers/hwmon/Kconfig.
  - Fixed alert_alarms comment
  - remote offset register not supported on max6658 (fixed comment)
  - rewrote set_temp11()
  - Added tempX_emergency_alarm
  - Some code alignment fixes
