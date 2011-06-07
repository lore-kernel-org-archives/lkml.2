Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1FGPOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:14:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38526 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1FGPOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QitMkKHqEs9Rs6x+wEQOqWo/fRrJ1y/0yBz/vWhSLEqPch5cK9wPnrQ5MqxP4v5xFi
         Jucjs9WbBgHnf4tc97BHTyGHX3yDFgwpB17faW3wye/smxdyG048sjKGlJedCkm5uXK+
         T4wUNzKLvH8+N/+GRnICJHeVPQr+zGsBAu6Zo=
Date: Wed, 8 Jun 2011 00:14:12 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Sattler <tsattler@gmx.de>, Ury Stankevich <urykhy@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mm: memory-failure: Fix isolated page count during
 memory failure
Message-ID: <20110607151412.GJ1686@barrios-laptop>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
 <1307459225-4481-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307459225-4481-4-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 04:07:04PM +0100, Mel Gorman wrote:
> From: Minchan Kim <minchan.kim@gmail.com>
> 
> From: Minchan Kim <minchan.kim@gmail.com>
> 
> Pages isolated for migration are accounted with the vmstat counters
> NR_ISOLATE_[ANON|FILE]. Callers of migrate_pages() are expected to
> increment these counters when pages are isolated from the LRU. Once
> the pages have been migrated, they are put back on the LRU or freed
> and the isolated count is decremented.
> 
> Memory failure is not properly accounting for pages it isolates
> causing the NR_ISOLATED counters to be negative. On SMP builds,
> this goes unnoticed as negative counters are treated as 0 due to
> expected per-cpu drift. On UP builds, the counter is treated by
> too_many_isolated() as a large value causing processes to enter D
> state during page reclaim or compaction. This patch accounts for
> pages isolated by memory failure correctly.
> 
> [mgorman@suse.de: Updated changelog]
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

I was about to resend this patch with your updated description.
Thanks! Mel.

-- 
Kind regards
Minchan Kim
