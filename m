Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1CPSom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:44:42 -0400
Received: from imr4.ericy.com ([198.24.6.8]:49539 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1CPSoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:44:38 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon changes for 2.6.39
Date: Wed, 16 Mar 2011 11:49:38 -0700
Message-ID: <1300301378-30788-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem changes for Linux 2.6.39 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Added support for several new devices this time around. Most notable addition
is probably the PMBus driver, which provides support for a whole class of devices.

Thanks,
Guenter Roeck

------

The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:

  Linux 2.6.38 (2011-03-14 18:20:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (29):
      hwmon: Add support for Lineage Compact Power Line PEM devices
      hwmon: (lm85) Use boolean to determine if VID5 is configured
      hwmon: (lm85) Use function to remove sysfs attribute files
      hwmon: (lm85) Do not update hysteresis and temp_auto_off if auto_temp_min is changed
      hwmon: (lm85) Add support for EMC6D103S
      hwmon: PMBus device driver
      hwmon: PMBus driver documentation
      hwmon: (pmbus) Add support for Maxim MAX8688
      hwmon: (pmbus) Add support for Maxim MAX16064
      hwmon: (pmbus) Add support for Maxim MAX34440/MAX34441
      hwmon: (pmbus) More stringent checking of VOUT_MODE register
      hwmon: (pmbus) Improve support for paged fans
      hwmon: (pmbus) Improve support for paged temperature sensors
      hwmon: (pmbus) Continuously update temperature limit registers
      hwmon: (pmbus) Fix LINEAR16 data format
      hwmon: Add tachometer pulses per fan revolution to sysfs ABI
      hwmon: (w83627ehf) Unify temperature register access, and use strict string conversions
      hwmon: (w83627ehf) Fixed most checkpatch warnings and errors
      hwmon: (w83627ehf) Optimize multi-bank register access
      hwmon: (w83627ehf) Improve support for W83667HG-B
      hwmon: (w83627ehf) Remove references to datasheets which no longer exist
      hwmon: (w83627ehf) Convert register arrays to 16 bit, and convert access to pointers
      hwmon: (w83627ehf) Permit enabling SmartFan IV mode if configured at startup
      hwmon: (w83627ehf) Add support for Nuvoton NCT6775F and NCT6776F
      hwmon: (w83627ehf) Use 16 bit fan count registers if supported
      hwmon: (w83627ehf) Store rpm instead of raw fan speed data
      hwmon: (w83627ehf) Update Kconfig for W83677HG-B, NCT6775F and NCT6776F
      hwmon: (w83627ehf) Display correct temperature sensor labels for systems with NCT6775F
      hwmon: (lineage-pem): Fix in1 voltage alarm sysfs attributes

Hans de Goede (10):
      hwmon/f71882fg: Fix temp1 sensor type reporting
      hwmon/f71882fg: Only allow negative auto point temps if fan_neg_temp is enabled
      hwmon/f71882fg: Make creation of in sysfs attributes more generic
      hwmon/f71882fg: Make number of temps configurable
      hwmon/f71882fg: Remove bogus temp2_type for certain models
      hwmon/f71882fg: Separate temp beep sysfs attr from the other temp sysfs attr
      hwmon/f71882fg: Break out test for auto pwm's controlled by digital readings
      hwmon/f71882fg: Add support for f71889ed
      hwmon/f71882fg: Add support for f71869f and f71869e
      hwmon/f71882fg: Add support for f71808e

Ian Dobson (1):
      hwmon: (w83627ehf) Add fan debounce support for NCT6775F and NCT6776F

Mark Brown (1):
      hwmon: (lis3lv02d) Convert SPI to dev_pm_ops

per.dalen@appeartv.com (1):
      hwmon: Add support for LTC4151

stigge@antcom.de (2):
      hwmon: Driver for Maxim MAX6639
      hwmon: (max6639) Set reasonable default PWM frequency

 Documentation/hwmon/f71882fg        |   16 +-
 Documentation/hwmon/lineage-pem     |   77 ++
 Documentation/hwmon/lm85            |   12 +-
 Documentation/hwmon/ltc4151         |   47 +
 Documentation/hwmon/max6639         |   49 +
 Documentation/hwmon/pmbus           |  215 +++++
 Documentation/hwmon/sysfs-interface |   11 +
 Documentation/hwmon/w83627ehf       |   60 +-
 drivers/hwmon/Kconfig               |   92 ++-
 drivers/hwmon/Makefile              |   10 +
 drivers/hwmon/f71882fg.c            |  522 ++++++++----
 drivers/hwmon/lineage-pem.c         |  586 +++++++++++++
 drivers/hwmon/lis3lv02d_spi.c       |   19 +-
 drivers/hwmon/lm85.c                |  136 ++--
 drivers/hwmon/ltc4151.c             |  256 ++++++
 drivers/hwmon/max16064.c            |   91 ++
 drivers/hwmon/max34440.c            |  199 +++++
 drivers/hwmon/max6639.c             |  653 ++++++++++++++
 drivers/hwmon/max8688.c             |  158 ++++
 drivers/hwmon/pmbus.c               |  203 +++++
 drivers/hwmon/pmbus.h               |  313 +++++++
 drivers/hwmon/pmbus_core.c          | 1658 +++++++++++++++++++++++++++++++++++
 drivers/hwmon/w83627ehf.c           | 1351 +++++++++++++++++++++-------
 include/linux/i2c/max6639.h         |   14 +
 include/linux/i2c/pmbus.h           |   45 +
 25 files changed, 6208 insertions(+), 585 deletions(-)
 create mode 100644 Documentation/hwmon/lineage-pem
 create mode 100644 Documentation/hwmon/ltc4151
 create mode 100644 Documentation/hwmon/max6639
 create mode 100644 Documentation/hwmon/pmbus
 create mode 100644 drivers/hwmon/lineage-pem.c
 create mode 100644 drivers/hwmon/ltc4151.c
 create mode 100644 drivers/hwmon/max16064.c
 create mode 100644 drivers/hwmon/max34440.c
 create mode 100644 drivers/hwmon/max6639.c
 create mode 100644 drivers/hwmon/max8688.c
 create mode 100644 drivers/hwmon/pmbus.c
 create mode 100644 drivers/hwmon/pmbus.h
 create mode 100644 drivers/hwmon/pmbus_core.c
 create mode 100644 include/linux/i2c/max6639.h
 create mode 100644 include/linux/i2c/pmbus.h
