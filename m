Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779Ab2JaLX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:23:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38686 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965466Ab2JaLXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:23:09 -0400
Message-ID: <50910A17.1090600@gmail.com>
Date: Wed, 31 Oct 2012 19:23:03 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of per_cpu_ptr(p,
 raw_smp_processor_id())
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

smp_processor_id is defined as raw_smp_processor_id.
replace per_cpu_ptr(p, raw_smp_processor_id()) is also ok.

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..3a21fcf 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	struct rcu_node *rnp_old = NULL;
 
 	/* Funnel through hierarchy to reduce memory contention. */
-	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
+	rnp = this_cpu_ptr(rsp->rda)->mynode;
 	for (; rnp != NULL; rnp = rnp->parent) {
 		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
 		      !raw_spin_trylock(&rnp->fqslock);
-- 
1.7.1

