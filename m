Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0LEXTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:19:42 -0500
Received: from sh.osrg.net ([192.16.179.4]:60549 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab0LEXTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:19:41 -0500
Date: Mon, 6 Dec 2010 08:19:10 +0900
To: linus.ml.walleij@gmail.com
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net, linux@arm.linux.org.uk,
        per.forlin@linaro.org, Ulf.Hansson@stericsson.com
Subject: Re: dma_unmap_sg - what number of entries is to be passed as
 parameter really?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTimL=UX-FpNL7gqPnThmqK-BuZQJStGLrwwq2O0w@mail.gmail.com>
References: <AANLkTimL=UX-FpNL7gqPnThmqK-BuZQJStGLrwwq2O0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101206081830B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 06 Dec 2010 08:19:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010 14:40:56 +0100
Linus Walleij <linus.ml.walleij@gmail.com> wrote:

> Now we have a contradiction between two pieces of documentation,
> in Documentation/DMA-API.txt
> 
> 
>         void
>         dma_unmap_sg(struct device *dev, struct scatterlist *sg,
>                 int nhwentries, enum dma_data_direction direction)
> 
>   Unmap the previously mapped scatter/gather list.  All the parameters
>   must be the same as those and passed in to the scatter/gather mapping
>   API.
> 
>   Note: <nents> must be the number you passed in, *not* the number of
>   physical entries returned.
> 
> 
> Note the last paragraph! But in arch/arm/mm/dma-mapping.c;
> 
> 
> /**
>  * dma_unmap_sg - unmap a set of SG buffers mapped by dma_map_sg
>  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
>  * @sg: list of buffers
>  * @nents: number of buffers to unmap (returned from dma_map_sg)
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  * @dir: DMA transfer direction (same as was passed to dma_map_sg)
>  *
>  * Unmap a set of streaming mode DMA translations.  Again, CPU access
>  * rules concerning calls here are the same as for dma_unmap_single().
>  */
> 
> So the documentation in Documentation/ says one thing, whereas
> the ARM implementation documentation says something else.

Can you remove DMA-API comments in arch? They simply lead to
confusion.

DMA-API.txt and DMA-API-HOWTO.txt in Documentation should be always
used.
