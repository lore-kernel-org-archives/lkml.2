Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2LaLKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:10:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48570 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab2LaLJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:46 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 10/10] mfd: twl-core: Move twl_i2c_read/write_u8 to header as inline function
Date: Mon, 31 Dec 2012 12:09:31 +0100
Message-ID: <1356952171-6109-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl_i2c_read/write_u8 become as a simple wrapper over the twl_i2c_read/write.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c  | 28 ----------------------------
 include/linux/i2c/twl.h | 17 +++++++++++------
 2 files changed, 11 insertions(+), 34 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 9661204..557f9ee 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -379,34 +379,6 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
 }
 EXPORT_SYMBOL(twl_i2c_read);
 
-/**
- * twl_i2c_write_u8 - Writes a 8 bit register in TWL4030/TWL5030/TWL60X0
- * @mod_no: module number
- * @value: the value to be written 8 bit
- * @reg: register address (just offset will do)
- *
- * Returns result of operation - 0 is success
- */
-int twl_i2c_write_u8(u8 mod_no, u8 value, u8 reg)
-{
-	return twl_i2c_write(mod_no, &value, reg, 1);
-}
-EXPORT_SYMBOL(twl_i2c_write_u8);
-
-/**
- * twl_i2c_read_u8 - Reads a 8 bit register from TWL4030/TWL5030/TWL60X0
- * @mod_no: module number
- * @value: the value read 8 bit
- * @reg: register address (just offset will do)
- *
- * Returns result of operation - 0 is success
- */
-int twl_i2c_read_u8(u8 mod_no, u8 *value, u8 reg)
-{
-	return twl_i2c_read(mod_no, value, reg, 1);
-}
-EXPORT_SYMBOL(twl_i2c_read_u8);
-
 /*----------------------------------------------------------------------*/
 
 /**
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index e441fd8..488debb 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -175,17 +175,22 @@ TWL_CLASS_IS(4030, TWL4030_CLASS_ID)
 TWL_CLASS_IS(6030, TWL6030_CLASS_ID)
 
 /*
- * Read and write single 8-bit registers
- */
-int twl_i2c_write_u8(u8 mod_no, u8 val, u8 reg);
-int twl_i2c_read_u8(u8 mod_no, u8 *val, u8 reg);
-
-/*
  * Read and write several 8-bit registers at once.
  */
 int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
+/*
+ * Read and write single 8-bit registers
+ */
+static inline int twl_i2c_write_u8(u8 mod_no, u8 val, u8 reg) {
+	return twl_i2c_write(mod_no, &val, reg, 1);
+}
+
+static inline int twl_i2c_read_u8(u8 mod_no, u8 *val, u8 reg) {
+	return twl_i2c_read(mod_no, val, reg, 1);
+}
+
 int twl_get_type(void);
 int twl_get_version(void);
 int twl_get_hfclk_rate(void);
-- 
1.8.0.2

