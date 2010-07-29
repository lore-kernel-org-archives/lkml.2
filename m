Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0G2A6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 20:58:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36768 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0G2A6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 20:58:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49137832"
Message-ID: <bad58db98c165a61860827d4e720acf8.squirrel@www.codeaurora.org>
In-Reply-To: <201007281950.20847.arnd@arndb.de>
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org>
    <201007281039.44883.arnd@arndb.de>
    <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
    <201007281950.20847.arnd@arndb.de>
Date: Wed, 28 Jul 2010 17:58:50 -0700 (PDT)
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: stepanm@codeaurora.org
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, stepanm@codeaurora.org,
        linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 28 July 2010, stepanm@codeaurora.org wrote:
>> > On Wednesday 28 July 2010 00:41:06 Stepan Moskovchenko wrote:
>> >> Add support for the System MMUs found on the 8x60 and 8x72
>> >> families of Qualcomm chips. These SMMUs allow virtualization
>> >> of the address space used by most of the multimedia cores
>> >> on these chips.
>> >
>> > How is this different from an IOMMU?
>> >
>> > From a very brief look, it seems that you should be using the
>> > existing dma-mapping APIs here instead of making up your own.
>> >
>> > 	Arnd
>>
>>
>> These are just SMMU APIs, and the DMA-mapping API is one layer above
>> this.
>>
>> We have our own SMMU API for the MSM SoCs because we have muliple
>> IOMMUs,
>> each one having multiple contexts, or even having multiple instances of
>> the same context. Our usage model is also quite a bit different from how
>> the DMA APIs are set up. I believe only two IOMMU drivers actually make
>> use of the DMA API (Intel and AMD) and the other ones (OMAP and other
>> SoCs) have their own APIs for their specific use cases.
>
> The DMA API is extremely flexible, it works just fine with all the
> IOMMUs that I've seen so far. Please take a look at
> include/asm-generic/dma-mapping-common.h and its users to see how
> to use multiple IOMMUs depending on the device.
>
> If the OMAP developers got this wrong, that's not your problem :-)
>
> 	Arnd

Hi Arnd,

>From what I have been able to tell, the IOMMU interface was written by
AMD/Intel to allow the kvm code to work with a common IOMMU interface. To
that end, it isn't really a generic IOMMU interface. We have chosen to use
our own interface because it provides us with a lightweight way of
managing mappings for more esoteric MSM-specific use cases.

These map functions also take into account the way in which we map buffers
that we get from our own physical pool, because the current API was not
intended to deal with prioritized allocation of things like on/off-chip
memory. We are currently evaluating how to use the DMA API with our own
specialized allocator, which has been undergoing some discussion on the
other lists. We would like to use this allocator to maximize TLB
performance, as well as to prioritize the allocation from several
different memory pools.

Steve

