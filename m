Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab0KASlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:41:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0KASli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pEPuci/edzBY5aWK4KpbgD7k4VYY4W04zcrM/x+PaRi9mEw+0aOXp6jNVvLnjv9wWa
         8+3gOST8jCf7P9CycVOtS0rKJhvKrbdt4cIZgDikLvWNkTrqRTpU4ZvbQ4lPH6Gx8Yp4
         CEOSBdtZwRrAo8esxeytpp1eBs9KihwJ6RFSA=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 04/29] Staging: yaffs2: moduleconfig.h: Add file
Date: Mon,  1 Nov 2010 14:40:52 -0400
Message-Id: <1288636877-7964-5-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/moduleconfig.h |   86 +++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/moduleconfig.h

diff --git a/drivers/staging/yaffs2/moduleconfig.h b/drivers/staging/yaffs2/moduleconfig.h
new file mode 100644
index 0000000..4b4d642
--- /dev/null
+++ b/drivers/staging/yaffs2/moduleconfig.h
@@ -0,0 +1,86 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Martin Fouts <Martin.Fouts@palmsource.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_CONFIG_H__
+#define __YAFFS_CONFIG_H__
+
+#ifdef YAFFS_OUT_OF_TREE
+
+/* DO NOT UNSET THESE THREE. YAFFS2 will not compile if you do. */
+#define CONFIG_YAFFS_FS
+#define CONFIG_YAFFS_YAFFS1
+#define CONFIG_YAFFS_YAFFS2
+
+/* These options are independent of each other.  Select those that matter. */
+
+/* Default: Not selected */
+/* Meaning: Yaffs does its own ECC, rather than using MTD ECC */
+/* #define CONFIG_YAFFS_DOES_ECC */
+
+/* Default: Selected */
+/* Meaning: Yaffs does its own ECC on tags for packed tags rather than use mtd */
+#define CONFIG_YAFFS_DOES_TAGS_ECC
+
+/* Default: Not selected */
+/* Meaning: ECC byte order is 'wrong'.  Only meaningful if */
+/*          CONFIG_YAFFS_DOES_ECC is set */
+/* #define CONFIG_YAFFS_ECC_WRONG_ORDER */
+
+/* Default: Not selected */
+/* Meaning: Always test whether chunks are erased before writing to them.
+	    Use during mtd debugging and init. */
+/* #define CONFIG_YAFFS_ALWAYS_CHECK_CHUNK_ERASED */
+
+/* Default: Not Selected */
+/* Meaning: At mount automatically empty all files from lost and found. */
+/* This is done to fix an old problem where rmdir was not checking for an */
+/* empty directory. This can also be achieved with a mount option. */
+#define CONFIG_YAFFS_EMPTY_LOST_AND_FOUND
+
+/* Default: Selected */
+/* Meaning: Cache short names, taking more RAM, but faster look-ups */
+#define CONFIG_YAFFS_SHORT_NAMES_IN_RAM
+
+/* Default: Unselected */
+/* Meaning: Select to disable block refreshing. */
+/* Block Refreshing periodically rewrites the oldest block. */
+/* #define CONFIG_DISABLE_BLOCK_REFRESHING */
+
+/* Default: Unselected */
+/* Meaning: Select to disable background processing */
+/* #define CONFIG_DISABLE_BACKGROUND */
+
+
+/* Default: Selected */
+/* Meaning: Enable XATTR support */
+#define CONFIG_YAFFS_XATTR
+
+/*
+Older-style on-NAND data format has a "page_status" byte to record
+chunk/page state.  This byte is zeroed when the page is discarded.
+Choose this option if you have existing on-NAND data in this format
+that you need to continue to support.  New data written also uses the
+older-style format.
+Note: Use of this option generally requires that MTD's oob layout be
+adjusted to use the older-style format.  See notes on tags formats and
+MTD versions in yaffs_mtdif1.c.
+*/
+/* Default: Not selected */
+/* Meaning: Use older-style on-NAND data format with page_status byte */
+/* #define CONFIG_YAFFS_9BYTE_TAGS */
+
+#endif /* YAFFS_OUT_OF_TREE */
+
+#endif /* __YAFFS_CONFIG_H__ */
-- 
1.7.3.2.146.gca209

