Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967423Ab2ERU4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:56:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4072 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab2ERU4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:56:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 18 May 2012 13:56:33 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "arnd@arndb.de" <arnd@arndb.de>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Fri, 18 May 2012 22:56:19 +0200
Subject: Re: [PATCH 1/1] iommu/tegra: smmu: Add DMA window parser
Thread-Topic: [PATCH 1/1] iommu/tegra: smmu: Add DMA window parser
Thread-Index: Ac01OLL5HIx3jSw4T/C1SqmGsj/S+w==
Message-ID: <20120518.235619.175499431618565933.hdoyu@nvidia.com>
References: <20120518085051.4a0fca863c5ab37cf8d42cb1@nvidia.com><1337323393-1035-1-git-send-email-hdoyu@nvidia.com><4FB66796.1030007@wwwdotorg.org>
In-Reply-To: <4FB66796.1030007@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, Joerg,

Stephen Warren <swarren@wwwdotorg.org> wrote @ Fri, 18 May 2012 17:15:34 +0200:

> On 05/18/2012 12:43 AM, Hiroshi DOYU wrote:
> > This code was based on:
> >     "arch/microblaze/kernel/prom_parse.c"
> >     "arch/powerpc/kernel/prom_parse.c"
> > 
> > Can be promoted as a global function for general use.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Hiroshi,
> 
> Once this is accepted, it might be worth following up on the original
> of_get_dma_window thread and noting that once it's approved, an updated
> version of the patch will be needed to remove this code at the same time.
> 
> A couple comments below though:
> 
> > +static int of_get_dma_window(struct device_node *dn,
> > +			const char *propname, int index,
> > +			unsigned long *busno,
> > +			dma_addr_t *addr, size_t *size)
> > +{
> > +	const __be32 *dma_window, *end;
> > +	int bytes, cur_index = 0;
> 
> Since bytes is an out parameter from of_get_property, do you need to
> wrap the declaration in uninitialized_var() to prevent a compile warning
> like the other patch you sent me downstream?
> 
> > +	if (!dn || !addr || !size)
> > +		return -EINVAL;
> > +
> > +	if (!propname)
> > +		propname = "dma-window";
> > +
> > +	dma_window = of_get_property(dn, propname, &bytes);
> > +	if (!dma_window)
> > +		return -ENODEV;
> > +	end = dma_window + bytes / sizeof(*dma_window);
> > +
> > +	while (dma_window < end) {
> > +		u32 cells;
> > +		const void *prop;
> > +
> > +		/* busno is always one cell */
> > +		if (busno)
> > +			*busno = be32_to_cpup(dma_window++);
> 
> Shouldn't the ++ happen even if (!busno)?

Hm...the above code happens to work with our "dma-window" format right
now, but most likely this seems incmpatible with "ibm,dma-window"
format. I couldn't find the official format previously. I'm wondering
that those "(ibm,)dma-window" and "(ibm,)dma-range" may be able to be
generally used since those parameters are quite common to any
IOMMUs. I'll hold off those patches at least this time

Joerg, as Stephen proposed originally. Could you please revert or drop
the original one this time?

  [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU

PS: I'm being off-line'd mostly next four weeks, and my response would
be delayed.
