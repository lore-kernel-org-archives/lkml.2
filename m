Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0IJImj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:42:39 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.42]:52310 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab0IJImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:42:37 -0400
Message-ID: <4C89EE46.8030701@ladisch.de>
Date: Fri, 10 Sep 2010 10:37:26 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: steve@fl-eng.com
CC: linux-kernel@vger.kernel.org
Subject: Re: ### DMA_ALLOC_COHERENT question
References: <234ad71a39aa28e71c3fccd1f16fd1f3.squirrel@webmail.fl-eng.com>
In-Reply-To: <234ad71a39aa28e71c3fccd1f16fd1f3.squirrel@webmail.fl-eng.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

steve spano wrote:
> I have a 2.6.30.2 kernel running with a custom device driver for a
> multi-channel sound card via PCI-Express. Interrupts,DMA, everything is
> working fine.
> 
> We allocate a very small 64KB buffer for our DMA actions using
> dma_alloc_coherent.

Assuming that the sound driver is using the ALSA framework, why don't
you use snd_pcm_lib_malloc_pages like most of the other PCI sound
drivers?

> At 256MB of ram, dma_alloc_coherent gets us an address within the first
> 128MB of ram, near the upper 1/2 of the 256MB actually.
> 
> Then at 1GB, we get an address near the upper 1/2 again (512MB)
> Then at 2GB, we get an address near the upper 1/2 again (1GB)
> 
> This causes a problem on the sound card board because we need to then map
> in nearly all 2GB of address space across the PCI bar registers so we can
> access our tiny 64KB dma address range sitting up near the 1GB boundary.

What have the PCI BARs to do with this?  If your PCIe device wants to do
DMA from/to the computer's main memory, no BARs are involved.

BARs are used to map memory located in the device into the CPU's address
space.

> Ideally, we would get a non-cached block of ram that we can DMA to and the
> processor can access.

"Coherent" means that the CPU cache works correctly in the presence
of DMA.

> This block would ideally always be located near the base of ram (maybe
> right after the kernel?). That way we can open a 128MB window into the
> system ram from PCI-Express and always be sure to be able to access
> our DMA buffer.

What do you mean with "open a window"?  PCIe devices always can access
the entire adress space.

> Should we just put an "unsigned char []" of 64k in the driver?

The memory that modules are loaded into is not DMAable on many
architectures.

> Im sure there is something simple we can do.

Show the source code.  :)


Regards,
Clemens
