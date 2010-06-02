Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab0FBOB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:01:57 -0400
Received: from 8bytes.org ([88.198.83.132]:53231 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0FBOB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:01:56 -0400
Date: Wed, 2 Jun 2010 16:01:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602140155.GE11162@8bytes.org>
References: <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org> <4C064DA7.6060504@redhat.com> <20100602125049.GB11162@8bytes.org> <20100602131719.GA29930@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602131719.GA29930@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 04:17:19PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 02, 2010 at 02:50:50PM +0200, Joerg Roedel wrote:
> > On Wed, Jun 02, 2010 at 03:25:11PM +0300, Avi Kivity wrote:
> > > On 06/02/2010 03:19 PM, Joerg Roedel wrote:

> 
> > If its
> > required anyway the binding can happen implicitly. We could allow to do
> > a nop 'ioctl(dev1, SHARE, dev1)' to remove the asymmetry.
> 
> And then when we assign meaning to it we find that half the apps
> are broken because they did not call this ioctl.

The meaning is already assigned and chaning it means changing the
userspace-abi which is a no-go.

> This simple scenario ignores all the real-life corner cases.
> For example, with an explicit iommu open and bind application
> can naturally detect that:
> - we have run out of iommu domains

ioctl(dev, MAP, ...)  will fail in this case.

> - iommu is unsupported

Is best checked by open() anyway because userspace can't do anything
with the device before it is bound to a domain.

> - iommu is in use by another, incompatible device

How should this happen?

> - device is in bad state

How is this checked with your proposal and why can this not be detected
with my one?

> because each is a separate operation, so it is easy to produce meaningful
> errors.

Ok, this is true.

> Another interesting thing that a separate iommu device supports is when
> application A controls the iommu and application B
> controls the device.

Until Linux becomes a micro-kernel the IOMMU itself will _never_ be
controlled by an application.

> This might be good to e.g. improve security (B is run by root, A is
> unpriveledged and passes commands to/from B over a pipe).

Micro-kernel arguments. I hope a userspace controlled IOMMU in Linux
will never happen ;-)

	Joerg

