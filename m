Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab0G2OdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:33:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab0G2OdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:33:14 -0400
Date: Thu, 29 Jul 2010 17:27:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
        chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100729142705.GA25879@redhat.com>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
 <201007271513.15093.pugs@cisco.com>
 <20100727235322.GB19930@redhat.com>
 <201007281414.22335.pugs@cisco.com>
 <1280354222.3919.12.camel@x201>
 <20100728215739.GA9671@redhat.com>
 <1280355199.3919.22.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280355199.3919.22.camel@x201>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 04:13:19PM -0600, Alex Williamson wrote:
> On Thu, 2010-07-29 at 00:57 +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 28, 2010 at 03:57:02PM -0600, Alex Williamson wrote:
> > > 
> > > Something like GET_MSIX_VECTORS seems like a user library routine to me.
> > > The PCI config space is well specified and if we try to do more than
> > > shortcut trivial operations (like getting the BAR length), we risk
> > > losing functionality.  And for my purposes, translating to and from a
> > > made up API to PCI for the guest seems like a pain.
> > 
> > Won't a userspace library do just as well for you?
> 
> You mean aside from qemu's reluctance to add dependencies for more
> libraries?

Main reason is portability. So as long as it's kvm-only stuff, they
likely won't care.

> My only concern is that I want enough virtualized/raw config
> space that I'm not always translating PCI config accesses from the guest
> into some userspace API.  If it makes sense to do this for things like
> MSI, since I need someone to figure out what resources can actually be
> allocated on the host, then maybe the library makes sense for that.
> Then again, if every user needs to do this, let the vfio kernel driver
> check what it can get and virtualize the available MSIs in exposed
> config space, and my driver would be even happier.
> 
> Alex

It would?  guest driver might or might not work if you reduce the number
of vectors for device.  So I think you need an API to find out whether
all vectors can be allocated.

And these are examples of why virtualizing is wrong:
1. hides real hardware
2. no way to report errors

-- 
MST
