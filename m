Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1FVCmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:42:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816Ab1FVCmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:42:36 -0400
Message-ID: <4E015672.2020407@redhat.com>
Date: Wed, 22 Jun 2011 10:41:54 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: make the threshold of enabling THP configurable
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <1308587683-2555-2-git-send-email-amwang@redhat.com> <20110620165955.GB9396@suse.de> <4DFF8050.9070201@redhat.com> <20110621093640.GD9396@suse.de>
In-Reply-To: <20110621093640.GD9396@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 17:36, Mel Gorman 写道:
 >
> Fragmentation avoidance benefits from tuning min_free_kbytes to a higher
> value and minimising fragmentation-related problems is crucial if THP is
> to allocate its necessary pages.
>
> THP tunes min_free_kbytes automatically and this value is in part
> related to the number of zones. At 512M on a single node machine, the
> recommended min_free_kbytes is close to 10% of memory which is barely
> tolerable as it is. At 256M, it's 17%, at 128M, it's 34% so tuning the
> value lower has diminishing returns as the performance impact of giving
> up such a high percentage of free memory is not going to be offset by
> reduced TLB misses. Tuning it to a higher value might make some sense
> if the higher min_free_kbytes was a problem but it would be much more
> rational to tune it as a sysctl than making it a compile-time decision.
>

What this patch changed is the check of total memory pages in hugepage_init(),
which I don't think is suitable as a sysctl.

If you mean min_free_kbytes could be tuned as a sysctl, that should be done
in other patch, right? :)

Thanks.
