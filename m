Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3ACKK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:10:56 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65502 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3ACKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:10:51 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-82-50e559275c54
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6/8] fs/configfs: checkpatch cleanup
Date: Thu, 03 Jan 2013 11:10:23 +0100
Message-id: <1357207825-10485-7-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
References: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xy7rqkU8DDJ6/srG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ37csYSv4oF1xbeMelgbGS8pdjJwcEgImEjtfXWOFsMUkLtxb
	z9bFyMUhJLCUUWLi6yvMEM4GJolTk16AVbEJGEvsPdjBCGKLCChIbO59xgpSxCywHqjjfgNY
	QhhobNO862wgNouAqsS8v7dYQGxeAVeJ6dd+s0Gsk5d4er8PzOYUcJP4cqeRHcQWAqqZv+Ux
	ywRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQrz+ZQfj4mNWhxgFOBiVeHhX1DwJ
	EGJNLCuuzD3EKMHBrCTCez0HKMSbklhZlVqUH19UmpNafIiRiYNTqoHRI2Wt9XbbTbM3vz0p
	P/PX21dTX97wu1xzfd3Bp/9edzsueeN3KH7JPe5lGn1MZjYzO2/ev7TpD0PC2S2xmZnd+2bV
	/DZ7t9DSQl+tPd1JQID12B1RO06jlrzLyyMKih1mVls1zdH/92PSb4aw17FPNmoblN9Wm9n1
	dmoeS63Xu/kzkh/P54+4pcRSnJFoqMVcVJwIAM43R1bYAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/configfs/item.c |   60 +++++++++++++++++++++++++--------------------------
 1 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/fs/configfs/item.c b/fs/configfs/item.c
index 50cee7f..05a08e1 100644
--- a/fs/configfs/item.c
+++ b/fs/configfs/item.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on kobject:
- * 	kobject is Copyright (c) 2002-2003 Patrick Mochel
+ *	kobject is Copyright (c) 2002-2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  *
@@ -35,9 +35,9 @@
 #include <linux/configfs.h>
 
 
-static inline struct config_item * to_item(struct list_head * entry)
+static inline struct config_item *to_item(struct list_head *entry)
 {
-	return container_of(entry,struct config_item,ci_entry);
+	return container_of(entry, struct config_item, ci_entry);
 }
 
 /* Evil kernel */
@@ -47,11 +47,12 @@ static void config_item_release(struct kref *kref);
  *	config_item_init - initialize item.
  *	@item:	item in question.
  */
-void config_item_init(struct config_item * item)
+void config_item_init(struct config_item *item)
 {
 	kref_init(&item->ci_kref);
 	INIT_LIST_HEAD(&item->ci_entry);
 }
+EXPORT_SYMBOL(config_item_init);
 
 /**
  *	config_item_set_name - Set the name of an item
@@ -62,19 +63,19 @@ void config_item_init(struct config_item * item)
  *	dynamically allocated string that @item->ci_name points to.
  *	Otherwise, use the static @item->ci_namebuf array.
  */
-int config_item_set_name(struct config_item * item, const char * fmt, ...)
+int config_item_set_name(struct config_item *item, const char *fmt, ...)
 {
 	int error = 0;
 	int limit = CONFIGFS_ITEM_NAME_LEN;
 	int need;
 	va_list args;
-	char * name;
+	char *name;
 
 	/*
 	 * First, try the static array
 	 */
-	va_start(args,fmt);
-	need = vsnprintf(item->ci_namebuf,limit,fmt,args);
+	va_start(args, fmt);
+	need = vsnprintf(item->ci_namebuf, limit, fmt, args);
 	va_end(args);
 	if (need < limit)
 		name = item->ci_namebuf;
@@ -83,20 +84,20 @@ int config_item_set_name(struct config_item * item, const char * fmt, ...)
 		 * Need more space? Allocate it and try again
 		 */
 		limit = need + 1;
-		name = kmalloc(limit,GFP_KERNEL);
+		name = kmalloc(limit, GFP_KERNEL);
 		if (!name) {
 			error = -ENOMEM;
-			goto Done;
+			goto done;
 		}
-		va_start(args,fmt);
-		need = vsnprintf(name,limit,fmt,args);
+		va_start(args, fmt);
+		need = vsnprintf(name, limit, fmt, args);
 		va_end(args);
 
 		/* Still? Give up. */
 		if (need >= limit) {
 			kfree(name);
 			error = -EFAULT;
-			goto Done;
+			goto done;
 		}
 	}
 
