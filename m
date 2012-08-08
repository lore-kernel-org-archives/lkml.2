Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab2HHNCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065Ab2HHNCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:02:19 -0400
Date: Wed, 8 Aug 2012 14:58:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 3/5] uprobes: remove check for uprobe variable in
	handle_swbp()
Message-ID: <20120808125845.GB4504@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-4-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344355952-2382-4-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Sebastian Andrzej Siewior wrote:
>
> by the time we get here (after we pass cleanup_ret) uprobe is always is
> set. If it is NULL we leave very early in the code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/events/uprobes.c |   16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 41a2555..c8e5204 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1528,17 +1528,15 @@ cleanup_ret:
>  		utask->active_uprobe = NULL;
>  		utask->state = UTASK_RUNNING;
>  	}
> -	if (uprobe) {
> -		if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> +	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
>  
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
>  }
>  
>  /*
> -- 
> 1.7.10.4
> 

