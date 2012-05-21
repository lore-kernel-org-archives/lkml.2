Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2EURPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:15:46 -0400
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:44501 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751647Ab2EURPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:15:45 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2012 13:15:45 EDT
Message-ID: <1337619935.1621.13.camel@tellur>
Subject: Re: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
From: Lucas Stach <dev@lynxeye.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 19:05:35 +0200
In-Reply-To: <4FBA702A.1010203@wwwdotorg.org>
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
	 <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>
	 <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>
	 <4FBA702A.1010203@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 21.05.2012, 10:41 -0600 schrieb Stephen Warren:
> On 05/21/2012 08:11 AM, Thierry Reding wrote:
> > * Hiroshi DOYU wrote:
> >> GART Register/Aperture range should be reserved.
> ...
> >> diff --git a/drivers/iommu/tegra-gart.c
> >> b/drivers/iommu/tegra-gart.c
> ...
> >> +	if (!devm_request_mem_region(dev, res_remap->start, +
> >> resource_size(res_remap), dev_name(dev))) { +		dev_err(dev,
> >> "failed to reserve GART aperture\n"); +		return -EBUSY; +	} +
> > 
> > I'm not so sure that this is a good idea. If the GART driver
> > requests the GART aperture, then users of the GART aperture (e.g.
> > the DRM driver) will no longer be able to use it.
> 
> Presumably the DRM driver would be obtaining access to parts of the
> GART aperture through the GART driver, rather than just grabbing the
> IO region and using it for itself?

With a TTM-like memory manager the DRM driver will take over the address
space management of the GART aperture. The GART driver is only used to
set up the mappings in the IOMMU. The DRM driver is the one that sets
up/tears down the CPU mappings on demand, so the aperture should be
claimed in the DRM driver.

-- Lucas


