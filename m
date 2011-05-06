Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1EFNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:09:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39139 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab1EFNJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:09:58 -0400
Date: Fri, 6 May 2011 14:09:55 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        kamezawa.hiroyu@jp.fujisu.com, minchan.kim@gmail.com,
        Andrew Morton <akpm@osdl.org>, aarcange@redhat.com
Subject: Re: [PATCH]mm/compation.c: checking page in lru twice
Message-ID: <20110506130955.GF4941@csn.ul.ie>
References: <1304681575.15473.4.camel@figo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1304681575.15473.4.camel@figo-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 07:32:46PM +0800, Figo.zhang wrote:
> 
> in isolate_migratepages() have check page in LRU twice, the next one
> at _isolate_lru_page(). 
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com> 

Not checking for PageLRU means that PageTransHuge() gets called
for each page. While the scanner is active and the lock released,
a transparent hugepage can be created and potentially we test
PageTransHuge() on a tail page. This will trigger a BUG if
CONFIG_DEBUG_VM is set.

Nacked-by: Mel Gorman <mel@csn.ul.ie>

> 
> mm/compaction.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 021a296..ac605cb 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -321,9 +321,6 @@ static unsigned long isolate_migratepages(struct zone *zone,
>  			continue;
>  		}
>  
> -		if (!PageLRU(page))
> -			continue;
> -
>  		/*
>  		 * PageLRU is set, and lru_lock excludes isolation,
>  		 * splitting and collapsing (collapsing has already
> 
> 

-- 
Mel Gorman
SUSE Labs
