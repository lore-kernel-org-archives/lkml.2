Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab1CQVmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:42:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36836 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755728Ab1CQVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:42:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] mfd: Constify WM8994 write path
Date: Thu, 17 Mar 2011 21:42:30 +0000
Message-Id: <1300398150-11834-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300398150-11834-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1300398150-11834-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow const buffers to be passed in without type safety issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c       |    8 ++++----
 include/linux/mfd/wm8994/core.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 475bd50..3f5b7cc 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -97,9 +97,9 @@ int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
 EXPORT_SYMBOL_GPL(wm8994_bulk_read);
 
 static int wm8994_write(struct wm8994 *wm8994, unsigned short reg,
-			int bytes, void *src)
+			int bytes, const void *src)
 {
-	u16 *buf = src;
+	const u16 *buf = src;
 	int i;
 
 	BUG_ON(bytes % 2);
@@ -146,7 +146,7 @@ EXPORT_SYMBOL_GPL(wm8994_reg_write);
  * @buf: Buffer to write from.  Data must be big-endian formatted.
  */
 int wm8994_bulk_write(struct wm8994 *wm8994, unsigned short reg,
-		      int count, u16 *buf)
+		      int count, const u16 *buf)
 {
 	int ret;
 
@@ -583,7 +583,7 @@ static int wm8994_i2c_read_device(struct wm8994 *wm8994, unsigned short reg,
 }
 
 static int wm8994_i2c_write_device(struct wm8994 *wm8994, unsigned short reg,
-				   int bytes, void *src)
+				   int bytes, const void *src)
 {
 	struct i2c_client *i2c = wm8994->control_data;
 	struct i2c_msg xfer[2];
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index cb7d3ae..f0b69cd 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -59,7 +59,7 @@ struct wm8994 {
 	int (*read_dev)(struct wm8994 *wm8994, unsigned short reg,
 			int bytes, void *dest);
 	int (*write_dev)(struct wm8994 *wm8994, unsigned short reg,
-			 int bytes, void *src);
+			 int bytes, const void *src);
 
 	void *control_data;
 
@@ -89,7 +89,7 @@ int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
 int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
 		     int count, u16 *buf);
 int wm8994_bulk_write(struct wm8994 *wm8994, unsigned short reg,
-		     int count, u16 *buf);
+		     int count, const u16 *buf);
 
 
 /* Helper to save on boilerplate */
-- 
1.7.4.1

