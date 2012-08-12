Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2HLJps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2HLJpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:18 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 6/7] fs/fat: Fix all other checkpatch issues in dir.c
Date: Sun, 12 Aug 2012 19:44:46 +1000
Message-Id: <1344764687-4155-7-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does the following:

	1: Import linux/uaccess.h instead of asm.uaccess.h
	2: Stop any lines going over 80 characters
	3: Stopped setting any variables in if statements
	4: Stopped splitting quoted strings
	5: Removed unneeded parentheses

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 fs/fat/dir.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 4b04d5e..79fdec6 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -18,7 +18,7 @@
 #include <linux/time.h>
 #include <linux/buffer_head.h>
 #include <linux/compat.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include "fat.h"
 
@@ -123,7 +123,8 @@ static inline int fat_get_entry(struct inode *dir, loff_t *pos,
 {
 	/* Fast stuff first */
 	if (*bh && *de &&
-	    (*de - (struct msdos_dir_entry *)(*bh)->b_data) < MSDOS_SB(dir->i_sb)->dir_per_block - 1) {
+	   (*de - (struct msdos_dir_entry *)(*bh)->b_data) <
+				MSDOS_SB(dir->i_sb)->dir_per_block - 1) {
 		*pos += sizeof(struct msdos_dir_entry);
 		(*de)++;
 		return 0;
@@ -155,7 +156,8 @@ static int uni16_to_x8(struct super_block *sb, unsigned char *ascii,
 
 	while (*ip && ((len - NLS_MAX_CHARSET_SIZE) > 0)) {
 		ec = *ip++;
-		if ((charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
+		charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE);
+		if (charlen > 0) {
 			op += charlen;
 			len -= charlen;
 		} else {
@@ -172,12 +174,12 @@ static int uni16_to_x8(struct super_block *sb, unsigned char *ascii,
 	}
 
 	if (unlikely(*ip)) {
-		fat_msg(sb, KERN_WARNING, "filename was truncated while "
-			"converting.");
+		fat_msg(sb, KERN_WARNING,
+			"filename was truncated while converting.");
 	}
 
 	*op = 0;
-	return (op - ascii);
+	return op - ascii;
 }
 
 static inline int fat_uni_to_x8(struct super_block *sb, const wchar_t *uni,
@@ -205,7 +207,8 @@ fat_short2uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *uni)
 }
 
 static inline int
-fat_short2lower_uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *uni)
+fat_short2lower_uni(struct nls_table *t, unsigned char *c,
+		    int clen, wchar_t *uni)
 {
 	int charlen;
 	wchar_t wc;
@@ -220,7 +223,9 @@ fat_short2lower_uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *un
 		if (!nc)
 			nc = *c;
 
-		if ( (charlen = t->char2uni(&nc, 1, uni)) < 0) {
+		charlen = t->char2uni(&nc, 1, uni);
+
+		if (charlen < 0) {
 			*uni = 0x003f;	/* a question mark */
 			charlen = 1;
 		}
@@ -573,7 +578,8 @@ static int __fat_readdir(struct inode *inode, struct file *filp, void *dirent,
 	/* Fake . and .. for the root directory. */
 	if (inode->i_ino == MSDOS_ROOT_INO) {
 		while (cpos < 2) {
-			if (filldir(dirent, "..", cpos+1, cpos, MSDOS_ROOT_INO, DT_DIR) < 0)
+			if (filldir(dirent, "..", cpos+1, cpos,
+				    MSDOS_ROOT_INO, DT_DIR) < 0)
 				goto out;
 			cpos++;
 			filp->f_pos++;
-- 
1.7.9.5

