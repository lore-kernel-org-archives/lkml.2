Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1L1QuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:50:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47898 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1L1QuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:50:16 -0500
MIME-Version: 1.0
Date: Wed, 28 Dec 2011 12:20:15 -0430
Message-ID: <CAH=dYrHhttmRjkVuo9QvJ5_Uqd+BJGCJJkaMw8153RW1SFv9dA@mail.gmail.com>
Subject: firmware loading failure for AR3011 (0cf3:3000 or 0cf3:3005 ?)
From: Andres Cimmarusti <acimmarusti@gmail.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        641749@bugs.debian.org, info@linuxcertified.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

This is an upstream bug report for known bugs in at least 3 linux distros:

Debian: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=641749
Fedora: https://bugzilla.redhat.com/show_bug.cgi?id=702375

***Steps to reproduce***

- Boot current Debian testing / Fedora 16 / Ubuntu 11.10 (using
kernels 3.1.x and 3.0.x)

***Expected behavior***

- Working bluetooth and no problems in rebooting laptop as occurs
using Ubuntu 11.04 / Fedora 15 and/or Debian Squeeze (using kernels
2.6.38 or newer)

- lsusb reveals this:

Bus 001 Device 004: ID 0cf3:3005 Atheros Communications, Inc. AR3011 Bluetooth

***Actual Result***

- Boot process stalls and fails to load firmware for this Atheros
AR3011 bluetooth module:

[    9.335184] ath3k_load_firmware: Can't change to loading configuration err
[    9.335413] ath3k: probe of 1-1.3:1.0 failed with error -110
[    9.335459] usbcore: registered new interface driver ath3k

- lsusb of the device shows this:

Bus 001 Device 003: ID 0cf3:3000 Atheros Communications, Inc. AR3011
Bluetooth (no firmware)

- After login bluetooth does not work. Furthermore, choosing to
"Restart" the laptop causes it to hang at first pre-bios post screen.

***Things I've tried***

The weird part about this bug is that using Debian squeeze as a base,
I can run the newest kernels (2.6.39, 3.0.x and 3.1.x) and I have no
problems at all. Also the output of lsusb differs substantially from
the working vs broken system. Ubuntu 11.04 and Fedora 15 also work
fine using kernel 2.6.38.

Here is an example dmesg, using kernel 3.0.8 on Squeeze (no problem):

http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=56;filename=dmesg_stable%2B3.0.8.txt;att=2;bug=641749

And here is a similar 3.0.x Debian mainline kernel running on top of
Debian testing (wheezy):

http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=56;filename=dmesg_testing%2B3.0.0-2.txt;att=1;bug=641749

If you browse the Debian bug report link listed at the beginning of
this email, you will also be able to get logs for kernel 3.1.x.
Furthermore, I've tested downgrading the version of udev to the one
found in Debian squeeze (version 164) as well as usb-modeswitch (also
tried upgrading to the latest versions in Debian unstable), but this
has yielded no progress and no clues at all...the error messages
remain the same.

Help debugging this issue would be most welcome.

Best Regards

Andres Cimmarusti

PS: For reference this is a Linux Certified laptop model LC2131, also
known as the Zareason Strata Pro 13 or the ASI SpringPeak 13
