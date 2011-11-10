Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab1KJIGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:06:48 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:45020 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933735Ab1KJIGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:06:42 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 09/16] mtd/docg3: add OOB buffer to device structure
Date: Thu, 10 Nov 2011 09:05:35 +0100
Message-Id: <1320912342-30147-10-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OOB buffer area to store the OOB data until the actual
page is written, so that it can be completed by hardware ECC
generator.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index e9967ab..397e461 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -243,6 +243,11 @@
  * @device_id: number of the cascaded DoCG3 device (0, 1, 2 or 3)
  * @if_cfg: if true, reads are on 16bits, else reads are on 8bits
  * @bbt: bad block table cache
+ * @oob_write_ofs: offset of the MTD where this OOB should belong (ie. in next
+ *                 page_write)
+ * @oob_autoecc: if 1, use only bytes 0-7, 15, and fill the others with HW ECC
+ *               if 0, use all the 16 bytes.
+ * @oob_write_buf: prepared OOB for next page_write
  * @debugfs_root: debugfs root node
  */
 struct docg3 {
@@ -252,6 +257,9 @@ struct docg3 {
 	unsigned int if_cfg:1;
 	int max_block;
 	u8 *bbt;
+	loff_t oob_write_ofs;
+	int oob_autoecc;
+	u8 oob_write_buf[DOC_LAYOUT_OOB_SIZE];
 	struct dentry *debugfs_root;
 };
 
-- 
1.7.5.4

