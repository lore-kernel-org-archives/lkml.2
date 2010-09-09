Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0IIUmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:42:39 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:40848 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755602Ab0IIUmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:42:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=toOyEkXefGUsAAvM5vmFVw5YIQFXPNC9R6QFGc0fo6tYVEXkTu75+gjI2MhLd2rV6fisiylMBqDGKQEZctMhZ3KtgMsq5UTetsk7ro3I5LUQg3sUsTpjUF4AIR4XfhPU;
Date: Thu, 9 Sep 2010 13:42:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-pci@vger.kernel.org
Subject: Re: [patch 12/30] ibmphp-hpc: semaphore cleanup
Message-ID: <20100909134231.0edf3136@jbarnes-desktop>
In-Reply-To: <20100907125055.849873983@linutronix.de>
References: <20100907124636.880953480@linutronix.de>
	<20100907125055.849873983@linutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 14:32:38 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: linux-pci@vger.kernel.org
> 
> ---
>  drivers/pci/hotplug/ibmphp_hpc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/hotplug/ibmphp_hpc.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/hotplug/ibmphp_hpc.c
> +++ linux-2.6/drivers/pci/hotplug/ibmphp_hpc.c
> @@ -133,8 +133,8 @@ void __init ibmphp_hpc_initvars (void)
>  	debug ("%s - Entry\n", __func__);
>  
>  	mutex_init(&sem_hpcaccess);
> -	init_MUTEX (&semOperations);
> -	init_MUTEX_LOCKED (&sem_exit);
> +	sema_init(&semOperations, 1);
> +	sema_init(&sem_exit, 0);
>  	to_debug = 0;
>  
>  	debug ("%s - Exit\n", __func__);
> 
> 
> 

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
