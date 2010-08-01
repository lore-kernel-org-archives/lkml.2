Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0HAJyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 05:54:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:53536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab0HAJyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 05:54:35 -0400
Message-ID: <4C55444B.9030804@kernel.org>
Date: Sun, 01 Aug 2010 11:54:19 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH wq#for-next] workqueue: explain for_each_*cwq_cpu() iterators
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com> <20100730165522.22dc982b.akpm@linux-foundation.org>
In-Reply-To: <20100730165522.22dc982b.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 01 Aug 2010 09:54:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_*cwq_cpu() are similar to regular CPU iterators except that
it also considers the pseudo CPU number used for unbound workqueues.
Explain them.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/workqueue.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e5cb7fa..1105c47 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -271,6 +271,19 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 	return __next_gcwq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
 }

+/*
+ * CPU iterators
+ *
+ * An extra gcwq is defined for an invalid cpu number
+ * (WORK_CPU_UNBOUND) to host workqueues which are not bound to any
+ * specific CPU.  The following iterators are similar to
+ * for_each_*_cpu() iterators but also considers the unbound gcwq.
+ *
+ * for_each_gcwq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
+ * for_each_online_gcwq_cpu()	: online CPUs + WORK_CPU_UNBOUND
+ * for_each_cwq_cpu()		: possible CPUs for bound workqueues,
+ *				  WORK_CPU_UNBOUND for unbound workqueues
+ */
 #define for_each_gcwq_cpu(cpu)						\
 	for ((cpu) = __next_gcwq_cpu(-1, cpu_possible_mask, 3);		\
 	     (cpu) < WORK_CPU_NONE;					\
-- 
1.7.1

