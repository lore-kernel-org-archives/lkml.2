Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2BXGlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:41:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35521 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2BXGlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:41:23 -0500
From: wolfram@the-dreams.de
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yegor Yefremov <yegorslists@googlemail.com>,
        Wolfram Sang <wolfram@the-dreams.de>
Subject: [PATCH] misc: at24: describe platform_data with kernel_doc
Date: Fri, 24 Feb 2012 07:41:06 +0100
Message-Id: <1330065666-12758-1-git-send-email-wolfram@the-dreams.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: wolfram@the-dreams.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wolfram@the-dreams.de>

There have been questions about its fields lately, so describe them properly.

Reported-by: Yegor Yefremov <yegorslists@googlemail.com>
Signed-off-by: Wolfram Sang <wolfram@the-dreams.de>
---
 include/linux/i2c/at24.h |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/include/linux/i2c/at24.h b/include/linux/i2c/at24.h
index 8ace930..5767ac7 100644
--- a/include/linux/i2c/at24.h
+++ b/include/linux/i2c/at24.h
@@ -1,19 +1,42 @@
+/*
+ * at24.h - platform_data for the at24 (generic eeprom) driver
+ * (C) Copyright 2008 by Pengutronix
+ * (C) Copyright 2012 by Wolfram Sang
+ * same license as the driver
+ */
+
 #ifndef _LINUX_AT24_H
 #define _LINUX_AT24_H
 
 #include <linux/types.h>
 #include <linux/memory.h>
 
-/*
- * As seen through Linux I2C, differences between the most common types of I2C
- * memory include:
- * - How much memory is available (usually specified in bit)?
- * - What write page size does it support?
- * - Special flags (16 bit addresses, read_only, world readable...)?
+/**
+ * struct at24_platform_data - data to set up at24 (generic eeprom) driver
+ * @byte_len: size of eeprom in byte
+ * @page_size: number of byte which can be written in one go
+ * @flags: tunable options, check AT24_FLAG_* defines
+ * @setup: an optional callback invoked after eeprom is probed; enables kernel
+	code to access eeprom via memory_accessor, see example
+ * @context: optional parameter passed to setup()
  *
  * If you set up a custom eeprom type, please double-check the parameters.
  * Especially page_size needs extra care, as you risk data loss if your value
  * is bigger than what the chip actually supports!
+ *
+ * An example in pseudo code for a setup() callback:
+ *
+ * void get_mac_addr(struct memory_accessor *mem_acc, void *context)
+ * {
+ * 	u8 *mac_addr = ethernet_pdata->mac_addr;
+ *	off_t offset = context;
+ *
+ *	// Read MAC addr from EEPROM
+ *	if (mem_acc->read(mem_acc, mac_addr, offset, ETH_ALEN) == ETH_ALEN)
+ *		pr_info("Read MAC addr from EEPROM: %pM\n", mac_addr);
+ * }
+ *
+ * This function pointer and context can now be set up in at24_platform_data.
  */
 
 struct at24_platform_data {
-- 
1.7.2.5

