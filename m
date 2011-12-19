Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1LSWnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 17:43:31 -0500
Received: from ozlabs.org ([203.10.76.45]:45548 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1LSWn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 17:43:27 -0500
Date: Tue, 20 Dec 2011 09:31:20 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
        benh@kernel.crashing.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org
Subject: Re: [RFC] Device isolation infrastructure v2
Message-ID: <20111219223120.GB5207@truffala.fritz.box>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
	benh@kernel.crashing.org, chrisw@redhat.com, agraf@suse.de,
	scottwood@freescale.com, B08248@freescale.com,
	rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
	joro@8bytes.org
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
 <20111216145353.GA29877@amd.com>
 <20111219001125.GA30390@truffala.fritz.box>
 <1324309598.2132.12.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324309598.2132.12.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 03:46:38PM +0000, David Woodhouse wrote:
> On Mon, 2011-12-19 at 11:11 +1100, David Gibson wrote:
> >   They have no inbuilt concept
> > of domains (though we could fake in software in some circumstances).
> 
> That sentence doesn't make much sense to me.
> 
> Either you're saying that every device behind a given IOMMU is in *one*
> domain (i.e. there's one domain per PCI host bridge), or you're saying
> that each device has its *own* domain (maximum isolation, but still
> perhaps not really true if you end up with PCIe-to-PCI bridges or broken
> hardware such as the ones we've been discovering, where multifunction
> devices do their DMA from the wrong function).
> 
> Either way, you *do* have domains. You just might not have thought about
> it before.

Right, sorry, what I mean is that there's no concept of runtime
assignment of devices to domains.  The concept used in the
documentation is a "Partitionable Endpoint" (PE) - which would
correspond to the isolation groups I'm proposing.  These are generally
assigned by firmware based on various hardware dependent isolation
constraints.

When we're running paravirtualized under pHyp, it's impossible to
merge multiple PEs into one domain per se.  We could fake it rather
nastily by replicating all map/unmaps across mutiple PEs.  When
running bare metal, we could do so a bit more nicely by assigning
multiple PEs the same TCE pointer, but we have no mechanism to do so
at present.

Older hardware usually does have just one PE per host bridge, but it
also often has only one slot per host bridge, so in practice is often
both one domain per host bridge _and_ one device per host bridge.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
