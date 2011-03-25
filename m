Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450Ab1CYCy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 22:54:29 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:50670 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab1CYCy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 22:54:27 -0400
Date: Thu, 24 Mar 2011 19:54:01 -0700
From: Micah Elizabeth Scott <micah@vmware.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Greg KH <greg@kroah.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [ANNOUNCE] usbmon capture and parser script
Message-ID: <20110325025401.GA14110@vmware.com>
References: <4D8102A9.9080202@redhat.com>
 <20110316194758.GA32557@kroah.com>
 <1300306845.1954.7.camel@t41.thuisdomein>
 <4D81F4B3.4000004@redhat.com>
 <1300468899.1844.17.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300468899.1844.17.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 10:21:33AM -0700, Paul Bolle wrote:
> On Thu, 2011-03-17 at 08:46 -0300, Mauro Carvalho Chehab wrote:
> > On a quick test, it seems that it doesn't recognize the tcpdump file 
> > format (at least, it was not able to capture the dump files I got 
> > with the beagleboard). Adding support for it could be an interesting 
> > addition to your code.
> 
> Please note that Micah Dowty is the maintainer of vusb-analyzer. I
> mostly cleaned, etc. its usbmon support (which was originally added by
> Christoph Zimmermann). Anyway, you're always free to try to add support
> for another file format. I must say that Micah was rather easy to work
> with.
> 
> > Btw, it seems that most of your work is focused on getting VMware logs.
> 
> Micah had a vmware.com address last time I contacted him. That should
> explain that focus.

Right, vusb-analyzer doesn't currently understand tcpdump files.

I originally wrote it as just an internal debugging tool for VMware,
but we open sourced it and I've been quite interested in including
support for other log formats. It originally just had support for
VMware's logs and for XML files dumped by the Ellisys hardware
analyzers we use. Paul Bolle contributed usbmon log support.

I unfortunately haven't had much time to work on vusb-analyzer myself
in the past few years.. I'm hoping that will change soon, but in any
case I'd be happy to accept patches.

As another point of interest... I have some friends working on a
hardware USB analyzer project (openvizsla.org) and they've been
planning on using vusb-analyzer or something based on it. I've been
thinking about rewriting it in something a bit faster than Python,
improving the support for traversing large log files efficiently, and
making it fully understand lower-level USB packet logs like you'd see
from a hardware analyzer.

I think vusb-analyzer's strength has always been the graphical timing
analysis and quickly navigating complex logs. Wireshark is probably
better suited for deep protocol analysis.

> > Do you know if any of them are now capable of properly emulate USB 2.0
> > isoc transfers and give enough performance for the devices to actually
> > work with such high-bandwidth requirements?
>
> This is not something I know much about. I tried to use some digital
> camera over USB with qemu without much success. Apparently qemu's USB
> pass through has little chance of supporting high bandwidth USB devices.
> See
> http://lists.nongnu.org/archive/html/qemu-devel/2010-09/msg00017.html
> for the - not very interesting - answer I got when I wanted to know more
> about the problems of USB pass through in qemu.

I can't really speak for qemu, but I wrote the EHCI USB 2.0 Isochronous
emulation that VMware uses.

At the risk of sounding like an advertisment, there are of course
plenty of caveats to emulating Isochronous transfers in
userspace.. but VMware's emulation usually manages to work
correctly. You'll certainly run into problem devices sometimes, but
the raw CPU power hasn't been an issue. I routinely tested it with
high-bandwidth uncompressed TV tuner devices back in 2005 or 2006.

Cheers,
--beth
