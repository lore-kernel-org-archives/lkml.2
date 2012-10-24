Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146Ab2JXPRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:17:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35724 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab2JXPRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:17:36 -0400
Message-ID: <5088066D.7000907@ti.com>
Date: Wed, 24 Oct 2012 20:47:01 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <peterz@infradead.org>,
        <mingo@redhat.com>, <pjt@google.com>, <linux@arm.linux.org.uk>
Subject: Re: [RFC 2/6] sched: add a new SD SHARE_POWERLINE flag for sched_domain
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org> <1349595838-31274-3-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1349595838-31274-3-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent,

Few comments/questions.

On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
> This new flag SD SHARE_POWERLINE reflects the sharing of the power rail
> between the members of a domain. As this is the current assumption of the
> scheduler, the flag is added to all sched_domain
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>   arch/ia64/include/asm/topology.h |    1 +
>   arch/tile/include/asm/topology.h |    1 +
>   include/linux/sched.h            |    1 +
>   include/linux/topology.h         |    3 +++
>   kernel/sched/core.c              |    5 +++++
>   5 files changed, 11 insertions(+)
>
> diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
> index a2496e4..065c720 100644
> --- a/arch/ia64/include/asm/topology.h
> +++ b/arch/ia64/include/asm/topology.h
> @@ -65,6 +65,7 @@ void build_cpu_to_node_map(void);
>   				| SD_BALANCE_EXEC	\
>   				| SD_BALANCE_FORK	\
>   				| SD_WAKE_AFFINE,	\
> +				| arch_sd_share_power_line()		\
>   	.last_balance		= jiffies,		\
>   	.balance_interval	= 1,			\
>   	.nr_balance_failed	= 0,			\
> diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
> index 7a7ce39..d39ed0b 100644
> --- a/arch/tile/include/asm/topology.h
> +++ b/arch/tile/include/asm/topology.h
> @@ -72,6 +72,7 @@ static inline const struct cpumask *cpumask_of_node(int node)
>   				| 0*SD_PREFER_LOCAL			\
>   				| 0*SD_SHARE_CPUPOWER			\
>   				| 0*SD_SHARE_PKG_RESOURCES		\
> +				| arch_sd_share_power_line()		\
>   				| 0*SD_SERIALIZE			\
>   				,					\
>   	.last_balance		= jiffies,				\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4786b20..74f2daf 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -862,6 +862,7 @@ enum cpu_idle_type {
>   #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
>   #define SD_PREFER_LOCAL		0x0040  /* Prefer to keep tasks local to this domain */
>   #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
> +#define SD_SHARE_POWERLINE	0x0100	/* Domain members share power domain */
If you ignore the current use of SD_SHARE_CPUPOWER, isn't the meaning of
CPUPOWER and POWERLINE is same here. Just trying to understand the clear
meaning of this new flag. Have you not considered SD_SHARE_CPUPOWER
because it is being used for cpu_power and needs at least minimum two
domains ? SD_PACKING would have been probably more appropriate based
on the way it is being used in further series.

Regards
Santosh

