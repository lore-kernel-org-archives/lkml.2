Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1DCXzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:55:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38290 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1DCXzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cQBzEZh/0MXzayopT82hn52uuWEGU9x97uH655Wa/l8nkXaxUgb3ZCcZXkl4e7UOXp
         8IVZzn/rdaAKlwowIDZFon0+TYPdoxBRuLEqEeci+E3gnsE82pBxB1zMnOmPqetRZ+Eq
         M86FG18JDl67Y5iI25kpY6FaqOoktF55UsTSo=
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] ubifs: Use empty_iops and empty_fops consistently
Date: Mon,  4 Apr 2011 01:55:39 +0200
Message-Id: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the nomenclature as we did for empty_aops and rename
to empty_iops and empty_fops.

This patch is on top of linux-2.6-block.git#for-linus.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>
CC: Adrian Hunter <adrian.hunter@nokia.com>
CC: Jens Axboe <jaxboe@fusionio.com>
---
 fs/ubifs/xattr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 3299f46..16f19f5 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -80,8 +80,8 @@ enum {
 	SECURITY_XATTR,
 };
 
-static const struct inode_operations none_inode_operations;
-static const struct file_operations none_file_operations;
+static const struct inode_operations empty_iops;
+static const struct file_operations empty_fops;
 
 /**
  * create_xattr - create an extended attribute.
@@ -131,8 +131,8 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
 
 	/* Re-define all operations to be "nothing" */
 	inode->i_mapping->a_ops = &empty_aops;
-	inode->i_op = &none_inode_operations;
-	inode->i_fop = &none_file_operations;
+	inode->i_op = &empty_iops;
+	inode->i_fop = &empty_fops;
 
 	inode->i_flags |= S_SYNC | S_NOATIME | S_NOCMTIME | S_NOQUOTA;
 	ui = ubifs_inode(inode);
-- 
1.7.4.3

