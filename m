Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab0FBLM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:12:27 -0400
Received: from 8bytes.org ([88.198.83.132]:44250 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab0FBLM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:12:26 -0400
Date: Wed, 2 Jun 2010 13:12:25 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602111224.GA11033@8bytes.org>
References: <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602103828.GF29023@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:38:28PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 02, 2010 at 12:35:16PM +0200, Joerg Roedel wrote:

> > With the userspace interface a process can create io-page-faults
> > anyway if it wants. We can't protect us from this.
> 
> We could fail all operations until an iommu is bound.  This will help
> catch bugs with access before setup. We can not do this if a domain is
> bound by default.

Even if it is bound to a domain the userspace driver could program the
device to do dma to unmapped regions causing io-page-faults. The kernel
can't do anything about it.

> > The second IOMMU_MAP ioctl is just to show that existing mappings would
> > be destroyed if the device is assigned to another address space. Not
> > strictly necessary. So we have two ioctls but save one call to create
> > the iommu-domain.
> 
> With 10 devices you have 10 extra ioctls.

And this works implicitly with your proposal? Remember that we still
need to be able to provide seperate mappings for each device to support
IOMMU emulation for the guest. I think my proposal does not have any
extra costs.

> > Because we express here that "dev2 shares the iommu mappings of dev1".
> > Thats easy to remember.
> 
> they both share the mappings. which one gets the iommu
> destroyed (breaking the device if it is now doing DMA)?

As I wrote the domain has a reference count and is destroyed only when
it goes down to zero. This does not happen as long as a device is bound
to it.

	Joerg

