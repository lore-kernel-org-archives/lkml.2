Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0DPE2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:28:19 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:36954 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726Ab0DPE2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:28:17 -0400
Date: Fri, 16 Apr 2010 14:27:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] vmscan: Setup pagevec as late as possible in
 shrink_inactive_list()
Message-ID: <20100416042742.GA2493@dastard>
References: <1271352103-2280-1-git-send-email-mel@csn.ul.ie>
 <1271352103-2280-9-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271352103-2280-9-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:21:41PM +0100, Mel Gorman wrote:
> shrink_inactive_list() sets up a pagevec to release unfreeable pages. It
> uses significant amounts of stack doing this. This patch splits
> shrink_inactive_list() to take the stack usage out of the main path so
> that callers to writepage() do not contain an unused pagevec on the
> stack.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |   93 +++++++++++++++++++++++++++++++++-------------------------
>  1 files changed, 53 insertions(+), 40 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a232ad6..9bc1ede 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1120,6 +1120,54 @@ static int too_many_isolated(struct zone *zone, int file,
>  }
>  
>  /*
> + * TODO: Try merging with migrations version of putback_lru_pages
> + */
> +static noinline void putback_lru_pages(struct zone *zone,

noinline_for_stack

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
