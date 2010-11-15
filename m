Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab0KOXwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:52:55 -0500
Received: from smtp-out.google.com ([74.125.121.35]:36061 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab0KOXws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:52:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=vAMAOA4N1lXy0MAtNHa0oxjWcVbKDOgMeacrDcZfyely3Vrc6xB+6zTfWzUs5Ssx4
	xIPVSV25MfmcmqH5vhU/w==
Message-Id: <20101115234938.204191702@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 15 Nov 2010 15:47:07 -0800
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
Subject: [tg_shares_up rewrite v4 08/11] sched: update shares on idle_balance
References: <20101115234659.610333554@google.com>
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

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -3365,6 +3365,7 @@ static void idle_balance(int this_cpu, s
 	 */
 	raw_spin_unlock(&this_rq->lock);
 
+	update_shares(this_cpu);
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;


