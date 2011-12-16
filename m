Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab1LPEgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:36:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab1LPEgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:36:11 -0500
Message-ID: <4EEACA96.6020200@redhat.com>
Date: Thu, 15 Dec 2011 23:35:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] mm: vmscan: When reclaiming for compaction, ensure
 there are sufficient free pages available
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-10-git-send-email-mgorman@suse.de>
In-Reply-To: <1323877293-15401-10-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:41 AM, Mel Gorman wrote:
> In commit [e0887c19: vmscan: limit direct reclaim for higher order
> allocations], Rik noted that reclaim was too aggressive when THP was
> enabled. In his initial patch he used the number of free pages to
> decide if reclaim should abort for compaction. My feedback was that
> reclaim and compaction should be using the same logic when deciding if
> reclaim should be aborted.
>
> Unfortunately, this had the effect of reducing THP success rates when
> the workload included something like streaming reads that continually
> allocated pages. The window during which compaction could run and return
> a THP was too small.
>
> This patch combines Rik's two patches together. compaction_suitable()
> is still used to decide if reclaim should be aborted to allow
> compaction is used. However, it will also ensure that there is a
> reasonable buffer of free pages available. This improves upon the
> THP allocation success rates but bounds the number of pages that are
> freed for compaction.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
