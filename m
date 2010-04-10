Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab0DJKls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 06:41:48 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60560 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0DJKlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 06:41:44 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] Add "nested" field to event of lock_release
Date: Sat, 10 Apr 2010 19:41:40 +0900
Message-Id: <1270896100-7935-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

State machine of perf lock requires "nested" field of lock_release(),
so this patch adds it to event.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

---
 include/trace/events/lock.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 5c1dcfc..4f489b5 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -44,15 +44,17 @@ TRACE_EVENT(lock_release,
 	TP_STRUCT__entry(
 		__string(name, lock->name)
 		__field(void *, lockdep_addr)
+		__field(int, nested)
 	),
 
 	TP_fast_assign(
 		__assign_str(name, lock->name);
 		__entry->lockdep_addr = lock;
+		__entry->nested = nested;
 	),
 
-	TP_printk("%p %s",
-		  __entry->lockdep_addr, __get_str(name))
+	TP_printk("%p %s %d",
+		  __entry->lockdep_addr, __get_str(name), __entry->nested)
 );
 
 #ifdef CONFIG_LOCK_STAT
-- 
1.6.5.2

