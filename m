Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab0GASxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:53:10 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:3738 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab0GASw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:52:57 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,521,1272844800"; 
   d="scan'208";a="340378706"
From: Tom Lyon <pugs@lyon-about.com>
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Date: Thu, 1 Jul 2010 11:49:17 -0700
User-Agent: KMail/1.9.9
Cc: "Michael S. Tsirkin" <mst@redhat.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com,
       Donald Dutile <ddutile@redhat.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <20100701153115.GA2008@redhat.com> <1277999321.10112.63.camel@x201>
In-Reply-To: <1277999321.10112.63.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007011149.17807.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010 08:48:41 am Alex Williamson wrote:
> On Thu, 2010-07-01 at 18:31 +0300, Michael S. Tsirkin wrote:
> > On Thu, Jul 01, 2010 at 09:29:04AM -0600, Alex Williamson wrote:
> > > On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> > > > +The VFIO_DMA_MASK ioctl is used to set the maximum permissible DMA address
> > > > +(device dependent). It takes a single unsigned 64 bit integer as an argument.
> > > > +This call also has the side effect of enabling PCI bus mastership.
> > > 
> > > Hi Tom,
> > > 
> > > This interface doesn't make sense for the MAP_IOVA user.  Especially in
> > > qemu, we have no idea what the DMA mask is for the device we're
> > > assigning.  It doesn't really matter though because the guest will use
> > > bounce buffers internally once it loads the device specific drivers and
> > > discovers the DMA mask.  This only seems relevant if we're using a
> > > DMA_MAP call that gets to pick the dmaaddr, so I'd propose we only make
> > > this a required call for that interface, and create a separate ioctl for
> > > actually enabling bus master.  Thanks,
> > > 
> > > Alex
> > 
> > I expect there's no need for a separate ioctl to do this:
> > you can do this by write to the control register.
> 
> Nope, vfio only allows direct writes to the memory and io space bits of
> the command register, all other bits are virtualized.  I wonder if
> that's necessary though since we require the device to be attached to an
> iommu domain before we allow config space access.
> 
I had already gotten rid of the mask setting & master mode ioctl. It was a remnant
of using the dma_map_sg API which is no longer in there.  And I tweaked the
config stuff to allow writing the master bit.
