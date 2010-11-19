Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0KSU5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:57:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059Ab0KSU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:57:06 -0500
Date: Fri, 19 Nov 2010 12:56:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        minchan.kim@gmail.com, Bob Liu <lliubbo@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, m.nazarewicz@samsung.com,
        pawel@osciak.com, andi.kleen@intel.com, felipe.contreras@gmail.com,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/4] big chunk memory allocator v4
Message-Id: <20101119125653.16dd5452.akpm@linux-foundation.org>
In-Reply-To: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 17:10:33 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Hi, this is an updated version. 
> 
> No major changes from the last one except for page allocation function.
> removed RFC.
> 
> Order of patches is
> 
> [1/4] move some functions from memory_hotplug.c to page_isolation.c
> [2/4] search physically contiguous range suitable for big chunk alloc.
> [3/4] allocate big chunk memory based on memory hotplug(migration) technique
> [4/4] modify page allocation function.
> 
> For what:
> 
>   I hear there is requirements to allocate a chunk of page which is larger than
>   MAX_ORDER. Now, some (embeded) device use a big memory chunk. To use memory,
>   they hide some memory range by boot option (mem=) and use hidden memory
>   for its own purpose. But this seems a lack of feature in memory management.
> 
>   This patch adds 
> 	alloc_contig_pages(start, end, nr_pages, gfp_mask)
>   to allocate a chunk of page whose length is nr_pages from [start, end)
>   phys address. This uses similar logic of memory-unplug, which tries to
>   offline [start, end) pages. By this, drivers can allocate 30M or 128M or
>   much bigger memory chunk on demand. (I allocated 1G chunk in my test).
> 
>   But yes, because of fragmentation, this cannot guarantee 100% alloc.
>   If alloc_contig_pages() is called in system boot up or movable_zone is used,
>   this allocation succeeds at high rate.

So this is an alternatve implementation for the functionality offered
by Michal's "The Contiguous Memory Allocator framework".

>   I tested this on x86-64, and it seems to work as expected. But feedback from
>   embeded guys are appreciated because I think they are main user of this
>   function.

>From where I sit, feedback from the embedded guys is *vital*, because
they are indeed the main users.

Michal, I haven't made a note of all the people who are interested in
and who are potential users of this code.  Your patch series has a
billion cc's and is up to version 6.  Could I ask that you review and
test this code, and also hunt down other people (probably at other
organisations) who can do likewise for us?  Because until we hear from
those people that this work satisfies their needs, we can't really
proceed much further.

Thanks.



