Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab1KEFuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 01:50:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41027 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1KEFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 01:50:15 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: add blk_finish_plug in error case of writepages.
Date: Sat,  5 Nov 2011 14:49:56 +0900
Message-Id: <1320472196-1987-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_finish_plug is needed in error case of writepages.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/ext4/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cc5a6da..18b262b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2270,6 +2270,7 @@ retry:
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
 			       "%ld pages, ino %lu; err %d", __func__,
 				wbc->nr_to_write, inode->i_ino, ret);
+			blk_finish_plug(&plug);
 			goto out_writepages;
 		}
 
-- 
1.7.4.4

