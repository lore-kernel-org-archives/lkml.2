Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab2HHJLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:11:21 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33780 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab2HHJLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:11:14 -0400
Message-ID: <50222D11.4010005@in.ibm.com>
Date: Wed, 08 Aug 2012 14:40:41 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 3/5] uprobes: remove check for uprobe variable in handle_swbp()
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-4-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1344355952-2382-4-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12080809-5564-0000-0000-000003EDFA67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 09:42 PM, Sebastian Andrzej Siewior wrote:
> by the time we get here (after we pass cleanup_ret) uprobe is always is
> set. If it is NULL we leave very early in the code.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   kernel/events/uprobes.c |   16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 41a2555..c8e5204 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1528,17 +1528,15 @@ cleanup_ret:
>   		utask->active_uprobe = NULL;
>   		utask->state = UTASK_RUNNING;
>   	}
> -	if (uprobe) {
> -		if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> +	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
>
Shouldn't we check uprobe != NULL before we check the uprobe->flags ?
i.e, shouldn't the above line be :

        if (uprobe && ! (uprobe->flags & UPROBE_SKIP_SSTEP)) ?
> -			/*
> -			 * cannot singlestep; cannot skip instruction;
> -			 * re-execute the instruction.
> -			 */
> -			instruction_pointer_set(regs, bp_vaddr);
> +		/*
> +		 * cannot singlestep; cannot skip instruction;
> +		 * re-execute the instruction.
> +		 */
> +		instruction_pointer_set(regs, bp_vaddr);
>
> -		put_uprobe(uprobe);
> -	}
> +	put_uprobe(uprobe);
>   }

Thanks
Suzuki

