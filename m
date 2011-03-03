Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1CCO7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:59:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab1CCO7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:59:49 -0500
Date: Thu, 3 Mar 2011 09:59:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/05] use proc_dointvec_minmax to check boundaries while
 needed
Message-ID: <20110303145908.GA32154@redhat.com>
References: <20110303135819.GA2620@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303135819.GA2620@darkstar>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 09:58:20PM +0800, Dave Young wrote:
> proc_dointvec doesn't check extra minmax params, use proc_dointvec_minmax
> instead of proc_dointvec for cases need boundaries check.

Is this patch needed, if you are basically changing it again in patches 3
and 5?

Cheers,
Don

> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
>  kernel/sysctl.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.orig/kernel/sysctl.c	2011-03-03 10:44:53.000000000 +0800
> +++ linux-2.6/kernel/sysctl.c	2011-03-03 11:02:43.736663258 +0800
> @@ -374,7 +374,7 @@ static struct ctl_table kern_table[] = {
>  		.data		= &sysctl_sched_autogroup_enabled,
>  		.maxlen		= sizeof(unsigned int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &zero,
>  		.extra2		= &one,
>  	},
> @@ -1204,7 +1204,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &block_dump,
>  		.maxlen		= sizeof(block_dump),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &zero,
>  	},
>  	{
> @@ -1212,7 +1212,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &sysctl_vfs_cache_pressure,
>  		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &zero,
>  	},
>  #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
> @@ -1221,7 +1221,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &sysctl_legacy_va_layout,
>  		.maxlen		= sizeof(sysctl_legacy_va_layout),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &zero,
>  	},
>  #endif
> @@ -1231,7 +1231,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &zone_reclaim_mode,
>  		.maxlen		= sizeof(zone_reclaim_mode),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &zero,
>  	},
>  	{
> @@ -1287,7 +1287,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &vdso_enabled,
>  		.maxlen		= sizeof(vdso_enabled),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= &zero,
>  	},
>  #endif
