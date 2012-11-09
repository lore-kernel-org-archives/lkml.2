Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab2KICVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:21:40 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55251 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2KICVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:21:39 -0500
Message-ID: <509C68AE.9090009@gmail.com>
Date: Fri, 09 Nov 2012 10:21:34 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org, Shan Wei <shanwei88@gmail.com>
Subject: [PATCH v3 6/9] rcu: use __this_cpu_read helper instead of per_cpu_ptr(p,
 raw_smp_processor_id())
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
no changes vs v2.
---
 kernel/rcutree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..441b945 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	struct rcu_node *rnp_old = NULL;
 
 	/* Funnel through hierarchy to reduce memory contention. */
-	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
+	rnp = __this_cpu_read(rsp->rda->mynode);
 	for (; rnp != NULL; rnp = rnp->parent) {
 		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
 		      !raw_spin_trylock(&rnp->fqslock);
-- 
1.7.1
