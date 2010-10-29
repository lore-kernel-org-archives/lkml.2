Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab0J2JSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:18:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16853 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0J2JSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:18:21 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 29 Oct 2010 11:20:40 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
In-reply-to: <AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andi.kleen@intel.com, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, felipe.contreras@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Peter Zijlstra <peterz@infradead.org>
Message-id: <op.vlbywq137p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 26, 2010 at 7:00 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> I only did small test and it seems to work (but I think there will be bug...)
>> I post this now just because I'll be out of office 10/31-11/15 with ksummit and
>> a private trip.
>>
>> Any comments are welcome but please see the interface is enough for use cases or
>> not.  For example) If MAX_ORDER alignment is too bad, I need to rewrite almost
>> all code.

On Thu, 28 Oct 2010 01:22:38 +0200, Minchan Kim <minchan.kim@gmail.com> wrote:
> First of all, thanks for the endless your effort to embedded system.
> It's time for statkeholders to review this.
> Cced some guys. Maybe many people of them have to attend KS.
> So I hope SAMSUNG guys review this.
>
> Maybe they can't test this since ARM doesn't support movable zone now.
> (I will look into this).
> As Kame said, please, review this patch whether this patch have enough
> interface and meet your requirement.
> I think this can't meet _all_ of your requirements(ex, latency and
> making sure getting big contiguous memory) but I believe it can meet
> NOT CRITICAL many cases, I guess.

I'm currently working on a framework (the CMA framework some may be aware of) which
in principle is meant for the same purpose: allocating physically contiguous blocks
of memory.  I'm hoping to help with latency, remove the need for MAX_ORDER alignment
as well as help with fragmentation by letting different drivers allocate memory from
different memory range.

When I was posting CMA, it had been suggested to create a new migration type
dedicated to contiguous allocations.  I think I already did that and thanks to
this new migration type we have (i) an area of memory that only accepts movable
and reclaimable pages and (ii) is used only if all other (non-reserved) pages have
been allocated.

I'm currently working on migration so that those movable and reclaimable pages
allocated in area dedicated for CMA are freed and Kame's work is quite helpful
in this regard as I have something to base my work on. :)

Nonetheless, it's a conference time now (ELC, PLC; interestingly both are in
Cambridge :P) so I guess we, here at SPRC, will look into it more after PLC.

>> Now interface is:
>>
>> struct page *__alloc_contig_pages(unsigned long base, unsigned long end,
>>                        unsigned long nr_pages, int align_order,
>>                        int node, gfp_t gfpflag, nodemask_t *mask)
>>
>>  * @base: the lowest pfn which caller wants.
>>  * @end:  the highest pfn which caller wants.
>>  * @nr_pages: the length of a chunk of pages to be allocated.
>>  * @align_order: alignment of start address of returned chunk in order.
>>  *   Returned' page's order will be aligned to (1 << align_order).If smaller
>>  *   than MAX_ORDER, it's raised to MAX_ORDER.
>>  * @node: allocate near memory to the node, If -1, current node is used


PS. Please note that Pawel's new address is <pawel@osciak.com>.  Fixing in Cc.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
