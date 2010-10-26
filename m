Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab0JZVX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:23:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17857 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab0JZVX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:23:27 -0400
Date: Tue, 26 Oct 2010 14:17:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] docbook: add more wait/wake/completion to device-drivers
 docbook
Message-Id: <20101026141725.858a3b12.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add more wait, wake, and completion interfaces to the device-drivers
docbook.

Fix kernel-doc notation in the added files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/device-drivers.tmpl |    5 +++++
 include/linux/completion.h                |   10 +++++-----
 kernel/wait.c                             |    6 +++---
 3 files changed, 13 insertions(+), 8 deletions(-)

--- lnx-2636-g6-docs.orig/Documentation/DocBook/device-drivers.tmpl
+++ lnx-2636-g6-docs/Documentation/DocBook/device-drivers.tmpl
@@ -51,8 +51,13 @@
      <sect1><title>Delaying, scheduling, and timer routines</title>
 !Iinclude/linux/sched.h
 !Ekernel/sched.c
+!Iinclude/linux/completion.h
 !Ekernel/timer.c
      </sect1>
+     <sect1><title>Wait queues and Wake events</title>
+!Iinclude/linux/wait.h
+!Ekernel/wait.c
+     </sect1>
      <sect1><title>High-resolution timers</title>
 !Iinclude/linux/ktime.h
 !Iinclude/linux/hrtimer.h
--- lnx-2636-g6-docs.orig/include/linux/completion.h
+++ lnx-2636-g6-docs/include/linux/completion.h
@@ -10,7 +10,7 @@
 
 #include <linux/wait.h>
 
-/**
+/*
  * struct completion - structure used to maintain state for a "completion"
  *
  * This is the opaque structure used to maintain the state for a "completion".
@@ -34,7 +34,7 @@ struct completion {
 	({ init_completion(&work); work; })
 
 /**
- * DECLARE_COMPLETION: - declare and initialize a completion structure
+ * DECLARE_COMPLETION - declare and initialize a completion structure
  * @work:  identifier for the completion structure
  *
  * This macro declares and initializes a completion structure. Generally used
@@ -50,7 +50,7 @@ struct completion {
  * are on the kernel stack:
  */
 /**
- * DECLARE_COMPLETION_ONSTACK: - declare and initialize a completion structure
+ * DECLARE_COMPLETION_ONSTACK - declare and initialize a completion structure
  * @work:  identifier for the completion structure
  *
  * This macro declares and initializes a completion structure on the kernel
@@ -64,7 +64,7 @@ struct completion {
 #endif
 
 /**
- * init_completion: - Initialize a dynamically allocated completion
+ * init_completion - Initialize a dynamically allocated completion
  * @x:  completion structure that is to be initialized
  *
  * This inline function will initialize a dynamically created completion
@@ -92,7 +92,7 @@ extern void complete(struct completion *
 extern void complete_all(struct completion *);
 
 /**
- * INIT_COMPLETION: - reinitialize a completion structure
+ * INIT_COMPLETION - reinitialize a completion structure
  * @x:  completion structure to be reinitialized
  *
  * This macro should be used to reinitialize a completion structure so it can
--- lnx-2636-g6-docs.orig/kernel/wait.c
+++ lnx-2636-g6-docs/kernel/wait.c
@@ -92,7 +92,7 @@ prepare_to_wait_exclusive(wait_queue_hea
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
-/*
+/**
  * finish_wait - clean up after waiting in a queue
  * @q: waitqueue waited on
  * @wait: wait descriptor
@@ -127,11 +127,11 @@ void finish_wait(wait_queue_head_t *q, w
 }
 EXPORT_SYMBOL(finish_wait);
 
-/*
+/**
  * abort_exclusive_wait - abort exclusive waiting in a queue
  * @q: waitqueue waited on
  * @wait: wait descriptor
- * @state: runstate of the waiter to be woken
+ * @mode: runstate of the waiter to be woken
  * @key: key to identify a wait bit queue or %NULL
  *
  * Sets current thread back to running state and removes
