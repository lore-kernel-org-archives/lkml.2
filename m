Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2FDEVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:21:40 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46652 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2FDEVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:21:39 -0400
Message-ID: <4FCC37CE.3080203@gmail.com>
Date: Mon, 04 Jun 2012 00:21:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com> <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com> <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com> <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <4FCC0B09.1070708@kernel.org> <alpine.LSU.2.00.1206031820520.5143@eggly.anvils> <4FCC1D68.8060406@kernel.org>
In-Reply-To: <4FCC1D68.8060406@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In changelog, Bartlomiej said.
>
>      My particular test case (on a ARM EXYNOS4 device with 512 MiB, which means
>      131072 standard 4KiB pages in 'Normal' zone) is to:
>
>      - allocate 120000 pages for kernel's usage
>      - free every second page (60000 pages) of memory just allocated
>      - allocate and use 60000 pages from user space
>      - free remaining 60000 pages of kernel memory
>        (now we have fragmented memory occupied mostly by user space pages)
>      - try to allocate 100 order-9 (2048 KiB) pages for kernel's usage
>
>      The results:
>      - with compaction disabled I get 11 successful allocations
>      - with compaction enabled - 14 successful allocations
>      - with this patch I'm able to get all 100 successful allocations
>
> I think above workload is really really artificial and theoretical so I didn't like
> this patch but Mel seem to like it. :(
>
> Quote from Mel
> " Ok, that is indeed an adverse workload that the current system will not
> properly deal with. I think you are right to try fixing this but may need
> a different approach that takes the cost out of the allocation/free path
> and moves it the compaction path."
>
> We can correct this patch to work but at least need justification about it.
> Do we really need this patch for such artificial workload?
> what do you think?

I'm ok to resubmit. But please change the thread.

