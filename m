Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0KASsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:48:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49923 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0KASl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ofFyzBUUZXEfbmE3IgPv2pR/Q4BQ3VdEKAnNbO/FhP+KdlXsotwZP3+MINLrVKe9+v
         uDU+VX0nApQFlZkWFM71lO370yMsjKLbU9Hg8LdH3WK4QvRLc+RJMeS+9Pi9e6B0lkhQ
         xi+qvtRHr0Gn4I/73q03+p0LfS0ctO7ddHRB0=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 12/29] Staging: yaffs2: yaffs_list.h: add file
Date: Mon,  1 Nov 2010 14:41:00 -0400
Message-Id: <1288636877-7964-13-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_list.h |  127 +++++++++++++++++++++++++++++++++++
 1 files changed, 127 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_list.h

diff --git a/drivers/staging/yaffs2/yaffs_list.h b/drivers/staging/yaffs2/yaffs_list.h
new file mode 100644
index 0000000..145a1c5
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_list.h
@@ -0,0 +1,127 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+/*
+ * This file is just holds extra declarations of macros that would normally
+ * be providesd in the Linux kernel. These macros have been written from
+ * scratch but are functionally equivalent to the Linux ones.
+ *
+ */
+
+#ifndef __YAFFS_LIST_H__
+#define __YAFFS_LIST_H__
+
+
+#include "yportenv.h"
+
+/*
+ * This is a simple doubly linked list implementation that matches the
+ * way the Linux kernel doubly linked list implementation works.
+ */
+
+struct ylist_head {
+	struct ylist_head *next; /* next in chain */
+	struct ylist_head *prev; /* previous in chain */
+};
+
+
+/* Initialise a static list */
+#define YLIST_HEAD(name) \
+struct ylist_head name = { &(name), &(name)}
+
+
+
+/* Initialise a list head to an empty list */
+#define YINIT_LIST_HEAD(p) \
+do { \
+	(p)->next = (p);\
+	(p)->prev = (p); \
+} while (0)
+
+
+/* Add an element to a list */
+static Y_INLINE void ylist_add(struct ylist_head *new_entry,
+				struct ylist_head *list)
+{
+	struct ylist_head *list_next = list->next;
+
+	list->next = new_entry;
+	new_entry->prev = list;
+	new_entry->next = list_next;
+	list_next->prev = new_entry;
+
+}
+
+static Y_INLINE void ylist_add_tail(struct ylist_head *new_entry,
+				 struct ylist_head *list)
+{
+	struct ylist_head *list_prev = list->prev;
+
+	list->prev = new_entry;
+	new_entry->next = list;
+	new_entry->prev = list_prev;
+	list_prev->next = new_entry;
+
+}
+
+
+/* Take an element out of its current list, with or without
+ * reinitialising the links.of the entry*/
+static Y_INLINE void ylist_del(struct ylist_head *entry)
+{
+	struct ylist_head *list_next = entry->next;
+	struct ylist_head *list_prev = entry->prev;
+
+	list_next->prev = list_prev;
+	list_prev->next = list_next;
+
+}
+
+static Y_INLINE void ylist_del_init(struct ylist_head *entry)
+{
+	ylist_del(entry);
+	entry->next = entry->prev = entry;
+}
+
+
+/* Test if the list is empty */
+static Y_INLINE int ylist_empty(struct ylist_head *entry)
+{
+	return (entry->next == entry);
+}
+
+
+/* ylist_entry takes a pointer to a list entry and offsets it to that
+ * we can find a pointer to the object it is embedded in.
+ */
+
+
+#define ylist_entry(entry, type, member) \
+	((type *)((char *)(entry)-(unsigned long)(&((type *)NULL)->member)))
+
+
+/* ylist_for_each and list_for_each_safe  iterate over lists.
+ * ylist_for_each_safe uses temporary storage to make the list delete safe
+ */
+
+#define ylist_for_each(itervar, list) \
+	for (itervar = (list)->next; itervar != (list); itervar = itervar->next)
+
+#define ylist_for_each_safe(itervar, save_var, list) \
+	for (itervar = (list)->next, save_var = (list)->next->next; \
+		itervar != (list); itervar = save_var, save_var = save_var->next)
+
+
+#endif
-- 
1.7.3.2.146.gca209

