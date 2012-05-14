Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab2ENXeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:34:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54984 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab2ENXeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:34:18 -0400
Message-ID: <4FB19677.4040702@wwwdotorg.org>
Date: Mon, 14 May 2012 17:34:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, iommu@lists.linux-foundation.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Simplify allocation at once
References: <1337022975-23999-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1337022975-23999-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 01:16 PM, Hiroshi DOYU wrote:
> To simplify the code, alloc necessary data at once.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
> This patch requires:
> 
>     [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
>         http://marc.info/?l=linux-tegra&m=133663641107327&w=2
> 
> Also the above patch requires:
> 
>     [PATCH 1/1] dt: Add general DMA window parser
>         http://marc.info/?l=linux-tegra&m=133671302703840&w=2

I know I've been harping on about dependencies, but you typically only
need to mention them if the dependencies are not already checked into
the branch you expect this patch to be checked into.

> -	smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
> +	if (of_property_read_u32(dev->of_node, "nvidia,#asids", &asids))
> +		return -ENODEV;

I believe you need to change the asids variable from int to u32 to avoid
a warning here.

Aside from that, the series,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
