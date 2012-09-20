Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2ITJqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:46:42 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:11671
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab2ITJqk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:46:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zzbb2dI98dI9371I542M1432Id6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdhbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH 2/3] iommu/fsl: Add iommu domain attributes
 required by fsl PAMU driver.
Thread-Topic: [RFC][PATCH 2/3] iommu/fsl: Add iommu domain attributes
 required by fsl PAMU driver.
Thread-Index: AQHNlsSXSEm5m82fs0K9SUb/eg6jl5eS+OGg
Date: Thu, 20 Sep 2012 09:46:32 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D1A49A2@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1348060632-12997-1-git-send-email-b16395@freescale.com>
	<1348060632-12997-3-git-send-email-b16395@freescale.com>
	<6B8A3365-C97E-4742-A0DD-D8FD6BA358EB@kernel.crashing.org>
 <1348099936.22800.21@snotra>
In-Reply-To: <1348099936.22800.21@snotra>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.81]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Thursday, September 20, 2012 5:42 AM
> To: Kumar Gala
> Cc: Sethi Varun-B16395; joerg.roedel@amd.com; iommu@lists.linux-
> foundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Sethi Varun-B16395
> Subject: Re: [RFC][PATCH 2/3] iommu/fsl: Add iommu domain attributes
> required by fsl PAMU driver.
> 
> On 09/19/2012 08:52:27 AM, Kumar Gala wrote:
> >
> > On Sep 19, 2012, at 8:17 AM, <b16395@freescale.com>
> > <b16395@freescale.com> wrote:
> >
> > > From: Varun Sethi <Varun.Sethi@freescale.com>
> > >
> > > Added the following domain attributes required by FSL PAMU driver:
> > > 1. Subwindows field added to the iommu domain geometry attribute.
> > > 2. Added new iommu stash attribute, which allows setting of the
> > >   LIODN specific stash id parameter through IOMMU API.
> > > 3. Added an attribute for enabling/disabling DMA to a particular
> > >   memory window.
> > >
> > > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > > ---
> > > include/linux/iommu.h |   30 ++++++++++++++++++++++++++++++
> > > 1 files changed, 30 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> > > 7e83370..eaa40c6 100644
> > > --- a/include/linux/iommu.h
> > > +++ b/include/linux/iommu.h
> > > @@ -44,6 +44,28 @@ struct iommu_domain_geometry {
> > > 	dma_addr_t aperture_start; /* First address that can be
> > mapped    */
> > > 	dma_addr_t aperture_end;   /* Last address that can be
> > mapped     */
> > > 	bool force_aperture;       /* DMA only allowed in mappable
> > range? */
> > > +
> > > +	/* The subwindows field indicates number of DMA subwindows
> > supported
> > > +	 * by the geometry. Following is the interpretation of
> > > +	 * values for this field:
> > > +	 * 0 : This implies that the supported geometry size is 1 MB
> > > +         * with each subwindow size being 4KB. Thus number of
> > subwindows
> > > +	 * being = 1MB/4KB = 256.
> > > +	 * 1 : Only one DMA window i.e. no subwindows.
> > > +	 * value other than 0 or 1 would indicate actual number of
> > subwindows.
> > > +	 */
> > > +	u32 subwindows;
> > > +};
> > > +
> > > +/* This attribute corresponds to IOMMUs capable of generating
> > > + * a stash transaction. A stash transaction is typically a
> > > + * hardware initiated prefetch of data from memory to cache.
> > > + * This attribute allows configuring stashig specific parameters
> > > + * in the IOMMU hardware.
> > > + */
> > > +struct iommu_stash_attribute {
> > > +	u32 	cpu;	/* cpu number */
> > > +	u32 	cache;	/* cache to stash to: L1,L2,L3 */
> >
> > seems like this should be enum instead of u32 for cache
> >
> > With enum being something like:
> >
> > enum iommu_attr_stash_cache {
> > 	IOMMU_ATTR_CACHE_L1,
> > 	IOMMU_ATTR_CACHE_L2,
> > 	IOMMU_ATTR_CACHE_L3,
> > };
> 
> Don't we want these structs to be usable via some VFIO ioctl?  In that
> case they need to use fixed size types.
> 
Yes, this would be usable via vfio ioctl. But, then the caller should be
aware of supported stash targets. May be I should add an interface for the caller,
to query supported stash targets.

-Varun

