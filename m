Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab1EBKcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:32:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43716 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1EBKcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:32:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/2] Check PageUnevictable in lru_deactivate_fn
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>
In-Reply-To: <c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com> <c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
Message-Id: <20110502193353.2D59.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  2 May 2011 19:32:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The lru_deactivate_fn should not move page which in on unevictable lru
> into inactive list. Otherwise, we can meet BUG when we use isolate_lru_pages
> as __isolate_lru_page could return -EINVAL.
> It's really BUG and let's fix it.
> 
> Reported-by: Ying Han <yinghan@google.com>
> Tested-by: Ying Han <yinghan@google.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/swap.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index a83ec5a..2e9656d 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -429,6 +429,9 @@ static void lru_deactivate_fn(struct page *page, void *arg)
>  	if (!PageLRU(page))
>  		return;
>  
> +	if (PageUnevictable(page))
> +		return;
> +

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



