Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1B0KqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 05:46:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1B0KqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 05:46:23 -0500
Date: Sun, 27 Feb 2011 11:46:21 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] list: add list_last_entry macros
Message-ID: <20110227104620.GA2814@psychotron.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handy to get last item in a list. Also corrected parameter name for
list_first_entry.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>

diff --git a/include/linux/list.h b/include/linux/list.h
index 3a54266..e10862e 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -352,14 +352,25 @@ static inline void list_splice_tail_init(struct list_head *list,
 
 /**
  * list_first_entry - get the first element from a list
- * @ptr:	the list head to take the element from.
+ * @head:	the list head to take the element from.
  * @type:	the type of the struct this is embedded in.
  * @member:	the name of the list_struct within the struct.
  *
  * Note, that list is expected to be not empty.
  */
-#define list_first_entry(ptr, type, member) \
-	list_entry((ptr)->next, type, member)
+#define list_first_entry(head, type, member) \
+	list_entry((head)->next, type, member)
+
+/**
+ * list_last_entry - get the last element from a list
+ * @head:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(head, type, member) \
+	list_entry((head)->prev, type, member)
 
 /**
  * list_for_each	-	iterate over a list
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 2dea94f..2cfa99f 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -229,7 +229,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 
 /**
  * list_first_entry_rcu - get the first element from a list
- * @ptr:        the list head to take the element from.
+ * @head:       the list head to take the element from.
  * @type:       the type of the struct this is embedded in.
  * @member:     the name of the list_struct within the struct.
  *
@@ -238,8 +238,23 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * This primitive may safely run concurrently with the _rcu list-mutation
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
-#define list_first_entry_rcu(ptr, type, member) \
-	list_entry_rcu((ptr)->next, type, member)
+#define list_first_entry_rcu(head, type, member) \
+	list_entry_rcu((head)->next, type, member)
+
+/**
+ * list_last_entry_rcu - get the last element from a list
+ * @head:       the list head to take the element from.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+
+#define list_last_entry_rcu(head, type, member) \
+	list_entry_rcu((head)->prev, type, member)
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
