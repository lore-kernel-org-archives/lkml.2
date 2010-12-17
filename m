Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0LQLbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:31:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62109 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0LQLbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MwPuGD+mhROnMJXlO+xN4DCMBcTBjWBSRU7osmG/UYZxpfhQnvmacEmg/Uq9hivA9F
         iNEJOV9ZUzW3j6/mqsJLB92W6vqDY8t78AO1cMnIfxx3ZKfx8St96xBzlDGYgddV1odO
         oT6P9n+Uy3ueDtSw4/HzIU/1HCP0efb2hUGw8=
MIME-Version: 1.0
In-Reply-To: <99eb693af85e07b01d81d45f1bc77f64.squirrel@www.codeaurora.org>
References: <4CF94DDD.8000409@codeaurora.org>
	<20101203203653.GB10245@n2100.arm.linux.org.uk>
	<4CFDD297.4020600@codeaurora.org>
	<15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>
	<20101209103835.GA31465@n2100.arm.linux.org.uk>
	<4D017B45.4000805@codeaurora.org>
	<AANLkTi=PnnT8rVKMxK0tVTdKnKdcKf71fsX2o594Qx3e@mail.gmail.com>
	<4D045692.4050607@codeaurora.org>
	<AANLkTimwqC6DqN8ft10EyRbPh9XvibN1fA-Cug4OdS5m@mail.gmail.com>
	<8c67e174d807416f0c6c190cc72d3f5a.squirrel@www.codeaurora.org>
	<20101217094818.GA9937@n2100.arm.linux.org.uk>
	<99eb693af85e07b01d81d45f1bc77f64.squirrel@www.codeaurora.org>
Date: Fri, 17 Dec 2010 11:31:03 +0000
X-Google-Sender-Auth: SLlF9TGiVnYgViu5hsYXEufo10k
Message-ID: <AANLkTinsgqLDe3=KX59n1UAp9v0ErXQzxj+A+qQ8TRj_@mail.gmail.com>
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to early_initcall
From: Catalin Marinas <catalin.marinas@arm.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Nicolas Pitre <nico@marvell.com>,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2010 10:26, Saravana Kannan <skannan@codeaurora.org> wrote:
>>> Looks like you agree with our approach. If that's the case, would you
>>> mind
>>> Acking Jeff's initial patch that this thread is based on?
>>
>> I read Catalin's reply as agreeing with me.
>
> Catalin, Can you clarify?

I'll try but I started my holidays and I'll only be online occasionally.

Just to clarify, even if I ack Jeff's patch, it is for Russell to
decide what gets merged. Now, Jeff's patch doesn't show anything about
how the dma_alloc_coherent is used, just suggests something in the
commit log, so I don't see it critical to this discussion. I wouldn't
ack it without agreement on the extension of the DMA API (which can
only have a no-op get_dma_ops at this point).

I agree with Russell's points that just using the DMA API as it is may
break in the future, hence a proposal to treat it slightly different.

People in ARM working on a generic state save/restore mechanism face
the same problem - they need some non-cacheable memory for
synchronisation. I'm not sure whether they managed to find an
alternative algorithm with cached memory and cache flushing and I also
haven't followed the development to give more details.

> Russell,
>
> I agree with your point about using an API for purpose and not property.
> But I read Catalin's proposal as, let's treat secure domain as another DMA
> "device". If we make a conscious agreement to do that, then using the DMA
> API for secure domain would be "using it for its purpose" and we will make
> an effort to not break it with future updates. Of course, if we don't
> agree on that proposal, then we can't use the DMA API for secure domain
> stuff.

If there is no better proposal, I'm for such extension to the DMA API.
>From the kernel perspecitve, the secure side is just another entity
that accesses the RAM directly. It's not a physically separate device
indeed but from a direct memory access perspective it can be treated
as any other device.

In the DMA API we can fall back to the non-coherent ops when a NULL
struct device is passed. I assume in your code you already pass a NULL
device to dma_alloc_coherent().

-- 
Catalin
