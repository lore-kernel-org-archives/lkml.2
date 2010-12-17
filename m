Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0LQK07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:26:59 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14732 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0LQK06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:26:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67216456"
Message-ID: <99eb693af85e07b01d81d45f1bc77f64.squirrel@www.codeaurora.org>
In-Reply-To: <20101217094818.GA9937@n2100.arm.linux.org.uk>
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
Date: Fri, 17 Dec 2010 02:26:44 -0800 (PST)
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to 
     early_initcall
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, "Nicolas Pitre" <nico@marvell.com>,
        linux-kernel@vger.kernel.org,
        "Jeff Ohlstein" <johlstei@codeaurora.org>, "Tejun Heo" <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Catalin,
>>
>> Looks like you agree with our approach. If that's the case, would you
>> mind
>> Acking Jeff's initial patch that this thread is based on?
>
> I read Catalin's reply as agreeing with me.

Catalin, Can you clarify?

>> Russell,
>>
>> Does Catalin's proposal sound acceptable to you?
>
> Catalin's proposal for get_dma_ops doesn't work for you because you
> don't have a struct device for your CPUs - and as we don't have anything
> supporting ACP at the moment, there's little point engineering it in.
>
> The basic point here is that using the DMA API to achieve DMA coherency
> with something that is not DMA is going to be prone to failure, because
> we aren't going to guarantee that it'll do what you want.  There's
> already a history of people abusing the DMA API, and then when we fix
> stuff in the DMA API, they complain that their drivers have broken.
>
> What I've been saying is never use it for its properties (for its uncached
> memory) as that is _not_ guaranteed - use it for its purpose instead
> (which is to provide coherent memory for DMA devices) which is guaranteed.

Russell,

I agree with your point about using an API for purpose and not property.
But I read Catalin's proposal as, let's treat secure domain as another DMA
"device". If we make a conscious agreement to do that, then using the DMA
API for secure domain would be "using it for its purpose" and we will make
an effort to not break it with future updates. Of course, if we don't
agree on that proposal, then we can't use the DMA API for secure domain
stuff.

After Catalin's response to clarify, if we still end up not treating
secure domain as a "DMA device", then what's the alternative? Can we get
an explicit "cache invalidate API" that's outside of the DMA APIs? Or a
general uncached pages alloc/free APIs?

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


