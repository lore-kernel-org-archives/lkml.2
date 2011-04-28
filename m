Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1D1QsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:48:18 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39763 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab1D1QsR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110428134055.GA19709@n2100.arm.linux.org.uk>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com>
	<20110414223036.GA7335@n2100.arm.linux.org.uk>
	<BANLkTin8gugnVoai6VHC7qMgK4eKRXRtHg@mail.gmail.com>
	<20110428134055.GA19709@n2100.arm.linux.org.uk>
Date: Thu, 28 Apr 2011 11:48:15 -0500
Message-ID: <BANLkTikKnE-9WncNCADKfZVqkP1LFPYeXA@mail.gmail.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
From: "Gupta, Ramesh" <grgupta@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, Hari Kanigeri <h-kanigeri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

On Thu, Apr 28, 2011 at 8:40 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Apr 15, 2011 at 06:26:40AM -0500, Gupta, Ramesh wrote:
>> Russell,
>>
>> On Thu, Apr 14, 2011 at 5:30 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
>> >> From: Ramesh Gupta <grgupta@ti.com>
>> >>
>> >> This patch is to flush the iommu page table entries from L1 and L2
>> >> caches using dma_map_single. This also simplifies the implementation
>> >> by removing the functions  flush_iopgd_range/flush_iopte_range.
>> >
>> > No.  This usage is just wrong.  If you're going to use the DMA API then
>> > unmap it, otherwise the DMA API debugging will go awol.
>> >
>>
>> Thank you for the comments, this particular memory is always a write
>> from the A9 for MMU programming and
>> only read from the slave processor, that is the reason for not calling
>> the unmap. I can re-look into the changes to call
>> unmap in a proper way as this impacts the DMA API.
>> Are there any other ways to perform only flush the memory from L1/L2 caches?
>
> We _could_ invent a new API to deal with this, which is probably going
> to be far better in the longer term for page table based iommus.  That's
> going to need some thought - eg, do we need to pass a struct device
> argument for the iommu cache flushing so we know whether we need to flush
> or not (eg, if we have cache coherent iommus)...

I agree with you, right now these functions are taking only start and
end arguments but
we can pass a struct deivice to these functions.

thank you and regards
Ramesh Gupta G
