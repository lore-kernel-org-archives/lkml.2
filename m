Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1KHE3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:29:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:30715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1KHE3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:29:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:subject:references:
	content-disposition:x-system-of-record;
	b=aaHjZJEOAeQaQupW8QHiVIgjpMs1Kw1K6eBN+EA9u71Acm4jZdH1SXFO6OmXeWyZA
	PBGCeDyTnhYfok4WTs7wg==
Message-Id: <20111108042736.623812423@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:26:34 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [patch 2/3] sched: fix buglet in return_cfs_rq_runtime()
References: <20111108042632.977080206@google.com>
Content-Disposition: inline; filename=sched-bwc-fix_return_cfs_rq_runtime.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In return_cfs_rq_runtime() we want to return bandwidth when there are no
remaining tasks, not "return" when this is the case.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1746,7 +1746,7 @@ static __always_inline void return_cfs_r
 	if (!cfs_bandwidth_used())
 		return;
 
-	if (!cfs_rq->runtime_enabled || !cfs_rq->nr_running)
+	if (!cfs_rq->runtime_enabled || cfs_rq->nr_running)
 		return;
 
 	__return_cfs_rq_runtime(cfs_rq);


