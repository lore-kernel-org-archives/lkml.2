Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0J2LEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:04:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37886 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0J2LEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:04:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 29 Oct 2010 19:59:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi.kleen@intel.com>
Cc: =?UTF-8?B?TWljaGHFgg==?= Nazarewicz <m.nazarewicz@samsung.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
Message-Id: <20101029195900.88559162.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101029103154.GA10823@gargoyle.fritz.box>
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
	<op.vlbywq137p4s8u@pikus>
	<20101029103154.GA10823@gargoyle.fritz.box>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 12:31:54 +0200
Andi Kleen <andi.kleen@intel.com> wrote:

> > When I was posting CMA, it had been suggested to create a new migration type
> > dedicated to contiguous allocations.  I think I already did that and thanks to
> > this new migration type we have (i) an area of memory that only accepts movable
> > and reclaimable pages and 
> 
> Aka highmem next generation :-(
> 

yes. But Nick's new shrink_slab() may be a new help even without
new zone.


> > (ii) is used only if all other (non-reserved) pages have
> > been allocated.
> 
> That will be near always the case after some uptime, as memory fills up
> with caches. Unless you do early reclaim? 
> 

memory migration always do work with alloc_page() for getting migration target
pages. So, memory will be reclaimed if filled by cache.

About my patch, I may have to prealloc all required pages before start.
But I didn't do that at this time.

Thanks,
-Kame

