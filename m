Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2LMKlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:41:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab2LMKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:41:08 -0500
Date: Thu, 13 Dec 2012 10:41:04 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] mm: vmscan: save work scanning (almost) empty LRU
 lists
Message-ID: <20121213104104.GX1009@suse.de>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1355348620-9382-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 04:43:35PM -0500, Johannes Weiner wrote:
> In certain cases (kswapd reclaim, memcg target reclaim), a fixed
> minimum amount of pages is scanned from the LRU lists on each
> iteration, to make progress.
> 
> Do not make this minimum bigger than the respective LRU list size,
> however, and save some busy work trying to isolate and reclaim pages
> that are not there.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

This looks like a corner case where the LRU size would have to be smaller
than SWAP_CLUSTER_MAX. Is that common enough to care? It looks correct,
I'm just curious.

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
