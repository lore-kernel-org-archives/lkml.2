Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2E2BSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 21:18:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:7189 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab2E2BSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 21:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="149410122"
Message-ID: <4FC4236F.309@intel.com>
Date: Tue, 29 May 2012 09:16:31 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: rusty@rustcorp.com.au, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com> <4FC373D9.7040109@linux.vnet.ibm.com> <4FC38277.2030500@intel.com> <4FC39904.9080309@linux.vnet.ibm.com>
In-Reply-To: <4FC39904.9080309@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> s/return/Returns
>>>
>>> What do you mean by "old" cpumask?
>>
>> Thanks for comments!
>> Should be "the old bitmap of cpumask"?
>>
> 
> 
> No, there is no "old" or "new" cpumask here because this function doesn't
> change the cpumask. It just checks if that bit is set.
> So something like:
> Returns 1 if 'cpu' is set in 'cpumask', else returns 0.
> 



Sure, thanks! and comments changed again following your style.
Is the following new update patch ok?


>From 1daa52caf1ba83eea0975a9250becd85dd5a5315 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 28 May 2012 22:23:51 +0800
Subject: [PATCH] cpumask: add a few comments of cpumask functions

Current few cpumask functions' purposes are not quite clear. Stupid
user like myself needs to dig into details for clear function
purpose and return value.
Add few explanation for them is helpful.

Thanks for Srivatsa's comments and correction!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/cpumask.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index a2c819d..170c5af 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -271,6 +271,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_cpu - test for a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * Returns 1 if 'cpu' is set in 'cpumask', else returns 0
  *
  * No static inline type checking - see Subtlety (1) above.
  */
@@ -281,6 +282,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * Returns 1 if 'cpu' is set in old bitmap of 'cpumask', else returns 0
  *
  * test_and_set_bit wrapper for cpumasks.
  */
@@ -293,6 +295,7 @@ static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
  * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * Returns 1 if 'cpu' is set in old bitmap of 'cpumask', else returns 0
  *
  * test_and_clear_bit wrapper for cpumasks.
  */
@@ -324,6 +327,7 @@ static inline void cpumask_clear(struct cpumask *dstp)
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
+ * If *dstp is empty, returns 0, else returns 1
  */
 static inline int cpumask_and(struct cpumask *dstp,
 			       const struct cpumask *src1p,
@@ -365,6 +369,7 @@ static inline void cpumask_xor(struct cpumask *dstp,
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
+ * If *dstp is empty, returns 0, else returns 1
  */
 static inline int cpumask_andnot(struct cpumask *dstp,
 				  const struct cpumask *src1p,
@@ -414,6 +419,7 @@ static inline bool cpumask_intersects(const struct cpumask *src1p,
  * cpumask_subset - (*src1p & ~*src2p) == 0
  * @src1p: the first input
  * @src2p: the second input
+ * Returns 1 if *src1p is a subset of *src2p, else returns 0
  */
 static inline int cpumask_subset(const struct cpumask *src1p,
 				 const struct cpumask *src2p)
-- 
1.7.5.4



