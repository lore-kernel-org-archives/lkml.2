Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab1KRW1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:27:41 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:45422 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab1KRW1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:27:40 -0500
Date: Fri, 18 Nov 2011 23:27:18 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: hjk@hansjkoch.de, gregkh@suse.de, tglx@linutronix.de,
        linux-pci@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111118222718.GF22904@local>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 04:16:23PM -0500, Jean-Francois Dagenais wrote:
> Hello fellow hackers.

Hi. Could you please limit the line length of your mails to something less
than 80 chars?

> 
> I am maintaining a UIO based driver for a PCI-E data acquisition device.

Can you post it? No point in discussing non-existent code...

> 
> I map BAR0 of the device to userspace. I also map two memory areas, one is used to feed instructions to the acquisition device, the other is used autonomously by the PCI device to write the acquired data.
> 
> The strategy we have been using for those two share memory areas has historically been using pci_alloc_coherent on v2.6.35 x86_64 (limited to 4MB based on my trials) and later, I made use of the VT-d (intel_iommu) to allocate as much as 128MB (an arbitrary limit) which appear contiguous to the PCI device. I use vmalloc_user to allocate 128M, then write all the physically continuous segments in a scatterlist, then use pci_map_sg which works it's way to intel_iommu. The device DMA addresses I get back are contiguous over the whole 128M. Neat! Our VT-d capable devices still use this strategy.
> 
> This large memory is mission-critical in making the acquisition device autonomous (real-time), yet keep the DMA implementation very simple. Today, we are re-using this device on a CPU architecture that has no IOMMU (intel E6XX/EG20T) and want to avoid creating a scatter-gather scheme between my driver and the FPGA (PCI device).
> 
> So I went back to the old pci_alloc_coherent method, which although limited to 4 MB, will do for early development phases. Instead of 2.6.35, we are doing preliminary development using 2.6.37 and will probably use 3.1 or more later.  The cpu/device shared memory maps (1MB and 4MB) are allocated using pci_alloc_coherent and handed to UIO as physical memory using the dma_addr_t returned by the pci_alloc func.
> 
> The 1st memory map is written to by CPU and read from device.
> The 2nd memory map is typically written by the device and read by the CPU, but future features may have the device also read this memory.
> 
> My initial testing on the atom E6XX show the PCI device failing when trying to read from the first memory map.

Any kernel messages in the logs that could help?

[...]

Thanks,
Hans
