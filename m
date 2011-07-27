Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1G0TMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:12:15 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:54840 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab1G0TMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:12:12 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 4/8] list, treewide: Rename __list_del_entry() to __list_del()
Date: Wed, 27 Jul 2011 21:10:21 +0200
Message-Id: <1311793825-31933-5-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

Now that the name __list_del was freed, we can use this more
appropriate name for __list_del_entry(), making the name a bit
more consistent with __list_add().

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 include/linux/list.h |   10 +++++-----
 lib/list_debug.c     |    6 +++---
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 9d093cc..5319099 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -95,7 +95,7 @@ static inline void __list_link(struct list_head *prev, struct list_head *next)
  * in an undefined state.
  */
 #ifndef CONFIG_DEBUG_LIST
-static inline void __list_del_entry(struct list_head *entry)
+static inline void __list_del(struct list_head *entry)
 {
 	__list_link(entry->prev, entry->next);
 }
@@ -107,7 +107,7 @@ static inline void list_del(struct list_head *entry)
 	entry->prev = LIST_POISON2;
 }
 #else
-extern void __list_del_entry(struct list_head *entry);
+extern void __list_del(struct list_head *entry);
 extern void list_del(struct list_head *entry);
 #endif
 
@@ -140,7 +140,7 @@ static inline void list_replace_init(struct list_head *old,
  */
 static inline void list_del_init(struct list_head *entry)
 {
-	__list_del_entry(entry);
+	__list_del(entry);
 	INIT_LIST_HEAD(entry);
 }
 
@@ -151,7 +151,7 @@ static inline void list_del_init(struct list_head *entry)
  */
 static inline void list_move(struct list_head *list, struct list_head *head)
 {
-	__list_del_entry(list);
+	__list_del(list);
 	list_add(list, head);
 }
 
@@ -163,7 +163,7 @@ static inline void list_move(struct list_head *list, struct list_head *head)
 static inline void list_move_tail(struct list_head *list,
 				  struct list_head *head)
 {
-	__list_del_entry(list);
+	__list_del(list);
 	list_add_tail(list, head);
 }
 
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 7e37695..9ca2d3a 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -35,7 +35,7 @@ void __list_add(struct list_head *new,
 }
 EXPORT_SYMBOL(__list_add);
 
-void __list_del_entry(struct list_head *entry)
+void __list_del(struct list_head *entry)
 {
 	struct list_head *prev, *next;
 
@@ -58,7 +58,7 @@ void __list_del_entry(struct list_head *entry)
 
 	__list_link(prev, next);
 }
-EXPORT_SYMBOL(__list_del_entry);
+EXPORT_SYMBOL(__list_del);
 
 /**
  * list_del - deletes entry from list.
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(__list_del_entry);
  */
 void list_del(struct list_head *entry)
 {
-	__list_del_entry(entry);
+	__list_del(entry);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
-- 
1.7.6

