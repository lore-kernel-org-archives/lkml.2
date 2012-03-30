Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab2C3PuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:50:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54440 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934290Ab2C3PuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:50:17 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-i2c@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 00/16] I2C updates
Date: Fri, 30 Mar 2012 21:19:55 +0530
Message-ID: <1333122611-29953-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series does the following

- Warn fixes if CONFIG_PM_RUNTIME is not selected.
- I2C register restore only if context if the context is lost
- Bus busy recovery mechanism.
- the reset is not done in init.

v2 changes
-Adds a patch to use devm_* functions
-Also checks the return type of the get_sync and in case
 of errors prevents register access.
- In case of i2c remove register access was done without any
 get_sync fix the same.
- Adds a pdata function pointer to do context save restore

v3 changes
- Split the omap_i2c_isr to increase readability
- Adds the restore flag patch for OMAP4 to the series
- Make the i2c use SET_RUNTIME_PM_OPS

Tested on omap4sdp and omap3sdp.

Also available through

git://gitorious.org/linus-tree/linus-tree.git for_3.5_i2c

Previous discussion can be found
http://www.spinics.net/lists/linux-i2c/msg07380.html


Jon Hunter (1):
  I2C: OMAP: Correct I2C revision for OMAP3

Shubhrajyoti D (14):
  I2C : OMAP : make omap_i2c_unidle/idle functions depend on
    CONFIG_PM_RUNTIME
  OMAP : I2C : Remove reset at init
  OMAP: I2C: I2C register restore only if context is lost
  OMAP: I2C: Fix the interrupt clearing in OMAP4
  OMAP: I2C: Fix the mismatch of pm_runtime enable and disable
  OMAP: I2C: Optimise the remove code
  OMAP: I2C: Fix the error handling
  I2C: OMAP: Don't check if wait_for_completion_timeout() returns less
    than zero
  OMAP : I2C : use devm_* functions
  I2C : OMAP : Fix the crash in i2c remove
  OMAP: I2C: Handle error check for pm runtime
  I2C : OMAP : Use SET_RUNTIME_PM_OPS
  OMAP4: hwmod data: I2C: add flag for context restore
  i2c: omap: make the read ready processing a separate function

Vikram Pandita (1):
  I2C: OMAP: Recover from Bus Busy condition

 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    3 +-
 arch/arm/plat-omap/i2c.c                   |    3 +
 drivers/i2c/busses/i2c-omap.c              |  318 +++++++++++++++-------------
 include/linux/i2c-omap.h                   |    1 +
 4 files changed, 182 insertions(+), 143 deletions(-)

