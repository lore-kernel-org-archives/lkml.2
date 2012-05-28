Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2E1JES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:04:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:52669 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab2E1JEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:04:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="145350633"
From: Alex Shi <alex.shi@intel.com>
To: alex.shi@intel.com, rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        kosaki.motohiro@jp.fujitsu.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpumask: add a few comments of cpumask functions
Date: Mon, 28 May 2012 17:02:28 +0800
Message-Id: <1338195748-18934-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current few cpumask function purpose are not quite clear. Stupid
user like myself need to dig into details for clear function
purpose and return value.
Add few explanation for them is helpful.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/cpumask.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index a2c819d..8436e61 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -271,6 +271,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_cpu - test for a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
  *
  * No static inline type checking - see Subtlety (1) above.
  */
@@ -281,6 +282,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
  *
  * test_and_set_bit wrapper for cpumasks.
  */
@@ -293,6 +295,7 @@ static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
  * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
  *
  * test_and_clear_bit wrapper for cpumasks.
  */
@@ -324,6 +327,7 @@ static inline void cpumask_clear(struct cpumask *dstp)
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
+ * if *dstp is empty, return 0, otherwise return 1
  */
 static inline int cpumask_and(struct cpumask *dstp,
 			       const struct cpumask *src1p,
@@ -365,6 +369,7 @@ static inline void cpumask_xor(struct cpumask *dstp,
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
+ * if *dstp is empty, return 0, otherwise return 1
  */
 static inline int cpumask_andnot(struct cpumask *dstp,
 				  const struct cpumask *src1p,
@@ -414,6 +419,7 @@ static inline bool cpumask_intersects(const struct cpumask *src1p,
  * cpumask_subset - (*src1p & ~*src2p) == 0
  * @src1p: the first input
  * @src2p: the second input
+ * return 1 if the *src1p is the subset of *src2p, otherwise return 0
  */
 static inline int cpumask_subset(const struct cpumask *src1p,
 				 const struct cpumask *src2p)
-- 
1.7.5.4

