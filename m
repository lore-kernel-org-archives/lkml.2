Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab2EOOqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:46:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab2EOOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:46:22 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, joe@perches.com,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/2] fat: add fat_msg_ratelimit.
Date: Tue, 15 May 2012 10:46:02 -0400
Message-Id: <1337093162-3963-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to add fat_msg_ratelimit to limit many message at once.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/fat.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 951d12b..1708d9a 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -335,6 +335,11 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...);
 	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
 __printf(3, 4) __cold
 void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
+#define fat_msg_ratelimit(sb, level, fmt, args...)	\
+	do {	\
+			if (__ratelimit(&MSDOS_SB(sb)->ratelimit))	\
+				fat_msg(sb, level, fmt, ## args);	\
+	 } while (0)
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
-- 
1.7.5.4

