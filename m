Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2I2Exr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 00:53:47 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3722 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2I2Exp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 00:53:45 -0400
Date: Sat, 29 Sep 2012 06:53:42 +0200
From: jurriaan_lkml@rivierenland.xs4all.nl
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Etron usb3 device not detected on Qnap TS 119 P II
Message-ID: <20120929045342.GA17904@qnap.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a situation where a single-bay NAS, the Qnap TS 119 P II in the
newest revision has 2 usb3 ports on the back. When using the 3.6-rc7
kernel (and earlier ones), these ports don't exist. There is no output
with lsusb, and the device doesn't show up with lspci or dmesg. The
directory /sys/devices/pci is empty.

Qnap's own kernel, a patched variety of 2.6.33.2, adds a separate
etcxhci-pci driver that does find the hardware, with vendorid
PCI_VENDOR_ID_ETRON 0x1b6f and PCI_DEVICE_ID_ASROCK_P67 0x7023.

I did notice these ids are in the 3.6-rc7 xhci-pci.c file, so the new
kernel should support the hardware. Contact with Sarah Sharp, the author
of xhci-pci.c, pointed out that Qnap likely did something in the
pci-enumeration code to get the device activated.

This is a armiv5tel device, running a Marvell Feroceon cpu. I have a
serial console cable and can run experimental kernels/patches. What I
would dearly like is some pointers about where to turn on debugging and
what to post here to get find out where things go wrong.

I'm posting it here, since I think it might be more of a general pci
device problem than an usb problem.

Thanks,
Jurriaan
