Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0KUNfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 08:35:18 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35391 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab0KUNfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 08:35:16 -0500
Date: Sun, 21 Nov 2010 08:35:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Change return type of obvious Boolean list fns to "bool".
Message-ID: <alpine.DEB.2.00.1011210819350.25385@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's clear that a number of basic list routines return simply a
Boolean value, so change their return type from "int" to "bool".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  Compile-tested with defconfig on x86_64.  Not sure who should
be CCed when a patch touches something this basic.  Andrew?


diff --git a/include/linux/list.h b/include/linux/list.h
index 9a5f8a7..1d6ed55 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -167,7 +167,7 @@ static inline void list_move_tail(struct list_head *list,
  * @list: the entry to test
  * @head: the head of the list
  */
-static inline int list_is_last(const struct list_head *list,
+static inline bool list_is_last(const struct list_head *list,
 				const struct list_head *head)
 {
 	return list->next == head;
@@ -177,7 +177,7 @@ static inline int list_is_last(const struct list_head *list,
  * list_empty - tests whether a list is empty
  * @head: the list to test.
  */
-static inline int list_empty(const struct list_head *head)
+static inline bool list_empty(const struct list_head *head)
 {
 	return head->next == head;
 }
@@ -195,7 +195,7 @@ static inline int list_empty(const struct list_head *head)
  * to the list entry is list_del_init(). Eg. it cannot be used
  * if another CPU could re-list_add() it.
  */
-static inline int list_empty_careful(const struct list_head *head)
+static inline bool list_empty_careful(const struct list_head *head)
 {
 	struct list_head *next = head->next;
 	return (next == head) && (next == head->prev);
@@ -219,7 +219,7 @@ static inline void list_rotate_left(struct list_head *head)
  * list_is_singular - tests whether a list has just one entry.
  * @head: the list to test.
  */
-static inline int list_is_singular(const struct list_head *head)
+static inline bool list_is_singular(const struct list_head *head)
 {
 	return !list_empty(head) && (head->next == head->prev);
 }


rday

--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
