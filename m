Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1KVQil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:38:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36647 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753898Ab1KVQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:38:40 -0500
Date: Tue, 22 Nov 2011 11:38:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: [regression 3.1.0 -> 3.20rc] USB Oops
In-Reply-To: <20111122125256.GB32440@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.1111221131170.2466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Norbert Preining wrote:

> Hi all,
> 
> (please Cc)
> 
> running current git kernel (commit f8f5ed7c9) I see this Oops
> when connecting an USB stick:
> [   65.428179] usb 2-1: new high-speed USB device number 2 using ehci_hcd
> [   65.563400] usb 2-1: New USB device found, idVendor=1687, idProduct=3252
> [   65.565004] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   65.566519] usb 2-1: Product: USB2.0 FlashDisk
> [   65.567998] usb 2-1: Manufacturer: Kingmax
> [   65.569460] usb 2-1: SerialNumber: AA04012700039580
> [   66.045924] Initializing USB Mass Storage driver...
> [   66.047551] scsi6 : usb-storage 2-1:1.0
> [   66.049146] usbcore: registered new interface driver usb-storage
> [   66.050606] USB Mass Storage support registered.
> [   67.808567] scsi 6:0:0:0: Direct-Access     Kingmax  USB2.0 FlashDisk 1100 PQ: 0 ANSI: 0 CCS
> [   67.813844] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [   67.821873] sd 6:0:0:0: [sdb] 7471104 512-byte logical blocks: (3.82 GB/3.56 GiB)
> [   67.827475] sd 6:0:0:0: [sdb] Write Protect is off
> [   67.832164] sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
> [   67.837710] sd 6:0:0:0: [sdb] No Caching mode page present
> [   67.842228] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [   67.848325] sd 6:0:0:0: [sdb] No Caching mode page present
> [   67.849838] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [   67.852328] BUG: unable to handle kernel NULL pointer dereference at 00000000000002d9
> [   67.853898] IP: [<ffffffffa0249e6b>] last_sector_hacks.part.2+0x72/0xe0 [usb_storage]

This is odd.  I've never seen a problem in that routine before.

What is "last_sector_hacks.part.2"?  In my kernel source tree there is
a last_sector_hacks() function in drivers/usb/storage/transport.c, but
what does the ".part.2" refer to?

I can't see many places in the routine which might dereference a NULL
pointer.  About the only possibility is the line:

	disk = srb->request->rq_disk;

This would get an error if srb->request was NULL.  Can you add a little
debugging code to test for that case?  If it is NULL, just "goto done".

Alan Stern

