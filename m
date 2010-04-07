Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0DGL1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:27:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59657 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab0DGL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E/TtgZ0+xQby9BaNJZ8rF+/807D7J4PLcc7YVKXGB+/xs/wNNQ59oPsxYBKOH/KMWN
         IarRNEljXoSrZ7hF687F4u3ASv0k/UNwRJ41+x2luTYVEBkiDNuRQS2PJlI+Oqdfy8uG
         1kT+le1yQ3IUKuwoJKGQhSupQw2v1Dx1BfSKg=
Date: Wed, 7 Apr 2010 13:27:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, David Miller <davem@davemloft.net>, acme@redhat.com,
       paulus@samba.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch 3/3] sched: Use local_irq_save_nmi() in cpu_clock()
Message-ID: <20100407112707.GA5143@nowhere>
References: <20100406132807.698467930@chello.nl> <20100406133141.039454288@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406133141.039454288@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 03:28:10PM +0200, Peter Zijlstra wrote:
> Since we can call cpu_clock() from NMI context fix up the IRQ
> disabling to conform to the new rules.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_clock.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/sched_clock.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_clock.c
> +++ linux-2.6/kernel/sched_clock.c
> @@ -241,9 +241,9 @@ unsigned long long cpu_clock(int cpu)
>  	unsigned long long clock;
>  	unsigned long flags;
>  
> -	local_irq_save(flags);
> +	local_irq_save_nmi(flags);
>  	clock = sched_clock_cpu(cpu);
> -	local_irq_restore(flags);
> +	local_irq_restore_nmi(flags);
>  
>  	return clock;
>  }


That seem to add a small overhead in various places.
Do we want to make local_irq_save_nmi == local_irq_save
for archs that have native nmi?

Or cpu_clock_nmi()?

