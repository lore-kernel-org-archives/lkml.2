Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab1DHSRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:17:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35201 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab1DHSRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JWvESg4lT/dGp3EVYiGyIdUQ6YOJ9b/38kJfAuI2L86kt13Np6iBuMkF1t6SdDQHmY
         e3Sh3CHQ6l9Ju1kDlrN9hqUD6WUdw4A209sAbU50G+ZfDWvj8hxB9CaY4NTiCSRvOgxj
         BBjdtWwHcb6jWhGrVewwTssRySnSxpLVf402E=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1104081233280.1992-100000@iolanthe.rowland.org>
References: <BANLkTikJ_mW5DFooGypNB_1MTHXKP9vi2A@mail.gmail.com>
	<Pine.LNX.4.44L0.1104081233280.1992-100000@iolanthe.rowland.org>
Date: Fri, 8 Apr 2011 20:17:37 +0200
Message-ID: <BANLkTikwsDtEgA4c55BSFcvh=kjM84c7JQ@mail.gmail.com>
Subject: Re: Endless print of uhci_result_common: failed with status 440000
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Alan Stern <stern@rowland.harvard.edu>:
> On Fri, 8 Apr 2011, Zdenek Kabelac wrote:
>
>> So now I've retested again with my own kernel build - where I've
>> disable USB_DEBUG.
>> It's somewhat harder to hit the problem - but 2 times I've ended with
>> laptop - which
>> sent this into  '/var/log/messages'
>>
>> [   53.851937] btusb_intr_complete: hci0 urb ffff88011735c300 failed
>> to resubmit (19)
>> [   53.855223] btusb_bulk_complete: hci0 urb ffff88011735c540 failed
>> to resubmit (19)
>> [   53.867211] btusb_bulk_complete: hci0 urb ffff88011735c9c0 failed
>> to resubmit (19)
>> [   53.875279] btusb_send_frame: hci0 urb ffff880117204d80 submission failed
>> [   54.127633] systemd[1]: Service bluetooth.target is not needed
>> anymore. Stopping.
>
> Evidently the software undock messed up the Bluetooth device somehow.
>
>> These are the last lines catched by serial console:
>>
>> [   53.340232] usb 1-1: new full speed USB device number 4 using uhci_hcd
>> [   53.505588] usb 1-1: New USB device found, idVendor=0a5c, idProduct=2110
>> [   53.513035] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> [   53.520876] usb 1-1: Product: BCM2045B
>> [   53.524775] usb 1-1: Manufacturer: Broadcom Corp
>> [   53.846908] usb 1-1: USB disconnect, device number 4
>
> It's odd that the Bluetooth device should disconnect shortly after
> being detected.  However there have been other reports recently about
> similar problems with Bluetooth.
>

Most probably because I've run  in the loop

while : ; do pm-suspend ; sleep 5; done

for debug purposes...


>> [   53.851937] btusb_intr_complete: hci0 urb ffff88011735c300 failed
>> to resubmit (19)
>> [   53.855223] btusb_bulk_complete: hci0 urb ffff88011735c540 failed
>> to resubmit (19)
>> [   53.867211] btusb_bulk_complete: hci0 urb ffff88011735c9c0 failed
>> to resubmit (19)
>> [   53.875279] btusb_send_frame: hci0 urb ffff880117204d80 submission failed
>> [   54.127633] systemd[1]: Service bluetooth.target is not needed
>> anymore. Stopping.
>> [   54.205292] PM: Syncing filesystems ... done.
>> [   54.216056] PM: Preparing system for mem sleep
>>
>> And system was 'dead' - (Moon sign on laptop was already blinking at
>> this moment)
>
> Why did the system suspend like this?  A software undock shouldn't
> cause a suspend.

pm-suspend - with  script executed on suspend which undocks laptop
(otherwise when I'd forget to press button on docking station before
suspend - it would stay 'red' mode - thus all buses are connected -
and as I've noticed in past - it's not working well, when I unplug
laptop in this 'still connected'  mode - so this software 'undock'
solved this problem)


>
>> I've strong believe - it's the moment  where USB_DEBUG version was
>> printing those lines in endless loop.
>> (Or let say it this way:   More then few minutes loop  - as maybe it
>> will end within a week - but I don't have that much time to wait ;))
>
> Those debugging messages will continue for as long as the hardware
> fails to respond properly.

Which is probably 'forever' when the machine is suspending.
(note - even SysRq+B  no longer works at this moment)

Zdenek
