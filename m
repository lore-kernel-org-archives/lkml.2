Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330Ab1EAT0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 15:26:32 -0400
Received: from kroah.org ([198.145.64.141]:48036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475Ab1EAT0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 15:26:31 -0400
Date: Sun, 1 May 2011 12:27:25 -0700
From: Greg KH <greg@kroah.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        hirofuchi@users.sourceforge.net, arjan.mels@gmx.net, rjw@sisk.pl,
        stern@rowland.harvard.edu, Stanislav SCHATTKE <schattke@linuxbox.cz>
Subject: Re: [regression?] d199c96d41d80a567493e12b8e96ea056a1350c1 breaks
 usbip
Message-ID: <20110501192725.GA28466@kroah.com>
References: <20110501181030.GA9106@nik-comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501181030.GA9106@nik-comp.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 08:10:30PM +0200, Nikola Ciprich wrote:
> Hello,
> we've hit regression introduced by d199c96d41d80a567493e12b8e96ea056a1350c1:
> 
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Mon Jan 31 10:56:37 2011 -0500
> 
>     USB: prevent buggy hubs from crashing the USB stack
>     
>     If anyone comes across a high-speed hub that (by mistake or by design)
>     claims to have no Transaction Translators, plugging a full- or
>     low-speed device into it will cause the USB stack to crash.  This
>     patch (as1446) prevents the problem by ignoring such devices, since
>     the kernel has no way to communicate with them.
>     
>     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>     Tested-by: Perry Neben <neben@vmware.com>
>     CC: <stable@kernel.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> since this commit, trying to use staging/usbip spits message about missing TT:
> 
> [  388.893134] usbip_common_mod: module is from the staging directory, the quality is unknown, you have been warned.
> [  388.898154] usbip_common_mod: usbip common driver1.0
> [  388.905360] vhci_hcd: module is from the staging directory, the quality is unknown, you have been warned.
> [  388.909991] vhci_hcd: vhci_hcd, 1.0
> [  388.912370] usbip: proving...
> [  388.912379] vhci_hcd vhci_hcd: USB/IP Virtual Host Contoroller
> [  388.913052] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 2
> [  388.932339] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [  388.932344] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [  388.932348] usb usb2: Product: USB/IP Virtual Host Contoroller
> [  388.932351] usb usb2: Manufacturer: Linux 2.6.32lb.38 vhci_hcd
> [  388.932354] usb usb2: SerialNumber: vhci_hcd
> [  388.932531] usb usb2: configuration #1 chosen from 1 choice
> [  388.932578] hub 2-0:1.0: USB hub found
> [  388.932587] hub 2-0:1.0: 8 ports detected
> [  478.379036] usbip: rhport(0) sockfd(3) devid(131075) speed(2)
> [  478.379214] usbip: changed 1
> [  478.500048] usbip: changed 0
> [  478.608075] usb 2-1: new full speed USB device using vhci_hcd and address 2
> [  478.608079] usb 2-1: parent hub has no TT
> [  478.720074] usb 2-1: new full speed USB device using vhci_hcd and address 3
> [  478.720078] usb 2-1: parent hub has no TT
> [  478.832086] usb 2-1: new full speed USB device using vhci_hcd and address 4
> [  478.832091] usb 2-1: parent hub has no TT
> [  478.944076] usb 2-1: new full speed USB device using vhci_hcd and address 5
> [  478.944080] usb 2-1: parent hub has no TT
> [  478.944087] hub 2-0:1.0: unable to enumerate USB device on port 1
> 
> I'm not sure whether this is bug in
> d199c96d41d80a567493e12b8e96ea056a1350c1, I guess it might be usbip
> problem.
> Since d199c96d41d80a567493e12b8e96ea056a1350c1 already got into
> -stable, usbip stopped working in 2.6.32.x (and I guess also stable
> and longterm kernels).

This is a usbip problem, we need to set the correct flag for it to work
properly.  I'll look into it tomorrow when I get a chance.

> I also tried 2.6.39-rc5-git4 but usbip seems to be even more broken
> there. Here's dmesg trying to initialize usbip (with debugging
> enabled).
> http://nelide.cz/nik/2.6.39-rc5-git4-usbip-dmesg.txt
> (it's long, so I've uploaded it to web).

I'd recommend posting this to the linux-usb@vger.kernel.org list and
dealing with it as a separate issue.  There have been a number of
changes recently in this driver so perhaps one of them caused the
problem?  Any 'git bisect' work you could do to resolve this would be
appreciated.

thanks,

greg k-h
