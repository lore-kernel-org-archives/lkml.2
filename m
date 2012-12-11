Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2LKBA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 20:00:56 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:25966 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab2LKBAz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:00:55 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI98dI9371I179dN542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1155h)
Date: Mon, 10 Dec 2012 19:00:44 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>, Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tabi Timur-B04825 <B04825@freescale.com>
References: <C5ECD7A89D1DC44195F34B25E172658D2B70EE@039-SN2MPN1-013.039d.mgd.msft.net>
	<1354645371.16710.15@snotra>
	<C5ECD7A89D1DC44195F34B25E172658D2C09A4@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D2C09A4@039-SN2MPN1-013.039d.mgd.msft.net>
	(from B16395@freescale.com on Mon Dec 10 04:10:06 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1355187644.5334.23@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 04:10:06 AM, Sethi Varun-B16395 wrote:
> 
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Tuesday, December 04, 2012 11:53 PM
> > To: Sethi Varun-B16395
> > Cc: Wood Scott-B07421; Joerg Roedel; linux-kernel@vger.kernel.org;
> > iommu@lists.linux-foundation.org; linuxppc-dev@lists.ozlabs.org;  
> Tabi
> > Timur-B04825
> > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> > required by fsl PAMU driver.
> >
> > On 12/04/2012 05:53:33 AM, Sethi Varun-B16395 wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Wood Scott-B07421
> > > > Sent: Monday, December 03, 2012 10:34 PM
> > > > To: Sethi Varun-B16395
> > > > Cc: Joerg Roedel; linux-kernel@vger.kernel.org;  
> iommu@lists.linux-
> > > > foundation.org; Wood Scott-B07421;  
> linuxppc-dev@lists.ozlabs.org;
> > > Tabi
> > > > Timur-B04825
> > > > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain  
> attributes
> > > > required by fsl PAMU driver.
> > > >
> > > > On 12/03/2012 10:57:29 AM, Sethi Varun-B16395 wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: iommu-bounces@lists.linux-foundation.org  
> [mailto:iommu-
> > > > > > bounces@lists.linux-foundation.org] On Behalf Of Joerg  
> Roedel
> > > > > > Sent: Sunday, December 02, 2012 7:33 PM
> > > > > > To: Sethi Varun-B16395
> > > > > > Cc: linux-kernel@vger.kernel.org;
> > > iommu@lists.linux-foundation.org;
> > > > > Wood
> > > > > > Scott-B07421; linuxppc-dev@lists.ozlabs.org; Tabi  
> Timur-B04825
> > > > > > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain
> > > attributes
> > > > > > required by fsl PAMU driver.
> > > > > >
> > > > > > Hmm, we need to work out a good abstraction for this.
> > > > > >
> > > > > > On Tue, Nov 20, 2012 at 07:24:56PM +0530, Varun Sethi wrote:
> > > > > > > Added the following domain attributes required by FSL PAMU
> > > driver:
> > > > > > > 1. Subwindows field added to the iommu domain geometry
> > > attribute.
> > > > > >
> > > > > > Are the Subwindows mapped with full size or do you map only
> > > parts
> > > > > of the
> > > > > > subwindows?
> > > > > >
> > > > > [Sethi Varun-B16395] It's possible to map a part of the  
> subwindow
> > > i.e.
> > > > > size of the mapping can be less than the sub window size.
> > > > >
> > > > > > > +	 * This attribute indicates number of DMA subwindows
> > > > supported
> > > > > by
> > > > > > > +	 * the geometry. If there is a single window that maps
> > > the
> > > > > entire
> > > > > > > +	 * geometry, attribute must be set to "1". A value of
> > > "0"
> > > > > implies
> > > > > > > +	 * that this mechanism is not used at all(normal paging
> > > is
> > > > > used).
> > > > > > > +	 * Value other than* "0" or "1" indicates the actual
> > > number
> > > > of
> > > > > > > +	 * subwindows.
> > > > > > > +	 */
> > > > > >
> > > > > > This semantic is ugly, how about a feature detection  
> mechanism?
> > > > > >
> > > > > [Sethi Varun-B16395] A feature mechanism to query the type of
> > > IOMMU?
> > > >
> > > > A feature mechanism to determine whether this subwindow  
> mechanism is
> > > > available, and what the limits are.
> > > >
> > > So, we use the IOMMU capability interface to find out if IOMMU
> > > supports sub windows or not, right? But still number of sub  
> windows
> > > would be specified as a part of the geometry and the valid value  
> for
> > > sub windows would  0,1 or actual number of sub windows.
> >
> > How does a user of the interface find out what values are possible  
> for
> > the "actual number of subwindows"?  How does a user of the  
> interface find
> > out whether there are any limitations on specifying a value of zero  
> (in
> > the case of PAMU, that would be a maximum 1 MiB naturally-aligned
> > aperture to support arbitrary 4KiB mappings)?
> How about if we say that the default value for subwindows is zero and  
> this what you get when you read the geometry (iommu_get_attr) after  
> initializing the domain? In that case the user would know that  
> implication of setting subwindows to zero with respect to the  
> aperture size.

So it would default to the maximum aperture size possible with no  
subwindows?  That might be OK, though is there a way to reset the  
domain later on to get back to that informational state?

How about finding out the maximum number of subwindows?

> Also, should we introduce an additional API like "iommu_check_attr",  
> which the user can use to validate the attribute value. For example  
> in case of geometry, the user can fill up the structure and pass it  
> to the iommu driver in order to verify the aperture and subwindows  
> field.

Doesn't the current API raise an error if you do something  
unsupported?  In any case I don't think making a series of guesses and  
seeing which ones are accepted is a good substitute for being able to  
simply read out the relevant parameters.

-Scott
