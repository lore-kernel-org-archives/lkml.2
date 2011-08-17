Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1HQUjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab1HQUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch 27/36] Hexagon: Provide DMA implementation
Date: Wed, 17 Aug 2011 22:01:07 +0200
Message-ID: <16233560.LW8Ali0bj4@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163522.381019304@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163522.381019304@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o+K8u3MkExCBXf5doXtuhRVM+V8qbmAt/A2B+lz+EUj
 xBhGAZPBkFpGEURefUwJZSD7kPi0uyYIuTl5Z81QwzHDM6L2zg
 3wTNCXXcN5gaq7SiFWKB0RQ2eu1DATpl6+JOOLVA8X+wovs5SY
 IYyRkmy3Xd8o+hrLydelJtmQE8dYb8PGVkwu6icyqvI7+/mwip
 /uaZcCan588XgqUgHTlQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:24 Richard Kuo wrote:

> +static dma_addr_t hexagon_map_page(struct device *dev, struct page *page,
> +				   unsigned long offset, size_t size,
> +				   enum dma_data_direction dir,
> +				   struct dma_attrs *attrs)
> +{
> +	dma_addr_t bus = page_to_phys(page) + offset;
> +	WARN_ON(size == 0);
> +
> +	if (!check_addr("map_single", dev, bus, size))
> +		return bad_dma_address;
> +
> +	flush_dcache_range(PAGE_OFFSET + bus, PAGE_OFFSET + bus + size);
> +
> +	return bus;
> +}
> +
> +static void hexagon_sync_single_for_cpu(struct device *dev,
> +					dma_addr_t dma_handle, size_t size,
> +					enum dma_data_direction dir)
> +{
> +	mb();
> +}

Why do you need to flush the cache in map_page, but not in sync?
Normally when you have non-coherent DMA, you need to invalidate
the cache in sync_*_foc_cpu and flush it sync_*_for_device.

	Arnd
