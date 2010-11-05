Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0KEDLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:11:33 -0400
Received: from mail.perches.com ([173.55.12.10]:4183 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0KEDJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:08 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: [PATCH 42/49] include/linux/coda_linux.h: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:06 -0700
Message-Id: <1f2c6fee2d755879872b5fdd5f81d9f23569ffdd.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/coda_linux.h |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
index 2e914d0..57460f3 100644
--- a/include/linux/coda_linux.h
+++ b/include/linux/coda_linux.h
@@ -55,19 +55,25 @@ unsigned short coda_flags_to_cflags(unsigned short);
 void coda_sysctl_init(void);
 void coda_sysctl_clean(void);
 
-#define CODA_ALLOC(ptr, cast, size) do { \
-    if (size < PAGE_SIZE) \
-        ptr = kmalloc((unsigned long) size, GFP_KERNEL); \
-    else \
-        ptr = (cast)vmalloc((unsigned long) size); \
-    if (!ptr) \
-        printk("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
-    else memset( ptr, 0, size ); \
+#define CODA_ALLOC(ptr, cast, size)					\
+do {									\
+	if (size < PAGE_SIZE)						\
+		ptr = kzalloc((unsigned long) size, GFP_KERNEL);	\
+	else								\
+		ptr = vzalloc((unsigned long) size);			\
+	if (!ptr)							\
+		printk(KERN_ERR "kernel malloc returns 0 at %s:%d\n",	\
+		       __FILE__, __LINE__);				\
 } while (0)
 
 
-#define CODA_FREE(ptr,size) \
-    do { if (size < PAGE_SIZE) kfree((ptr)); else vfree((ptr)); } while (0)
+#define CODA_FREE(ptr, size)			\
+do {						\
+	if (size < PAGE_SIZE)			\
+		kfree((ptr));			\
+	else					\
+		vfree((ptr));			\
+} while (0)
 
 /* inode to cnode access functions */
 
-- 
1.7.3.1.g432b3.dirty

