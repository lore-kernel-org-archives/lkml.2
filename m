Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0FAQOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:14:18 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35917 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab0FAQOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:14:16 -0400
Date: Tue, 1 Jun 2010 09:14:01 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] squashfs: fix unsigned warnings
Message-ID: <20100601091401.0d927f09@nehalam>
In-Reply-To: <20100601091144.1ff3e677@nehalam>
References: <4BFC7269.3070309@lougher.demon.co.uk>
	<AANLkTilWjRvjl5M_4lenw3aMI57eDYjOV96k3KmxrNwB@mail.gmail.com>
	<20100601091144.1ff3e677@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xattr_size is passed to xattr_lookup as a signed integer, when
it is unsigned.  Also include xattr.h to get function prototype.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/fs/squashfs/xattr.h	2010-06-01 08:48:42.539735350 -0700
+++ b/fs/squashfs/xattr.h	2010-06-01 09:02:27.889738545 -0700
@@ -25,7 +25,7 @@
 extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
 		u64 *, int *);
 extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
-		int *, unsigned long long *);
+		unsigned int *, unsigned long long *);
 #else
 static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
 		u64 start, u64 *xattr_table_start, int *xattr_ids)
@@ -35,7 +35,7 @@ static inline __le64 *squashfs_read_xatt
 }
 
 static inline int squashfs_xattr_lookup(struct super_block *sb,
-		unsigned int index, int *count, int *size,
+		unsigned int index, int *count, unsigned int *size,
 		unsigned long long *xattr)
 {
 	return 0;
--- a/fs/squashfs/xattr_id.c	2010-06-01 08:49:21.350077943 -0700
+++ b/fs/squashfs/xattr_id.c	2010-06-01 09:03:35.030052467 -0700
@@ -34,6 +34,7 @@
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
 #include "squashfs.h"
+#include "xattr.h"
 
 /*
  * Map xattr id using the xattr id look up table
