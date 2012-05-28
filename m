Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2E1Nty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:49:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:56856 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2E1Ntx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:49:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105059497"
Message-ID: <4FC38277.2030500@intel.com>
Date: Mon, 28 May 2012 21:49:43 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: rusty@rustcorp.com.au, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com> <4FC373D9.7040109@linux.vnet.ibm.com>
In-Reply-To: <4FC373D9.7040109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 08:47 PM, Srivatsa S. Bhat wrote:

> On 05/28/2012 02:32 PM, Alex Shi wrote:
> 
>> Current few cpumask function purpose are not quite clear. Stupid
>> user like myself need to dig into details for clear function
>> purpose and return value.
> 
> 
> You can just see how it is used elsewhere and figure it out ;-)
> Anyway, in principle, I don't have any objections to adding comments
> that are actually helpful. But I don't think all the comments this
> patch adds fall into that category..
> 
>> Add few explanation for them is helpful.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  include/linux/cpumask.h |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>> index a2c819d..8436e61 100644
>> --- a/include/linux/cpumask.h
>> +++ b/include/linux/cpumask.h
>> @@ -271,6 +271,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
>>   * cpumask_test_cpu - test for a cpu in a cpumask
>>   * @cpu: cpu number (< nr_cpu_ids)
>>   * @cpumask: the cpumask pointer
>> + * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
>>   *
> 
> 
> s/return/Returns
> 
> What do you mean by "old" cpumask?




Thanks for comments!
Should be "the old bitmap of cpumask"?

> 
>>   * No static inline type checking - see Subtlety (1) above.
>>   */
>> @@ -281,6 +282,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
>>   * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
>>   * @cpu: cpu number (< nr_cpu_ids)
>>   * @cpumask: the cpumask pointer
>> + * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
>>   *
> 
> 
> "Test and Set" already has a very well-defined and well-known meaning.. Not sure if the
> comment adds any extra value..




Yes, but it is still helpful for newbie. :)

> 
>>   * test_and_set_bit wrapper for cpumasks.
>>   */
>> @@ -293,6 +295,7 @@ static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
>>   * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
>>   * @cpu: cpu number (< nr_cpu_ids)
>>   * @cpumask: the cpumask pointer
>> + * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
>>   *
> 
> 
> Same here. Pretty well known meaning.
> 
>>   * test_and_clear_bit wrapper for cpumasks.
>>   */
>> @@ -324,6 +327,7 @@ static inline void cpumask_clear(struct cpumask *dstp)
>>   * @dstp: the cpumask result
>>   * @src1p: the first input
>>   * @src2p: the second input
>> + * if *dstp is empty, return 0, otherwise return 1
> 
> 
> I don't think anybody would be interested in the return value of this function!
> The functionality (rather than the return value) is what is more interesting
> and useful, and is already well-documented.




:) it is true none is using the return value, but why not to have a comments 
if we have this return value.

> 
>>   */
>>  static inline int cpumask_and(struct cpumask *dstp,
>>  			       const struct cpumask *src1p,
>> @@ -365,6 +369,7 @@ static inline void cpumask_xor(struct cpumask *dstp,
>>   * @dstp: the cpumask result
>>   * @src1p: the first input
>>   * @src2p: the second input
>> + * if *dstp is empty, return 0, otherwise return 1
> 
> 
> Same here. Functionality is more interesting.
> 
>>   */
>>  static inline int cpumask_andnot(struct cpumask *dstp,
>>  				  const struct cpumask *src1p,
>> @@ -414,6 +419,7 @@ static inline bool cpumask_intersects(const struct cpumask *src1p,
>>   * cpumask_subset - (*src1p & ~*src2p) == 0
>>   * @src1p: the first input
>>   * @src2p: the second input
>> + * return 1 if the *src1p is the subset of *src2p, otherwise return 0
> 
> 
> s/return/Returns
> (I think the function name itself is pretty descriptive, but anyway...)




Just this function make me confusing, because I missed the '== 0' in 
"*src1p & ~*src2p) == 0", than I thought scr1p should be the mother mask
 and scr2p is daughter. :)

> 
>>   */
>>  static inline int cpumask_subset(const struct cpumask *src1p,
>>  				 const struct cpumask *src2p)
> 
> 
>  
> Regards,
> Srivatsa S. Bhat



Thanks for all comments, I updated the patch according to your some suggestion.
Anyway, I don't mind if the patch is picked up. Maybe there is only one stupid 
guy in the world. :)
----------

>From caf6e32ec4f335064f067904f24fb9f9f90312df Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 28 May 2012 15:53:51 +0800
Subject: [PATCH] cpumask: add a few comments of cpumask functions

Current few cpumask functions' purposes are not quite clear. Stupid
user like myself need to dig into details for clear function
purpose and return value.
Add few explanation for them is helpful.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/cpumask.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index a2c819d..177e5e8 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -271,6 +271,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_cpu - test for a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * Return 1 if the 'cpu' is in the old bitmap of 'cpumask', otherwise return 0
  *
  * No static inline type checking - see Subtlety (1) above.
  */
@@ -281,6 +282,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
  * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * Return 1 if the 'cpu' is in the old bitmap of 'cpumask', otherwise return 0
  *
  * test_and_set_bit wrapper for cpumasks.
  */
@@ -293,6 +295,7 @@ static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
  * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
  * @cpu: cpu number (< nr_cpu_ids)
  * @cpumask: the cpumask pointer
+ * Return 1 if the 'cpu' is in the old bitmap of 'cpumask', otherwise return 0
  *
  * test_and_clear_bit wrapper for cpumasks.
  */
@@ -324,6 +327,7 @@ static inline void cpumask_clear(struct cpumask *dstp)
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
+ * If *dstp is empty, return 0, otherwise return 1
  */
 static inline int cpumask_and(struct cpumask *dstp,
 			       const struct cpumask *src1p,
@@ -365,6 +369,7 @@ static inline void cpumask_xor(struct cpumask *dstp,
  * @dstp: the cpumask result
  * @src1p: the first input
  * @src2p: the second input
+ * If *dstp is empty, return 0, otherwise return 1
  */
 static inline int cpumask_andnot(struct cpumask *dstp,
 				  const struct cpumask *src1p,
@@ -414,6 +419,7 @@ static inline bool cpumask_intersects(const struct cpumask *src1p,
  * cpumask_subset - (*src1p & ~*src2p) == 0
  * @src1p: the first input
  * @src2p: the second input
+ * Return 1 if the *src1p is the subset of *src2p, otherwise return 0
  */
 static inline int cpumask_subset(const struct cpumask *src1p,
 				 const struct cpumask *src2p)
-- 
1.7.5.4

