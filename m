Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1KURRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:17:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab1KURRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:17:17 -0500
Message-ID: <4ECA8781.7090302@redhat.com>
Date: Mon, 21 Nov 2011 12:16:49 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] mm: compaction: Allow compaction to isolate dirty
 pages
References: <1321635524-8586-1-git-send-email-mgorman@suse.de> <1321635524-8586-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1321635524-8586-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 11:58 AM, Mel Gorman wrote:
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
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

