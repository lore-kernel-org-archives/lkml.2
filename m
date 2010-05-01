Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0EAO2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:28:50 -0400
Received: from 8bytes.org ([88.198.83.132]:50082 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab0EAO2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:28:42 -0400
Date: Sat, 1 May 2010 16:28:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, hjk@linutronix.de, gregkh@suse.de,
       chrisw@sous-sol.org, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] drivers/uio/uio_pci_generic.c: allow access for
	non-privileged processes
Message-ID: <20100501142839.GD14542@8bytes.org>
References: <4bccd3af.M/eSrn9OV22zg0A8%pugs@cisco.com> <20100421093849.GB30855@redhat.com> <201004291229.40918.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004291229.40918.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 12:29:40PM -0700, Tom Lyon wrote:

> I think the plan for V4 will be to take things entirely out of the UIO
> framework, and instead have a driver which supports user mode use of
> "well-behaved" PCI devices.

I really don't think that we should create another uio-subsystem for the
kernel. The current one can be easily extended to fit your and the
virtualization needs.

> So, I will go outside UIO because:

> 1 - it doesn't allow reads and writes to sub-drivers, just irqcontrol

Can you elaborate on that? What do you mean by sub-drivers?

> 2 - it doesn't have ioctls

You already added ioctls. This is not a big deal.

> 3 - it has its own interrupt model which doesn't use eventfds

Can be extended using the ioctl.

> 4 - it's ugly doing the new stuff and maintaining backwards compat.

Not really. In the ioctls you will add to enable msi/msi-x you can pass
the eventfds to userspace. Thats not ugly at all. Its just an addition.

Here is the approach I would take:

* Add an ioctl to the uio-framework and add some basic functionality
  like querying for some device capabilities like memory regions to mmap
  or io regions.
* Add ioctls to uio-pci-generic to ask for interrupt capabilities of the
  pci device (old style irqs/msi/msi-x, how many vectors and so on) and
  ioctls to enable them and get an eventfd back for each vector.

Thats a good extension and backwards compatible as well in my eyes. What
do you think?


	Joerg

