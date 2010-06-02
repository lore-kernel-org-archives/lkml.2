Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0FBKfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:35:19 -0400
Received: from 8bytes.org ([88.198.83.132]:54545 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab0FBKfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:35:17 -0400
Date: Wed, 2 Jun 2010 12:35:16 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602103516.GI964@8bytes.org>
References: <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602102144.GD29023@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:21:44PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 02, 2010 at 12:19:40PM +0200, Joerg Roedel wrote:

> > It can. The worst thing that can happen is an io-page-fault.
> 
> devices might not be able to recover from this.

With the userspace interface a process can create io-page-faults
anyway if it wants. We can't protect us from this. And the process is
also responsible to not tear down iommu-mappings that are currently in
use.

> What you describe below does 3 ioctls for what can be done with 1.

The second IOMMU_MAP ioctl is just to show that existing mappings would
be destroyed if the device is assigned to another address space. Not
strictly necessary. So we have two ioctls but save one call to create
the iommu-domain.

> > ioctl(dev2, IOMMU_SHARE, dev1); /* destroys all mapping for dev2 and
> > 				   assigns it to the same domain as
> > 				   dev1. Domain has a refcount of two
> > 				   now */
> 
> Or maybe it destroys mapping for dev1?
> How do you remember?

Because we express here that "dev2 shares the iommu mappings of dev1".
Thats easy to remember.

> Also, no way to unshare? That seems limiting.

Just left out for simplicity reasons. An IOMMU_UNBIND (no IOMMU_UNSHARE
because that would require a second parameter) ioctl is certainly also
required.

	Joerg

