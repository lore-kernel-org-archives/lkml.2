Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0LCPhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:37:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57744 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0LCPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:37:00 -0500
Date: Fri, 3 Dec 2010 15:36:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        David Brownell <david-b@pacbell.net>, per.forlin@linaro.org,
        Ulf Hansson <Ulf.Hansson@stericsson.com>
Subject: Re: dma_unmap_sg - what number of entries is to be passed as
	parameter really?
Message-ID: <20101203153645.GB30898@n2100.arm.linux.org.uk>
References: <AANLkTimL=UX-FpNL7gqPnThmqK-BuZQJStGLrwwq2O0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimL=UX-FpNL7gqPnThmqK-BuZQJStGLrwwq2O0w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 02:40:56PM +0100, Linus Walleij wrote:
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
> 
> Which one is it? (Looks like the first one from Documentation/ to me.)

The only from Documentation/.  Luckily though, it doesn't make any
odds to the implementation on ARM as we don't have IOMMUs involved
in the DMA layer where we could coalesce entries.
