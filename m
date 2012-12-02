Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2LBIMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 03:12:37 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13258 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab2LBIMg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 03:12:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz9371I542I1432Id799hdf9Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Tabi Timur-B04825 <B04825@freescale.com>
Subject: RE: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Topic: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Index: AQHNxydj7Z6tWPtNqUibA9WyqhhElJf7ncgQgAmdYGA=
Date: Sun, 2 Dec 2012 08:12:31 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D2B0419@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
 <1353419697-31269-4-git-send-email-Varun.Sethi@freescale.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!!

> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Monday, November 26, 2012 10:55 AM
> To: joerg.roedel@amd.com
> Cc: Sethi Varun-B16395; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood Scott-B07421;
> Tabi Timur-B04825
> Subject: RE: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> required by fsl PAMU driver.
> 
> Hi Joerg,
> Any comments? Can we apply this patch?
> 
> Regards
> Varun
> 
> > -----Original Message-----
> > From: Sethi Varun-B16395
> > Sent: Tuesday, November 20, 2012 7:25 PM
> > To: joerg.roedel@amd.com; iommu@lists.linux-foundation.org; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood Scott-B07421;
> > Tabi Timur-B04825
> > Cc: Sethi Varun-B16395
> > Subject: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> > required by fsl PAMU driver.
> >
> > Added the following domain attributes required by FSL PAMU driver:
> > 1. Subwindows field added to the iommu domain geometry attribute.
> > 2. Added new iommu stash attribute, which allows setting of the
> >    LIODN specific stash id parameter through IOMMU API.
> > 3. Added an attribute for enabling/disabling DMA to a particular
> >    memory window.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> > changes in v5:
> > - Updated description of the subwindows field.
> > changes in v4:
> > - Updated comment explaining subwindows(as mentioned by Scott).
> > change in v3:
> > -renamed the stash attribute targets
> >  include/linux/iommu.h |   43
> +++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 43 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> > f3b99e1..7ca1cda 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -44,6 +44,41 @@ struct iommu_domain_geometry {
> >  	dma_addr_t aperture_start; /* First address that can be mapped */
> >  	dma_addr_t aperture_end;   /* Last address that can be mapped
> > */
> >  	bool force_aperture;       /* DMA only allowed in mappable range?
> > */
> > +
> > +	/*
> > +	 * A geometry mapping can be created in one of the following ways
> > +	 * for an IOMMU:
> > +	 * 1. A single contiguous window
> > +	 * 2. Through arbritary paging throughout the aperture.
> > +	 * 3. Using multiple subwindows
> > +	 *
> > +	 * In absence of arbritary paging, subwindows allow for supporting
> > +	 * physically discontiguous mappings.
> > +	 *
> > +	 * This attribute indicates number of DMA subwindows supported by
> > +	 * the geometry. If there is a single window that maps the entire
> > +	 * geometry, attribute must be set to "1". A value of "0" implies
> > +	 * that this mechanism is not used at all(normal paging is used).
> > +	 * Value other than* "0" or "1" indicates the actual number of
> > +	 * subwindows.
> > +	 */
> > +	u32 subwindows;
> > +};
> > +
> > +/* cache stash targets */
> > +#define IOMMU_ATTR_CACHE_L1 1
> > +#define IOMMU_ATTR_CACHE_L2 2
> > +#define IOMMU_ATTR_CACHE_L3 3
> > +
> > +/* This attribute corresponds to IOMMUs capable of generating
> > + * a stash transaction. A stash transaction is typically a
> > + * hardware initiated prefetch of data from memory to cache.
> > + * This attribute allows configuring stashig specific parameters
> > + * in the IOMMU hardware.
> > + */
> > +struct iommu_stash_attribute {
> > +	u32 	cpu;	/* cpu number */
> > +	u32 	cache;	/* cache to stash to: L1,L2,L3 */
> >  };
> >
> >  struct iommu_domain {
> > @@ -60,6 +95,14 @@ struct iommu_domain {  enum iommu_attr {
> >  	DOMAIN_ATTR_MAX,
> >  	DOMAIN_ATTR_GEOMETRY,
> > +	/* Set the IOMMU hardware stashing
> > +	 * parameters.
> > +	 */
> > +	DOMAIN_ATTR_STASH,
> > +	/* Explicity enable/disable DMA for a
> > +         * particular memory window.
> > +         */
> > +	DOMAIN_ATTR_ENABLE,
> >  };
> >
> >  #ifdef CONFIG_IOMMU_API
> > --
> > 1.7.4.1


