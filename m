Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1BYPDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:03:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48904 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab1BYPDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:03:47 -0500
Date: Fri, 25 Feb 2011 16:03:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>, Tejun Heo <tj@kernel.org>
Cc: yinghai@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix calculation of size of numa_distance
Message-ID: <20110225150339.GA29895@elte.hu>
References: <20110225145759.GA1606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225145759.GA1606@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> Fix the calculation of the size of numa_distance array. It is 2-dimemsional
> array. This fixes early panics seen on large numa systems.
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> Index: linux/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux.orig/arch/x86/mm/numa_64.c	2011-02-23 17:46:38.000000000 -0600
> +++ linux/arch/x86/mm/numa_64.c	2011-02-25 08:53:45.781921592 -0600
> @@ -414,7 +414,8 @@ static int __init numa_alloc_distance(vo
>  
>  	for_each_node_mask(i, nodes_parsed)
>  		cnt = i;
> -	size = ++cnt * sizeof(numa_distance[0]);
> +	cnt++;
> +	size = cnt * cnt * sizeof(numa_distance[0]);
>  
>  	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
>  				      size, PAGE_SIZE);

Tejun has queued up a fix for this already. Tejun, mind sending the fix to me ASAP?

Thanks,

	Ingo
