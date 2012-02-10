Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab2BJAVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:21:22 -0500
Received: from ozlabs.org ([203.10.76.45]:51819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab2BJAVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:21:18 -0500
Date: Fri, 10 Feb 2012 11:21:12 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@ozlabs.ru, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Device isolation group infrastructure (v3)
Message-ID: <20120210002112.GB10536@truffala.fritz.box>
Mail-Followup-To: Joerg Roedel <joerg.roedel@amd.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	aik@ozlabs.ru, qemu-devel@nongnu.org, alex.williamson@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
 <1328071614-8320-2-git-send-email-david@gibson.dropbear.id.au>
 <20120208152748.GD22598@amd.com>
 <1328737168.2903.35.camel@pasglop>
 <20120209112805.GN22598@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209112805.GN22598@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 12:28:05PM +0100, Joerg Roedel wrote:
> On Thu, Feb 09, 2012 at 08:39:28AM +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2012-02-08 at 16:27 +0100, Joerg Roedel wrote:
> > > Again, device grouping is done by the IOMMU drivers, so this all
> > > belongs
> > > into the generic iommu-code rather than the driver core.
> > 
> > Except that there isn't really a "generic iommu code"... discovery,
> > initialization & matching of iommu vs. devices etc... that's all
> > implemented in the arch specific iommu code.
> 
> The whole point of moving the iommu drivers to drivers/iommu was to
> factor out common code. We are not where we want to be yet but the goal
> is to move more code to the generic part.
> 
> For the group-code this means that the generic code should iterate over
> all devices on a bus and build up group structures based on isolation
> information provided by the arch specific code.

And how exactly do you suggest it provide that information.  I really
can't see how an iommu driver would specify its isolation constraints
generally enough, except in the form of code and then we're back to
where we are now.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
