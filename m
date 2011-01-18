Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1ARQRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:17:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab1ARQRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:17:54 -0500
Date: Tue, 18 Jan 2011 17:10:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 1/2] perf: find_get_context: fix the per-cpu-counter check
Message-ID: <20110118161008.GB693@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20110117203459.GA32700@redhat.com> <1295297576.30950.382.camel@laptop> <20110118160942.GA693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118160942.GA693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If task == NULL, find_get_context() should always check that cpu
is correct.

Afaics, the bug was introduced by 38a81da2 "perf events: Clean up
pid passing", but even before that commit "&& cpu != -1" was not
exactly right, -ESRCH from find_task_by_vpid() is not accurate.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- git/kernel/perf_event.c~1_find_get_context	2011-01-14 18:21:05.000000000 +0100
+++ git/kernel/perf_event.c	2011-01-18 16:56:40.000000000 +0100
@@ -2228,7 +2228,7 @@ find_get_context(struct pmu *pmu, struct
 	unsigned long flags;
 	int ctxn, err;
 
-	if (!task && cpu != -1) {
+	if (!task) {
 		/* Must be root to operate on a CPU event: */
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);

