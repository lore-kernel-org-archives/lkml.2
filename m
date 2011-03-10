Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958Ab1CJNyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:54:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33483 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893Ab1CJNyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:54:13 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add WM8994 bulk register write operation
Date: Thu, 10 Mar 2011 13:54:07 +0000
Message-Id: <1299765247-23653-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c       |   23 +++++++++++++++++++++++
 include/linux/mfd/wm8994/core.h |    2 ++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index e673bda2..5220af2 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -138,6 +138,29 @@ int wm8994_reg_write(struct wm8994 *wm8994, unsigned short reg,
 EXPORT_SYMBOL_GPL(wm8994_reg_write);
 
 /**
+ * wm8994_bulk_write: Write multiple WM8994 registers
+ *
+ * @wm8994: Device to write to
+ * @reg: First register
+ * @count: Number of registers
+ * @buf: Buffer to write from.
+ */
+int wm8994_bulk_write(struct wm8994 *wm8994, unsigned short reg,
+		      int count, u16 *buf)
+{
+	int ret;
+
+	mutex_lock(&wm8994->io_lock);
+
+	ret = wm8994_write(wm8994, reg, count * 2, buf);
+
+	mutex_unlock(&wm8994->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8994_bulk_write);
+
+/**
  * wm8994_set_bits: Set the value of a bitfield in a WM8994 register
  *
  * @wm8994: Device to write to.
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index ef4f0b6..cb7d3ae 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -88,6 +88,8 @@ int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
 		    unsigned short mask, unsigned short val);
 int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
 		     int count, u16 *buf);
+int wm8994_bulk_write(struct wm8994 *wm8994, unsigned short reg,
+		     int count, u16 *buf);
 
 
 /* Helper to save on boilerplate */
-- 
1.7.2.3

