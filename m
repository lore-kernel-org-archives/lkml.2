Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab2EURil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:38:41 -0400
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:41606 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758415Ab2EURib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:38:31 -0400
Message-ID: <1337621908.1621.16.camel@tellur>
Subject: Re: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
From: Lucas Stach <dev@lynxeye.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Hiroshi DOYU <hdoyu@nvidia.com>,
        linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 19:38:28 +0200
In-Reply-To: <20120521173124.GB11824@avionic-0098.mockup.avionic-design.de>
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
	 <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>
	 <20120521141152.GA21513@avionic-0098.mockup.avionic-design.de>
	 <4FBA702A.1010203@wwwdotorg.org> <1337619935.1621.13.camel@tellur>
	 <4FBA77E2.4000409@wwwdotorg.org>
	 <20120521173124.GB11824@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 21.05.2012, 19:31 +0200 schrieb Thierry Reding:
> * Stephen Warren wrote:
> > On 05/21/2012 11:05 AM, Lucas Stach wrote:
> > > Am Montag, den 21.05.2012, 10:41 -0600 schrieb Stephen Warren:
> > >> On 05/21/2012 08:11 AM, Thierry Reding wrote:
> > >>> * Hiroshi DOYU wrote:
> > >>>> GART Register/Aperture range should be reserved.
> > >> ...
> > >>>> diff --git a/drivers/iommu/tegra-gart.c
> > >>>> b/drivers/iommu/tegra-gart.c
> > >> ...
> > >>>> +	if (!devm_request_mem_region(dev, res_remap->start, +
> > >>>> resource_size(res_remap), dev_name(dev))) { +		dev_err(dev,
> > >>>> "failed to reserve GART aperture\n"); +		return -EBUSY; +	} +
> > >>>
> > >>> I'm not so sure that this is a good idea. If the GART driver
> > >>> requests the GART aperture, then users of the GART aperture (e.g.
> > >>> the DRM driver) will no longer be able to use it.
> > >>
> > >> Presumably the DRM driver would be obtaining access to parts of the
> > >> GART aperture through the GART driver, rather than just grabbing the
> > >> IO region and using it for itself?
> > > 
> > > With a TTM-like memory manager the DRM driver will take over the address
> > > space management of the GART aperture. The GART driver is only used to
> > > set up the mappings in the IOMMU. The DRM driver is the one that sets
> > > up/tears down the CPU mappings on demand, so the aperture should be
> > > claimed in the DRM driver.
> > 
> > Even if the DRM driver is managing the aperture, I still think the GART
> > driver should claim it. The physical address of the aperture is a
> > property of the GART, so only the GART's resources (and DT node) should
> > contain a representation of where that aperture is. The DRM driver
> > should call into the GART driver to find out where the aperture is, and
> > hence GART is able to claim it without conflict.
> 
> That could be difficult to do. There isn't any API to allow this. I guess if
> something like that is added it should probably go into the IOMMU framework.

Ah, yes. There already was a plan to add properties for this to the
IOMMU API. So I'm ok with the GART driver claiming the resources. I will
try to push the needed API changes forward in the next few days.

-- Lucas


