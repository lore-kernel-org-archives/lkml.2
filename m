Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1LAJdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:33:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43304 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1LAJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:33:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Dec 2011 18:32:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: incorrect overflow check in shrink_slab()
Message-Id: <20111201183202.2e5bd872.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <0D9D9F79-204D-4460-8CE7-A583C5C38A1E@gmail.com>
References: <0D9D9F79-204D-4460-8CE7-A583C5C38A1E@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 04:20:34 -0500
Xi Wang <xi.wang@gmail.com> wrote:

> total_scan is unsigned long, so the overflow check (total_scan < 0)
> didn't work.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Nice catch but.... the 'total_scan" shouldn't be long ?
Rather than type casting ?

Thanks,
-Kame
> ---
>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a1893c0..46a04e7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -270,7 +270,7 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>  		delta *= max_pass;
>  		do_div(delta, lru_pages + 1);
>  		total_scan += delta;
> -		if (total_scan < 0) {
> +		if ((long)total_scan < 0) {
>  			printk(KERN_ERR "shrink_slab: %pF negative objects to "
>  			       "delete nr=%ld\n",
>  			       shrinker->shrink, total_scan);
> -- 
> 1.7.5.4
> 
> 
> 

