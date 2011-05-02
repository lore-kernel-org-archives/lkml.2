Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1EBKhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:37:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40036 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1EBKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:37:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/2] Filter unevictable page out in deactivate_page
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>
In-Reply-To: <dc54a5771cf1f580a91d16816100d4a2bcf2cdf5.1304261567.git.minchan.kim@gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com> <dc54a5771cf1f580a91d16816100d4a2bcf2cdf5.1304261567.git.minchan.kim@gmail.com>
Message-Id: <20110502193820.2D60.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  2 May 2011 19:37:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's pointless that deactive_page's pagevec operation about
> unevictable page as it's nop.
> This patch removes unnecessary overhead which might be a bit problem
> in case that there are many unevictable page in system(ex, mprotect workload)
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/swap.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 2e9656d..b707694 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -511,6 +511,15 @@ static void drain_cpu_pagevecs(int cpu)
>   */
>  void deactivate_page(struct page *page)
>  {
> +
> +	/*
> +	 * In workload which system has many unevictable page(ex, mprotect),
> +	 * unevictalge page deactivation for accelerating reclaim
> +	 * is pointless.
> +	 */
> +	if (PageUnevictable(page))
> +		return;
> +

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


btw, I think we should check PageLRU too.



