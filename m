Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2LDSXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 13:23:07 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:36295
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab2LDSXE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 13:23:04 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI98dI9371I179dN542I1432Izz1de0h1202h1d1ah1d2ahzz8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1155h)
Date: Tue, 4 Dec 2012 12:22:51 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>, Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tabi Timur-B04825 <B04825@freescale.com>
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D2B70EE@039-SN2MPN1-013.039d.mgd.msft.net>
	(from B16395@freescale.com on Tue Dec  4 05:53:33 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1354645371.16710.15@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 05:53:33 AM, Sethi Varun-B16395 wrote:
> 
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Monday, December 03, 2012 10:34 PM
> > To: Sethi Varun-B16395
> > Cc: Joerg Roedel; linux-kernel@vger.kernel.org; iommu@lists.linux-
> > foundation.org; Wood Scott-B07421; linuxppc-dev@lists.ozlabs.org;  
> Tabi
> > Timur-B04825
> > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> > required by fsl PAMU driver.
> >
> > On 12/03/2012 10:57:29 AM, Sethi Varun-B16395 wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> > > > bounces@lists.linux-foundation.org] On Behalf Of Joerg Roedel
> > > > Sent: Sunday, December 02, 2012 7:33 PM
> > > > To: Sethi Varun-B16395
> > > > Cc: linux-kernel@vger.kernel.org;  
> iommu@lists.linux-foundation.org;
> > > Wood
> > > > Scott-B07421; linuxppc-dev@lists.ozlabs.org; Tabi Timur-B04825
> > > > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain  
> attributes
> > > > required by fsl PAMU driver.
> > > >
> > > > Hmm, we need to work out a good abstraction for this.
> > > >
> > > > On Tue, Nov 20, 2012 at 07:24:56PM +0530, Varun Sethi wrote:
> > > > > Added the following domain attributes required by FSL PAMU  
> driver:
> > > > > 1. Subwindows field added to the iommu domain geometry  
> attribute.
> > > >
> > > > Are the Subwindows mapped with full size or do you map only  
> parts
> > > of the
> > > > subwindows?
> > > >
> > > [Sethi Varun-B16395] It's possible to map a part of the subwindow  
> i.e.
> > > size of the mapping can be less than the sub window size.
> > >
> > > > > +	 * This attribute indicates number of DMA subwindows
> > supported
> > > by
> > > > > +	 * the geometry. If there is a single window that maps  
> the
> > > entire
> > > > > +	 * geometry, attribute must be set to "1". A value of  
> "0"
> > > implies
> > > > > +	 * that this mechanism is not used at all(normal paging  
> is
> > > used).
> > > > > +	 * Value other than* "0" or "1" indicates the actual  
> number
> > of
> > > > > +	 * subwindows.
> > > > > +	 */
> > > >
> > > > This semantic is ugly, how about a feature detection mechanism?
> > > >
> > > [Sethi Varun-B16395] A feature mechanism to query the type of  
> IOMMU?
> >
> > A feature mechanism to determine whether this subwindow mechanism is
> > available, and what the limits are.
> >
> So, we use the IOMMU capability interface to find out if IOMMU  
> supports sub windows or not, right? But still number of sub windows  
> would be specified as a part of the geometry and the valid value for  
> sub windows would  0,1 or actual number of sub windows.

How does a user of the interface find out what values are possible for  
the "actual number of subwindows"?  How does a user of the interface  
find out whether there are any limitations on specifying a value of  
zero (in the case of PAMU, that would be a maximum 1 MiB  
naturally-aligned aperture to support arbitrary 4KiB mappings)?

-Scott
