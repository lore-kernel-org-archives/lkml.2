Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1BUKEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:04:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54484 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1BUKEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:04:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 21 Feb 2011 18:57:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix dubious code in __count_immobile_pages()
Message-Id: <20110221185757.85dcaaf1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297993586-3514-1-git-send-email-namhyung@gmail.com>
References: <1297993586-3514-1-git-send-email-namhyung@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 10:46:26 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> When pfn_valid_within() failed 'iter' was incremented twice.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/page_alloc.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e8b02771ccea..bf83d1c1d648 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5380,10 +5380,9 @@ __count_immobile_pages(struct zone *zone, struct page *page, int count)
>  	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
>  		unsigned long check = pfn + iter;
>  
> -		if (!pfn_valid_within(check)) {
> -			iter++;
> +		if (!pfn_valid_within(check))
>  			continue;
> -		}
> +
>  		page = pfn_to_page(check);
>  		if (!page_count(page)) {
>  			if (PageBuddy(page))
> -- 
> 1.7.4
> 
> 

