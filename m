Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0EaC60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 22:58:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:49663 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab0EaC6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 22:58:24 -0400
Date: Mon, 31 May 2010 11:58:12 +0900
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 3/8] arch/tile: header files for the Tile architecture.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
	<201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100531113524E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 31 May 2010 11:58:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 23:10:07 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> This includes the relevant Linux headers in asm/; the low-level
> low-level "Tile architecture" headers in arch/, which are
> shared with the hypervisor, etc., and are build-system agnostic;
> and the relevant hypervisor headers in hv/.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

(snip)

> +++ b/arch/tile/include/asm/dma-mapping.h
> @@ -0,0 +1,106 @@
> +/*
> + * Copyright 2010 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _ASM_TILE_DMA_MAPPING_H
> +#define _ASM_TILE_DMA_MAPPING_H
> +
> +/*
> + * IOMMU interface. See Documentation/PCI/PCI-DMA-mapping.txt and
> + * Documentation/DMA-API.txt for documentation.
> + */

Documentation/PCI/PCI-DMA-mapping.txt was renamed to
Documentation/DMA-API-HOWTO. Anyway, I recommend removing the useless
comment.


> +#include <linux/mm.h>
> +#include <linux/scatterlist.h>
> +#include <linux/cache.h>
> +#include <linux/io.h>
> +
> +/*
> + * Note that on x86 and powerpc, there is a "struct dma_mapping_ops"
> + * that is used for all the DMA operations.  For now, we don't have an
> + * equivalent on tile, because we only have a single way of doing DMA.
> + */

I think that using "struct dma_mapping_ops" is a good idea even if you
support the single dma ops. You can avoid lots of duplicated code.


(snip)

> --- /dev/null
> --- /dev/null
> +++ b/arch/tile/include/asm/scatterlist.h
> @@ -0,0 +1 @@
> +#include <asm-generic/scatterlist.h>

Did you compile this patchset with 2.6.35-rc1? I think that you need
to define ISA_DMA_THRESHOLD here.
