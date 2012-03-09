Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2CIDkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:40:08 -0500
Received: from ozlabs.org ([203.10.76.45]:34575 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab2CIDkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:40:06 -0500
Date: Fri, 9 Mar 2012 14:40:02 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@ozlabs.ru,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC: Device isolation groups
Message-ID: <20120309034002.GP10735@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	aik@ozlabs.ru, benh@kernel.crashing.org, qemu-devel@nongnu.org,
	joerg.roedel@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
 <1328126919.6937.254.camel@bling.home>
 <20120202012414.GE8700@truffala.fritz.box>
 <1330543855.29701.180.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330543855.29701.180.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:30:55PM -0700, Alex Williamson wrote:
> On Thu, 2012-02-02 at 12:24 +1100, David Gibson wrote:
> > On Wed, Feb 01, 2012 at 01:08:39PM -0700, Alex Williamson wrote:
[snip]
> Any update to this series?  It would be great if we could map out the
> functionality to the point of breaking down and distributing work... or
> determining if the end result has any value add to what VFIO already
> does.  Thanks,

Yes and no.

No real change on the isolation code per se.  I had been hoping for
feedback from David Woodhouse, but I guess he's been too busy.

In the meantime, however, Alexey has been working on a different
approach to doing PCI passthrough which is more suitable for our
machines.  It is based on passing through an entire virtual host
bridge (which could be a whole host side host bridge, or a subset,
depending on host isolation capabilities), rather than individual
devices.  This makes it substantially simpler than VFIO (we don't need
to virtualize config space or device addresses), and it provides
better enforcement of isolation guarantees (VFIO isolation can be
broken if devices have MMIO backdoors to config space, or if they can
be made to DMA to other devices MMIO addresses instead of RAM
addresses), but does require suitable bridge hardware - pSeries has
such hardware, x86 mostly doesn't (although it wouldn't surprise me if
large server class x86 machines do or will provide the necessary
things).  Even on this sort of hardware the device-centred VFIO
approach may have uses, since it might allow finer grained division,
at the cost of isolation enforcement.

This provides a more concrete case for the isolation infrastructure,
since it would allow the virtual-PHB and VFIO approaches to co-exist.
As Alexey's prototype comes into shape, it should illuminate what
other content we need in the isolation infrastructure to make it fully
usable.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
