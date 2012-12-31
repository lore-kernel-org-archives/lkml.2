Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2LaLKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:10:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48384 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab2LaLJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:45 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 09/10] mfd: twl-core: Remove no longer valid comment regarding to write buffer size
Date: Mon, 31 Dec 2012 12:09:30 +0100
Message-ID: <1356952171-6109-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the regmap conversion there is no longeer a need to allocate bigger
buffer for writes

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c  | 3 ---
 include/linux/i2c/twl.h | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index e2895a4..9661204 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -308,9 +308,6 @@ EXPORT_SYMBOL(twl_rev);
  * @reg: register address (just offset will do)
  * @num_bytes: number of bytes to transfer
  *
- * IMPORTANT: for 'value' parameter: Allocate value num_bytes+1 and
- * valid data starts at Offset 1.
- *
  * Returns the result of operation - 0 is success
  */
 int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 72adc88..e441fd8 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -182,9 +182,6 @@ int twl_i2c_read_u8(u8 mod_no, u8 *val, u8 reg);
 
 /*
  * Read and write several 8-bit registers at once.
- *
- * IMPORTANT:  For twl_i2c_write(), allocate num_bytes + 1
- * for the value, and populate your data starting at offset 1.
  */
 int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
-- 
1.8.0.2

