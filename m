Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1LHR5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:57:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1LHR47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:56:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
 <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
From: Albert Strasheim <fullung@gmail.com>
Date: Thu, 8 Dec 2011 19:56:37 +0200
Message-ID: <CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
To: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Thu, Dec 8, 2011 at 7:47 PM, Roland Dreier <roland@purestorage.com> wrote:
>  > [  597.412843] kernel BUG at drivers/iommu/intel-iommu.c:1767!
> So this is
>        BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pages - 1)
>>> addr_width);
>
> in __domain_mapping() I believe.  And we have:
>        int addr_width = agaw_to_width(domain->agaw) - VTD_PAGE_SHIFT;
> How much RAM does you system have?

192 GB.

A few gigabyte is reserved for 2 MB huge pages, if that matters.

> I don't know too much about the low-level VT-d details, but is it
> possible the setup code
> is choosing a too small "guest address width" to cover all your memory?
>
> drivers/net/ethernet/mellanox/mlx4/main.c has
>
>        err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
>        if (err) {
>                dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI
> DMA mask.\n");
>                err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>                if (err) {
>                        dev_err(&pdev->dev, "Can't set PCI DMA mask,
> aborting.\n");
>                        goto err_release_regions;
>                }
>        }
>        err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
>        if (err) {
>                dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
>                         "consistent PCI DMA mask.\n");
>                err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
>                if (err) {
>                        dev_err(&pdev->dev, "Can't set consistent PCI
> DMA mask, "
>                                "aborting.\n");
>                        goto err_release_regions;
>                }
>        }
>
> do you see any warnings in your kernel log about setting the PCI DMA mask?
> (in any case that should only affect bus addresses, not "guest addresses")

I don't see anything like what you mentioned here.

>From the SAS controller:

mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (198141716 kB)

Not seeing anything about PCI DMA errors.

I think the BIOS has VT-d enabled. dmesg says:

PCI-DMA: Intel(R) Virtualization Technology for Directed I/O

I can send you a full dmesg if that would help.

Regards

Albert
