Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0KYUZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 15:25:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:32949 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751941Ab0KYUZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 15:25:11 -0500
Date: Thu, 25 Nov 2010 15:25:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Nobody cared about IRQs at shutdown
In-Reply-To: <4CEE8B67.2050701@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1011251522380.26094-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:

> 25.11.2010 21:06, Alan Stern wrote:
> > On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:
> >
> >> Hello.
> >>
> >> After switching my Gentoo desktop from sysvinit + openrc to systemd, I
> >> started getting "nobody cared" messages about IRQs 16 and 19 (common
> >> thing: they are assigned to the USB controllers, that's why CC:
> > According to your listing, they are used by uhci-hcd.  Do the messages
> > go away if you unload uhci-hcd before shutting down?
> 
> It is not a module here, so I have to recompile the kernel in order to 
> try this. Will do that tomorrow.
> 
> > You may need to debug the uhci-hcd driver. Look into
> > drivers/usb/host/uhci-hcd.c; the uhci_shutdown() routine ought to be
> > called and it ought to call uhci_hc_died(), which in turn calls
> > uhci_reset_hc() in pci-quirks.c, which is supposed to prevent the
> > controller from generating any IRQs.
> 
> OK, tomorrow I will add some printks there.
> 
> > Do you have any USB devices attached to bus 3 or bus 6?
> 
> Yes:
> 
> Bus 006 Device 002: ID 05d8:4002 Ultima Electronics Corp. Artec Ultima 
> 2000 (GT6801 based)/Lifetec LT9385/ScanMagic 1200 UB Plus Scanner
> 
> Should I unplug it and retest the bug now?

Sure.

Even without rebuilding the kernel, you can unbind the uhci-hcd driver 
from the hardware by going to the /sys/bus/pci/drivers/uhci_hcd 
directory and doing:

	echo -n device-name >unbind

where "device-name" is the name of one of the symlinks in that 
directory.

Alan Stern

