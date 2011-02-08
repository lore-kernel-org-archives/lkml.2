Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1BHCP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:15:26 -0500
Received: from mail001.aei.ca ([206.123.6.130]:43367 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1BHCPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:15:24 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: [BUG] usb problems in .38-rc3+
Date: Mon, 7 Feb 2011 21:15:20 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.37-crc+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <201102051417.58953.edt@aei.ca> <201102071009.51238.oneukum@suse.de> <201102071920.22543.edt@aei.ca>
In-Reply-To: <201102071920.22543.edt@aei.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072115.20858.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 February 2011 19:20:21 Ed Tomlinson wrote:
> On Monday 07 February 2011 04:09:51 Oliver Neukum wrote:
> > Am Samstag, 5. Februar 2011, 20:17:57 schrieb Ed Tomlinson:
> > > Hi,
> > > 
> > > My bluetooth usb dongle has stopped working in .38-rc3+
> > > 
> > > Bus 002 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
> > > 
> > > and in dmesg
> > > 
> > > [108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
> > > [108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
> > > [108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > > [108652.971977] usb 5-1: USB disconnect, address 3
> > > [108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
> > > [108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
> > > [108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
> > > [108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
> > > [108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
> > > [108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
> > > [108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > > 
> > > Its been working for years here.
> > > 
> > > Any ideas on what to try or additional info to gather?
> > 
> > Please test what happens if you disable runtime power management.
> 
> After a pointer from Oliver I booted with usbcore.autosuspend=30000 and verified the device used
> the parm via /sys/bus...   Still did not work.  Bisect or are there some other things to try?

I tried bisecting without much luck.  It started with about 4000 commits to check.  It was still bad
when it reached the first 1000 commits post .37.  Then all boots started crashing.  I think its possible
to restrict a bisect to a directory - if so, what dir should I try?

TIA
Ed
