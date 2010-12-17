Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0LQCza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 21:55:30 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52390 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0LQCzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 21:55:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67174856"
Message-ID: <8c67e174d807416f0c6c190cc72d3f5a.squirrel@www.codeaurora.org>
In-Reply-To: <AANLkTimwqC6DqN8ft10EyRbPh9XvibN1fA-Cug4OdS5m@mail.gmail.com>
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org>
    <20101202221909.GK29347@n2100.arm.linux.org.uk>
    <4CF94DDD.8000409@codeaurora.org>
    <20101203203653.GB10245@n2100.arm.linux.org.uk>
    <4CFDD297.4020600@codeaurora.org>
    <15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>
    <20101209103835.GA31465@n2100.arm.linux.org.uk>
    <4D017B45.4000805@codeaurora.org>
    <AANLkTi=PnnT8rVKMxK0tVTdKnKdcKf71fsX2o594Qx3e@mail.gmail.com>
    <4D045692.4050607@codeaurora.org>
    <AANLkTimwqC6DqN8ft10EyRbPh9XvibN1fA-Cug4OdS5m@mail.gmail.com>
Date: Thu, 16 Dec 2010 18:55:06 -0800 (PST)
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to 
     early_initcall
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Catalin Marinas" <catalin.marinas@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Saravana Kannan" <skannan@codeaurora.org>, dwalker@codeaurora.org,
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


> On 12 December 2010 04:58, Saravana Kannan <skannan@codeaurora.org> wrote:
>> As you and James suggested, having the NS bit set by the secure world is
>> definitely a solution that would work. But IMHO, the explicit cache
>> flush/invalidate approach keeps the design simple and easy to maintain.
>
> That is indeed an approach to the problem. But it depends on whether
> we consider the DMA API appropriate for this. We can view the secure
> world as a non-coherent agent accessing the memory and could try to
> justify the use of the DMA API in Linux.
>
> At some point we'll probably have platforms supporting cacheable DMA
> (e.g. via the ARM coherency port) and the DMA API would no longer give
> you what you need. But it is also possible that platforms with ACP
> would only have 1 or 2 devices on that port (some HD LCD controller
> for example) and the rest of devices non-coherent. In this case, we
> need to have different DMA operations depending on the bus/device (via
> get_dma_ops) and thus we can allow your scenario via dedicated DMA
> ops.

Catalin,

Looks like you agree with our approach. If that's the case, would you mind
Acking Jeff's initial patch that this thread is based on?

Russell,

Does Catalin's proposal sound acceptable to you?

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


