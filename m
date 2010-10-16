Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0JPExo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:53:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:31365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0JPExl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:53:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=TUHEiKZ8WKk3AdovAOuB902YtqPYi1kFv6vHq4yw8AjM3ZJ+WGDiqQ6C6PYXQWjv0
	eycVKUVFH3Hk/tvdz0d8A==
Message-Id: <20101016045119.059187452@google.com>
References: <20101016044349.830426011@google.com>
User-Agent: quilt/0.46-1
Date: Fri, 15 Oct 2010 21:43:57 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC tg_shares_up improvements - v1 08/12] sched: update shares on idle_balance
Content-Disposition: inline; filename=sched-tg-update_shares_on_idle_balance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since shares updates are no longer expensive and effectively local, update them
at idle_balance().  This allows us to more quickly redistribute shares to
another cpu when our load becomes idle.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |    1 +
 1 file changed, 1 insertion(+)

Index: kernel/sched_fair.c
===================================================================
--- kernel/sched_fair.c.orig
+++ kernel/sched_fair.c
@@ -3301,6 +3301,7 @@ static void idle_balance(int this_cpu, s
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
+	update_shares(this_cpu);
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;

-- 

