Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2DWS1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:27:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41753 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2DWS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:27:31 -0400
Message-ID: <4F959F10.9010908@wwwdotorg.org>
Date: Mon, 23 Apr 2012 12:27:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] iommu/tegra: smmu: Add device tree support for SMMU
References: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com> <1335182340-17237-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1335182340-17237-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:58 AM, Hiroshi DOYU wrote:
> Add device tree support for Tegra30 IOMMU(SMMU).

> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c

> +	err = of_parse_dma_window(dev->of_node, "dma-window", 0, NULL,
> +				  &base, &size);

This patch also depends on "dt: Add general DMA window parser" that you
sent earlier.

> +	asids = be32_to_cpup(of_get_property(dev->of_node, "asids", NULL));
> +	if (!asids)
> +		return -ENODEV;

What if of_get_property() fails?

BTW, does the # ASIDs vary? I wonder if it's worth representing it in
the device tree or not. If this driver has a chance of working
unmodified on some future chip just by updating this DT property without
any code changes, then it seems reasonable to have it in DT.
