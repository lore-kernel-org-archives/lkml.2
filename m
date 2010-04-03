Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0DCKsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 06:48:10 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35268 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0DCKrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 06:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SOYTuIiBSJWDZz4XrDAdZbAPUtuYOGHiWL5SQEvRu2Y83UwTYWJL03qeleLrLycUbq
         tv9CED9TNVzIUMZJOFSJILr4osEpM3k08Gtca7ktQBJHjLBei8IguMEdmQH00DrGaqKH
         qLcvDyI/GEhdwG+SUE7swX7Zy2i+2rKLAfsdA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/2] perf: Always build the stub perf_arch_fetch_caller_regs version
Date: Sat,  3 Apr 2010 12:47:38 +0200
Message-Id: <1270291659-6299-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270291659-6299-1-git-send-regression-fweisbec@gmail.com>
References: <1270291659-6299-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that software events use perf_arch_fetch_caller_regs() too, we
need the stub version to be always built in for archs that don't
implement it.

Fixes the following build error in PARISC:

	kernel/built-in.o: In function `perf_event_task_sched_out':
	(.text.perf_event_task_sched_out+0x54): undefined reference to `perf_arch_fetch_caller_regs'

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 96aae13..681af80 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2784,12 +2784,11 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 	return NULL;
 }
 
-#ifdef CONFIG_EVENT_TRACING
 __weak
 void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int skip)
 {
 }
-#endif
+
 
 /*
  * Output
-- 
1.6.2.3

