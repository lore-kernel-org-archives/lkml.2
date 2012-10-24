Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965264Ab2JXPWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:22:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36783 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965198Ab2JXPWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:22:10 -0400
Message-ID: <50880795.4030609@ti.com>
Date: Wed, 24 Oct 2012 20:51:57 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <peterz@infradead.org>,
        <mingo@redhat.com>, <pjt@google.com>, <linux@arm.linux.org.uk>
Subject: Re: [RFC 6/6] ARM: sched: clear SD_SHARE_POWERLINE
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org> <1349595838-31274-7-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1349595838-31274-7-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
> The ARM platforms take advantage of packing small tasks on few cores.
> This is true even when the cores of a cluster can't be powergated
> independently.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>   arch/arm/kernel/topology.c |    5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 26c12c6..00511d0 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -226,6 +226,11 @@ static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
>    */
>   struct cputopo_arm cpu_topology[NR_CPUS];
>
> +int arch_sd_share_power_line(void)
> +{
> +	return 0*SD_SHARE_POWERLINE;
> +}

Making this selection of policy based on sched domain will better. Just
gives the flexibility to choose a separate scheme for big and little
systems which will be very convenient.

Regards
Santosh





