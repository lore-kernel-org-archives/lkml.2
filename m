Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab1G2G2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 02:28:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50074 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1G2G2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 02:28:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E3252E2.1030101@jp.fujitsu.com>
Date: Fri, 29 Jul 2011 15:27:46 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: jj@chaosbits.net
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com,
        minchan.kim@gmail.com, mgorman@suse.de, akpm@linux-foundation.org,
        kanoj@sgi.com, sct@redhat.com
Subject: Re: [PATCH] vmscan: Remove if statement that will never trigger
References: <alpine.LNX.2.00.1107282302580.20477@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1107282302580.20477@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/29 6:05), Jesper Juhl wrote:
> We have this code in mm/vmscan.c:shrink_slab() :
> ...
> 		if (total_scan < 0) {
> 			printk(KERN_ERR "shrink_slab: %pF negative objects to "
> 			       "delete nr=%ld\n",
> 			       shrinker->shrink, total_scan);
> 			total_scan = max_pass;
> 		}
> ...
> but since 'total_scan' is of type 'unsigned long' it will never be
> less than zero, so there is no way we'll ever enter the true branch of
> this if statement - so let's just remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  mm/vmscan.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> 	Compile tested only.
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7ef6912..c07d9b1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -271,12 +271,6 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>  		delta *= max_pass;
>  		do_div(delta, lru_pages + 1);
>  		total_scan += delta;
> -		if (total_scan < 0) {
> -			printk(KERN_ERR "shrink_slab: %pF negative objects to "
> -			       "delete nr=%ld\n",
> -			       shrinker->shrink, total_scan);
> -			total_scan = max_pass;
> -		}
>  
>  		/*
>  		 * We need to avoid excessive windup on filesystem shrinkers

Good catch.

However this seems intended to catch a overflow. So, I'd suggest to make proper
overflow check instead.


