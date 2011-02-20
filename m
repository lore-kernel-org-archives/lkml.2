Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1BTUuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:50:11 -0500
Received: from mail001.aei.ca ([206.123.6.130]:47496 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1BTUuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:50:07 -0500
From: Ed Tomlinson <edt@aei.ca>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: [BUG] usb problems in .38-rc3+
Date: Sun, 20 Feb 2011 15:49:55 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc5-crc+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <201102051417.58953.edt@aei.ca> <20110216184727.GG14085@joana> <201102201209.20799.edt@aei.ca>
In-Reply-To: <201102201209.20799.edt@aei.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102201549.56245.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 February 2011 12:09:20 Ed Tomlinson wrote:
> On Wednesday 16 February 2011 13:47:27 Gustavo F. Padovan wrote:
> > Hi Ed,
> > 
> > * Ed Tomlinson <edt@aei.ca> [2011-02-16 13:38:00 -0500]:
> > 
> > > On Wednesday 16 February 2011 09:00:53 Gustavo F. Padovan wrote:
> > > > Hi Ed,
> > > > 
> > > > * Ed Tomlinson <edt@aei.ca> [2011-02-05 14:17:57 -0500]:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > My bluetooth usb dongle has stopped working in .38-rc3+
> > > > > 
> > > > > Bus 002 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
> > > > > 
> > > > > and in dmesg
> > > > > 
> > > > > [108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
> > > > > [108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
> > > > > [108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > > > > [108652.971977] usb 5-1: USB disconnect, address 3
> > > > > [108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
> > > > > [108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
> > > > > [108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
> > > > > [108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
> > > > > [108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
> > > > > [108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
> > > > > [108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > > > > 
> > > > > Its been working for years here.
> > > > > 
> > > > > Any ideas on what to try or additional info to gather?
> > > > 
> > > > What's the symptom? what do you mean by stopped to work?
> > > 
> > > With .37 kernel my bluetooth apple magicmouse is detected at boot and works as expected & when 
> > > kde 4.6 is active bluedevil sees my bluetooth adaptor.  With .38-rc my bluetooth mouse is not detected
> > > nor does bluedevil see the bluetooth adaptor.
> > > 
> > > > Can you provide me output of "hciconfig -a"?
> > > This gives nothing when the doogle is not plugged (it runs but prints out nothing).
> > > 
> > > > And if possible enable dynamic debug for your kernel, mount the debugfs 
> > > > and then
> > > > 
> > > > echo -n "module btusb +p" > /sys/kernel/debug/dynamic_debug/control
> > > > echo -n "module bluetooth +p" > /sys/kernel/debug/dynamic_debug/control
> > > 
> > > Hey a new debug option to enable!  With it enabled and the system booted with the bluetooth doogle
> > > unpluged here is what happens when it gets plugged (with 38-rc5):
> > > 
> > > grover ed # hciconfig -a
> > > hci0:   Type: BR/EDR  Bus: USB
> > >         BD Address: 00:0A:3A:55:07:5A  ACL MTU: 192:8  SCO MTU: 64:8
> > >         UP RUNNING 
> > >         RX bytes:356 acl:0 sco:0 events:13 errors:0
> > >         TX bytes:53 acl:0 sco:0 commands:13 errors:0
> > >         Features: 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
> > >         Packet type: DM1 DH1 HV1 
> > >         Link policy: 
> > >         Link mode: SLAVE ACCEPT 
> > >         Name: 'grover-0'
> > >         Class: 0x000000
> > >         Service Classes: Unspecified
> > >         Device Class: Miscellaneous, 
> > >         HCI Version: 1.1 (0x1)  Revision: 0x20d
> > >         LMP Version: 1.1 (0x1)  Subversion: 0x20d
> > >         Manufacturer: Cambridge Silicon Radio (10)
> > > 
> > > and the device works.  So either enabling dynamic debug, something between rc4 and rc5 or booting with the
> > > adaptor unplugged makes things work.  Will do some more checking to figure out which.
> > 
> > Great that it is working now. It might be a usb bug that you had, because we
> > had no changes in the Bluetooth subsystem between rc4 and rc5.
> > 
> > But does booting with the adapter work as well?
> 
> I have not been able to get it to work a second time no mater what combo I try - some sort of race I would guess:
> 
> Plugged at boot			fails
> Plugged after boot			fails
> Plugged after, btusb traced	fails
> Plugged after, bluetooth traced	fails
> Plugged after, both traced	fails

Gustavo,

I've figured out how to make things work though I am not sure why it fixes things.  

If I power on my bluetooth devices after running an 'hciconifg -a' they work.  

I can leave the adapter plugged at boot or plug it after.  The important thing seems to
be running the hciconfig before attempting to connect devices.  From the manpage
hciconfig -a should just be a query.  Instead it seems to initialize something and
makes things work here.  

Any idea why?
Ed
