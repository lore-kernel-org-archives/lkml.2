Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2DVPvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 11:51:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60915 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2DVPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 11:51:04 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] [EXT4] super.c: unused variable warning without CONFIG_QUOTA
Date: Sun, 22 Apr 2012 17:50:52 +0200
Message-Id: <1335109852-17829-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sb info is only checked with quota support.

fs/ext4/super.c: In function ‘parse_options’:
fs/ext4/super.c:1600:23: warning: unused variable ‘sbi’ [-Wunused-variable]

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 fs/ext4/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6da1935..e1fb1d5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1597,7 +1597,9 @@ static int parse_options(char *options, struct super_block *sb,
 			 unsigned int *journal_ioprio,
 			 int is_remount)
 {
+#ifdef CONFIG_QUOTA
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+#endif
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int token;
-- 
1.7.10

