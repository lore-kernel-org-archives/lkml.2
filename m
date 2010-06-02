Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab0FBNCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:02:40 -0400
Received: from 8bytes.org ([88.198.83.132]:46072 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab0FBNCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:02:39 -0400
Date: Wed, 2 Jun 2010 15:02:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602130237.GC11162@8bytes.org>
References: <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org> <20100602123417.GA29815@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602123417.GA29815@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 03:34:17PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 02, 2010 at 02:19:28PM +0200, Joerg Roedel wrote:

> you normally need device mapped to start DMA.
> SHARE makes this bug more likely as you allow
> switching domains: mmap could be done before switching.

We need to support domain switching anyway for iommu emulation in a
guest. So if you consider this to be a problem (I don't) it will not go
away with your proposal.

> > dev1 = open();
> > ioctl(dev2, SHARE, dev1);
> > ioctl(dev3, SHARE, dev1);
> > ioctl(dev4, SHARE, dev1);
> > 
> > So we actually save an ioctl.
> 
> I thought we had a BIND ioctl?

I can't remember a BIND ioctl in my proposal. I remember an UNBIND, but
thats bad naming as you pointed out below. See my statement on this
below too.

> You undo SHARE with UNBIND?

Thats bad naming, agreed. Lets keep UNSHARE. Point is, we only need one
parameter to do this which removes any ambiguity:

ioctl(dev1, UNSHARE);

	Joerg

