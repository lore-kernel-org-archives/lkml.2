Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab2FFVZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:25:19 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:1967 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab2FFVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:25:17 -0400
Message-ID: <1339017911.21725.20.camel@x61.thuisdomein>
Subject: [PATCH] mfd/ab5500: delete ab5500-core.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 23:25:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jun 2012 21:25:11.0995 (UTC) FILETIME=[DB2AE8B0:01CD442A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 72fb92200d6c31b9982c06784e4bcff2f5b7d8b6 ("mfd/ab5500: delete
AB5500 support") deleted all files that used ab5500-core.h. That file
apparently was simply overlooked. Delete it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only.

 drivers/mfd/ab5500-core.h |   87 ---------------------------------------------
 1 files changed, 0 insertions(+), 87 deletions(-)
 delete mode 100644 drivers/mfd/ab5500-core.h

diff --git a/drivers/mfd/ab5500-core.h b/drivers/mfd/ab5500-core.h
deleted file mode 100644
index 63b30b1..0000000
--- a/drivers/mfd/ab5500-core.h
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Copyright (C) 2011 ST-Ericsson
- * License terms: GNU General Public License (GPL) version 2
- * Shared definitions and data structures for the AB5500 MFD driver
- */
-
-/* Read/write operation values. */
-#define AB5500_PERM_RD (0x01)
-#define AB5500_PERM_WR (0x02)
-
-/* Read/write permissions. */
-#define AB5500_PERM_RO (AB5500_PERM_RD)
-#define AB5500_PERM_RW (AB5500_PERM_RD | AB5500_PERM_WR)
-
-#define AB5500_MASK_BASE (0x60)
-#define AB5500_MASK_END (0x79)
-#define AB5500_CHIP_ID (0x20)
-
-/**
- * struct ab5500_reg_range
- * @first: the first address of the range
- * @last: the last address of the range
- * @perm: access permissions for the range
- */
-struct ab5500_reg_range {
-	u8 first;
-	u8 last;
-	u8 perm;
-};
-
-/**
- * struct ab5500_i2c_ranges
- * @count: the number of ranges in the list
- * @range: the list of register ranges
- */
-struct ab5500_i2c_ranges {
-	u8 nranges;
-	u8 bankid;
-	const struct ab5500_reg_range *range;
-};
-
-/**
- * struct ab5500_i2c_banks
- * @count: the number of ranges in the list
- * @range: the list of register ranges
- */
-struct ab5500_i2c_banks {
-	u8 nbanks;
-	const struct ab5500_i2c_ranges *bank;
-};
-
-/**
- * struct ab5500_bank
- * @slave_addr: I2C slave_addr found in AB5500 specification
- * @name: Documentation name of the bank. For reference
- */
-struct ab5500_bank {
-	u8 slave_addr;
-	const char *name;
-};
-
-static const struct ab5500_bank bankinfo[AB5500_NUM_BANKS] = {
-	[AB5500_BANK_VIT_IO_I2C_CLK_TST_OTP] = {
-		AB5500_ADDR_VIT_IO_I2C_CLK_TST_OTP, "VIT_IO_I2C_CLK_TST_OTP"},
-	[AB5500_BANK_VDDDIG_IO_I2C_CLK_TST] = {
-		AB5500_ADDR_VDDDIG_IO_I2C_CLK_TST, "VDDDIG_IO_I2C_CLK_TST"},
-	[AB5500_BANK_VDENC] = {AB5500_ADDR_VDENC, "VDENC"},
-	[AB5500_BANK_SIM_USBSIM] = {AB5500_ADDR_SIM_USBSIM, "SIM_USBSIM"},
-	[AB5500_BANK_LED] = {AB5500_ADDR_LED, "LED"},
-	[AB5500_BANK_ADC] = {AB5500_ADDR_ADC, "ADC"},
-	[AB5500_BANK_RTC] = {AB5500_ADDR_RTC, "RTC"},
-	[AB5500_BANK_STARTUP] = {AB5500_ADDR_STARTUP, "STARTUP"},
-	[AB5500_BANK_DBI_ECI] = {AB5500_ADDR_DBI_ECI, "DBI-ECI"},
-	[AB5500_BANK_CHG] = {AB5500_ADDR_CHG, "CHG"},
-	[AB5500_BANK_FG_BATTCOM_ACC] = {
-		AB5500_ADDR_FG_BATTCOM_ACC, "FG_BATCOM_ACC"},
-	[AB5500_BANK_USB] = {AB5500_ADDR_USB, "USB"},
-	[AB5500_BANK_IT] = {AB5500_ADDR_IT, "IT"},
-	[AB5500_BANK_VIBRA] = {AB5500_ADDR_VIBRA, "VIBRA"},
-	[AB5500_BANK_AUDIO_HEADSETUSB] = {
-		AB5500_ADDR_AUDIO_HEADSETUSB, "AUDIO_HEADSETUSB"},
-};
-
-int ab5500_get_register_interruptible_raw(struct ab5500 *ab, u8 bank, u8 reg,
-	u8 *value);
-int ab5500_mask_and_set_register_interruptible_raw(struct ab5500 *ab, u8 bank,
-	u8 reg, u8 bitmask, u8 bitvalues);
-- 
1.7.7.6