@@ -106,10 +107,9 @@ int config_item_set_name(struct config_item * item, const char * fmt, ...)
 
 	/* Now, set the new name */
 	item->ci_name = name;
- Done:
+ done:
 	return error;
 }
-
 EXPORT_SYMBOL(config_item_set_name);
 
 void config_item_init_type_name(struct config_item *item,
@@ -131,20 +131,21 @@ void config_group_init_type_name(struct config_group *group, const char *name,
 }
 EXPORT_SYMBOL(config_group_init_type_name);
 
-struct config_item * config_item_get(struct config_item * item)
+struct config_item *config_item_get(struct config_item *item)
 {
 	if (item)
 		kref_get(&item->ci_kref);
 	return item;
 }
+EXPORT_SYMBOL(config_item_get);
 
-static void config_item_cleanup(struct config_item * item)
+static void config_item_cleanup(struct config_item *item)
 {
-	struct config_item_type * t = item->ci_type;
-	struct config_group * s = item->ci_group;
-	struct config_item * parent = item->ci_parent;
+	struct config_item_type *t = item->ci_type;
+	struct config_group *s = item->ci_group;
+	struct config_item *parent = item->ci_parent;
 
-	pr_debug("config_item %s: cleaning up\n",config_item_name(item));
+	pr_debug("config_item %s: cleaning up\n", config_item_name(item));
 	if (item->ci_name != item->ci_namebuf)
 		kfree(item->ci_name);
 	item->ci_name = NULL;
@@ -167,11 +168,12 @@ static void config_item_release(struct kref *kref)
  *
  *	Decrement the refcount, and if 0, call config_item_cleanup().
  */
-void config_item_put(struct config_item * item)
+void config_item_put(struct config_item *item)
 {
 	if (item)
 		kref_put(&item->ci_kref, config_item_release);
 }
+EXPORT_SYMBOL(config_item_put);
 
 /**
  *	config_group_init - initialize a group for use
@@ -182,6 +184,7 @@ void config_group_init(struct config_group *group)
 	config_item_init(&group->cg_item);
 	INIT_LIST_HEAD(&group->cg_children);
 }
+EXPORT_SYMBOL(config_group_init);
 
 /**
  *	config_group_find_item - search for item in group.
@@ -195,11 +198,11 @@ void config_group_init(struct config_group *group)
 struct config_item *config_group_find_item(struct config_group *group,
 					   const char *name)
 {
-	struct list_head * entry;
-	struct config_item * ret = NULL;
+	struct list_head *entry;
+	struct config_item *ret = NULL;
 
-	list_for_each(entry,&group->cg_children) {
-		struct config_item * item = to_item(entry);
+	list_for_each(entry, &group->cg_children) {
+		struct config_item *item = to_item(entry);
 		if (config_item_name(item) &&
 		    !strcmp(config_item_name(item), name)) {
 			ret = config_item_get(item);
@@ -208,9 +211,4 @@ struct config_item *config_group_find_item(struct config_group *group,
 	}
 	return ret;
 }
-
-EXPORT_SYMBOL(config_item_init);
-EXPORT_SYMBOL(config_group_init);
-EXPORT_SYMBOL(config_item_get);
-EXPORT_SYMBOL(config_item_put);
 EXPORT_SYMBOL(config_group_find_item);
-- 
1.7.0.4

