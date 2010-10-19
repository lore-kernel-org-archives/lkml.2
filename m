Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0JSChG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:37:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51934 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0JSChE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:37:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Neil Brown <neilb@suse.de>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <20101019022451.GA8310@localhost>
References: <20101018154137.90f5325f.akpm@linux-foundation.org> <20101019022451.GA8310@localhost>
Message-Id: <20101019113558.A1D5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 11:37:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---
> Subject: vmscan: comment too_many_isolated()
> From: Wu Fengguang <fengguang.wu@intel.com>
> Date: Tue Oct 19 09:53:23 CST 2010
> 
> Comment "Why it's doing so" rather than "What it does"
> as proposed by Andrew Morton.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/vmscan.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- linux-next.orig/mm/vmscan.c	2010-10-19 09:29:44.000000000 +0800
> +++ linux-next/mm/vmscan.c	2010-10-19 10:21:41.000000000 +0800
> @@ -1142,7 +1142,11 @@ int isolate_lru_page(struct page *page)
>  }
>  
>  /*
> - * Are there way too many processes in the direct reclaim path already?
> + * A direct reclaimer may isolate SWAP_CLUSTER_MAX pages from the LRU list and
> + * then get resheduled. When there are massive number of tasks doing page
> + * allocation, such sleeping direct reclaimers may keep piling up on each CPU,
> + * the LRU list will go small and be scanned faster than necessary, leading to
> + * unnecessary swapping, thrashing and OOM.
>   */
>  static int too_many_isolated(struct zone *zone, int file,
>  		struct scan_control *sc)

nice!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


