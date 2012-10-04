Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945916Ab2JDQW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:22:28 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:44213
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486Ab2JDQW1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:22:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zz98dI9371I542M1432Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3 v2] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Topic: [PATCH 2/3 v2] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
Thread-Index: AQHNoifSRrIW5xfdwE+nNPAWlTdjFpepdLEA///fgIA=
Date: Thu, 4 Oct 2012 16:22:18 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D1EFC03@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1349351808-7156-1-git-send-email-b16395@freescale.com>
 <1349351808-7156-3-git-send-email-b16395@freescale.com>
 <43F13A8A-BF97-427C-8736-8F2E55B7A3D1@kernel.crashing.org>
In-Reply-To: <43F13A8A-BF97-427C-8736-8F2E55B7A3D1@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.222.225]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Thursday, October 04, 2012 6:47 PM
> To: Sethi Varun-B16395
> Cc: joerg.roedel@amd.com; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Sethi Varun-B16395
> Subject: Re: [PATCH 2/3 v2] iommu/fsl: Add iommu domain attributes
> required by fsl PAMU driver.
> 
> 
> On Oct 4, 2012, at 6:56 AM, <b16395@freescale.com> <b16395@freescale.com>
> wrote:
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
> > include/linux/iommu.h |   35 +++++++++++++++++++++++++++++++++++
> > 1 files changed, 35 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> > f3b99e1..62e22f0 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -44,6 +44,33 @@ struct iommu_domain_geometry {
> > 	dma_addr_t aperture_start; /* First address that can be mapped
> */
> > 	dma_addr_t aperture_end;   /* Last address that can be mapped
> */
> > 	bool force_aperture;       /* DMA only allowed in mappable range?
> */
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
> > +/* cache stash targets */
> > +#define L1_CACHE 1
> > +#define L2_CACHE 2
> > +#define L3_CACHE 3
> 
> These names are way to generic for being exposed to user space
Will fix naming to IOMMU_ATTR_CACHE_L1 etc.

-Varun


