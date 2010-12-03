Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab0LCNk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:40:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44581 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab0LCNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:40:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Tgby+jE9aQd0EtFtzAunamUTbpe/zeDxWt94j3Kme4V+y55+r/zXPuRc7ufbHiWRrl
         VB94SoUzeA9pyFeduZCTwR+rMu+mcSXTZV/djrXHlJWPHa8aGctncInzZZjYhD2m0wa2
         oKnyrpKDYwy8037D2PROEclF38EjNEFuleNJc=
MIME-Version: 1.0
Date: Fri, 3 Dec 2010 14:40:56 +0100
Message-ID: <AANLkTimL=UX-FpNL7gqPnThmqK-BuZQJStGLrwwq2O0w@mail.gmail.com>
Subject: dma_unmap_sg - what number of entries is to be passed as parameter really?
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux kernel <linux-kernel@vger.kernel.org>,
        David Brownell <david-b@pacbell.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: per.forlin@linaro.org, Ulf Hansson <Ulf.Hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have a contradiction between two pieces of documentation,
in Documentation/DMA-API.txt


        void
        dma_unmap_sg(struct device *dev, struct scatterlist *sg,
                int nhwentries, enum dma_data_direction direction)

  Unmap the previously mapped scatter/gather list.  All the parameters
  must be the same as those and passed in to the scatter/gather mapping
  API.

  Note: <nents> must be the number you passed in, *not* the number of
  physical entries returned.


Note the last paragraph! But in arch/arm/mm/dma-mapping.c;


/**
 * dma_unmap_sg - unmap a set of SG buffers mapped by dma_map_sg
 * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
 * @sg: list of buffers
 * @nents: number of buffers to unmap (returned from dma_map_sg)
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 * @dir: DMA transfer direction (same as was passed to dma_map_sg)
 *
 * Unmap a set of streaming mode DMA translations.  Again, CPU access
 * rules concerning calls here are the same as for dma_unmap_single().
 */

So the documentation in Documentation/ says one thing, whereas
the ARM implementation documentation says something else.

Which one is it? (Looks like the first one from Documentation/ to me.)

I will happily patch the culprit...

Yours,
Linus Walleij
