Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0GAPtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:49:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab0GAPtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:49:04 -0400
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com,
       Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20100701153115.GA2008@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
	 <1277998144.10112.58.camel@x201>  <20100701153115.GA2008@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 09:48:41 -0600
Message-ID: <1277999321.10112.63.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 18:31 +0300, Michael S. Tsirkin wrote:
> On Thu, Jul 01, 2010 at 09:29:04AM -0600, Alex Williamson wrote:
> > On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> > > +The VFIO_DMA_MASK ioctl is used to set the maximum permissible DMA address
> > > +(device dependent). It takes a single unsigned 64 bit integer as an argument.
> > > +This call also has the side effect of enabling PCI bus mastership.
> > 
> > Hi Tom,
> > 
> > This interface doesn't make sense for the MAP_IOVA user.  Especially in
> > qemu, we have no idea what the DMA mask is for the device we're
> > assigning.  It doesn't really matter though because the guest will use
> > bounce buffers internally once it loads the device specific drivers and
> > discovers the DMA mask.  This only seems relevant if we're using a
> > DMA_MAP call that gets to pick the dmaaddr, so I'd propose we only make
> > this a required call for that interface, and create a separate ioctl for
> > actually enabling bus master.  Thanks,
> > 
> > Alex
> 
> I expect there's no need for a separate ioctl to do this:
> you can do this by write to the control register.

Nope, vfio only allows direct writes to the memory and io space bits of
the command register, all other bits are virtualized.  I wonder if
that's necessary though since we require the device to be attached to an
iommu domain before we allow config space access.

Alex



