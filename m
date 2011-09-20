Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1ITBlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 21:41:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:56978 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab1ITBjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 21:39:21 -0400
Subject: Re: [PATCH 0/5] ppc64 scheduler fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110920101938.121098ed@kryten>
References: <20110725023311.175792493@samba.org>
	 <1311597702.24752.1.camel@twins>  <20110920101938.121098ed@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 11:38:48 +1000
Message-ID: <1316482728.7975.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 10:19 +1000, Anton Blanchard wrote:
> Hi Peter,
> 
> > On Mon, 2011-07-25 at 12:33 +1000, Anton Blanchard wrote:
> > > Here are a set of ppc64 scheduler fixes that help with some
> > > multi node performance issues.
> > 
> > They look fine to me. I'll probably ping you when I'll rip out all
> > that SD_NODES_PER_DOMAIN crap for good, but until then I'm fine with
> > you fiddling it for ppc64.
> > 
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Are you OK if Ben takes this, or would you prefer to send it via the
> scheduler tree?

I've already put it in my next branch that I'll stick on github later
today hopefully :-)

Cheers,
Ben.
 
> Anton
> --
> 
> [2/5] sched: Allow SD_NODES_PER_DOMAIN to be overridden
> 
> We want to override the default value of SD_NODES_PER_DOMAIN on ppc64,
> so move it into linux/topology.h.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> ---
> 
> Index: linux-2.6-work/include/linux/topology.h
> ===================================================================
> --- linux-2.6-work.orig/include/linux/topology.h	2011-07-25 11:20:02.588717796 +1000
> +++ linux-2.6-work/include/linux/topology.h	2011-07-25 11:26:50.616468376 +1000
> @@ -201,6 +201,10 @@ int arch_update_cpu_topology(void);
>  	.balance_interval	= 64,					\
>  }
>  
> +#ifndef SD_NODES_PER_DOMAIN
> +#define SD_NODES_PER_DOMAIN 16
> +#endif
> +
>  #ifdef CONFIG_SCHED_BOOK
>  #ifndef SD_BOOK_INIT
>  #error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
> Index: linux-2.6-work/kernel/sched.c
> ===================================================================
> --- linux-2.6-work.orig/kernel/sched.c	2011-07-25 11:20:09.538850173 +1000
> +++ linux-2.6-work/kernel/sched.c	2011-07-25 11:26:50.626468565 +1000
> @@ -6938,8 +6938,6 @@ static int __init isolated_cpu_setup(cha
>  
>  __setup("isolcpus=", isolated_cpu_setup);
>  
> -#define SD_NODES_PER_DOMAIN 16
> -
>  #ifdef CONFIG_NUMA
>  
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


