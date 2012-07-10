Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2GJQYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:24:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57548 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2GJQX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:23:57 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 2/4] MTD parts: introduce mtd_get_device_size()
Date: Tue, 10 Jul 2012 18:23:40 +0200
Message-Id: <1341937423-16516-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtd_get_device_size() returns the size of the whole MTD device, that is
the mtd_info master size.
This is used by UBI to calculate the maximum number of bad blocks (MBB)
on a MTD device.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/mtdpart.c          |   14 ++++++++++++++
 include/linux/mtd/partitions.h |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 8500584..d12f583 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -760,3 +760,17 @@ int mtd_is_partition(const struct mtd_info *mtd)
 	return ispart;
 }
 EXPORT_SYMBOL_GPL(mtd_is_partition);
+
+/* returns the size of an MTD device */
+uint64_t mtd_get_device_size(const struct mtd_info *mtd)
+{
+	struct mtd_part *part;
+
+	if (!mtd_is_partition(mtd))
+		return mtd->size;
+
+	part = PART(mtd);
+
+	return part->master->size;
+}
+EXPORT_SYMBOL_GPL(mtd_get_device_size);
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index 02a5115..1f8d24b 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -83,5 +83,6 @@ int mtd_is_partition(const struct mtd_info *mtd);
 int mtd_add_partition(struct mtd_info *master, char *name,
 		      long long offset, long long length);
 int mtd_del_partition(struct mtd_info *master, int partno);
+uint64_t mtd_get_device_size(const struct mtd_info *mtd);
 
 #endif
-- 
1.7.2.5

