Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2FUG56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:57:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48320 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab2FUG55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:57:57 -0400
Message-ID: <4FE2C5F3.1010007@wwwdotorg.org>
Date: Thu, 21 Jun 2012 00:57:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/5] iommu/tegra: smmu: Add DMA window parser, of_get_dma_window()
References: <20120521124707.GC2604@amd.com><1340176620-13012-1-git-send-email-hdoyu@nvidia.com><4FE20457.8090307@wwwdotorg.org> <20120621.094611.2108645748323641310.hdoyu@nvidia.com>
In-Reply-To: <20120621.094611.2108645748323641310.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 12:46 AM, Hiroshi Doyu wrote:
...
> There are the following 3 users of of_parse_dma_window() as below. All
> of them are IOMMU related, but they are architecture specific ones,
> not for the standard IOMMU API. I guess that the current trend is to
> convert Arch specific IOMMU API to the standard one basically.
> 
>   arch/powerpc/kernel/vio.c 	of_parse_dma_window(dev->dev.of_node, dma_window,
>   arch/powerpc/platforms/cell/iommu.c 	of_parse_dma_window(np, dma_window, &index, base, size);
>   arch/powerpc/platforms/pseries/iommu.c 	of_parse_dma_window(dn, dma_window, &tbl->it_index, &offset, &size);
> 
> I think that the common "dma-window" DT parser is necessary for the
> standard IOMMU because "dma-window" info is dealt as
> DOMAIN_ATTR_GEOMETRY in the following Joerg's patch too.
> 
>   [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
>     https://lkml.org/lkml/2012/1/19/170
> 
> If it's ok to have of_get_dma_window() in "drivers/iommu/of_iommu.c",
> I'll post that version.

Sounds sane to me.
