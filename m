Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0KLDeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:34:11 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11404 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0KLDck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:32:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
	b=cSG/nb0hP3cL6nOpV8R7kUtVGIv+DIN7a/UdiUnFCO9VdtggmgOVIJ9voX2qhSC1Q
	pAGIqdUDe14QAOqr/4gAg==
Message-Id: <20101112032701.947743064@google.com>
References: <20101112032405.657789056@google.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Nov 2010 19:24:13 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [tg_shares_up rewrite v3 08/11] sched: update shares on idle_balance
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

