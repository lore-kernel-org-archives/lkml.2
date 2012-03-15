Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031791Ab2COQoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:44:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52403 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031768Ab2COQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:44:23 -0400
From: jean.pihet@newoldbits.com
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 00/10] PM: Create the AVS class of drivers
Date: Thu, 15 Mar 2012 17:43:55 +0100
Message-Id: <1331829845-9526-1-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

AVS is a power management technique which controls the operating
voltage of a device in order to optimize (i.e. reduce) its power
consumption. The voltage is adapted depending on static factors
(chip manufacturing process) and dynamic factors (temperature
depending performance).
AVS is also called SmartReflex on OMAP devices.

To that end, create the AVS framework in drivers/power/avs and
move the OMAP SmartReflex code to the new directory.

In preparation to the move of the OMAP code the following changes have been
made:
- split the include files into generic and platform specific code,
- fill in platform data from the device initialization code and pass
  it to the driver,
- create CONFIG_AVS* config options accordingly.

The platform integration data for SmartReflex is passed from hwmod
and the voltage layer to the driver using pdata.


Tested on OMAP3 Beagleboard using omap2plus_defconfig with the
CONFIG_POWER_AVS* options set.
Based on master branch of the l-o git tree (3.3.0-rc6) [1], commit
85244e0edd240da2004bb2ab7cbcbc67a336f20d.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git


Jean Pihet (10):
  ARM: OMAP3+: voltage: export functions to plat/voltage.h
  ARM: OMAP2+: SmartReflex: move the platform specific macros in
    plat-omap
  ARM: OMAP3+: SmartReflex: class drivers should use struct omap_sr *
  ARM: OMAP2+: smartreflex: Use the names from hwmod data instead of
    voltage domains.
  ARM: OMAP3: hwmod: rename the smartreflex entries
  ARM: OMAP2+: SmartReflex: use the platform header file for voltage
    functions
  ARM: OMAP2+: SmartReflex: introduce a busy loop condition test macro
  ARM: OMAP2+: SmartReflex: Use per-OPP data structure
  ARM: OMAP2+: SmartReflex: add POWER_AVS Kconfig options
  ARM: OMAP: SmartReflex: Move smartreflex driver to drivers/

 arch/arm/mach-omap2/Makefile                  |    4 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c    |   11 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c    |    3 +-
 arch/arm/mach-omap2/pm.h                      |    2 +-
 arch/arm/mach-omap2/smartreflex-class3.c      |   60 --
 arch/arm/mach-omap2/smartreflex.c             | 1165 -------------------------
 arch/arm/mach-omap2/smartreflex.h             |  256 ------
 arch/arm/mach-omap2/sr_device.c               |   38 +-
 arch/arm/mach-omap2/voltage.h                 |    1 -
 arch/arm/mach-omap2/vp.h                      |    2 -
 arch/arm/plat-omap/Kconfig                    |   31 -
 arch/arm/plat-omap/include/plat/smartreflex.h |   95 ++
 arch/arm/plat-omap/include/plat/voltage.h     |    3 +
 drivers/power/Kconfig                         |    2 +
 drivers/power/Makefile                        |    2 +
 drivers/power/avs/Kconfig                     |   45 +
 drivers/power/avs/Makefile                    |    2 +
 drivers/power/avs/smartreflex-class3.c        |   60 ++
 drivers/power/avs/smartreflex.c               | 1117 ++++++++++++++++++++++++
 drivers/power/avs/smartreflex.h               |  238 +++++
 20 files changed, 1604 insertions(+), 1533 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/smartreflex-class3.c
 delete mode 100644 arch/arm/mach-omap2/smartreflex.c
 delete mode 100644 arch/arm/mach-omap2/smartreflex.h
 create mode 100644 arch/arm/plat-omap/include/plat/smartreflex.h
 create mode 100644 drivers/power/avs/Kconfig
 create mode 100644 drivers/power/avs/Makefile
 create mode 100644 drivers/power/avs/smartreflex-class3.c
 create mode 100644 drivers/power/avs/smartreflex.c
 create mode 100644 drivers/power/avs/smartreflex.h

-- 
1.7.5.4

