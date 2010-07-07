Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0GGIEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 04:04:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:59208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab0GGIEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 04:04:20 -0400
Date: Wed, 7 Jul 2010 08:03:40 GMT
From: tip-bot for Kulikov Vasiliy <segooon@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu, segooon@gmail.com, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       dzickus@redhat.com, segooon@gmail.com, mingo@elte.hu
In-Reply-To: <1278316854-28442-1-git-send-email-segooon@gmail.com>
References: <1278316854-28442-1-git-send-email-segooon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] kernel/watchdog: Initialize 'result'
Message-ID: <tip-eb703f98191a505f78d0066712ad67d5dedc4c90@git.kernel.org>
Git-Commit-ID: eb703f98191a505f78d0066712ad67d5dedc4c90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 07 Jul 2010 08:03:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb703f98191a505f78d0066712ad67d5dedc4c90
Gitweb:     http://git.kernel.org/tip/eb703f98191a505f78d0066712ad67d5dedc4c90
Author:     Kulikov Vasiliy <segooon@gmail.com>
AuthorDate: Mon, 5 Jul 2010 12:00:54 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Jul 2010 08:46:42 +0200

kernel/watchdog: Initialize 'result'

Variable on the stack is not initialized to zero, do it
explicitly.

This bug was found by a compiler warning:

 kernel/watchdog.c:463: warning: 'result' may be used uninitialized in this function

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1278316854-28442-1-git-send-email-segooon@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 91b0b26..613bc1f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -460,7 +460,7 @@ static void watchdog_disable(int cpu)
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
-	int result;
+	int result = 0;
 
 	for_each_online_cpu(cpu)
 		result += watchdog_enable(cpu);
