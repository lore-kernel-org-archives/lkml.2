Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0GVO5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:57:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13717 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0GVO5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:57:21 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 22 Jul 2010 16:58:43 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <20100722134056.GJ4737@rakim.wolfsonmicro.main>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>, linux-mm@kvack.org,
        Pawel Osciak <p.osciak@samsung.com>,
        "'Xiaolin Zhang'" <xiaolin.zhang@intel.com>,
        "'Hiremath Vaibhav'" <hvaibhav@ti.com>,
        "'Robert Fekete'" <robert.fekete@stericsson.com>,
        "'Marcus Lorentzon'" <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
Message-id: <op.vf82j5m17p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <20100721135229.GC10930@sirena.org.uk> <op.vf66mxka7p4s8u@pikus>
 <20100721182457.GE10930@sirena.org.uk> <op.vf7h6ysh7p4s8u@pikus>
 <20100722090602.GF10930@sirena.org.uk>
 <000901cb297f$e28f2b10$a7ad8130$%szyprowski@samsung.com>
 <20100722105203.GD4737@rakim.wolfsonmicro.main> <op.vf8sxqro7p4s8u@pikus>
 <20100722124559.GH4737@rakim.wolfsonmicro.main> <op.vf8x60wi7p4s8u@pikus>
 <20100722134056.GJ4737@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 15:40:56 +0200, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Thu, Jul 22, 2010 at 03:24:26PM +0200, Michał Nazarewicz wrote:
>
>> That's why command line is only intended as a way to overwrite the
>> defaults which are provided by the platform.  In a final product,
>> configuration should be specified in platform code and not on
>> command line.
>
> Yeah, agreed though I'm not convinced we can't do it via userspace
> (initrd would give us a chance to do stuff early) or just kernel
> rebuilds.

If there's any other easy way of overwriting platform's default I'm happy
to listen. :)

>> >It sounds like apart from the way you're passing the configuration in
>> >you're doing roughly what I'd suggest.  I'd expect that in a lot of
>> >cases the map could be satisfied from the default region so there'd be
>> >no need to explicitly set one up.
>
>> Platform can specify something like:
>
>> 	cma_defaults("reg=20M", "*/*=reg");
>
>> which would make all the drivers share 20 MiB region by default.
>
> Yes, exactly - probably you can even have a default region backed by
> normal vmalloc() RAM which would at least be able to take a stab at
> working by default.

Not sure what you mean here.  vmalloc() allocated buffers cannot be used
with CMA since they are not contiguous in memory.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
