Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0HNTpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 15:45:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:9551 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0HNTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 15:45:18 -0400
Date: Sat, 14 Aug 2010 21:45:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon updates for 2.6.36
Message-ID: <20100814214505.42480679@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.35 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have support for new chips (SMSC EMC2103 and Nuvoton W83667HG-B),
improvements to the pc87427 driver, and random other small fixes,
improvements and cleanups.

 Documentation/hwmon/emc2103         |   33 ++
 Documentation/hwmon/ltc4245         |   24 +-
 Documentation/hwmon/pc87427         |   27 +-
 Documentation/hwmon/sysfs-interface |   29 +-
 Documentation/hwmon/w83627ehf       |   15 +-
 MAINTAINERS                         |   14 +
 drivers/hwmon/Kconfig               |   14 +-
 drivers/hwmon/Makefile              |    1 +
 drivers/hwmon/asc7621.c             |    9 +-
 drivers/hwmon/emc1403.c             |   33 ++
 drivers/hwmon/emc2103.c             |  740 ++++++++++++++++++++++++++++++
 drivers/hwmon/it87.c                |   46 ++-
 drivers/hwmon/k8temp.c              |    3 +-
 drivers/hwmon/lm75.c                |   39 ++
 drivers/hwmon/lm75.h                |    1 +
 drivers/hwmon/ltc4245.c             |  177 +++++++-
 drivers/hwmon/pc87360.c             |   31 +-
 drivers/hwmon/pc87427.c             |  862 ++++++++++++++++++++++++++++++++---
 drivers/hwmon/via-cputemp.c         |    2 +-
 drivers/hwmon/w83627ehf.c           |   97 ++++-
 include/linux/i2c/ltc4245.h         |   21 +
 21 files changed, 2085 insertions(+), 133 deletions(-)
 create mode 100644 Documentation/hwmon/emc2103
 create mode 100644 drivers/hwmon/emc2103.c
 create mode 100644 include/linux/i2c/ltc4245.h

---------------

Alan Cox (1):
      hwmon: (emc1403) Add power support

Guenter Roeck (4):
      hwmon: Add 3 critical limit attributes to sysfs-interface
      hwmon: Add 4 current alarm/beep attributes to sysfs-interface
      hwmon: (w83627ehf) Driver cleanup
      hwmon: (w83627ehf) Add support for W83667HG-B

H. Peter Anvin (1):
      hwmon: (via-cputemp) Remove bogus "SHOW" global variable

Ira W. Snyder (1):
      hwmon: (ltc4245) Expose all GPIO pins as analog voltages

Jean Delvare (11):
      hwmon: (pc87360) Fix device resource declaration
      hwmon: (it87) Export labels for internal sensors
      hwmon: (asc7621) Clean up and improve detect function
      hwmon: Remove in[0-*]_fault from sysfs-interface
      hwmon: (pc87427) Handle disabled fan inputs properly
      hwmon: (pc87427) Minor style cleanups
      hwmon: (pc87427) Add support for manual fan speed control
      hwmon: (pc87427) Add support for the second logical device
      hwmon: (pc87427) Add temperature monitoring support
      hwmon: (pc87427) Move sysfs file removal to a separate function
      hwmon: (pc87427) Add a maintainer

Julia Lawall (1):
      hwmon: (k8temp) Adjust confusing if indentation

Randy Dunlap (1):
      hwmon: jc42 depends on I2C

Shubhrajyoti Datta (1):
      hwmon: (lm75) Add suspend/resume feature

Steve Glendinning (1):
      hwmon: Add driver for SMSC EMC2103 temperature monitor and fan controller

Thanks,
-- 
Jean Delvare
