Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1G2Eia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 00:38:30 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58904 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab1G2Ei3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 00:38:29 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.1
Date: Thu, 28 Jul 2011 21:37:33 -0700
Message-ID: <1311914253-1439-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 3.1 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Significant changes:
Moved PMBus drivers into their own subdirectory.
Added support for MAX1668, NTC thermistors, SA56004, LM95245,
LM95231, ADP4000, NCP4200, NCP4208, LM25066, LM5064, and LM5066.

Thanks,
Guenter Roeck

------

The following changes since commit 95b6886526bb510b8370b625a49bc0ab3b8ff10f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 (2011-07-27 19:26:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Alexander Stein (1):
      hwmon: LM95245 driver

David George (1):
      hwmon: Driver for MAX1668

Donggeun Kim (1):
      hwmon: Driver for NTC Thermistors

Durgadoss R (1):
      hwmon: (coretemp) Add core/pkg threshold support to Coretemp

Guenter Roeck (16):
      hwmon: (max1668) Add support for tempX_fault attributes
      hwmon: (lm95241) Add support for LM95231
      hwmon: (pmbus) Move PMBus drivers to drivers/hwmon/pmbus
      hwmon: (pmbus) Add support for VID output voltage mode
      hwmon: (pmbus) Add ADP4000, NCP4200 and NCP4208 to list of supported devices
      hwmon: (pmbus) Increase attribute name size
      hwmon: (pmbus) Support reading and writing of word registers in device specific code
      hwmon: (pmbus) Add support for virtual pages
      hwmon: (pmbus) Strengthen check for status register existence
      hwmon: Add new attributes to sysfs ABI
      hwmon: (pmbus) Add support for peak attributes
      hwmon: (adm1275) Add support for peak attributes
      hwmon: (max16064) Add support for peak attributes
      hwmon: (max8688) Add support for peak attributes
      hwmon: (max34440) Add support for peak attributes
      hwmon: (pmbus) Add client driver for LM25066, LM5064, and LM5066

Jean Delvare (3):
      hwmon: (lm90) Simplify handling of extended local temp register
      hwmon: (lm90) Make SA56004 detection more robust
      hwmon: (lm90) Refactor reading of config2 register

Stijn Devriendt (1):
      hwmon: (lm90) Add support for Philips SA56004

 Documentation/hwmon/adm1275                  |    8 +-
 Documentation/hwmon/coretemp                 |    7 +
 Documentation/hwmon/lm25066                  |   90 +++++
 Documentation/hwmon/lm90                     |    9 +-
 Documentation/hwmon/lm95245                  |   33 ++
 Documentation/hwmon/max16064                 |    4 +
 Documentation/hwmon/max1668                  |   60 +++
 Documentation/hwmon/max34440                 |    6 +
 Documentation/hwmon/max8688                  |    6 +
 Documentation/hwmon/ntc_thermistor           |   93 +++++
 Documentation/hwmon/pmbus                    |    7 +
 Documentation/hwmon/sysfs-interface          |   46 +++
 MAINTAINERS                                  |   18 +
 drivers/hwmon/Kconfig                        |  127 ++-----
 drivers/hwmon/Makefile                       |   13 +-
 drivers/hwmon/coretemp.c                     |  177 +++++++---
 drivers/hwmon/lm90.c                         |   65 ++-
 drivers/hwmon/lm95241.c                      |   31 +-
 drivers/hwmon/lm95245.c                      |  543 ++++++++++++++++++++++++++
 drivers/hwmon/max1668.c                      |  502 ++++++++++++++++++++++++
 drivers/hwmon/ntc_thermistor.c               |  453 +++++++++++++++++++++
 drivers/hwmon/pmbus/Kconfig                  |  100 +++++
 drivers/hwmon/pmbus/Makefile                 |   13 +
 drivers/hwmon/{ => pmbus}/adm1275.c          |   66 +++-
 drivers/hwmon/pmbus/lm25066.c                |  340 ++++++++++++++++
 drivers/hwmon/{ => pmbus}/max16064.c         |   57 +++-
 drivers/hwmon/{ => pmbus}/max34440.c         |   81 ++++-
 drivers/hwmon/{ => pmbus}/max8688.c          |   69 +++-
 drivers/hwmon/{ => pmbus}/pmbus.c            |   37 ++-
 drivers/hwmon/{ => pmbus}/pmbus.h            |   48 +++-
 drivers/hwmon/{ => pmbus}/pmbus_core.c       |  351 +++++++++++++----
 drivers/hwmon/{ => pmbus}/ucd9000.c          |    0
 drivers/hwmon/{ => pmbus}/ucd9200.c          |    0
 include/linux/platform_data/ntc_thermistor.h |   53 +++
 34 files changed, 3229 insertions(+), 284 deletions(-)
 create mode 100644 Documentation/hwmon/lm25066
 create mode 100644 Documentation/hwmon/lm95245
 create mode 100644 Documentation/hwmon/max1668
 create mode 100644 Documentation/hwmon/ntc_thermistor
 create mode 100644 drivers/hwmon/lm95245.c
 create mode 100644 drivers/hwmon/max1668.c
 create mode 100644 drivers/hwmon/ntc_thermistor.c
 create mode 100644 drivers/hwmon/pmbus/Kconfig
 create mode 100644 drivers/hwmon/pmbus/Makefile
 rename drivers/hwmon/{ => pmbus}/adm1275.c (67%)
 create mode 100644 drivers/hwmon/pmbus/lm25066.c
 rename drivers/hwmon/{ => pmbus}/max16064.c (66%)
 rename drivers/hwmon/{ => pmbus}/max34440.c (76%)
 rename drivers/hwmon/{ => pmbus}/max8688.c (72%)
 rename drivers/hwmon/{ => pmbus}/pmbus.c (89%)
 rename drivers/hwmon/{ => pmbus}/pmbus.h (79%)
 rename drivers/hwmon/{ => pmbus}/pmbus_core.c (84%)
 rename drivers/hwmon/{ => pmbus}/ucd9000.c (100%)
 rename drivers/hwmon/{ => pmbus}/ucd9200.c (100%)
 create mode 100644 include/linux/platform_data/ntc_thermistor.h
