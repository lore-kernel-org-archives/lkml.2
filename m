Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2HOQQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:16:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2HOQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:16:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 14/31] arm64: DMA mapping API
Date: Wed, 15 Aug 2012 16:16:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-15-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-15-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151616.01114.arnd@arndb.de>
X-Provags-ID: V02:K0:bVI/DnhKstTPzFCBjZaNsFPcp4aPpYk1b7wKbrS2uuE
 HfUrNHpiSkRl2NJ9lCSd2l2f9veojnnr8C9ZtWQ1JpD/2tlFuz
 rBCxv0+oqHpfnHWKVwp3KPx2Wvba3a1B/sSdLPVPRRfvNDtLGs
 2LAMT6FRKGbWjisI7K8X6dHlwQQA5qFJGYMvqYbJBRmlMmY6Ki
 GPaYo7TK2JY5BAMJ1TFV7AAAjxQxGSDQac3fkzMd6VtyCl0m5k
 /+sOF7OFDz1PtoBz52p9Su0whhtnsqD3a7nAF+Wwj5pF1vKVXO
 H85s2Mo92gwTDCtfZKyl+ytM/i8BK7S9+ijcKriL4pIUYeaWLU
 iyLSKoW1qkHfVCH7oHiw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> +static struct dma_map_ops arm64_swiotlb_dma_ops = {
> +       .alloc = arm64_swiotlb_alloc_coherent,
> +       .free = arm64_swiotlb_free_coherent,
> +       .map_page = arm64_swiotlb_map_page,
> +       .unmap_page = arm64_swiotlb_unmap_page,
> +       .map_sg = arm64_swiotlb_map_sg_attrs,
> +       .unmap_sg = arm64_swiotlb_unmap_sg_attrs,
> +       .sync_single_for_cpu = arm64_swiotlb_sync_single_for_cpu,
> +       .sync_single_for_device = arm64_swiotlb_sync_single_for_device,
> +       .sync_sg_for_cpu = arm64_swiotlb_sync_sg_for_cpu,
> +       .sync_sg_for_device = arm64_swiotlb_sync_sg_for_device,
> +       .dma_supported = swiotlb_dma_supported,
> +       .mapping_error = swiotlb_dma_mapping_error,
> +};
> +
> +void __init swiotlb_init_with_default_size(size_t default_size, int verbose);
> +
> +void __init arm64_swiotlb_init(size_t max_size)
> +{
> +       dma_ops = &arm64_swiotlb_dma_ops;
> +       swiotlb_init_with_default_size(min((size_t)SZ_64M, max_size), 1);
> +}

Why is swiotlb the default? I would expect that most devices can in fact
use the entire 64 bit address space, so you can use a simple linear
implementation for those.

	Arnd
