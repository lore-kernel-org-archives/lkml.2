Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2KWUYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:24:37 -0500
Received: from gerolde.archlinux.org ([66.211.214.132]:44084 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2KWUYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:24:36 -0500
From: Dave Reisner <dreisner@archlinux.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, Dave Reisner <dreisner@archlinux.org>
Subject: [PATCH] fs/fat: strip "cp" prefix from codepage in display
Date: Fri, 23 Nov 2012 15:24:28 -0500
Message-Id: <1353702268-1568-1-git-send-email-dreisner@archlinux.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Option parsing code expects an unsigned integer for the codepage option,
but prefixes and stores this option with "cp" before passing to
load_nls(). This makes the displayed option in /proc an invalid one.
Strip the prefix when printing so that the displayed option is valid
for reuse.

Signed-off-by: Dave Reisner <dreisner@archlinux.org>
---
 fs/fat/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 5bafaad..f037feb 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -725,7 +725,8 @@ static int fat_show_options(struct seq_file *m, struct dentry *root)
 	if (opts->allow_utime)
 		seq_printf(m, ",allow_utime=%04o", opts->allow_utime);
 	if (sbi->nls_disk)
-		seq_printf(m, ",codepage=%s", sbi->nls_disk->charset);
+		/* strip "cp" prefix from displayed option */
+		seq_printf(m, ",codepage=%s", &sbi->nls_disk->charset[2]);
 	if (isvfat) {
 		if (sbi->nls_io)
 			seq_printf(m, ",iocharset=%s", sbi->nls_io->charset);
-- 
1.8.0

