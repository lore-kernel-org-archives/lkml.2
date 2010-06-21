Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab0FUQZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:25:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55336 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757288Ab0FUQZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:25:31 -0400
Date: Mon, 21 Jun 2010 12:25:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, <gregkh@suse.de>, <rjw@sisk.pl>
Subject: Re: [BISECTED] Suspend regression in v2.6.31 with Lenovo 3000 v200
In-Reply-To: <201006211022.37707.ozan@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.1006211222470.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Ozan [utf-8] Çağlayan wrote:

> Hi,
> 
> First of all I know that 2.6.31 is not maintained anymore and I don't know if 
> the problem still exists in kernels > 2.6.31 as I don't have any hardware to 
> reproduce it.
> 
> The users are just regular users which are not able to test the newer kernels.
> 
> What I've found out is that the following commit broke suspend-to-ram on their
> Lenovo 3000 v200 (2 separate bug reports confirming that reverting fixed the 
> issue):

Can you provide a kernel log showing a failed suspend attempt with 
CONFIG_USB_DEBUG enabled?

> commit 4f0e35f03db2673dc86ee940dcaab5f8f422dc81
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Fri Jan 8 11:18:20 2010 -0500
> 
>     USB: EHCI & UHCI: fix race between root-hub suspend and port resume
> 
>     commit cec3a53c7fe794237b582e8e77fc0e48465e65ee upstream.
> 
>     This patch (as1321) fixes a problem with EHCI and UHCI root-hub
>     suspends: If the suspend occurs while a port is trying to resume, the
>     resume doesn't finish and simply gets lost.  When remote wakeup is
>     enabled, this is undesirable behavior.
> 
>     The patch checks first to see if any port resumes are in progress, and
>     if they are then it fails the root-hub suspend with -EBUSY.
> 
>     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Their dmesg propagates the same error just before suspending and the system 
> instantly resumes back:
> 
> [ 2995.328808] PM: Syncing filesystems ... done.
> [ 2995.417778] Stopping fuse filesystems.
> [ 2995.417786] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 2995.436558] Stopping normal filesystems.
> [ 2995.551470] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) 
> done.
> [ 2995.551558] Suspending console(s) (use no_console_suspend to debug)
> [ 2995.551923] pci 0000:00:02.0: PCI INT A disabled
> [ 2995.591204] btusb_bulk_complete: hci0 urb f1d1e600 failed to resubmit (1)
> [ 2995.592197] btusb_bulk_complete: hci0 urb f1d1e680 failed to resubmit (1)
> [ 2995.593200] btusb_intr_complete: hci0 urb f1d1e580 failed to resubmit (1)
> [ 2995.642091] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [ 2995.642263] sd 0:0:0:0: [sda] Stopping disk
> [ 2996.619560] pm_op(): usb_dev_suspend+0x0/0xf returns -16  	*******
> [ 2996.619562] PM: Device usb2 failed to suspend: error -16  	*******
> [ 2996.619564] PM: Some devices failed to suspend 	 		 	*******
> [ 2996.723535] sd 0:0:0:0: [sda] Starting disk
> 
> and their device usb2 is:
> 
> $ cat /sys/bus/usb/devices/usb2/product
> EHCI Host Controller
> 
> Is it possible that this get fixed in somewhere between v2.6.31.13..HEAD? If 
> yes, can you point me to the relevant commit if possible?

It may have been fixed already, depending on the device responsible.  
Or it may be possible to avoid the problem by changing a setting in
sysfs.  Without the debug information I can't tell.

Alan Stern

