Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab2GJQZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:25:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47618 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2GJQX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:23:56 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/4] mtd_is_partition: struct mtd_info should be const
Date: Tue, 10 Jul 2012 18:23:39 +0200
Message-Id: <1341937423-16516-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct mtd_info is not modified by mtd_is_partition so it should be a
const.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/mtdpart.c          |    2 +-
 include/linux/mtd/partitions.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index d518e4d..8500584 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -744,7 +744,7 @@ int parse_mtd_partitions(struct mtd_info *master, const char **types,
 	return ret;
 }
 
-int mtd_is_partition(struct mtd_info *mtd)
+int mtd_is_partition(const struct mtd_info *mtd)
 {
 	struct mtd_part *part;
 	int ispart = 0;
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index 2475228..02a5115 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -79,7 +79,7 @@ struct mtd_part_parser {
 extern int register_mtd_parser(struct mtd_part_parser *parser);
 extern int deregister_mtd_parser(struct mtd_part_parser *parser);
 
-int mtd_is_partition(struct mtd_info *mtd);
+int mtd_is_partition(const struct mtd_info *mtd);
 int mtd_add_partition(struct mtd_info *master, char *name,
 		      long long offset, long long length);
 int mtd_del_partition(struct mtd_info *master, int partno);
-- 
1.7.2.5

