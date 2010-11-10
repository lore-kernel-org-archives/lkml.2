Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0KJAfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:35:40 -0500
Received: from mail.perches.com ([173.55.12.10]:4845 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0KJAfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:35:31 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [PATCH 7/9] fs/nilfs2/super.c: Use printf extension %pV
Date: Tue,  9 Nov 2010 16:35:21 -0800
Message-Id: <1addeb606bca88e09fb46b93be10c3a58e759348.1289348757.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/nilfs2/super.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f804d41..bef8cc6 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -111,12 +111,17 @@ void nilfs_error(struct super_block *sb, const char *function,
 		 const char *fmt, ...)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk(KERN_CRIT "NILFS error (device %s): %s: ", sb->s_id, function);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_CRIT "NILFS error (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
 	va_end(args);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -136,13 +141,17 @@ void nilfs_error(struct super_block *sb, const char *function,
 void nilfs_warning(struct super_block *sb, const char *function,
 		   const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	va_start(args, fmt);
-	printk(KERN_WARNING "NILFS warning (device %s): %s: ",
-	       sb->s_id, function);
-	vprintk(fmt, args);
-	printk("\n");
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_WARNING "NILFS warning (device %s): %s: %pV\n",
+	       sb->s_id, function, &vaf);
+
 	va_end(args);
 }
 
-- 
1.7.3.1.g432b3.dirty

