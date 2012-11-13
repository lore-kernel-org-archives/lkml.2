Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2KMI3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:29:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60093 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab2KMI26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:28:58 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/13] MFD: twl drivers: Convert to regmap IO and cleanups
Date: Tue, 13 Nov 2012 09:28:41 +0100
Message-ID: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series converts the twl-core to use regmap for IO towards the chip.
With the conversion to regmap IO we no longer need to allocate bigger buffer for
writes.
I have appended patches to this series to make some cleanups which will help in
the future to further clean up the twl stack.

The series depends on a regression fix patch for the twl-core:
https://patchwork.kernel.org/patch/1679421/

Regards,
Peter
---
Peter Ujfalusi (13):
  MFD: twl-core: Register twl4030-madc child only for twl4030 class
  MFD: twl-core: Support for proper PWM drivers
  MFD: twl-core: Convert to use regmap for I/O
  MFD/rtc/gpio: twl: No need to allocate bigger buffer for write
  MFD: twl-core: Clean up and correct child registration
  mfd: twl: Remove unused TWL_MODULE definitions
  mfd: twl: Convert module id definitions to enums
  mfd: twl: Use decimal numbers for TWL6030_MODULE_IDs
  MFD: twl-core: re-group the twl_mapping table for easier reading
  mfd: twl4030-madc: Change TWL4030_MODULE_* ids to TWL_MODULE_*
  mfd: twl4030-power: Change TWL4030_MODULE_* ids to TWL_MODULE_*
  mfd: twl4030-irq: Change TWL4030_MODULE_* ids to TWL_MODULE_*
  mfd: twl-core: Change TWL4030_MODULE_* ids to TWL_MODULE_*

 drivers/gpio/gpio-twl4030.c |  12 +--
 drivers/mfd/twl-core.c      | 227 +++++++++++++++++++++++---------------------
 drivers/mfd/twl4030-irq.c   |  10 +-
 drivers/mfd/twl4030-madc.c  |  14 +--
 drivers/mfd/twl4030-power.c | 124 ++++++++++--------------
 drivers/mfd/twl6030-irq.c   |   4 +-
 drivers/rtc/rtc-twl.c       |  32 +++----
 include/linux/i2c/twl.h     |  73 +++++++-------
 8 files changed, 241 insertions(+), 255 deletions(-)

-- 
1.8.0

