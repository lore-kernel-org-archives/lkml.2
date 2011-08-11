Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1HKT2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:28:47 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48551 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab1HKT2p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikKnE-9WncNCADKfZVqkP1LFPYeXA@mail.gmail.com>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
	<20110414223036.GA7335@n2100.arm.linux.org.uk>
	<BANLkTin8gugnVoai6VHC7qMgK4eKRXRtHg@mail.gmail.com>
	<20110428134055.GA19709@n2100.arm.linux.org.uk>
	<BANLkTikKnE-9WncNCADKfZVqkP1LFPYeXA@mail.gmail.com>
Date: Thu, 11 Aug 2011 14:28:39 -0500
Message-ID: <CADysL2bp08WP798_MvUJthGi9ACySDE=Dc_BM9Vd0A=YcKpm+Q@mail.gmail.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
From: "Gupta, Ramesh" <grgupta@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,


On Thu, Apr 28, 2011 at 11:48 AM, Gupta, Ramesh <grgupta@ti.com> wrote:
> Hi Russel,
>
> On Thu, Apr 28, 2011 at 8:40 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Fri, Apr 15, 2011 at 06:26:40AM -0500, Gupta, Ramesh wrote:
>>> Russell,
>>>
>>> On Thu, Apr 14, 2011 at 5:30 PM, Russell King - ARM Linux
>>> <linux@arm.linux.org.uk> wrote:
>>> > On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
>>> >> From: Ramesh Gupta <grgupta@ti.com>
>>> >>
>>> >> This patch is to flush the iommu page table entries from L1 and L2
>>> >> caches using dma_map_single. This also simplifies the implementation
>>> >> by removing the functions  flush_iopgd_range/flush_iopte_range.
>>> >
>>> > No.  This usage is just wrong.  If you're going to use the DMA API then
>>> > unmap it, otherwise the DMA API debugging will go awol.
>>> >
>>>
>>> Thank you for the comments, this particular memory is always a write
>>> from the A9 for MMU programming and
>>> only read from the slave processor, that is the reason for not calling
>>> the unmap. I can re-look into the changes to call
>>> unmap in a proper way as this impacts the DMA API.
>>> Are there any other ways to perform only flush the memory from L1/L2 caches?
>>
>> We _could_ invent a new API to deal with this, which is probably going
>> to be far better in the longer term for page table based iommus.  That's
>> going to need some thought - eg, do we need to pass a struct device
>> argument for the iommu cache flushing so we know whether we need to flush
>> or not (eg, if we have cache coherent iommus)...

my apologies for a late mail on this topic.

do you think of any other requirements for this new API?

Could we use the existing dmac_flush_range(), outer_flush_range()
for this purpose instead of a new API?

I see a comment in the arch/arm/include/asm/cacheflush.h
for  _not_ to use these APIs directly, but I am not really understand
the reason for that.

I would appreciate any inputs on this.

thank you and regards
Ramesh Gupta G
