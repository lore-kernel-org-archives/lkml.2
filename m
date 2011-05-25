Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1EYThY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:37:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30635 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab1EYThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:37:23 -0400
Date: Wed, 25 May 2011 21:35:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [GIT PULL] hwmon updates for 2.6.40
Message-ID: <20110525213549.51ba3f7a@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.40 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have support for new devices (SMSC EMC6W201, AMD Family 15h CPU,
Fintek F71808A) and various driver cleanups.

 Documentation/hwmon/emc6w201                       |   42 ++
 Documentation/hwmon/f71882fg                       |    4 +
 Documentation/hwmon/fam15h_power                   |   37 ++
 Documentation/hwmon/k10temp                        |    3 +-
 Documentation/hwmon/max6650                        |   21 +-
 MAINTAINERS                                        |    7 +
 arch/x86/Kconfig                                   |    1 +
 drivers/acpi/Kconfig                               |   11 -
 drivers/acpi/Makefile                              |    1 -
 drivers/char/i8k.c                                 |  166 ++++++-
 drivers/hwmon/Kconfig                              |   42 ++-
 drivers/hwmon/Makefile                             |    3 +
 drivers/hwmon/abituguru.c                          |    3 -
 drivers/hwmon/abituguru3.c                         |   13 -
 .../power_meter.c => hwmon/acpi_power_meter.c}     |    0
 drivers/hwmon/adcxx.c                              |   16 +-
 drivers/hwmon/emc6w201.c                           |  539 ++++++++++++++++++++
 drivers/hwmon/f71882fg.c                           |  115 ++++-
 drivers/hwmon/fam15h_power.c                       |  229 +++++++++
 drivers/hwmon/ibmaem.c                             |   10 +-
 drivers/hwmon/it87.c                               |   31 +-
 drivers/hwmon/jc42.c                               |    2 +-
 drivers/hwmon/k10temp.c                            |   11 +-
 drivers/hwmon/k8temp.c                             |    8 +-
 drivers/hwmon/lm70.c                               |   10 +-
 drivers/hwmon/max6650.c                            |   78 +--
 drivers/hwmon/sch5627.c                            |   46 ++-
 drivers/hwmon/ultra45_env.c                        |    4 +-
 include/linux/i2c.h                                |    2 +-
 29 files changed, 1305 insertions(+), 150 deletions(-)
 create mode 100644 Documentation/hwmon/emc6w201
 create mode 100644 Documentation/hwmon/fam15h_power
 rename drivers/{acpi/power_meter.c => hwmon/acpi_power_meter.c} (100%)
 create mode 100644 drivers/hwmon/emc6w201.c
 create mode 100644 drivers/hwmon/fam15h_power.c

---------------

Andre Przywara (1):
      hwmon: (k10temp) Add support for Fam15h (Bulldozer)

Andreas Herrmann (1):
      hwmon: Add driver for AMD family 15h processor power information

Hans de Goede (4):
      hwmon: (f71882fg) Split has_beep in fan_has_beep and temp_has_beep
      hwmon: (f71882fg) Add support for F71808A
      hwmon: (sch5627) Add sch5627_send_cmd function
      hwmon: (sch5627) Trigger Vbat measurements

Jean Delvare (9):
      hwmon: Use helper functions to set and get driver data
      hwmon: (jc42) Change detection class
      hwmon: (asc7621) Drop duplicate dependency
      Move ACPI power meter driver to hwmon
      hwmon: (max6650) Drop device detection
      hwmon: (max6650) Properly support the MAX6650
      i8k: Integrate with the hwmon subsystem
      hwmon: (abituguru) Depend on DMI
      hwmon: New driver for the SMSC EMC6W201

Luca Tettamanti (1):
      i8k: Avoid lahf in 64-bit code

Nat Gurumoorthy (1):
      hwmon: (it87) Use request_muxed_region

Thanks,
-- 
Jean Delvare
