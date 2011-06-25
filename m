Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1FYVlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1FYVlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:41:11 -0400
Message-ID: <4E0655C8.7080908@redhat.com>
Date: Sat, 25 Jun 2011 17:40:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?UMOhZHJhaWcgQnJh?= =?UTF-8?B?ZHk=?= <P@draigBrady.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: vmscan: Do not apply pressure to slab if we are
 not applying pressure to zone
References: <1308926697-22475-1-git-send-email-mgorman@suse.de> <1308926697-22475-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1308926697-22475-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 10:44 AM, Mel Gorman wrote:
> During allocator-intensive workloads, kswapd will be woken frequently
> causing free memory to oscillate between the high and min watermark.
> This is expected behaviour.
>
> When kswapd applies pressure to zones during node balancing, it checks
> if the zone is above a high+balance_gap threshold. If it is, it does
> not apply pressure but it unconditionally shrinks slab on a global
> basis which is excessive. In the event kswapd is being kept awake due to
> a high small unreclaimable zone, it skips zone shrinking but still
> calls shrink_slab().
>
> Once pressure has been applied, the check for zone being unreclaimable
> is being made before the check is made if all_unreclaimable should be
> set. This miss of unreclaimable can cause has_under_min_watermark_zone
> to be set due to an unreclaimable zone preventing kswapd backing off
> on congestion_wait().
>
> Reported-and-tested-by: Pádraig Brady<P@draigBrady.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
