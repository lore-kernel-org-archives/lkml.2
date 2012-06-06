Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2FFFHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:07:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54910 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2FFFG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:06:59 -0400
Date: Wed, 6 Jun 2012 14:06:52 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Andy King <acking@vmware.com>, linux-kernel@vger.kernel.org,
        dsouders@vmware.com, cschamp@vmware.com, akpm@linux-foundation.org,
        virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: Re: [vmw_vmci RFC 00/11] VMCI for Linux
Message-ID: <20120606050652.GB14065@kroah.com>
References: <20120515235024.GB1758@kroah.com>
 <552579991.43606.1338564781979.JavaMail.root@vmware.com>
 <20120604225757.GC7041@kroah.com>
 <20120605070251.GA28032@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605070251.GA28032@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 12:02:51AM -0700, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On Mon, Jun 04, 2012 at 03:57:57PM -0700, Greg KH wrote:
> > On Fri, Jun 01, 2012 at 08:33:02AM -0700, Andy King wrote:
> > > Greg,
> > > 
> > > Thanks so much for the comments and apologies for the delayed response.
> > > 
> > > > Don't we have something like this already for KVM and maybe Xen?
> > > > virtio?  Can't you use that code instead of a new block of code that
> > > > is only used by vmware users?  It has virtual pci devices which
> > > > should give you what you want/need here, right?
> > > >
> > > > If not, why doesn't that work for you?  Would it be easier to just
> > > > extend it?
> > > 
> > > The VMCI virtual device for which this driver is intended has been
> > > around a lot longer than this submission might suggest.  The virtual
> > > hardware was released in a product before Rusty sent his RFC and
> > > quite a bit before it made it to mainline; there was, regrettably,
> > > no virtio then.
> > > 
> > > As such, it was designed to be its own transport, and it's something
> > > that is now very much fixed at the hardware level (enhancements
> > > not withstanding), and which we have to support all the way back.
> > 
> > What "hardware" are you refering to here?
> 
> The virtual hardware that is currently shipping and has been shipping
> for a few years.
> 
> > 
> > > In addition to that, our hypervisor endpoints are written using
> > > the existing device backend; virtio doesn't currently make a lot of
> > > sense for them, and would require a lot of additional work.
> > > 
> > > All of this is unfortunate.  While I agree that virtio is certainly
> > > the right approach, and we need to avoid this proliferation, I think
> > > at this point we'd really like to try and upstream this in its current
> > > form.  There's certainly the possibility going forwards that we could
> > > add a glue layer, such that other clients could use virtio if they're
> > > willing to write their own hypervisor endpoints.
> > > 
> > > Does that sound reasonable?
> > 
> > Not really, why should we take an interface that is tied to something
> > that you are saying isn't something we should be using?
> 
> That is not what Andy said. If virtio was available when we started
> shipping VMCI then we certainly could have used that, but since it
> wasn't there we invented something else.

Ok, that makes sense.

> > Don't you also
> > have control over the hypervisor side of things in order to properly
> > design this type of thing?
> 
> We do not have a time machine to go back and change products that we
> already shipped to the customers. It is probably the same story as with
> Hyper-V's vmbus which is not virtio.
> 
> Besides, virtio is not available on non-Linux guests with we have to
> support as well, and than affected the design decisions in hypervisor
> layer that have been made several years ago.

Ok, thanks for clearing that up, I was confused here.

greg k-h
