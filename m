Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1IAJ56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:57:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43682 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab1IAJ54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <1314826214-22428-2-git-send-email-msalter@redhat.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com> <1314826214-22428-2-git-send-email-msalter@redhat.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Thu, 1 Sep 2011 11:57:36 +0200
Message-ID: <CAHXqBFJ6tEkn+iW3ZBAiWu5Sx9y9MQdnJt5Gfnv5Xc3UB78uLw@mail.gmail.com>
Subject: Re: [PATCH 1/3] add dma_coherent_write_sync to DMA API
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/31 Mark Salter <msalter@redhat.com>:
> On ARMv6/7 DMA-coherent memory is bufferable which means that CPU writes to
> coherent memory may still be held in a write buffer for a significant amount
> of time. This is largely mitigated by having the MMIO write functions force
> a write buffer flush before doing the actual write to the MMIO register. This
> forces out previous CPU writes to coherent memory for drivers which write to
> a register to inform the device that something was written to memory. However,
> this does not mitigate the problem for devices which poll the DMA memory for
> changes written by the CPU. One such case was found by ming.lei@canonical.com
> in the USB EHCI driver. The EHCI host controller relies at least partly on
> polling DMA coherent memory for information from the driver.
>
> This patch adds a dma_coherent_write_sync() function to the DMA API which
> drivers can use to explicitly force out data which may otherwise be held up
> in a write buffer. It is a no-op unless and architecture provides its own
> version or the function and sets ARCH_HAS_DMA_COHERENT_WRITE_SYNC.
[...]
> --- a/Documentation/DMA-API.txt
> +++ b/Documentation/DMA-API.txt
> @@ -418,6 +418,18 @@ void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr,
>        ....
>
>
> +Part Ie - Write buffering to dma-coherent memory
> +------------------------------------------------
> +
> +Some architectures supporting DMA coherent memory may have write
> +buffering between the CPU and DMA memory. This buffering may delay
> +CPU writes from reaching coherent memory in a timely manner.
> +
> +    void
> +    dma_coherent_write_sync()
> +
> +Force any outstanding coherent writes to memory.

This should be merged or referenced in part Ia.

BTW, if there's no time limit on write buffers flushing, or if write
buffers can cause reordering of the writes, then the memory accesses
need to be managed just like non-DMA-coherent memory. So what differs
then in DMA-coherent vs non-DMA-coherent mappings then?

Best Regards,
Michał Mirosław
