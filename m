Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0HTBJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:09:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14554 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0HTBJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:09:15 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 20 Aug 2010 03:08:24 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
In-reply-to: <20100820001339N.fujita.tomonori@lab.ntt.co.jp>
To: kyungmin.park@samsung.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-mm@kvack.org, dwalker@codeaurora.org, linux@arm.linux.org.uk,
        corbet@lwn.net, p.osciak@samsung.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        hvaibhav@ti.com, hverkuil@xs4all.nl, kgene.kim@samsung.com,
        zpfeffer@codeaurora.org, jaeryul.oh@samsung.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Message-id: <op.vhppgaxq7p4s8u@localhost>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1281100495.git.m.nazarewicz@samsung.com>
 <AANLkTikp49oOny-vrtRTsJvA3Sps08=w7__JjdA3FE8t@mail.gmail.com>
 <20100820001339N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 17:15:12 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 18 Aug 2010 12:01:35 +0900
> Kyungmin Park <kyungmin.park@samsung.com> wrote:
>
>> Are there any comments or ack?
>>
>> We hope this method included at mainline kernel if possible.
>> It's really needed feature for our multimedia frameworks.
>
> You got any comments from mm people?
>
> Virtually, this adds a new memory allocator implementation that steals
> some memory from memory allocator during boot process. Its API looks
> completely different from the API for memory allocator. That doesn't
> sound appealing to me much. This stuff couldn't be integrated well
> into memory allocator?

What kind of integration do you mean?  I see three levels:

1. Integration on API level meaning that some kind of existing API is used
    instead of new cma_*() calls.  CMA adds notion of devices and memory
    types which is new to all the other APIs (coherent has notion of devices
    but that's not enough).  This basically means that no existing API can be
    used for CMA.  On the other hand, removing notion of devices and memory
    types would defeat the whole purpose of CMA thus destroying the solution
    that CMA provides.

2. Reuse of memory pools meaning that memory reserved by CMA can then be
    used by other allocation mechanisms.  This is of course possible.  For
    instance coherent could easily be implemented as a wrapper to CMA.
    This is doable and can be done in the future after CMA gets more
    recognition.

3. Reuse of algorithms meaning that allocation algorithms used by other
    allocators will be used with CMA regions.  This is doable as well and
    can be done in the future.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

