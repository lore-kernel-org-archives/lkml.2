Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3AHVLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:11:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab3AHVIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605074"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 13/21] mei: hw-me.c fix kernel doc
Date: Tue,  8 Jan 2013 23:07:24 +0200
Message-Id: <1357679252-12958-14-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the kernel doc for the functions in hw-me.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 4e6b657..1e82e33 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -49,17 +49,13 @@ static inline void mei_reg_write(const struct mei_device *dev,
 }
 
 /**
- * mei_hcsr_read - Reads 32bit data from the host CSR
+ * mei_mecbrw_read - Reads 32bit data from ME circular buffer
+ *  read window register
  *
  * @dev: the device structure
  *
- * returns the byte read.
+ * returns ME_CB_RW register value (u32)
  */
-u32 mei_hcsr_read(const struct mei_device *dev)
-{
-	return mei_reg_read(dev, H_CSR);
-}
-
 u32 mei_mecbrw_read(const struct mei_device *dev)
 {
 	return mei_reg_read(dev, ME_CB_RW);
@@ -77,13 +73,26 @@ u32 mei_mecsr_read(const struct mei_device *dev)
 }
 
 /**
- * mei_set_csr_register - writes H_CSR register to the mei device,
+ * mei_hcsr_read - Reads 32bit data from the host CSR
+ *
+ * @dev: the device structure
+ *
+ * returns H_CSR register value (u32)
+ */
+u32 mei_hcsr_read(const struct mei_device *dev)
+{
+	return mei_reg_read(dev, H_CSR);
+}
+
+/**
+ * mei_hcsr_set - writes H_CSR register to the mei device,
  * and ignores the H_IS bit for it is write-one-to-zero.
  *
  * @dev: the device structure
  */
 void mei_hcsr_set(struct mei_device *dev)
 {
+
 	if ((dev->host_hw_state & H_IS) == H_IS)
 		dev->host_hw_state &= ~H_IS;
 	mei_reg_write(dev, H_CSR, dev->host_hw_state);
@@ -91,7 +100,7 @@ void mei_hcsr_set(struct mei_device *dev)
 }
 
 /**
- * mei_enable_interrupts - clear and stop interrupts
+ * mei_clear_interrupts - clear and stop interrupts
  *
  * @dev: the device structure
  */
-- 
1.7.4.4

