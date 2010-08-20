Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0HTKyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:54:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45924 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0HTKys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:54:48 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 20 Aug 2010 12:54:02 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
In-reply-to: <20100820193328P.fujita.tomonori@lab.ntt.co.jp>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hverkuil@xs4all.nl, dwalker@codeaurora.org, linux@arm.linux.org.uk,
        corbet@lwn.net, p.osciak@samsung.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        hvaibhav@ti.com, linux-mm@kvack.org, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, zpfeffer@codeaurora.org, jaeryul.oh@samsung.com,
        m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Message-id: <op.vhqgkcgj7p4s8u@localhost>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <op.vhp4pws27p4s8u@localhost>
 <20100820155617S.fujita.tomonori@lab.ntt.co.jp> <op.vhp7rxz77p4s8u@localhost>
 <20100820193328P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 12:35:01 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Fri, 20 Aug 2010 10:10:45 +0200
> **UNKNOWN CHARSET** <m.nazarewicz@samsung.com> wrote:
>
>> > I wrote "similar to the existing API', not "reuse the existing API".
>>
>> Yes, but I don't really know what you have in mind.  CMA is similar to various
>> APIs in various ways: it's similar to any allocator since it takes
>> size in bytes,
>
> why don't take gfp_t flags?

Because they are insufficient.  Either that or I don't understand gfp_t.

With CMA, platform can define many memory types.  For instance, if there are
two memory bans there can be two memory types for the two banks.  For at least one
of the device I'm in contact with, another type for it's firmware is also needed.
Bottom line is that there may be possibly many types which won't map to gfp_t.

> Something like dev_alloc_page is more appropriate name?

Two things: I'd prefer a "cma" prefix rather then "dev" and I think it should
be "pages", right? Then, size should be given in pages rather then bytes.

Nonetheless, I don't really see at the moment why this should be better.

> Or something similar to dmapool API (mm/dmapool.c) might work
> better. The purpose of dmapool API is creating a pool for consistent
> memory per device. It's similar to yours, creating a pool for
> contiguous memory per device(s)?

I'll try to look at it later on and think about it.  I'm still somehow reluctant
to change the names but still, thank you for suggestions.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

