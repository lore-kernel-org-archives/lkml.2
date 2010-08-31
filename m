Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0HaA4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:56:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53237 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab0HaA4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:56:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap system
Cc: kosaki.motohiro@jp.fujitsu.com, Ying Han <yinghan@google.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <AANLkTikbs9sUVLhE4sWWVw8uEqY=v6SCdJ_6FLhXY6HW@mail.gmail.com>
References: <AANLkTinqm0o=AfmgFy+SpZ1mrdekRnjeXvs_7=OcLii8@mail.gmail.com> <AANLkTikbs9sUVLhE4sWWVw8uEqY=v6SCdJ_6FLhXY6HW@mail.gmail.com>
Message-Id: <20100831095542.87CA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 31 Aug 2010 09:56:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1b145e6..0b8a3ce 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1747,7 +1747,7 @@ static void shrink_zone(int priority, struct zone *zone,
>          * Even if we did not try to evict anon pages at all, we want to
>          * rebalance the anon lru active/inactive ratio.
>          */
> -       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
> +       if (nr_swap_pges > 0 && inactive_anon_is_low(zone, sc))

Sorry, I don't find any difference. What is your intention?


>                 shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> 
>         throttle_vm_writeout(sc->gfp_mask);
> 
> But Andrew merged middle version.
> I will send this patch again.
> 
> Thanks.
> 
> -- 
> Kind regards,
> Minchan Kim



