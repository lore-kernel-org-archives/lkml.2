Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0EIUoC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:44:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0EIUnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=bUas8PxozfKvjAqaeQ5ukHqQF/uYB+Xcymb0sa3udStW1kGyQPwXoWFS6Q1KeRwO9f
         +/L8hXsviUAiiO7ES1IW3lpRsx+wiwOcI7qiSXaZoBUJhDgjtUewhGjmiKOTFr0VWSLe
         UsMlvj1XEzeymanR2MyWP+BMQ/q0uU9i/TAOQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 07/10] tracing: Drop the nested field from lock_release event
Date: Sun,  9 May 2010 22:43:35 +0200
Message-Id: <1273437818-8130-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the nested field as we don't use it. Every nested state can
be computed from a state machine on post processing already.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lock.h |    4 ++--
 kernel/lockdep.c            |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 17ca287..fde4c38 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -37,9 +37,9 @@ TRACE_EVENT(lock_acquire,
 
 TRACE_EVENT(lock_release,
 
-	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
+	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
 
-	TP_ARGS(lock, nested, ip),
+	TP_ARGS(lock, ip),
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 31e22e7..e9c759f 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3227,7 +3227,7 @@ void lock_release(struct lockdep_map *lock, int nested,
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
-	trace_lock_release(lock, nested, ip);
+	trace_lock_release(lock, ip);
 	__lock_release(lock, nested, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
-- 
1.6.2.3

