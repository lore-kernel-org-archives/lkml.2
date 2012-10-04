Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2JDEhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 00:37:45 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44343 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2JDEhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 00:37:43 -0400
MIME-Version: 1.0
In-Reply-To: <1348252345-5642-5-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-5-git-send-email-morten.rasmussen@arm.com>
Date: Thu, 4 Oct 2012 10:07:43 +0530
Message-ID: <CAKohpomHW8P8tUm5nHd49oExe=LzjyAHFNpJ2OJOrJ30SDUU7A@mail.gmail.com>
Subject: Re: [RFC PATCH 04/10] sched: Introduce priority-based task migration filter
From: Viresh Kumar <viresh.kumar@linaro.org>
To: morten.rasmussen@arm.com
Cc: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Robin Randhawa <robin.randhawa@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:

Hi Morten,

I would try to review your patches in coming days. For now, Just
reporting a problem
which i encountered during routine build.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 490f1f0..8f0f3b9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3129,9 +3129,12 @@ static int __init hmp_cpu_mask_setup(void)
>   * hmp_down_threshold: max. load allowed for tasks migrating to a slower cpu
>   * The default values (512, 256) offer good responsiveness, but may need
>   * tweaking suit particular needs.
> + *
> + * hmp_up_prio: Only up migrate task with high priority (<hmp_up_prio)
>   */
>  unsigned int hmp_up_threshold = 512;
>  unsigned int hmp_down_threshold = 256;

#ifdef CONFIG_SCHED_HMP_PRIO_FILTER

> +unsigned int hmp_up_prio = NICE_TO_PRIO(CONFIG_SCHED_HMP_PRIO_FILTER_VAL);

#endif

is required here for successful build without CONFIG_SCHED_HMP_PRIO_FILTER_VAL.

--
viresh
