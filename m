Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab2BDMQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:16:34 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50232 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972Ab2BDMQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:16:33 -0500
From: Aneesh V <aneesh@ti.com>
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Aneesh V <aneesh@ti.com>
Subject: [RFC PATCH 0/8] Add TI EMIF SDRAM controller driver
Date: Sat,  4 Feb 2012 17:46:03 +0530
Message-Id: <1328357771-31644-1-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the EMIF SDRAM controller used in TI SoCs

EMIF is an SDRAM controller that supports, based on its revision,
one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
for LPDDR2.

The driver supports the following features:
- Calculates the DDR AC timing parameters to be set in EMIF
  registers using data from the device data-sheets and based
  on the DDR frequency. If data from data-sheets is not available
  default timing values from the JEDEC spec are used. These
  will be safe, but not necessarily optimal
- API for changing timings during DVFS or at boot-up
- Temperature alert configuration and handling of temperature
  alerts, if any for LPDDR2 devices
  * temperature alert is based on periodic polling of MR4 mode
    register in DDR devices automatically performed by hardware
  * timings are de-rated and brought back to nominal when
    temperature raises and falls respectively
- Cache of calculated register values to avoid re-calculating
  them

The driver will need some minor updates when it is eventually
integrated with DVFS. This can not be done now as DVFS support
is not available yet in mainline.

Discussions with Santosh Shilimkar <santosh.shilimkar@ti.com>
were immensely helpful in shaping up the interfaces. Vibhore Vardhan
<vvardhan@gmail.com> did the initial code snippet for thermal
handling.

Testing: 
- The driver is tested on OMAP4430 SDP.
- The driver in a slightly adapted form is also tested on OMAP5.
- Since mainline kernel doesn't have DVFS support yet,
  testing was done using a test module.
- Temperature alert handling was tested with simulated interrupts
  and faked temperature values as testing all cases in real-life
  scenarios is difficult.

Aneesh V (7):
  misc: ddr: add LPDDR2 data from JESD209-2
  misc: emif: add register definitions for EMIF
  misc: emif: add basic infrastructure for EMIF driver
  misc: emif: handle frequency and voltage change events
  misc: emif: add interrupt and temperature handling
  misc: emif: add one-time settings
  misc: emif: add debugfs entries for emif

Benoit Cousson (1):
  OMAP4: hwmod: add EMIF hw mod data

 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  110 ++
 drivers/misc/Kconfig                       |   20 +
 drivers/misc/Makefile                      |    2 +
 drivers/misc/emif.c                        | 1522 ++++++++++++++++++++++++++++
 drivers/misc/emif_regs.h                   |  461 +++++++++
 drivers/misc/jedec_ddr_data.c              |  141 +++
 include/linux/emif.h                       |  257 +++++
 include/linux/jedec_ddr.h                  |  174 ++++
 8 files changed, 2687 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/emif.c
 create mode 100644 drivers/misc/emif_regs.h
 create mode 100644 drivers/misc/jedec_ddr_data.c
 create mode 100644 include/linux/emif.h
 create mode 100644 include/linux/jedec_ddr.h

