Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab1CRPje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:39:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48635 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756623Ab1CRPj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:39:29 -0400
Date: Fri, 18 Mar 2011 11:39:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-usb@vger.kernel.org, <xfs@oss.sgi.com>,
        <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1103181135190.2391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, Justin Piszcz wrote:

> Hi,
> 
> I can write to just about the entire USB stick, with no errors:
> 
> atom:~# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda2             5.8G  1.5G  4.3G  26% /
> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
> udev                   10M  140K  9.9M   2% /dev
> tmpfs                 2.0G     0  2.0G   0% /dev/shm
> atom:~# cd /
> atom:/# ls
> bin   cdrom  etc   lib    media  nfs  proc  sbin     srv  tmp  var
> boot  dev    home  lib64  mnt    opt  root  selinux  sys  usr
> atom:/# dd if=/dev/zero of=bigfile bs=1M count=4000
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 135.536 s, 30.9 MB/s
> atom:/# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda2             5.8G  5.4G  350M  95% /
> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
> udev                   10M  140K  9.9M   2% /dev
> tmpfs                 2.0G     0  2.0G   0% /dev/shm
> atom:/# rm bigfile
> 
> However, after some amount of time, the errors occur below, is this USB
> stick failing?  Since it has no SMART, is there any other way to verify
> the 'health' of a USB stick?

None that I know of.

> Mar 18 07:55:12 atom [   10.034310] e1000e 0000:03:00.0: eth1: 10/100 speed: disabling TSO
> 
> [ .. no errors .. ]
> 
> Mar 18 08:32:44 atom [ 2261.883848] usb 1-1: USB disconnect, address 2
> Mar 18 08:32:44 atom [ 2261.884465] Buffer I/O error on device sda2, logical block 1317256

The stick didn't "fail" in any obvious way, but for some reason it was
disconnected from the USB bus.  (If it initiated that disconnect by
itself, I guess you could consider that a failure.)  Maybe it was
something as simple as overheating causing a loss of electrical contact
between the connector and the pins in the USB port.

...
> Mar 18 08:33:06 atom [ 2283.963059] usb 1-1: new high speed USB device using ehci_hcd and address 4
> Mar 18 08:33:06 atom [ 2284.080647] usb 1-1: New USB device found, idVendor=0325, idProduct=ac02
> Mar 18 08:33:06 atom [ 2284.080707] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Mar 18 08:33:06 atom [ 2284.080752] usb 1-1: Product: R2_TURBO
> Mar 18 08:33:06 atom [ 2284.080794] usb 1-1: Manufacturer: OCZ Technology
> Mar 18 08:33:06 atom [ 2284.080831] usb 1-1: SerialNumber: (removed)

And then 22 seconds later it reconnected.

Alan Stern

