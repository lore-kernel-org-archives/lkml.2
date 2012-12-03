Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2LCRE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:04:27 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:53040
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000Ab2LCREZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:04:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI98dI9371I179dN542I1432Izz1de0h1202h1d1ah1d2ahzz8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1155h)
Date: Mon, 3 Dec 2012 11:03:43 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
To: Sethi Varun-B16395 <B16395@freescale.com>
CC: Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tabi Timur-B04825 <B04825@freescale.com>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
	<1353419697-31269-4-git-send-email-Varun.Sethi@freescale.com>
	<20121202140323.GO30633@8bytes.org>
	<C5ECD7A89D1DC44195F34B25E172658D2B2A51@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D2B2A51@039-SN2MPN1-013.039d.mgd.msft.net>
	(from B16395@freescale.com on Mon Dec  3 10:57:29 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1354554223.2960.7@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 10:57:29 AM, Sethi Varun-B16395 wrote:
> 
> 
> > -----Original Message-----
> > From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> > bounces@lists.linux-foundation.org] On Behalf Of Joerg Roedel
> > Sent: Sunday, December 02, 2012 7:33 PM
> > To: Sethi Varun-B16395
> > Cc: linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;  
> Wood
> > Scott-B07421; linuxppc-dev@lists.ozlabs.org; Tabi Timur-B04825
> > Subject: Re: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes
> > required by fsl PAMU driver.
> >
> > Hmm, we need to work out a good abstraction for this.
> >
> > On Tue, Nov 20, 2012 at 07:24:56PM +0530, Varun Sethi wrote:
> > > Added the following domain attributes required by FSL PAMU driver:
> > > 1. Subwindows field added to the iommu domain geometry attribute.
> >
> > Are the Subwindows mapped with full size or do you map only parts  
> of the
> > subwindows?
> >
> [Sethi Varun-B16395] It's possible to map a part of the subwindow  
> i.e. size of the mapping can be less than the sub window size.
> 
> > > +	 * This attribute indicates number of DMA subwindows supported  
> by
> > > +	 * the geometry. If there is a single window that maps the  
> entire
> > > +	 * geometry, attribute must be set to "1". A value of "0"  
> implies
> > > +	 * that this mechanism is not used at all(normal paging is  
> used).
> > > +	 * Value other than* "0" or "1" indicates the actual number of
> > > +	 * subwindows.
> > > +	 */
> >
> > This semantic is ugly, how about a feature detection mechanism?
> >
> [Sethi Varun-B16395] A feature mechanism to query the type of IOMMU?

A feature mechanism to determine whether this subwindow mechanism is  
available, and what the limits are.

-Scott
