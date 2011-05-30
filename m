Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1E3Xp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 19:45:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43920 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1E3Xp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 19:45:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 31 May 2011 08:38:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
Message-Id: <20110531083859.98e4ff43.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1306774744.4061.5.camel@localhost.localdomain>
References: <1306774744.4061.5.camel@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 22:59:04 +0600
Rakib Mullick <rakib.mullick@gmail.com> wrote:

> commit 468fd62ed9 (vmstats: add cond_resched() to refresh_cpu_vm_stats()) added cond_resched() in refresh_cpu_vm_stats. Purpose of that patch was to allow other threads to run in non-preemptive case. This patch, makes sure that cond_resched() gets called when !CONFIG_PREEMPT is set. In a preemptiable kernel we don't need to call cond_resched().
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Hmm, what benefit do we get by adding this extra #ifdef in the code directly ?
Other cond_resched() callers are not guilty in !CONFIG_PREEMPT ?

Thanks,
-Kame

> ---
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 20c18b7..72cf857 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -461,7 +461,11 @@ void refresh_cpu_vm_stats(int cpu)
>  				p->expire = 3;
>  #endif
>  			}
> +
> +#ifndef CONFIG_PREEMPT
>  		cond_resched();
> +#endif
> +
>  #ifdef CONFIG_NUMA
>  		/*
>  		 * Deal with draining the remote pageset of this
> 
> 

