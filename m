Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1GSQJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:09:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53077 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1GSQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:09:12 -0400
Date: Wed, 20 Jul 2011 01:09:03 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Andrew Lutomirski <luto@mit.edu>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: vmscan: Only read new_classzone_idx from pgdat
 when reclaiming successfully
Message-ID: <20110719160903.GA2978@barrios-desktop>
References: <1308926697-22475-1-git-send-email-mgorman@suse.de>
 <1308926697-22475-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308926697-22475-5-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Too late review.
At that time, I had no time to look into this patch.

On Fri, Jun 24, 2011 at 03:44:57PM +0100, Mel Gorman wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.  Unfortunately, if the highest zone is
> small, a problem occurs.
> 
> When balance_pgdat() returns, it may be at a lower classzone_idx than
> it started because the highest zone was unreclaimable. Before checking

Yes.

> if it should go to sleep though, it checks pgdat->classzone_idx which
> when there is no other activity will be MAX_NR_ZONES-1. It interprets

Yes.

> this as it has been woken up while reclaiming, skips scheduling and

Hmm. I can't understand this part.
If balance_pgdat returns lower classzone and there is no other activity,
new_classzone_idx is always MAX_NR_ZONES - 1 so that classzone_idx would be less than
new_classzone_idx. It means it doesn't skip scheduling.

Do I miss something?

-- 
Kinds regards,
Minchan Kim
