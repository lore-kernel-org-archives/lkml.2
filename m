Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0KNLPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 06:15:46 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17115 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0KNLPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 06:15:45 -0500
Date: Sun, 14 Nov 2010 12:03:36 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cleanup kswapd()
In-Reply-To: <20101114180505.BEE2.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LNX.2.00.1011141202430.3460@swampdragon.chaosbits.net>
References: <20101114180505.BEE2.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:

> 
> Currently, kswapd() function has deeper nest and it slightly harder to
> read. cleanup it.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |   71 +++++++++++++++++++++++++++++++---------------------------
>  1 files changed, 38 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8cc90d5..82ffe5f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2364,6 +2364,42 @@ out:
>  	return sc.nr_reclaimed;
>  }
>  
> +void kswapd_try_to_sleep(pg_data_t *pgdat, int order)

Shouldn't this be

  static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)

??


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

