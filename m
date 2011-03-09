Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1CIIFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:05:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42231 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1CIIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:05:51 -0500
Date: Wed, 9 Mar 2011 08:05:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: CONFIG_ARM_DMA_MEM_BUFFERABLE and readl/writel weirdness
Message-ID: <20110309080519.GB605@n2100.arm.linux.org.uk>
References: <4D6D9C03.2080906@codeaurora.org> <20110302083904.GA4493@n2100.arm.linux.org.uk> <4D6F481B.8000700@codeaurora.org> <20110303102411.GB13179@n2100.arm.linux.org.uk> <4D7708EC.9020806@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7708EC.9020806@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 08:58:20PM -0800, Saravana Kannan wrote:
> On 03/03/2011 02:24 AM, Russell King - ARM Linux wrote:
>> On Wed, Mar 02, 2011 at 11:49:47PM -0800, Saravana Kannan wrote:
>>>> I think you misunderstand what's going on.  IO accesses are always ordered
>>>> with respect to themselves.  The barriers are there to ensure ordering
>>>> between DMA coherent memory (normal non-cached memory) and IO accesses
>>>> (device).
>>>
>>> Unfortunately this is not correct. The ARM spec doesn't guarantee that
>>> all IO accesses should be ordered with respect to themselves. It only
>>> requires that the ordering should be guaranteed at least within a 1KB
>>> region.
>>>
>>> You can find this info in ARMv7 ARM spec[1] named
>>> "DDI0406B_arm_architecture_reference_manual_errata_markup_8_0.pdf", on
>>> page A3-45. There is a para that goes:
>>>
>>> "Accesses must arrive at any particular memory-mapped peripheral or
>>> block of memory in program order, that is, A1 must arrive before A2.
>>> There are no ordering restrictions about when accesses arrive at
>>> different peripherals or blocks of memory, provided that the accesses
>>> follow the general ordering rules given in this section."
>>
>> That is news to me.  My DDI0406B does not have this paragraph, so it's
>> something that ARM has sprung upon us without telling *anyone* about it.
>> It's not unreasonable or even unexpected.  That is exactly the same
>> condition which applies on buses like PCI due to write posting on bridges
>> downstream of the CPU, and issuing memory barriers will not help with
>> that.
>
> While the PCI stuff is true, as you say, it's not related to mb()s. The  
> mb()s matter to the point of getting the writes to the  intended  
> "devices addresses" in the program order. What happens after that is a  
> separate issue.
>
> So, going back to the discussion of mb()s and readl/writel (and  
> variations), I think we should no longer state the all IO accesses are  
> ordered wrt each other. Are we in agreement on this?

No, because you clearly haven't understood the point I made.

I still believe you are wrong on this point.
