Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3ADVQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:16:34 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:39573 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3ADVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:16:31 -0500
MIME-Version: 1.0
Date: Fri, 4 Jan 2013 16:10:45 -0500
Message-ID: <CAGh4K3Kq7n7YjqomZbT7S-KVTMXfN96S1kLnWrUM5KM=DpJfUA@mail.gmail.com>
Subject: PATCH: Pagemap.h check PAGE_CACHE_SIZE > PAGE_SIZE
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for Linux 3.8-rc2. Checked with checkpatch.pl and formatted
correctly with git.


>From 039fbd466cfadaaea0ea1215cc19d5e0d06577ea Mon Sep 17 00:00:00 2001
From: "Christopher P. Sacchi" <chris.sacchi@gmail.com>
Date: Fri, 4 Jan 2013 15:56:44 -0500
Subject: [PATCH] pagemap.h: Adds an if to check to see if PAGE_CACHE_SIZE >
 PAGE_SIZE.


Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
---
 pagemap.patch |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 pagemap.patch

diff --git a/pagemap.patch b/pagemap.patch
new file mode 100644
index 0000000..ed12893
--- /dev/null
+++ b/pagemap.patch
@@ -0,0 +1,24 @@
+Signed-off-by: Christopher P. Sacchi chris.sacchi@gmail.com
+--- pagemap.h	2013-01-04 15:44:17.713123984 -0500
++++ pagemap.h	2013-01-04 15:46:35.681120547 -0500
+@@ -1,3 +1,4 @@
++START:
+ #ifndef _LINUX_PAGEMAP_H
+ #define _LINUX_PAGEMAP_H
+
+@@ -424,8 +425,14 @@ extern void add_page_wait_queue(struct p
+  * Fault a userspace page into pagetables.  Return non-zero on a fault.
+  *
+  * This assumes that two userspace pages are always sufficient.  That's
+- * not true if PAGE_CACHE_SIZE > PAGE_SIZE.
++ * not true if PAGE_CACHE_SIZE > PAGE_SIZE. Check if
++ * PAGE_CACHE_SIZE > PAGE_SIZE; return 1 if true,
++ * then goto START.
+  */
++if (PAGE_CACHE_SIZE > PAGE_SIZE) {
++	return 1;
++	goto START;
++}
+ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
+ {
+ 	int ret;
-- 
1.7.9.5

Regards,

Christopher
