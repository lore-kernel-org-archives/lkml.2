Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2DZRlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:41:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40699 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab2DZRlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:41:12 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <khilman@ti.com>, <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
CC: <j-pihet@ti.com>, <j-keerthy@ti.com>
Subject: [PATCH V3 00/10] PM: Create the AVS(Adaptive Voltage Scaling)
Date: Thu, 26 Apr 2012 23:10:31 +0530
Message-ID: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

AVS(Adaptive Voltage Scaling) is a power management technique which
controls the operating voltage of a device in order to optimize (i.e. reduce)
its power consumption. The voltage is adapted depending on static factors
(chip manufacturing process) and dynamic factors (temperature
depending performance).
The TI AVS solution is named Smartreflex. 

To that end, create the AVS driver in drivers/power/avs and
move the OMAP SmartReflex code to the new directory. The
class driver is still retained in the mach-omap2 directory.

In preparation to the move of the OMAP code the following changes have been
made:
- fill in platform data from the device initialization code and pass
 it to the driver,
- create CONFIG_AVS* config options accordingly.

The platform integration data for SmartReflex is passed from hwmod
and the voltage layer to the driver using pdata.

Tested on OMAP4430 SDP using omap2plus_defconfig with the
CONFIG_POWER_AVS* options set. Voltage correction seen
on oscilloscope on all three VDDs.
Based on master branch of the l-o git tree, commit
6bd61e8de0511dd9831eb9d89eea0b4603a10e9e.

Tree: git://gitorious.org/~keerthy05/omap-pm/keerthy-sr.git for_smartreflex_ip_driver_move 

V3: rework after the comments on MLs
 . Retain Efuse offsets check to identify a particular OPP.
 . Introduce a common header file accessible both by arch/arm/mach-omap2/
   and drivers/.
 . Retain the class driver in mach-omap2/ and move IP driver to drivers/power/
   avs since class driver needs voltage layer support.

History:
v2: rework after the comments on MLs
 . Keep the OMAP Kconfig options in the arch dir (Rafael),
 . Move the shared header file from plat-omap to
   include/linux/power/ (Tony)

v1: initial revision

J Keerthy (1):
  ARM: OMAP2+: Voltage: Move the omap_volt_data structure to plat

Jean Pihet (9):
  ARM: OMAP2+: SmartReflex: move the smartreflex header to include/linux/power
  ARM: OMAP3+: SmartReflex: class drivers should use struct omap_sr *
  ARM: OMAP2+: smartreflex: Use the names from hwmod data instead of
    voltage domains.
  ARM: OMAP3: hwmod: rename the smartreflex entries
  ARM: OMAP2+: SmartReflex: introduce a busy loop condition test macro
  ARM: OMAP2+: SmartReflex: Use per-OPP data structure
  ARM: OMAP2+: SmartReflex: Create per-opp debugfs node for errminlimit
  ARM: OMAP2+: SmartReflex: add POWER_AVS Kconfig options
  ARM: OMAP: SmartReflex: Move smartreflex driver to drivers/
 arch/arm/mach-omap2/Makefile                       |    5 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   12 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    3 +-
 arch/arm/mach-omap2/pm.h                           |    2 +-
 arch/arm/mach-omap2/smartreflex-class3.c           |   29 ++--
 arch/arm/mach-omap2/sr_device.c                    |   39 ++++-
 arch/arm/mach-omap2/voltage.h                      |   21 +---
 arch/arm/plat-omap/Kconfig                         |   31 ++--
 arch/arm/plat-omap/include/plat/voltage.h          |   21 +++-
 drivers/power/Kconfig                              |    2 +
 drivers/power/Makefile                             |    1 +
 drivers/power/avs/Kconfig                          |   12 ++
 drivers/power/avs/Makefile                         |    1 +
 .../mach-omap2 => drivers/power/avs}/smartreflex.c |  161 ++++++++------------
 .../linux/power}/smartreflex.h                     |   74 ++++++++--
 15 files changed, 235 insertions(+), 179 deletions(-)
 create mode 100644 drivers/power/avs/Kconfig
 create mode 100644 drivers/power/avs/Makefile
 rename {arch/arm/mach-omap2 => drivers/power/avs}/smartreflex.c (90%)
 rename {arch/arm/mach-omap2 => include/linux/power}/smartreflex.h (79%)

-- 
1.7.5.4

