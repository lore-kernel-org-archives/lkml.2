Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab0HTGjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:39:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43746 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0HTGjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:39:11 -0400
Date: Fri, 20 Aug 2010 08:38:10 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
In-reply-to: <20100820121124Z.fujita.tomonori@lab.ntt.co.jp>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: kyungmin.park@samsung.com, linux-mm@kvack.org, dwalker@codeaurora.org,
        linux@arm.linux.org.uk, corbet@lwn.net, p.osciak@samsung.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        hvaibhav@ti.com, hverkuil@xs4all.nl, kgene.kim@samsung.com,
        zpfeffer@codeaurora.org, jaeryul.oh@samsung.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Message-id: <op.vhp4pws27p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <AANLkTikp49oOny-vrtRTsJvA3Sps08=w7__JjdA3FE8t@mail.gmail.com>
 <20100820001339N.fujita.tomonori@lab.ntt.co.jp> <op.vhppgaxq7p4s8u@localhost>
 <20100820121124Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 05:12:50 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>> 1. Integration on API level meaning that some kind of existing API is used
>>     instead of new cma_*() calls.  CMA adds notion of devices and memory
>>     types which is new to all the other APIs (coherent has notion of devices
>>     but that's not enough).  This basically means that no existing API can be
>>     used for CMA.  On the other hand, removing notion of devices and memory
>>     types would defeat the whole purpose of CMA thus destroying the solution
>>     that CMA provides.
>
> You can create something similar to the existing API for memory
> allocator.

That may be tricky.  cma_alloc() takes four parameters each of which is
required for CMA.  No other existing set of API uses all those arguments.
This means, CMA needs it's own, somehow unique API.  I don't quite see
how the APIs may be unified or "made similar".  Of course, I'm gladly
accepting suggestions.

>> 2. Reuse of memory pools meaning that memory reserved by CMA can then be
>>     used by other allocation mechanisms.  This is of course possible.  For
>>     instance coherent could easily be implemented as a wrapper to CMA.
>>     This is doable and can be done in the future after CMA gets more
>>     recognition.
>>
>> 3. Reuse of algorithms meaning that allocation algorithms used by other
>>     allocators will be used with CMA regions.  This is doable as well and
>>     can be done in the future.
>
> Well, why can't we do the above before the inclusion?

Because it's quite a bit of work and instead of diverting my attention I'd
prefer to make CMA as good as possible and then integrate it with other
subsystems.  Also, adding the integration would change the patch from being
4k lines to being like 40k lines.

What I'm trying to say is that I don't consider that a work for now but
rather a further enchantments.

> Anyway, I think that comments from mm people would be helpful to merge
> this.

Yes, I agree.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

