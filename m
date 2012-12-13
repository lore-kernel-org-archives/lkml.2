Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab2LMLM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:12:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab2LMLM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:12:57 -0500
Date: Thu, 13 Dec 2012 11:12:54 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] mm: vmscan: compaction works against zones, not
 lruvecs
Message-ID: <20121213111254.GB1009@suse.de>
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org>
 <1355348620-9382-8-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1355348620-9382-8-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 04:43:39PM -0500, Johannes Weiner wrote:
> The restart logic for when reclaim operates back to back with
> compaction is currently applied on the lruvec level.  But this does
> not make sense, because the container of interest for compaction is a
> zone as a whole, not the zone pages that are part of a certain memory
> cgroup.
> 
> Negative impact is bounded.  For one, the code checks that the lruvec
> has enough reclaim candidates, so it does not risk getting stuck on a
> condition that can not be fulfilled.  And the unfairness of hammering
> on one particular memory cgroup to make progress in a zone will be
> amortized by the round robin manner in which reclaim goes through the
> memory cgroups.  Still, this can lead to unnecessary allocation
> latencies when the code elects to restart on a hard to reclaim or
> small group when there are other, more reclaimable groups in the zone.
> 
> Move this logic to the zone level and restart reclaim for all memory
> cgroups in a zone when compaction requires more free pages from it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
