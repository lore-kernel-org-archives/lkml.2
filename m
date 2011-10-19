Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab1JSKYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 06:24:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56721 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1JSKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 06:24:15 -0400
MIME-Version: 1.0
In-Reply-To: <201110191045.42613@zigzag.lvk.cs.msu.su>
References: <201110191045.42613@zigzag.lvk.cs.msu.su>
Date: Wed, 19 Oct 2011 15:54:14 +0530
Message-ID: <CAM=x7SYGE50C7BHuEcSGpkC+aSPB143wYODktzEj4QsKcsRvMg@mail.gmail.com>
Subject: Re: high-order allocation + highmem + streaming DMA - possible?
From: RKK <kulkarni.ravi4@gmail.com>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: linux-kernel@vger.kernel.org, stefan@lvk.cs.msu.su
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikita

On Wed, Oct 19, 2011 at 12:15 PM, Nikita V. Youshchenko <yoush@cs.msu.su> wrote:
> Hello.
>
> We are writing a driver for a custom PCI device that receives large amount
> of data.
>
> Device is capable of DMAing received data in 64k chunks.
>
> We have been going to:
> - use physically-continuous 64k-sized memory areas using alloc_pages() with
> order=4,
> - allocate large number of such areas on driver init,
> - implement mmap() to map those all to userspace for zero-copy processing,
> - use streaming DMA to actually receive data
  May i know why u want to mmap to userspace instead of using a
device? performance is affected by a large amount if u use mmap
> However I can't find a way to use streaming DMA for large highmem areas.
> - pci_map_single() is for linear mapping and can't work with highmem
> - pci_map_page() can work with highmem but is limited to one page
> - pci_map_sg() is for s/g lists, not for single 64k blocks.
>
> Is there a way to use streaming DMA with large memory areas located in
> highmem?
I dont think DMA is available for highmem? Not sure though . never saw
a usecase for it.
> Or in this situation buffers in highmem can't be used?
>



-- 
Warm Regards,
Ravi .
