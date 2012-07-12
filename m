Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab2GLX6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab2GLX6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:58:39 -0400
Date: Fri, 13 Jul 2012 02:58:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Subject: Re: UIO: missing resource mapping
Message-ID: <20120712235850.GA9614@redhat.com>
References: <4FFE7C1F.7080702@gmx.net>
 <20120712194432.GA2592@local>
 <20120712231632.GC9317@redhat.com>
 <20120712234011.GE2592@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712234011.GE2592@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 01:40:11AM +0200, Hans J. Koch wrote:
> On Fri, Jul 13, 2012 at 02:16:32AM +0300, Michael S. Tsirkin wrote:
> > On Thu, Jul 12, 2012 at 09:44:33PM +0200, Hans J. Koch wrote:
> > > > Looking further at the code, I cannot see where the mem fields are
> > > > being filled at all.
> > > > Which code is supposed to write the struct uio_mem?
> > > 
> > > In my opinion, the driver should. However, Michael's idea is to use
> > > /sys/bus/pci/devices/XXXXXresourceX for mapping purposes.
> > > 
> > > That is of course also possible, but obviously it leads to confusion.
> > > We already had a long thread about this:
> > > 
> > > http://www.spinics.net/lists/kvm/msg73837.html
> > > 
> > > Michael, can we change the driver to offer all available PCI BARs in the
> > > normal UIO way? I'm afraid otherwise we'll have the same discussion over
> > > and over again.
> > > 
> > > Thanks,
> > > Hans
> > 
> > My concern was people will ask for more and more stuff that pci
> > sysfs already has.
> > If we do add these is there a way to not duplicate code from pci?
> > Export pci_mmap_resource and use it? Or make the uio attributes
> > softlinks to pci sysfs somehow?
> 
> I understand your concern. Of course I'm also not in favor of duplicating
> code, but I don't think there's much overhead. PCI already exports all
> information needed by pci_resource_start(dev, bar) and
> pci_resource_len(dev, bar). Have a look at other UIO PCI drivers like
> uio_cif.c or uio_netx.c to see how it works. It's just a few more lines
> of code to loop through all BARs and add the to info->mem[i].
> 
> By the way, the current size of the info->mem[] array was exactly made
> with PCI in mind...
> 
> Thanks,
> Hans

Well we also need to check resource type and probably iomem_is_exclusive.

-- 
MST
