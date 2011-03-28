Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1C1C2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:28:31 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42345 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753271Ab1C1C23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:28:29 -0400
Date: Sun, 27 Mar 2011 22:28:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Chuck Ebbert <cebbert@redhat.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Ed Tomlinson <edt@aei.ca>,
        <linux-usb@vger.kernel.org>
Subject: Re: [Bug #28562] [BUG] usb problems in .38-rc3+
In-Reply-To: <20110327205727.3abd06b5@katamari>
Message-ID: <Pine.LNX.4.44L0.1103272226260.10807-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Mar 2011, Chuck Ebbert wrote:

> On Sun, 27 Mar 2011 22:27:34 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
> > Subject		: [BUG] usb problems in .38-rc3+
> > Submitter	: Ed Tomlinson <edt@aei.ca>
> > Date		: 2011-02-05 19:17 (51 days old)
> > Message-ID	: <201102051417.58953.edt@aei.ca>
> > References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2
> > 
> 
> From the original report:
> 
> [108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
> [108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
> [108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [108652.971977] usb 5-1: USB disconnect, address 3
> [108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
> [108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
> [108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
> [108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
> [108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
> [108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
> [108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> 
> I just noticed this: the device is claimed by OHCI, then ~150 seconds later(!)
> it disconnects and then gets claimed by EHCI, presumably while it's in use.

Probably what happened is that Ed unplugged the device after 150
seconds of non-operation, and then four seconds later plugged it into
an external high-speed hub.

Alan Stern

