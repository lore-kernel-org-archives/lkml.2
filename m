Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2FKNfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:35:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab2FKNfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:35:21 -0400
Message-ID: <4FD5F405.9020904@redhat.com>
Date: Mon, 11 Jun 2012 09:35:01 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
References: <201206041543.56917.b.zolnierkie@samsung.com> <4FCD18FD.5030307@gmail.com> <4FCD6806.7070609@kernel.org> <4FCD713D.3020100@kernel.org> <4FCD8C99.3010401@gmail.com> <4FCDA1B4.9050301@kernel.org> <20120611130612.GA3030@suse.de>
In-Reply-To: <20120611130612.GA3030@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 09:06 AM, Mel Gorman wrote:

> My initial support for this patch was based on an artifical load but one I
> felt was plausible to trigger if CMA was being used. In a normal workload
> I thought it might be possible to hit if a large process exited freeing
> a lot of pagetable pages from MIGRATE_UNMOVABLE blocks at the same time
> but that is a little unlikely and a test case would also look very artifical.
>
> Hence, I believe that if you require a real workload to demonstrate the
> benefit of the patch that it will be very difficult to find. The primary
> decision is if CMA needs this or not. I was under the impression that it
> was a help for CMA allocation success rates but I may be mistaken.

If it helps CMA allocation rates, it should also help
allocation rates for transparent hugepages.

Conveniently, THP allocation rates are already exported
in /proc/vmstat.  Now all we need is a test load :)

-- 
All rights reversed
