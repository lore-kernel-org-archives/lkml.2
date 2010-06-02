Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0FBRqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:46:51 -0400
Received: from sous-sol.org ([216.99.217.87]:39404 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756414Ab0FBRqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:46:48 -0400
Date: Wed, 2 Jun 2010 10:46:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, hjk@linutronix.de,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602174615.GV8301@sequoia.sous-sol.org>
References: <20100601095532.GA9178@redhat.com>
 <20100602094201.GC964@8bytes.org>
 <20100602095312.GA25335@redhat.com>
 <20100602101940.GG964@8bytes.org>
 <20100602102144.GD29023@redhat.com>
 <20100602103516.GI964@8bytes.org>
 <20100602103828.GF29023@redhat.com>
 <20100602111224.GA11033@8bytes.org>
 <20100602112100.GA29697@redhat.com>
 <20100602121927.GA11162@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602121927.GA11162@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joro@8bytes.org) wrote:
> On Wed, Jun 02, 2010 at 02:21:00PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jun 02, 2010 at 01:12:25PM +0200, Joerg Roedel wrote:
> 
> > > Even if it is bound to a domain the userspace driver could program the
> > > device to do dma to unmapped regions causing io-page-faults. The kernel
> > > can't do anything about it.
> > 
> > It can always corrupt its own memory directly as well :)
> > But that is not a reason not to detect errors if we can,
> > and not to make APIs hard to misuse.
> 
> Changing the domain of a device while dma can happen is the same type of
> bug as unmapping potential dma target addresses. We can't catch this
> kind of misuse.
> 
> > > > With 10 devices you have 10 extra ioctls.
> > > 
> > > And this works implicitly with your proposal?
> > 
> > Yes.  so you do:
> > iommu = open
> > ioctl(dev1, BIND, iommu)
> > ioctl(dev2, BIND, iommu)
> > ioctl(dev3, BIND, iommu)
> > ioctl(dev4, BIND, iommu)
> > 
> > No need to add a SHARE ioctl.
> 
> In my proposal this looks like:
> 
> 
> dev1 = open();
> ioctl(dev2, SHARE, dev1);
> ioctl(dev3, SHARE, dev1);
> ioctl(dev4, SHARE, dev1);
> 
> So we actually save an ioctl.

This is not any hot path, so saving an ioctl shouldn't be a consideration.
Only important consideration is a good API.  I may have lost context here,
but the SHARE API is limited to the vfio fd.  The BIND API expects a new
iommu object.  Are there other uses for this object?  Tom's current vfio
driver exposes a dma mapping interface, would the iommu object expose
one as well?  Current interface is device specific DMA interface for
host device drivers typically mapping in-flight dma buffers, and IOMMU
specific interface for assigned devices typically mapping entire virtual
address space.

thanks,
-chris
