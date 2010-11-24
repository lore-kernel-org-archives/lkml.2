Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0KXAmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:42:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50799 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0KXAmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:42:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Nov 2010 09:36:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: =?UTF-8?B?TWljaGHFgg==?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan.kim@gmail.com, Bob Liu <lliubbo@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, pawel@osciak.com, andi.kleen@intel.com,
        felipe.contreras@gmail.com,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 0/4] big chunk memory allocator v4
Message-Id: <20101124093653.bb8692e4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <op.vmmre1vv7p4s8u@pikus>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
	<20101119125653.16dd5452.akpm@linux-foundation.org>
	<20101122090431.4ff9c941.kamezawa.hiroyu@jp.fujitsu.com>
	<op.vmmre1vv7p4s8u@pikus>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 16:46:03 +0100
Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:

> A few things than:
> 
> 1. As Felipe mentioned, on ARM it is often desired to have the memory
>     mapped as non-cacheable, which most often mean that the memory never
>     reaches the page allocator.  This means, that alloc_contig_pages()
>     would not be suitable for cases where one needs such memory.
> 
>     Or could this be overcome by adding the memory back as highmem?  But
>     then, it would force to compile in highmem support even if platform
>     does not really need it.
> 
> 2. Device drivers should not by themselves know what ranges of memory to
>     allocate memory from.  Moreover, some device drivers could require
>     allocation different buffers from different ranges.  As such, this
>     would require some management code on top of alloc_contig_pages().
> 
> 3. When posting hwmem, Johan Mossberg mentioned that he'd like to see
>     notion of "pinning" chunks (so that not-pinned chunks can be moved
>     around when hardware does not use them to defragment memory).  This
>     would again require some management code on top of
>     alloc_contig_pages().
> 
> 4. I might be mistaken here, but the way I understand ZONE_MOVABLE work
>     is that it is cut of from the end of memory.  Or am I talking nonsense?
>     My concern is that at least one chip I'm working with requires
>     allocations from different memory banks which would basically mean that
>     there would have to be two movable zones, ie:
> 
>     +-------------------+-------------------+
>     | Memory Bank #1    | Memory Bank #2    |
>     +---------+---------+---------+---------+
>     | normal  | movable | normal  | movable |
>     +---------+---------+---------+---------+
> 
yes.

> So even though I'm personally somehow drawn by alloc_contig_pages()'s
> simplicity (compared to CMA at least), those quick thoughts make me think
> that alloc_contig_pages() would work rather as a backend (as Kamezawa
> mentioned) for some, maybe even tiny but still present, management code
> which would handle "marking memory fragments as ZONE_MOVABLE" (whatever
> that would involve) and deciding which memory ranges drivers can allocate
> from.
> 
> I'm also wondering whether alloc_contig_pages()'s first-fit is suitable but
> that probably cannot be judged without some benchmarks.
> 

I'll continue to update patches, you can freely reuse my code and integrate
this set to yours. I works for this firstly for EMBEDED but I want this to be
a _generic_ function for gerenal purpose architecture.
There may be guys who want 1G page on a host with tons of free memory.


Thanks,
-Kame
 

