Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab1GLVUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:20:19 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:50856 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab1GLVUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:20:18 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jul 2011 17:20:17 EDT
Message-ID: <4E1CB962.1000308@tlinx.org>
Date: Tue, 12 Jul 2011 14:15:14 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: device support VGA compat Matrox MGA G200ew
X-Stationery: 0.5.1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was reviewing my kernel config and seeing what devices were
handled by what drivers -- and that all of them were configurable
via kernel devices.

I used an lspci -bkv to show me the kernel driver being used for each 
device.

One that would seem to be of some importance is the graphics controller.
There were some others devs that were 'unclaimed', but don't know
that they have a tangible effect and have yet to try a few
options, so won't bother with them here, but this one is a puzzler:

08:03.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200eW 
WPCM450 (rev 0a) (prog-if 00 [VGA controller])
        Subsystem: Dell PowerEdge T610 MGA G200eW WPCM450
        Flags: bus master, medium devsel, latency 32, IRQ 10
        Memory at d9800000 (32-bit, prefetchable)
        Memory at de7fc000 (32-bit, non-prefetchable)
        Memory at de800000 (32-bit, non-prefetchable)
        Capabilities: [dc] Power Management version 1


I have tried the dev support under the 'frame buffer devs'
for Matrox accel, with ghe G100/G200/... options checked 'on'
(and Matrox I2C support as a module). But that modules doesn't
seem to be attached to this HW.

The only other Matrox G200 related option under the DRM support, but it
says it requires /dev/agpgart to be enabled.  I know the computer doesn't
have an AGP 'slot' (the card is built-in), but is is possible AGP
would still be the choice for the interface?

Other ideas or not-supported?

Thanks!
Linda

