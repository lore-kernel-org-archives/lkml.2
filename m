Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab0FBKnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab0FBKnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:43:16 -0400
Date: Wed, 2 Jun 2010 13:38:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602103828.GF29023@redhat.com>
References: <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602103516.GI964@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 12:35:16PM +0200, Joerg Roedel wrote:
> On Wed, Jun 02, 2010 at 01:21:44PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jun 02, 2010 at 12:19:40PM +0200, Joerg Roedel wrote:
> 
> > > It can. The worst thing that can happen is an io-page-fault.
> > 
> > devices might not be able to recover from this.
> 
> With the userspace interface a process can create io-page-faults
> anyway if it wants. We can't protect us from this.

We could fail all operations until an iommu is bound.
This will help catch bugs with access before setup. We can not do this
if a domain is bound by default.

> And the process is
> also responsible to not tear down iommu-mappings that are currently in
> use.
> 
> > What you describe below does 3 ioctls for what can be done with 1.
> 
> The second IOMMU_MAP ioctl is just to show that existing mappings would
> be destroyed if the device is assigned to another address space. Not
> strictly necessary. So we have two ioctls but save one call to create
> the iommu-domain.

With 10 devices you have 10 extra ioctls.

> > > ioctl(dev2, IOMMU_SHARE, dev1); /* destroys all mapping for dev2 and
> > > 				   assigns it to the same domain as
> > > 				   dev1. Domain has a refcount of two
> > > 				   now */
> > 
> > Or maybe it destroys mapping for dev1?
> > How do you remember?
> 
> Because we express here that "dev2 shares the iommu mappings of dev1".
> Thats easy to remember.

they both share the mappings. which one gets the iommu
destroyed (breaking the device if it is now doing DMA)?

> > Also, no way to unshare? That seems limiting.
> 
> Just left out for simplicity reasons. An IOMMU_UNBIND (no IOMMU_UNSHARE
> because that would require a second parameter) ioctl is certainly also
> required.
> 
> 	Joerg



-- 
MST
