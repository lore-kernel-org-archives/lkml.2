Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0CTTT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:19:27 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58014 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0CTTT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=qkGwhTAjA9LdC7EKHWgwpCWV76dG+yBaiAGrfND4q13JzQvpQbZGmXxN4c5ajHFQFE
         ZFuoq0/O4NUiWSxFdiyndEp/y6n4wgI7ZKdJbfr29+VUmqZKyTzXV7bvJravIEppU1NN
         7LhuLtw6GOCDtcrE2oKvJ98h08uVYtSEsPW0k=
MIME-Version: 1.0
Date: Sat, 20 Mar 2010 21:19:24 +0200
Message-ID: <371405281003201219r7063f047g60024f726776615e@mail.gmail.com>
Subject: [PATCH] checkpatch: list.h
From: Vladimir Kondratiev <vladimir.kondratiev@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to clean up (make checkpatch happy) at least most useful headers.

Following is patch that cleans list.h

If it is welcomed, I'll continue this effort.
-- 
Thanks, Vladimir


>From a6b57aea7777d8110ac9023840260fe487611d73 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <vladimir.kondratiev@gmail.com>
Date: Sat, 20 Mar 2010 20:43:44 +0200
Subject: [PATCH] checkpatch: list.h

made it checkpatch clean

Signed-off-by: Vladimir Kondratiev <vladimir.kondratiev@gmail.com>
---
 include/linux/list.h |   57 +++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 8392884..da313e7 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -87,7 +87,7 @@ static inline void list_add_tail(struct list_head
*new, struct list_head *head)
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-static inline void __list_del(struct list_head * prev, struct list_head * next)
+static inline void __list_del(struct list_head *prev, struct list_head *next)
 {
 	next->prev = prev;
 	prev->next = next;
@@ -366,7 +366,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
  */
 #define list_for_each(pos, head) \
 	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
-        	pos = pos->next)
+		pos = pos->next)

 /**
  * __list_for_each	-	iterate over a list
@@ -388,7 +388,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
  */
 #define list_for_each_prev(pos, head) \
 	for (pos = (head)->prev; prefetch(pos->prev), pos != (head); \
-        	pos = pos->prev)
+		pos = pos->prev)

 /**
  * list_for_each_safe - iterate over a list safe against removal of list entry
@@ -419,7 +419,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     prefetch(pos->member.next), &pos->member != (head); 	\
+	     prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))

 /**
@@ -430,7 +430,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     prefetch(pos->member.prev), &pos->member != (head); 	\
+	     prefetch(pos->member.prev), &pos->member != (head);	\
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))

 /**
@@ -439,7 +439,8 @@ static inline void list_splice_tail_init(struct
list_head *list,
  * @head:	the head of the list
  * @member:	the name of the list_struct within the struct.
  *
- * Prepares a pos entry for use as a start point in
list_for_each_entry_continue().
+ * Prepares a pos entry for use as a start point in
+ * list_for_each_entry_continue().
  */
 #define list_prepare_entry(pos, head, member) \
 	((pos) ? : list_entry(head, typeof(*pos), member))
@@ -453,7 +454,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
  * Continue to iterate over list of given type, continuing after
  * the current position.
  */
-#define list_for_each_entry_continue(pos, head, member) 		\
+#define list_for_each_entry_continue(pos, head, member)			\
 	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
 	     prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))
@@ -480,7 +481,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
  *
  * Iterate over list of given type, continuing from current position.
  */
-#define list_for_each_entry_from(pos, head, member) 			\
+#define list_for_each_entry_from(pos, head, member)			\
 	for (; prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry(pos->member.next, typeof(*pos), member))

@@ -494,7 +495,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
 		n = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
+	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))

 /**
@@ -507,10 +508,10 @@ static inline void list_splice_tail_init(struct
list_head *list,
  * Iterate over list of given type, continuing after current point,
  * safe against removal of list entry.
  */
-#define list_for_each_entry_safe_continue(pos, n, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member), 		\
-		n = list_entry(pos->member.next, typeof(*pos), member);		\
-	     &pos->member != (head);						\
+#define list_for_each_entry_safe_continue(pos, n, head, member)		\
+	for (pos = list_entry(pos->member.next, typeof(*pos), member),	\
+		n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))

 /**
@@ -523,9 +524,9 @@ static inline void list_splice_tail_init(struct
list_head *list,
  * Iterate over list of given type from current point, safe against
  * removal of list entry.
  */
-#define list_for_each_entry_safe_from(pos, n, head, member) 			\
-	for (n = list_entry(pos->member.next, typeof(*pos), member);		\
-	     &pos->member != (head);						\
+#define list_for_each_entry_safe_from(pos, n, head, member)		\
+	for (n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))

 /**
@@ -541,7 +542,7 @@ static inline void list_splice_tail_init(struct
list_head *list,
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
 		n = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
+	     &pos->member != (head);					\
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))

 /*
@@ -629,7 +630,7 @@ static inline void hlist_add_after(struct hlist_node *n,
 	n->next = next;
 	next->pprev = &n->next;

-	if(next->next)
+	if (next->next)
 		next->next->pprev  = &next->next;
 }

@@ -646,7 +647,7 @@ static inline void hlist_move_list(struct hlist_head *old,
 	old->first = NULL;
 }

-#define hlist_entry(ptr, type, member) container_of(ptr,type,member)
+#define hlist_entry(ptr, type, member) container_of(ptr, type, member)

 #define hlist_for_each(pos, head) \
 	for (pos = (head)->first; pos && ({ prefetch(pos->next); 1; }); \
@@ -665,8 +666,8 @@ static inline void hlist_move_list(struct hlist_head *old,
  */
 #define hlist_for_each_entry(tpos, pos, head, member)			 \
 	for (pos = (head)->first;					 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });\
 	     pos = pos->next)

 /**
@@ -677,8 +678,8 @@ static inline void hlist_move_list(struct hlist_head *old,
  */
 #define hlist_for_each_entry_continue(tpos, pos, member)		 \
 	for (pos = (pos)->next;						 \
-	     pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });\
 	     pos = pos->next)

 /**
@@ -688,8 +689,8 @@ static inline void hlist_move_list(struct hlist_head *old,
  * @member:	the name of the hlist_node within the struct.
  */
 #define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	for (; pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });\
 	     pos = pos->next)

 /**
@@ -700,10 +701,10 @@ static inline void hlist_move_list(struct hlist_head *old,
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
  */
-#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
+#define hlist_for_each_entry_safe(tpos, pos, n, head, member)		 \
 	for (pos = (head)->first;					 \
-	     pos && ({ n = pos->next; 1; }) && 				 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos && ({ n = pos->next; 1; }) &&				 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; });\
 	     pos = n)

 #endif
-- 
1.6.2.1
