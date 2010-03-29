Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0C2Lpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:45:41 -0400
Received: from lucidpixels.com ([75.144.35.66]:46998 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0C2Lpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:45:39 -0400
Date: Mon, 29 Mar 2010 07:45:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <Pine.LNX.4.44L0.1003251646170.1808-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1003290743050.27175@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003251646170.1808-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Alan Stern wrote:

> On Thu, 25 Mar 2010, Justin Piszcz wrote:
>
> No, it all looks normal.  As a check you could compare this with the
> file contents while the mouse is still operating normally.  About the
> only difference should be the "hcca frame" line, which changes
> constantly.
>
> I guess the next test should be to wait for the mouse to stop working,
> unplug the mouse, and then see once again what these files contain.
>
> Alan Stern

Done, here is the output:

BEFORE UNPLUG:

# cat ./kernel/debug/usb/ohci/0000:00:0b.0/periodic
size = 32
  0 [117]: ed8/f674a040 (ls dev2 ep1in-int qlen 1 max 8 00083082)
  1 [ 98]: ed8/f674a0c0 (ls dev3 ep1in-int qlen 1 max 5 00053083)
  8 [117]: ed8/f674a040
  9 [ 98]: ed8/f674a0c0
16 [117]: ed8/f674a040
17 [ 98]: ed8/f674a0c0
24 [117]: ed8/f674a040
25 [ 98]: ed8/f674a0c0

UNPLUG:

# cat ./kernel/debug/usb/ohci/0000:00:0b.0/periodic
size = 32
  0 [117]: ed8/f674a040 (ls dev2 ep1in-int qlen 1 max 8 00083082)
  8 [117]: ed8/f674a040
16 [117]: ed8/f674a040
24 [117]: ed8/f674a040

AFTER PLUG BACK IN:

# cat ./kernel/debug/usb/ohci/0000:00:0b.0/periodic
size = 32
  0 [117]: ed8/f674a040 (ls dev2 ep1in-int qlen 1 max 8 00083082)
  8 [117]: ed8/f674a040
16 [117]: ed8/f674a040
24 [117]: ed8/f674a040

KERNEL MESSAGES:

[   30.569377] usb 2-5:1.0: uevent
[   30.572365] usb 2-6:1.0: uevent
[ 1053.663314] usb usb1: uevent
[ 1053.663404] usb 1-0:1.0: uevent
[ 1053.663455] usb usb2: uevent
[ 1053.663530] usb 2-0:1.0: uevent
[ 1053.663582] usb 2-5: uevent
[ 1053.663656] usb 2-5:1.0: uevent
[ 1053.663706] usb 2-6: uevent
[ 1053.663777] usb 2-6:1.0: uevent
[333937.016444] hub 2-0:1.0: state 7 ports 8 chg 0000 evt 0040
[333937.016453] ohci_hcd 0000:00:0b.0: GetStatus roothub.portstatus [5] = 0x00030300 PESC CSC LSDA PPS
[333937.016458] hub 2-0:1.0: port 6, status 0300, change 0003, 1.5 Mb/s
[333937.016461] usb 2-6: USB disconnect, address 3
[333937.016463] usb 2-6: unregistering device
[333937.016465] usb 2-6: usb_disable_device nuking all URBs
[333937.016472] ohci_hcd 0000:00:0b.0: shutdown urb f6a2d540 ep1in-intr

Justin.

