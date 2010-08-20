Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab0HTINS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:13:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33742 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0HTINO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:13:14 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 20 Aug 2010 10:10:45 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
In-reply-to: <20100820155617S.fujita.tomonori@lab.ntt.co.jp>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hverkuil@xs4all.nl, dwalker@codeaurora.org, linux@arm.linux.org.uk,
        corbet@lwn.net, p.osciak@samsung.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        hvaibhav@ti.com, linux-mm@kvack.org, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, zpfeffer@codeaurora.org, jaeryul.oh@samsung.com,
        m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Message-id: <op.vhp7rxz77p4s8u@localhost>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <op.vhppgaxq7p4s8u@localhost>
 <20100820121124Z.fujita.tomonori@lab.ntt.co.jp> <op.vhp4pws27p4s8u@localhost>
 <20100820155617S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 08:57:51 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Fri, 20 Aug 2010 08:38:10 +0200
> **UNKNOWN CHARSET** <m.nazarewicz@samsung.com> wrote:
>
>> On Fri, 20 Aug 2010 05:12:50 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>> >> 1. Integration on API level meaning that some kind of existing API is used
>> >>     instead of new cma_*() calls.  CMA adds notion of devices and memory
>> >>     types which is new to all the other APIs (coherent has notion of devices
>> >>     but that's not enough).  This basically means that no existing API can be
>> >>     used for CMA.  On the other hand, removing notion of devices and memory
>> >>     types would defeat the whole purpose of CMA thus destroying the solution
>> >>     that CMA provides.
>> >
>> > You can create something similar to the existing API for memory
>> > allocator.
>>
>> That may be tricky.  cma_alloc() takes four parameters each of which is
>> required for CMA.  No other existing set of API uses all those arguments.
>> This means, CMA needs it's own, somehow unique API.  I don't quite see
>> how the APIs may be unified or "made similar".  Of course, I'm gladly
>> accepting suggestions.
>
> Have you even tried to search 'blk_kmalloc' on google?

I have and I haven't seen any way how

   void *()(struct request_queue *q, unsigned size, gfp_t gfp);

prototype could be applied to CMA.  I admit that I haven't read the whole
discussion of the patch and maybe I'm missing something about Andi's patches
but I don't see how CMA could but from what I've understood blk_kmalloc() is
dissimilar to CMA.  I'll be glad if you could show me where I'm wrong.

> I wrote "similar to the existing API', not "reuse the existing API".

Yes, but I don't really know what you have in mind.  CMA is similar to various
APIs in various ways: it's similar to any allocator since it takes size in bytes,
it's similar to coherent since it takes device, it's similar to bootmem/memblock/etc
since it takes alignment.  I would appreciate if you could give some examples of what
you mean by similar and ideas haw CMA's API may be improved.

>> >> 2. Reuse of memory pools meaning that memory reserved by CMA can then be
>> >>     used by other allocation mechanisms.  This is of course possible.  For
>> >>     instance coherent could easily be implemented as a wrapper to CMA.
>> >>     This is doable and can be done in the future after CMA gets more
>> >>     recognition.
>> >>
>> >> 3. Reuse of algorithms meaning that allocation algorithms used by other
>> >>     allocators will be used with CMA regions.  This is doable as well and
>> >>     can be done in the future.
>> >
>> > Well, why can't we do the above before the inclusion?
>>
>> Because it's quite a bit of work and instead of diverting my attention I'd
>> prefer to make CMA as good as possible and then integrate it with other
>> subsystems.  Also, adding the integration would change the patch from being
>> 4k lines to being like 40k lines.
>
> 4k to 40k? I'm not sure. But If I see something like the following, I
> suspect that there is a better way to integrate this into the existing
> infrastructure.
>
> mm/cma-best-fit.c                   |  407 +++++++++++++++

Ah, sorry.  I misunderstood you.  I thought you were replying to both 2. and 3.
above.

If we only take allocating algorithm then you're right.  Reusing existing one
should not increase the patch size plus it would be probably a better solution.

No matter, I would rather first work and core CMA without worrying about reusing
kmalloc()/coherent/etc. code especially since providing a plugable allocator API
integration with existing allocating algorithms can be made later on.  To put it
short I want first to make it work and then improve it.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

