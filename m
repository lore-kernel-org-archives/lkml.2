Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab1D1NuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:50:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41655 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab1D1NuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:50:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [patch] vmstat: account page allocation failures
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20110428133838.GA12573@localhost>
References: <20110428133644.GA12400@localhost> <20110428133838.GA12573@localhost>
Message-Id: <20110428225144.3D4D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 28 Apr 2011 22:50:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  nopage:
> +	inc_zone_state(preferred_zone, NR_ALLOC_FAIL);
> +	/* count_zone_vm_events(PGALLOCFAIL, preferred_zone, 1 << order); */
>  	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
>  		unsigned int filter = SHOW_MEM_FILTER_NODES;
>  
> --- linux-next.orig/mm/vmstat.c	2011-04-28 21:34:30.000000000 +0800
> +++ linux-next/mm/vmstat.c	2011-04-28 21:34:35.000000000 +0800
> @@ -879,6 +879,7 @@ static const char * const vmstat_text[] 
>  	"nr_shmem",
>  	"nr_dirtied",
>  	"nr_written",
> +	"nr_alloc_fail",

I'm using very similar patch for debugging. However, this is useless for
admins because typical linux load have plenty GFP_ATOMIC allocation failure.
So, typical user have no way that failure rate is high or not.




