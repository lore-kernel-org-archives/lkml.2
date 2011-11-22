Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab1KVQ6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:58:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49362 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1KVQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:58:40 -0500
Date: Wed, 23 Nov 2011 01:58:28 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: compaction: Allow compaction to isolate dirty
 pages
Message-ID: <20111122165828.GA15253@barrios-laptop.redhat.com>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
 <1321900608-27687-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321900608-27687-2-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 06:36:42PM +0000, Mel Gorman wrote:
> Commit [39deaf85: mm: compaction: make isolate_lru_page() filter-aware]
> noted that compaction does not migrate dirty or writeback pages and
> that is was meaningless to pick the page and re-add it to the LRU list.
> 
> What was missed during review is that asynchronous migration moves
> dirty pages if their ->migratepage callback is migrate_page() because
> these can be moved without blocking. This potentially impacted
> hugepage allocation success rates by a factor depending on how many
> dirty pages are in the system.
> 
> This patch partially reverts 39deaf85 to allow migration to isolate
> dirty pages again. This increases how much compaction disrupts the
> LRU but that is addressed later in the series.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Mel, Thanks for the fix.

-- 
Kind regards,
Minchan Kim
