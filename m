Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2ITAMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 20:12:34 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:12876
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab2ITAMb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 20:12:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I1432Id6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd2bhf0ah107ah1288h12a5h12a9h12bdh1155h)
Date: Wed, 19 Sep 2012 19:12:16 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [RFC][PATCH 2/3] iommu/fsl: Add iommu domain attributes
 required by fsl PAMU driver.
To: Kumar Gala <galak@kernel.crashing.org>
CC: "<b16395@freescale.com>" <b16395@freescale.com>, <joerg.roedel@amd.com>,
        <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Varun Sethi <Varun.Sethi@freescale.com>
References: <1348060632-12997-1-git-send-email-b16395@freescale.com>
	<1348060632-12997-3-git-send-email-b16395@freescale.com>
	<6B8A3365-C97E-4742-A0DD-D8FD6BA358EB@kernel.crashing.org>
In-Reply-To: <6B8A3365-C97E-4742-A0DD-D8FD6BA358EB@kernel.crashing.org>
	(from galak@kernel.crashing.org on Wed Sep 19 08:52:27 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1348099936.22800.21@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 08:52:27 AM, Kumar Gala wrote:
> 
> On Sep 19, 2012, at 8:17 AM, <b16395@freescale.com>  
> <b16395@freescale.com> wrote:
> 
> > From: Varun Sethi <Varun.Sethi@freescale.com>
> >
> > Added the following domain attributes required by FSL PAMU driver:
> > 1. Subwindows field added to the iommu domain geometry attribute.
> > 2. Added new iommu stash attribute, which allows setting of the
> >   LIODN specific stash id parameter through IOMMU API.
> > 3. Added an attribute for enabling/disabling DMA to a particular
> >   memory window.
> >
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> > include/linux/iommu.h |   30 ++++++++++++++++++++++++++++++
> > 1 files changed, 30 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 7e83370..eaa40c6 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -44,6 +44,28 @@ struct iommu_domain_geometry {
> > 	dma_addr_t aperture_start; /* First address that can be  
> mapped    */
> > 	dma_addr_t aperture_end;   /* Last address that can be  
> mapped     */
> > 	bool force_aperture;       /* DMA only allowed in mappable  
> range? */
> > +
> > +	/* The subwindows field indicates number of DMA subwindows  
> supported
> > +	 * by the geometry. Following is the interpretation of
> > +	 * values for this field:
> > +	 * 0 : This implies that the supported geometry size is 1 MB
> > +         * with each subwindow size being 4KB. Thus number of  
> subwindows
> > +	 * being = 1MB/4KB = 256.
> > +	 * 1 : Only one DMA window i.e. no subwindows.
> > +	 * value other than 0 or 1 would indicate actual number of  
> subwindows.
> > +	 */
> > +	u32 subwindows;
> > +};
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
> 
> seems like this should be enum instead of u32 for cache
> 
> With enum being something like:
> 
> enum iommu_attr_stash_cache {
> 	IOMMU_ATTR_CACHE_L1,
> 	IOMMU_ATTR_CACHE_L2,
> 	IOMMU_ATTR_CACHE_L3,
> };

Don't we want these structs to be usable via some VFIO ioctl?  In that  
case they need to use fixed size types.

-Scott
