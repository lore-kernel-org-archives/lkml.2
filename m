Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2I1EvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:51:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54385 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2I1EvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:51:01 -0400
MIME-Version: 1.0
Date: Fri, 28 Sep 2012 12:51:01 +0800
Message-ID: <CAPgLHd-cc+_6316S9NxBFXHLdjM0trf1QvPt3aXhAE9on9u9WA@mail.gmail.com>
Subject: [PATCH] omfs: convert to use beXX_add_cpu()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: me@bobcopeland.com
Cc: yongjun_wei@trendmicro.com.cn, linux-karma-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Convert cpu_to_beXX(beXX_to_cpu(E1) + E2) to use beXX_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/omfs/file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 2c6d952..77e3cb2 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -146,8 +146,7 @@ static int omfs_grow_extent(struct inode *inode, struct omfs_extent *oe,
 			be64_to_cpu(entry->e_blocks);
 
 		if (omfs_allocate_block(inode->i_sb, new_block)) {
-			entry->e_blocks =
-				cpu_to_be64(be64_to_cpu(entry->e_blocks) + 1);
+			be64_add_cpu(&entry->e_blocks, 1);
 			terminator->e_blocks = ~(cpu_to_be64(
 				be64_to_cpu(~terminator->e_blocks) + 1));
 			goto out;
@@ -177,7 +176,7 @@ static int omfs_grow_extent(struct inode *inode, struct omfs_extent *oe,
 		be64_to_cpu(~terminator->e_blocks) + (u64) new_count));
 
 	/* write in new entry */
-	oe->e_extent_count = cpu_to_be32(1 + be32_to_cpu(oe->e_extent_count));
+	be32_add_cpu(&oe->e_extent_count, 1);
 
 out:
 	*ret_block = new_block;


