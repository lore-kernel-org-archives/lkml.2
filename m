Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0IITpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:45:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:40613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0IITpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:45:53 -0400
Date: Thu, 9 Sep 2010 19:45:29 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix CPU hotplug
Message-ID: <tip-5e11637e2c929e34dcc0fbbfb48bdb638937701a@git.kernel.org>
Git-Commit-ID: 5e11637e2c929e34dcc0fbbfb48bdb638937701a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:45:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e11637e2c929e34dcc0fbbfb48bdb638937701a
Gitweb:     http://git.kernel.org/tip/5e11637e2c929e34dcc0fbbfb48bdb638937701a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 Jun 2010 13:35:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:38:52 +0200

perf: Fix CPU hotplug

Since we have UP_PREPARE, we should also have UP_CANCELED.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 657555a..db5b560 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5761,15 +5761,15 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
 		perf_event_init_cpu(cpu);
 		break;
 
+	case CPU_UP_CANCELED:
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		perf_event_exit_cpu(cpu);
 		break;
 
