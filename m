Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027Ab1AVFFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 00:05:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5527 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1AVFEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 00:04:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=yXXkiSU1rwf9CgdcWChrp0pYkcwrVpxr3aUKSCQvcMFbs2fGVtZeZi4iMPpVSodZS
	Y1n+76bZgsU0xZ0radBkw==
Message-Id: <20110122044852.007092349@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 20:45:02 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [patch 4/5] sched: use rq->clock_task instead of rq->clock for maintaining load averages
References: <20110122044458.058531078@google.com>
Content-Disposition: inline; filename=sched-use_clock_task.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The delta in clock_task is a more fair attribution of how much time a tg has
been contributing load to the current cpu.

While not really important it also means we're more in sync (by magnitude)
with respect to periodic updates (since __update_curr deltas are clock_task
based).

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -724,7 +724,7 @@ static void update_cfs_load(struct cfs_r
 	if (cfs_rq->tg == root_task_group)
 		return;
 
-	now = rq_of(cfs_rq)->clock;
+	now = rq_of(cfs_rq)->clock_task;
 	delta = now - cfs_rq->load_stamp;
 
 	/* truncate load history at 4 idle periods */


