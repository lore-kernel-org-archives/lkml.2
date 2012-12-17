Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2LQSRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:17:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab2LQSRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:17:06 -0500
Message-ID: <50CF6145.6050207@redhat.com>
Date: Mon, 17 Dec 2012 13:15:33 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] mm: memcg: only evict file pages when we have plenty
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org> <1355767957-4913-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355767957-4913-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 01:12 PM, Johannes Weiner wrote:
> e986850 "mm, vmscan: only evict file pages when we have plenty" makes
> a point of not going for anonymous memory while there is still enough
> inactive cache around.
>
> The check was added only for global reclaim, but it is just as useful
> to reduce swapping in memory cgroup reclaim:
>
> 200M-memcg-defconfig-j2
>
>                                   vanilla                   patched
> Real time              454.06 (  +0.00%)         453.71 (  -0.08%)
> User time              668.57 (  +0.00%)         668.73 (  +0.02%)
> System time            128.92 (  +0.00%)         129.53 (  +0.46%)
> Swap in               1246.80 (  +0.00%)         814.40 ( -34.65%)
> Swap out              1198.90 (  +0.00%)         827.00 ( -30.99%)
> Pages allocated   16431288.10 (  +0.00%)    16434035.30 (  +0.02%)
> Major faults           681.50 (  +0.00%)         593.70 ( -12.86%)
> THP faults             237.20 (  +0.00%)         242.40 (  +2.18%)
> THP collapse           241.20 (  +0.00%)         248.50 (  +3.01%)
> THP splits             157.30 (  +0.00%)         161.40 (  +2.59%)
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
