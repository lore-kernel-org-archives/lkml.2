Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2GPCeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 22:34:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:20817 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2GPCeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 22:34:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177812349"
Message-ID: <50037DC6.6030209@intel.com>
Date: Mon, 16 Jul 2012 10:34:46 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        rusty@rustcorp.com.au, paul.gortmaker@windriver.com,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com> <4FC373D9.7040109@linux.vnet.ibm.com> <4FC38277.2030500@intel.com> <4FC38A77.8090700@intel.com> <20120713153756.78234398.akpm@linux-foundation.org>
In-Reply-To: <20120713153756.78234398.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> And the same applies to the other comments.  So can you please grab the
> latest linux-next, prepare a fixup patch and also check that the patch
> is complete - not all of your changes have been applied.
> 



Thanks for reminder! I just know this rule now. :)

===
>From 7b227fd186f0abc4b5fb1b7b768253d489f1ed56 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 16 Jul 2012 09:52:33 +0800
Subject: [PATCH 1/2] cpumask: fix kernel-doc incompatible comments

commit c4549cd0d77 introduced some kernel-doc incompatible comments
format, that make kernel-doc output mess and looks strange. like
the part of man cpumask_subset, the DESCRIPTION part merged into
ARGUMENTS incorrectly:

ARGUMENTS
       src1p       the first input

       src2p       the second input Returns 1 if *src1p is a subset of *src2p, else returns 0

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/cpumask.h |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 170c5af..8bf1c27 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -271,7 +271,8 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_cpu - test for a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
- * Returns 1 if 'cpu' is set in 'cpumask', else returns 0
+ *
+ * Returns 1 if @cpu is set in @cpumask, else returns 0
  *
  * No static inline type checking - see Subtlety (1) above.
  */
@@ -282,7 +283,8 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
- * Returns 1 if 'cpu' is set in old bitmap of 'cpumask', else returns 0
+ *
+ * Returns 1 if @cpu is set in old bitmap of @cpumask, else returns 0
  *
  * test_and_set_bit wrapper for cpumasks.
  */
@@ -295,7 +297,8 @@ static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
  * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
- * Returns 1 if 'cpu' is set in old bitmap of 'cpumask', else returns 0
+ *
+ * Returns 1 if @cpu is set in old bitmap of @cpumask, else returns 0
  *
  * test_and_clear_bit wrapper for cpumasks.
  */
@@ -327,7 +330,8 @@ static inline void cpumask_clear(struct cpumask *dstp)
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
- * If *dstp is empty, returns 0, else returns 1
+ *
+ * If *@dstp is empty, returns 0, else returns 1
  */
 static inline int cpumask_and(struct cpumask *dstp,
 			       const struct cpumask *src1p,
@@ -369,7 +373,8 @@ static inline void cpumask_xor(struct cpumask *dstp,
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
- * If *dstp is empty, returns 0, else returns 1
+ *
+ * If *@dstp is empty, returns 0, else returns 1
  */
 static inline int cpumask_andnot(struct cpumask *dstp,
 				  const struct cpumask *src1p,
@@ -419,7 +424,8 @@ static inline bool cpumask_intersects(const struct cpumask *src1p,
  * cpumask_subset - (*src1p & ~*src2p) == 0
  * @src1p: the first input
  * @src2p: the second input
- * Returns 1 if *src1p is a subset of *src2p, else returns 0
+ *
+ * Returns 1 if *@src1p is a subset of *@src2p, else returns 0
  */
 static inline int cpumask_subset(const struct cpumask *src1p,
 				 const struct cpumask *src2p)
-- 
1.7.5.4

