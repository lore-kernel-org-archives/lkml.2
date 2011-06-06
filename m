Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab1FFMjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1FFMjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:39:05 -0400
Date: Mon, 6 Jun 2011 14:38:51 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>, akpm@linux-foundation.org,
        Ury Stankevich <urykhy@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
Message-ID: <20110606123851.GA12887@random.random>
References: <20110601214018.GC7306@suse.de>
 <20110601233036.GZ19505@random.random>
 <20110602010352.GD7306@suse.de>
 <20110602132954.GC19505@random.random>
 <20110602145019.GG7306@suse.de>
 <20110602153754.GF19505@random.random>
 <20110603020920.GA26753@suse.de>
 <20110603144941.GI7306@suse.de>
 <20110603154554.GK2802@random.random>
 <20110606103924.GD5247@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606103924.GD5247@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 11:39:24AM +0100, Mel Gorman wrote:
> Well spotted.
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> 
> Minor nit. swapper_space is rarely referred to outside of the swap
> code. Might it be more readable to use
> 
> 	/*
> 	 * swapcache is accounted as NR_FILE_PAGES but it is not
> 	 * accounted as NR_SHMEM
> 	 *
> 	if (PageSwapBacked(page) && !PageSwapCache(page))

I thought the comparison on swapper_space would be faster as it was
immediate vs register in CPU, instead of forcing a memory
access. Otherwise I would have used the above. Now the test_bit is
written in C and lockless so it's not likely to be very different
considering the cacheline is hot in the CPU but it's still referencing
memory instead register vs immediate comparison.
