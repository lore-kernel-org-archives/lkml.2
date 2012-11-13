Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2KMBww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:52:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64882 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2KMBwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:52:49 -0500
Message-ID: <50A1A7E8.4010802@gmail.com>
Date: Tue, 13 Nov 2012 09:52:40 +0800
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
Acked-by: Christoph Lameter <cl@linux.com>
---
no changes vs v3,v2.
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

