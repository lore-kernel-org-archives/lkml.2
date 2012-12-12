Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2LLWeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:34:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab2LLWeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:34:01 -0500
Message-ID: <50C905CE.1010405@redhat.com>
Date: Wed, 12 Dec 2012 17:31:42 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] mm: vmscan: compaction works against zones, not lruvecs
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org> <1355348620-9382-8-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355348620-9382-8-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 04:43 PM, Johannes Weiner wrote:
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

Reviewed-by: Rik van Riel <riel@redhat.com>

