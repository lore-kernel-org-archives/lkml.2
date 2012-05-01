Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2EAOYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:24:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34211 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756569Ab2EAOYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:24:04 -0400
Date: Tue, 1 May 2012 10:24:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Grzegorz Nosek <root@localdomain.pl>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <support@supermicro.com>
Subject: Re: EHCI software retries break Supermicro IPKVM
In-Reply-To: <4F9F0426.6040603@localdomain.pl>
Message-ID: <Pine.LNX.4.44L0.1205011016130.1499-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Grzegorz Nosek wrote:

> W dniu 30.04.2012 23:12, Alan Stern pisze:
> > It isn't a software issue.  You've got a hardware problem; either the
> > IPKVM itself, or the connecting cable, or your computer's EHCI
> > controller is bad.  The only reason the device worked without the retry
> > logic is because it failed so completely that the kernel was forced to
> > run it at full speed (12 Mb/s) instead of high speed (480 Mb/s).  With
> > the retry logic present, the device was barely workable at high speed
> > (but it probably didn't work well enough to be very useful).
> 
> Oh. Thanks for the info. Is there a way to force the device into 12Mb/s 
> mode? I don't care about performance as the bottleneck is my Internet 
> link on the client, anyway. The retry logic rendered the console 
> unusable (not just slow, completely no keyboard or redirected media).

In fact there _is_ a way to do it:

	echo 7 >/sys/bus/pci/devices/0000:00:1d.7/companion

Here 7 is the number of the port which you want to force to full speed
and 0000:00:1d.7 is the PCI address of the EHCI controller.

> > Have you tried plugging the IPKVM into a different computer to see if
> > it behaves any better?
> 
> Nope. The IPKVM is a proprietary addon card without any cables (plugs 
> into a dedicated slot on the motherboard). Another identical machine is 
> misbehaving the exact same way (retry messages in dmesg), so either I'm 
> just unlucky, or it's a wider issue. Still, a few others are working 
> fine (no retry messages; though I did not check the KVM recently). All 
> the machines are in a rather remote DC, so I'm unlikely to muck with the 
> hardware any time soon.
> 
> Are there any diagnostics possible to determine what is broken (i.e. the 
> KVM card or the controller)? IIRC plugging a physical USB-based KVM 
> worked fine, although that might have been an older kernel, without the 
> retry logic.

Well, you could move the card into a different computer and see how it 
behaves there.  Or you could replace the card with a different one, to 
see if there's any difference in behavior.

It may be that neither part is directly at fault, but instead there's a 
slight incompatibilty between them.

For example, at one point I had a USB disk drive that didn't work on my
home computer.  The same drive and USB cable did work on my office
computer.  The same drive with a different cable worked on my home
computer.  And a flash storage device worked when attached via the same
cable to my home computer.  In a situation like that, it's very
difficult to point a finger at any specific part.

Alan Stern

