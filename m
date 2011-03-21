Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1CUTE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:04:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:41760 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1CUTEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:04:55 -0400
Date: Mon, 21 Mar 2011 20:04:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon updates for 2.6.39
Message-ID: <20110321200441.73f62e56@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.38 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have support for two new devices: Analog Devices ADS1015 and SMSC
SCH5627. And the lis3lv02d modules were finally kicked out of
drivers/hwmon.

 .../devicetree/bindings/hwmon/ads1015.txt          |   73 ++
 Documentation/hwmon/ads1015                        |   72 ++
 Documentation/hwmon/lm75                           |    5 +
 Documentation/hwmon/sch5627                        |   22 +
 Documentation/hwmon/w83795                         |  127 +++
 Documentation/{hwmon => laptops}/hpfall.c          |    0
 Documentation/{hwmon => misc-devices}/lis3lv02d    |    4 +-
 MAINTAINERS                                        |   21 +-
 drivers/hwmon/Kconfig                              |   85 +--
 drivers/hwmon/Makefile                             |    5 +-
 drivers/hwmon/abituguru.c                          |    4 +-
 drivers/hwmon/abituguru3.c                         |    4 +-
 drivers/hwmon/ads1015.c                            |  337 ++++++++
 drivers/hwmon/lm75.c                               |   66 +-
 drivers/hwmon/sch5627.c                            |  858 ++++++++++++++++++++
 drivers/hwmon/sht15.c                              |    6 +-
 drivers/misc/Kconfig                               |    9 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/lis3lv02d/Kconfig                     |   37 +
 drivers/misc/lis3lv02d/Makefile                    |    7 +
 drivers/{hwmon => misc/lis3lv02d}/lis3lv02d.c      |    3 +-
 drivers/{hwmon => misc/lis3lv02d}/lis3lv02d.h      |    0
 drivers/{hwmon => misc/lis3lv02d}/lis3lv02d_i2c.c  |    2 +-
 drivers/{hwmon => misc/lis3lv02d}/lis3lv02d_spi.c  |    0
 drivers/platform/x86/Kconfig                       |   18 +
 drivers/platform/x86/Makefile                      |    1 +
 drivers/{hwmon => platform/x86}/hp_accel.c         |    7 +-
 include/linux/i2c/ads1015.h                        |   36 +
 28 files changed, 1702 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ads1015.txt
 create mode 100644 Documentation/hwmon/ads1015
 create mode 100644 Documentation/hwmon/sch5627
 create mode 100644 Documentation/hwmon/w83795
 rename Documentation/{hwmon => laptops}/hpfall.c (100%)
 rename Documentation/{hwmon => misc-devices}/lis3lv02d (96%)
 create mode 100644 drivers/hwmon/ads1015.c
 create mode 100644 drivers/hwmon/sch5627.c
 create mode 100644 drivers/misc/lis3lv02d/Kconfig
 create mode 100644 drivers/misc/lis3lv02d/Makefile
 rename drivers/{hwmon => misc/lis3lv02d}/lis3lv02d.c (99%)
 rename drivers/{hwmon => misc/lis3lv02d}/lis3lv02d.h (100%)
 rename drivers/{hwmon => misc/lis3lv02d}/lis3lv02d_i2c.c (99%)
 rename drivers/{hwmon => misc/lis3lv02d}/lis3lv02d_spi.c (100%)
 rename drivers/{hwmon => platform/x86}/hp_accel.c (99%)
 create mode 100644 include/linux/i2c/ads1015.h

---------------

Dirk Eibach (2):
      hwmon: Add support for Texas Instruments ADS1015
      hwmon: (ads1015) Make gain and datarate configurable

Hans de Goede (2):
      hwmon: (abituguru*) Update my email address
      hwmon: New driver for SMSC SCH5627

Jean Delvare (7):
      hwmon: (w83795) Document pin mapping
      Let Kconfig handle lis3lv02d dependencies
      Move hp_accel to drivers/platform/x86
      Move lis3lv02d drivers to drivers/misc
      hp_accel: Fix driver name
      hwmon: (lm75) Speed up detection
      hwmon: (ads1015) Drop dynamic attribute group

Justin P. Mattock (1):
      hwmon: (sht15) Spelling fix

Len Sorensen (1):
      hwmon: (lm75) Add detection of the National Semiconductor LM75A

Vivien Didelot (1):
      hwmon: (sht15) Fix integer overflow in humidity calculation

Thanks,
-- 
Jean Delvare
