Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2EUQlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:41:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43231 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2EUQlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:41:18 -0400
Message-ID: <4FBA702A.1010203@wwwdotorg.org>
Date: Mon, 21 May 2012 10:41:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com> <1337019127-6863-2-git-send-email-hdoyu@nvidia.com> <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 08:11 AM, Thierry Reding wrote:
> * Hiroshi DOYU wrote:
>> GART Register/Aperture range should be reserved.
...
>> diff --git a/drivers/iommu/tegra-gart.c
>> b/drivers/iommu/tegra-gart.c
...
>> +	if (!devm_request_mem_region(dev, res_remap->start, +
>> resource_size(res_remap), dev_name(dev))) { +		dev_err(dev,
>> "failed to reserve GART aperture\n"); +		return -EBUSY; +	} +
> 
> I'm not so sure that this is a good idea. If the GART driver
> requests the GART aperture, then users of the GART aperture (e.g.
> the DRM driver) will no longer be able to use it.

Presumably the DRM driver would be obtaining access to parts of the
GART aperture through the GART driver, rather than just grabbing the
IO region and using it for itself?
