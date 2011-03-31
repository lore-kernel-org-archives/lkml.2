Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab1CaQ0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:26:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51700 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1CaQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:26:00 -0400
Date: Thu, 31 Mar 2011 10:25:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: John Williams <john.williams@petalogix.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110331162557.GG26709@ponder.secretlab.ca>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <1301574600-4861-2-git-send-email-monstr@monstr.eu>
 <20110331124925.GA2202@pengutronix.de>
 <AANLkTi=sG6oVNifwLLi8jjKQXjR6kXZx43NxtFfoPumy@mail.gmail.com>
 <20110331132328.GB2202@pengutronix.de>
 <AANLkTikCEYK5K3sQ1rgVK6qMvizQYUn=xsiSPedNRn9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikCEYK5K3sQ1rgVK6qMvizQYUn=xsiSPedNRn9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 11:47:04PM +1000, John Williams wrote:
> On Thu, Mar 31, 2011 at 11:23 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> >
> >>    Maybe I misunderstand you, in my view it is the responsibility of <vendor>
> >>    to create their DTS files to indicate they want <special-card1> to bind to
> >>    generic-uio.
> >
> > Device tree is a OS-neutral hardware description language. "generic-uio"
> > is neither OS-neutral nor a hardware description. devicetree.org has
> > more information about this.
> 
> If we are trying to be pure, I might argue we are not changing the DTS
> language, but rather just add support in Linux for a particular
> use-case.  There is no violation of DTS syntax.
> 
> It might be *recommended* that device trees describe only hardware,
> although as Michal points out there is already precedent in the
> 'chosen' node where this is clearly violated, but in a way that is
> compatible with DTS syntax.

There are of course exceptions, particularly for passing boot
information that is OS specific.  There is strong pressure to avoid it
however.

> 
> Is it forbidden to have DTS descriptions of purely virtual devices, as
> would be present if you boot a DTS-driven kernel inside a VM
> environment, which provides only virtual implementations of various
> devices (ethernet etc)?
> 
> 'vmware,virt-enet' or whatever?

No, it is not at all forbidden.  However it needs to be anchored on a
real implementation of the virtual device.  The difference with uio is
that 'uio' is a very specific description of /how/ linux interacts
with the device.  It doesn't describe /what/ the interface is.

The virtio stuff is a good example because the interface is defined
indepenently of how Linux actually drives it.

So you could modify the earlier statement to say that device trees
describe only interfaces; not internal OS implementation details.

A really big problem with 'generic-uio' is that it casts a very large
net.  If you add 'generic-uio' to a nodes compatible list, then it
immediately precludes any possibility of it being driven by an
in-kernel driver.

However, as already raised there is another way to skin this cat....

> 
> >>    Our use-case is pretty clear, in FPGA-based systems it is common to create
> >>    arbitrary devices that developers just want to control from userspace,
> >>    with simple IRQ and IO capabilities (DMA can come later :). �They don't
> >>    need to bind to other kernel APIs or subsystems, and don't want to invest
> >>    in one-off kernel drivers that simply will never go upstream.
> >
> > For that, the new_compatible-file would be suitable, I think.
> 
> # echo "generic-uio" > /sys/class/uio/<something>
> 
> ?

Yeah, something like that.  I'd prefer something like:
"<vendor>,<hardware-name>" > /sys/bus/platform/drivers/generic-uio/compatible-hardware

That makes it the model to supplement the driver with additional
information about what devices it binds against.

> 
> >>    UIO is perfect, and simply tagging the device as generic-uio in the DTS is
> >>    so simple, clean, and elegant.
> >
> > Simple, yes (I do understand I wrote the first approach ;)) . Elegant,
> > not really, because it breaks core conventions of the device tree. For
> > your case it is a very conveniant hack, but it is still a hack.
> 
> Being useful seems like a high priority in the kernel, I'm not ashamed of it! :)

:-)

> 
> Regards,
> 
> John
