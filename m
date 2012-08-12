Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2HLD5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 23:57:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2HLD5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 23:57:01 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH] fat: use accessor function for msdos_dir_entry 'start'
Date: Sat, 11 Aug 2012 23:56:50 -0400
Message-Id: <1344743810-2443-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use accessor function for msdos_dir_entry 'start'

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/dir.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 7b1b9c1..2f3e66e 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1143,10 +1143,8 @@ int fat_alloc_new_dir(struct inode *dir, struct timespec *ts)
 		de[0].ctime_cs = de[1].ctime_cs = 0;
 		de[0].adate = de[0].cdate = de[1].adate = de[1].cdate = 0;
 	}
-	de[0].start = cpu_to_le16(cluster);
-	de[0].starthi = cpu_to_le16(cluster >> 16);
-	de[1].start = cpu_to_le16(MSDOS_I(dir)->i_logstart);
-	de[1].starthi = cpu_to_le16(MSDOS_I(dir)->i_logstart >> 16);
+	fat_set_start(&de[0], cluster);
+	fat_set_start(&de[1], MSDOS_I(dir)->i_logstart);
 	de[0].size = de[1].size = 0;
 	memset(de + 2, 0, sb->s_blocksize - 2 * sizeof(*de));
 	set_buffer_uptodate(bhs[0]);
-- 
1.7.9.5

