Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2E1MzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:55:19 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48914 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2E1MzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:55:17 -0400
Message-ID: <4FC373D9.7040109@linux.vnet.ibm.com>
Date: Mon, 28 May 2012 18:17:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: rusty@rustcorp.com.au, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1338195748-18934-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052812-2674-0000-0000-000004B4A2FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 02:32 PM, Alex Shi wrote:

> Current few cpumask function purpose are not quite clear. Stupid
> user like myself need to dig into details for clear function
> purpose and return value.


You can just see how it is used elsewhere and figure it out ;-)
Anyway, in principle, I don't have any objections to adding comments
that are actually helpful. But I don't think all the comments this
patch adds fall into that category..

> Add few explanation for them is helpful.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  include/linux/cpumask.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index a2c819d..8436e61 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -271,6 +271,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
>   * cpumask_test_cpu - test for a cpu in a cpumask
>   * @cpu: cpu number (< nr_cpu_ids)
>   * @cpumask: the cpumask pointer
> + * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
>   *


s/return/Returns

What do you mean by "old" cpumask?

>   * No static inline type checking - see Subtlety (1) above.
>   */
> @@ -281,6 +282,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
>   * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
>   * @cpu: cpu number (< nr_cpu_ids)
>   * @cpumask: the cpumask pointer
> + * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
>   *


"Test and Set" already has a very well-defined and well-known meaning.. Not sure if the
comment adds any extra value..

>   * test_and_set_bit wrapper for cpumasks.
>   */
> @@ -293,6 +295,7 @@ static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
>   * cpumask_test_and_clear_cpu - atomically test and clear a cpu in a cpumask
>   * @cpu: cpu number (< nr_cpu_ids)
>   * @cpumask: the cpumask pointer
> + * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
>   *


Same here. Pretty well known meaning.

>   * test_and_clear_bit wrapper for cpumasks.
>   */
> @@ -324,6 +327,7 @@ static inline void cpumask_clear(struct cpumask *dstp)
>   * @dstp: the cpumask result
>   * @src1p: the first input
>   * @src2p: the second input
> + * if *dstp is empty, return 0, otherwise return 1


I don't think anybody would be interested in the return value of this function!
The functionality (rather than the return value) is what is more interesting
and useful, and is already well-documented.

>   */
>  static inline int cpumask_and(struct cpumask *dstp,
>  			       const struct cpumask *src1p,
> @@ -365,6 +369,7 @@ static inline void cpumask_xor(struct cpumask *dstp,
>   * @dstp: the cpumask result
>   * @src1p: the first input
>   * @src2p: the second input
> + * if *dstp is empty, return 0, otherwise return 1


Same here. Functionality is more interesting.

>   */
>  static inline int cpumask_andnot(struct cpumask *dstp,
>  				  const struct cpumask *src1p,
> @@ -414,6 +419,7 @@ static inline bool cpumask_intersects(const struct cpumask *src1p,
>   * cpumask_subset - (*src1p & ~*src2p) == 0
>   * @src1p: the first input
>   * @src2p: the second input
> + * return 1 if the *src1p is the subset of *src2p, otherwise return 0


s/return/Returns
(I think the function name itself is pretty descriptive, but anyway...)

>   */
>  static inline int cpumask_subset(const struct cpumask *src1p,
>  				 const struct cpumask *src2p)


 
Regards,
Srivatsa S. Bhat

