Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1C1BBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:01:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1C1BBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:01:34 -0400
Date: Sun, 27 Mar 2011 20:57:27 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, "Ed Tomlinson" <edt@aei.ca>,
        linux-usb@vger.kernel.org
Subject: Re: [Bug #28562] [BUG] usb problems in .38-rc3+
Message-ID: <20110327205727.3abd06b5@katamari>
In-Reply-To: <40UNry85rJN.A.NIF.Hp5jNB@chimera>
References: <lDYNS4ATQ-N.A._aD.9m5jNB@chimera>
	<40UNry85rJN.A.NIF.Hp5jNB@chimera>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Mar 2011 22:27:34 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
> Subject		: [BUG] usb problems in .38-rc3+
> Submitter	: Ed Tomlinson <edt@aei.ca>
> Date		: 2011-02-05 19:17 (51 days old)
> Message-ID	: <201102051417.58953.edt@aei.ca>
> References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2
> 

>From the original report:

[108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
[108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
[108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[108652.971977] usb 5-1: USB disconnect, address 3
[108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
[108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
[108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
[108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
[108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
[108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
[108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0

I just noticed this: the device is claimed by OHCI, then ~150 seconds later(!)
it disconnects and then gets claimed by EHCI, presumably while it's in use.
