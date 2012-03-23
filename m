Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2CWEsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:48:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56049 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2CWEsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:48:19 -0400
Date: Fri, 23 Mar 2012 13:48:11 +0900
From: Minchan Kim <minchan@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v6 3/7] mm: push lru index into shrink_[in]active_list()
Message-ID: <20120323044811.GA2717@barrios-desktop>
References: <20120322214944.27814.42039.stgit@zurg>
 <20120322215627.27814.4499.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322215627.27814.4499.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 01:56:27AM +0400, Konstantin Khlebnikov wrote:
> Let's toss lru index through call stack to isolate_lru_pages(),
> this is better than its reconstructing from individual bits.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> ---
>  mm/vmscan.c |   41 +++++++++++++++++------------------------
>  1 files changed, 17 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f4dca0c..fb6d54e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1127,15 +1127,14 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode, int file)
>   * @nr_scanned:	The number of pages that were scanned.
>   * @sc:		The scan_control struct for this reclaim session
>   * @mode:	One of the LRU isolation modes
> - * @active:	True [1] if isolating active pages
> - * @file:	True [1] if isolating file [!anon] pages
> + * @lru		LRU list id for isolating

Missing colon.

Otherwise, nice cleanup!

Reviewed-by: Minchan Kim <minchan@kernel.org>
-- 
Kind regards,
Minchan Kim
