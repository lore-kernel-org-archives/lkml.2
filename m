Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab1FWVPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:15:55 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:47469 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759995Ab1FWVPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:15:52 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christoph Hellwig <hch@tuxera.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, roman@ardistech.com,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH 2/2] hfsplus: Fix double iput of the same inode in hfsplus_fill_super()
Date: Fri, 24 Jun 2011 01:15:02 +0400
Message-Id: <1308863702-30859-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308863702-30859-1-git-send-email-khoroshilov@ispras.ru>
References: <1308863702-30859-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a misprint in resource deallocation code on error path in
hfsplus_fill_super(): the sbi->alloc_file inode is iput twice,
while the root inode in not iput at all.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/hfsplus/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 07a0502..8bfbd38 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -504,7 +504,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 out_put_hidden_dir:
 	iput(sbi->hidden_dir);
 out_put_root:
-	iput(sbi->alloc_file);
+	iput(root);
 out_put_alloc_file:
 	iput(sbi->alloc_file);
 out_close_cat_tree:
-- 
1.7.4.1

