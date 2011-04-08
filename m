Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab1DHQj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:39:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59883 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757035Ab1DHQj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:39:56 -0400
Date: Fri, 8 Apr 2011 12:39:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
In-Reply-To: <BANLkTikJ_mW5DFooGypNB_1MTHXKP9vi2A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104081233280.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Zdenek Kabelac wrote:

> So now I've retested again with my own kernel build - where I've
> disable USB_DEBUG.
> It's somewhat harder to hit the problem - but 2 times I've ended with
> laptop - which
> sent this into  '/var/log/messages'
> 
> [   53.851937] btusb_intr_complete: hci0 urb ffff88011735c300 failed
> to resubmit (19)
> [   53.855223] btusb_bulk_complete: hci0 urb ffff88011735c540 failed
> to resubmit (19)
> [   53.867211] btusb_bulk_complete: hci0 urb ffff88011735c9c0 failed
> to resubmit (19)
> [   53.875279] btusb_send_frame: hci0 urb ffff880117204d80 submission failed
> [   54.127633] systemd[1]: Service bluetooth.target is not needed
> anymore. Stopping.

Evidently the software undock messed up the Bluetooth device somehow.

> These are the last lines catched by serial console:
> 
> [   53.340232] usb 1-1: new full speed USB device number 4 using uhci_hcd
> [   53.505588] usb 1-1: New USB device found, idVendor=0a5c, idProduct=2110
> [   53.513035] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [   53.520876] usb 1-1: Product: BCM2045B
> [   53.524775] usb 1-1: Manufacturer: Broadcom Corp
> [   53.846908] usb 1-1: USB disconnect, device number 4

It's odd that the Bluetooth device should disconnect shortly after
being detected.  However there have been other reports recently about
similar problems with Bluetooth.

> [   53.851937] btusb_intr_complete: hci0 urb ffff88011735c300 failed
> to resubmit (19)
> [   53.855223] btusb_bulk_complete: hci0 urb ffff88011735c540 failed
> to resubmit (19)
> [   53.867211] btusb_bulk_complete: hci0 urb ffff88011735c9c0 failed
> to resubmit (19)
> [   53.875279] btusb_send_frame: hci0 urb ffff880117204d80 submission failed
> [   54.127633] systemd[1]: Service bluetooth.target is not needed
> anymore. Stopping.
> [   54.205292] PM: Syncing filesystems ... done.
> [   54.216056] PM: Preparing system for mem sleep
> 
> And system was 'dead' - (Moon sign on laptop was already blinking at
> this moment)

Why did the system suspend like this?  A software undock shouldn't 
cause a suspend.

> I've strong believe - it's the moment  where USB_DEBUG version was
> printing those lines in endless loop.
> (Or let say it this way:   More then few minutes loop  - as maybe it
> will end within a week - but I don't have that much time to wait ;))

Those debugging messages will continue for as long as the hardware
fails to respond properly.

Alan Stern

