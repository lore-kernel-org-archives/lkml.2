Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab0DBKkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 06:40:51 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:54874 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab0DBKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 06:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :x-operating-system:user-agent;
        b=NnLznXA4BqEwsZoGCA+z18t9W+QMtXTW/7YAbdPuR0Z9Dv3IDse6VVJBqy0yyyM2j3
         tKThEv32Q1ChTSqlSPeawiGw48rP/cLMGLhJxPA/rNA38Owzzp9rNvIsyqLM8llaQrK4
         +Ia2pVE8BHKwZPtlHJh/q4/DOPQz2wsR7N5eA=
Date: Fri, 2 Apr 2010 18:40:39 +0800
From: Li Hong <lihong.hi@gmail.com>
To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nilfs2: Remove an uninitialization warning in
 nilfs_btree_propagate_v()
Message-ID: <20100402104039.GA9652@xhl>
Mail-Followup-To: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`make CONFIG_NILFS2_FS=m M=fs/nilfs2/` will give the following warnings:

fs/nilfs2/btree.c: In function ‘nilfs_btree_propagate’:
fs/nilfs2/btree.c:1882: warning: ‘maxlevel’ may be used uninitialized in this function
fs/nilfs2/btree.c:1882: note: ‘maxlevel’ was declared here

Set maxlevel = 0 to fix it.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/nilfs2/btree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 7cdd98b..76c38e3 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1879,7 +1879,7 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
 				   struct nilfs_btree_path *path,
 				   int level, struct buffer_head *bh)
 {
-	int maxlevel, ret;
+	int maxlevel = 0, ret;
 	struct nilfs_btree_node *parent;
 	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
 	__u64 ptr;
-- 
1.6.3.3

