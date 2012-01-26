Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2AZTob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:44:31 -0500
Received: from 8bytes.org ([88.198.83.132]:52477 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab2AZToa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:44:30 -0500
Date: Thu, 26 Jan 2012 20:44:29 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120126194428.GH6269@8bytes.org>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com> <1326983405-319-3-git-send-email-joerg.roedel@amd.com> <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net> <20120120160344.GG2205@amd.com> <4F219A9C.8000400@freescale.com> <20120126183116.GI19255@amd.com> <4F219E82.106@freescale.com> <20120126185101.GJ19255@amd.com> <4F21A2D5.6000204@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F21A2D5.6000204@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 01:00:37PM -0600, Scott Wood wrote:
> On 01/26/2012 12:51 PM, Joerg Roedel wrote:
> > Because this is a flag that makes sense for all IOMMU. Every IOMMU
> > either allows DMA outside its aperture or it doesn't.
> > 
> > Another reason why it must be in the generic struct is the intended
> > generic dma-ops layer on-top. This code can decide on this flag wheter a
> > address needs to be remapped at all.
> 
> So the DMA API would just read this, not write it?

The whole geometry thing is only implemented on the read side. There is
no implementation in domain_set_attr for it. So the geometry
information is read-only by default.

> Still no reason why it couldn't be a separate attribute.  Then if you
> get a failure trying to write it, it's more obvious why.

This would mean iommu specific hacks, which are not necessary in this
case.

> > Setting this flag wrong does not create unintended identity mappings.
> 
> Failing to set it means that DMA can go through that is not limited to
> explicitly created mappings.  In some contexts (e.g. vfio) this is a
> security hole.

No, when the hardware does not allow this, then software can't enforce
it. Again, the whole geometry attribute is only for iommu drivers to
export what the hardware can do. It is not for software to configure the
iommu driver.

> > But I don't understand what you mean by 'restrictions on possible values'. The
> > geometry attribute is filled by the IOMMU driver dependent on the
> > hardware capabilities. There are no limits from the iommu-code side.
> 
> How does the user of the iommu API discover the hardware capabilities?

Which hardware capabilities besides the geometry do you mean?


	Joerg

