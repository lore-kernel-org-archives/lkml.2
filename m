Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2KCF15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 01:27:57 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55754 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2KCF1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 01:27:53 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 2/3] fat: notify when discard is not supported
Date: Sat,  3 Nov 2012 14:27:43 +0900
Message-Id: <1351920463-3289-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAT also notify warning message about discard support
as ext4(http://patchwork.ozlabs.org/patch/192668/)

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d077f57..672dc71 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1446,6 +1446,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		goto out_fail;
 	}
 
+	if (sbi->options.discard) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+		if (!blk_queue_discard(q))
+			fat_msg(sb, KERN_WARNING,
+					"mounting with \"discard\" option, but "
+					"the device does not support discard");
+	}
+
 	return 0;
 
 out_invalid:
-- 
1.7.9.5

