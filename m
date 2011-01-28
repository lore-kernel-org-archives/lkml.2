Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1A1Jjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 04:39:46 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:40986 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1A1Jjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 04:39:44 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 04:39:44 EST
Message-ID: <4D428D4B.1000307@ladisch.de>
Date: Fri, 28 Jan 2011 10:32:59 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: MJ embd <mj.embd@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: equivalent of phys_to_virt in an iommu system
References: <AANLkTi=+Hx+3Jk0yprAffhvQM+WcO+WytaLBU-vwbetc@mail.gmail.com>
In-Reply-To: <AANLkTi=+Hx+3Jk0yprAffhvQM+WcO+WytaLBU-vwbetc@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MJ embd wrote:
> Assuming at core mmu there is a mapping, V1 -> P1

Note: It's possible that there are pages for which there is no
mapping, e.g., highmem pages; and it's possible for a page to
have multiple mappings.

> And at the IOMMU for the device to access a region of DDR there is a
> mapping P2 -> P1. [P2 is the address on which device issues a r/w]

P2 is an address on a different bus, in a different address space,
so it might be a better idea to call it D1.

> Now the device driver does the following.
> 
> Line 0: V1 = kmalloc();
> Line 1: P2 = dma_map_single(V1)
> 
> Now if later in the driver, there is a requirement to get V1 from P2
> what is the primitive in linux  ?

	V1;

That is, save the address in a variable.  :-)

The DMA mapping functions typically do not save the original virtual
address, and there is no API for the reverse mapping.

If you device gives you some status message with nothing but P2, you
have to use some other mechanism to find the original virtual address.
This depends on how you device's DMA is organized; often, it is
possible to store the pointer near the DMA descriptor, or the device
has a offset relative to the known start of the buffer.

> Also is my understanding of Line 1(above) correct ?

Yes; P2 is the address that the device must use on _its_ bus.


Regards,
Clemens
