Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0KEDLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:11:35 -0400
Received: from mail.perches.com ([173.55.12.10]:4170 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889Ab0KEDJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:05 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 38/49] fs/jffs2: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:02 -0700
Message-Id: <1c6caf522ea9088919a89c8c23c54436c7020cdb.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jffs2/build.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/build.c b/fs/jffs2/build.c
index 85c6be2..3005ec4 100644
--- a/fs/jffs2/build.c
+++ b/fs/jffs2/build.c
@@ -336,14 +336,13 @@ int jffs2_do_mount_fs(struct jffs2_sb_info *c)
 	size = sizeof(struct jffs2_eraseblock) * c->nr_blocks;
 #ifndef __ECOS
 	if (jffs2_blocks_use_vmalloc(c))
-		c->blocks = vmalloc(size);
+		c->blocks = vzalloc(size);
 	else
 #endif
-		c->blocks = kmalloc(size, GFP_KERNEL);
+		c->blocks = kzalloc(size, GFP_KERNEL);
 	if (!c->blocks)
 		return -ENOMEM;
 
-	memset(c->blocks, 0, size);
 	for (i=0; i<c->nr_blocks; i++) {
 		INIT_LIST_HEAD(&c->blocks[i].list);
 		c->blocks[i].offset = i * c->sector_size;
-- 
1.7.3.1.g432b3.dirty

