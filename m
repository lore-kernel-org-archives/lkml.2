Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab2CIWlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:41:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47100 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab2CIWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:41:17 -0500
MIME-Version: 1.0
Date: Fri, 9 Mar 2012 22:41:16 +0000
Message-ID: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
Subject: [advice sought] EOMA68 kernel support
From: lkcl luke <luke.leighton@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i'm looking for some advice and feedback, and potentially a suitable
mentor for a gsoc 2012 applicant.
http://rhombus-tech.net/gsoc2012/ideas/EOMA68_linux_kernel_support/

some background: http://rhombus-tech.net has been set up as a
UK-registered Community Interest Company to act as a bridge between
China-based Mass-volume Product Manufacturing on one hand and Software
(Libre) Developers on the other.  if you are familiar with the
consequences of the rampant GPL violations that are endemic as a
result of the success of cheap android-based hardware, you'll
understand that rhombus-tech is endeavouring to help solve that by
going back to the root of the problem: create hardware that is sold in
mass-volume yet is GPL compliant and developed in consultation with
Free Software Engineers at every step of the way.

also, as previously described here
(http://lkcl.net/linux/modular.computing.architecture.html) and now
formalised as a specification named EOMA-68 here
(http://elinux.org/Embedded_Open_Modular_Architecture/EOMA-68) the
rhombus-tech strategy is to split what was formerly done as a single
"Motherboard" down into to components, one of which is potentially
user hot-swappable: 1) CPU card and 2) I/O Board.

the implications of that split, for the linux kernel source code, are
a bit... scarey :)

1) device-tree on its own isn't enough.  A CPU Card can literally be
removed from one Chassis (a laptop with an SATA Hard Drive, Gigabit
Ethernet, USB WIFI, a USB printer attached and so on) and inserted
into an entirely different Chassis (an LCD monitor with a 1920x1080
screen, with a USB hard drive but maybe no SATA) and then 5 minutes
later removed and put into another (e.g. a MID with a 480x320 LCD, no
Hard Drive and a completely different set of USB WIFI)

2) the EOMA68 interfaces aren't going to change (24-pin RGB/TTL for
LCD, SATA, USB, Ethernet, I2C, 16x GPIO) but there will be *multiple*
types of CPUs some of which will not even exist yet which can plug
into it, none of which we can predict, and they certainly won't all be
ARM processors.

3) the RGB/TTL out has a particular problem associated with it: many
LCD panels simply don't have proper EDID support, but worse than that,
the assumption has always been in the arm-linux kernel and many other
"embedded" systems based around SoCs that there will be one and ONLY
one LCD associated with the product for its entire lifetime, and the
linux kernel support for that product has traditionally reflected that
by hard-coding the LCD panel's parameters into a platform-specific
device driver.  whilst this has moved over to device-tree, device-tree
on its own *still* doesn't help you in this case because the bloody
thing can change!

4) it's worthwhile mentioning that part of the EOMA68 standard
requires that there be an I2C EEPROM (in a fixed address TBD) which
contains the device-tree information that properly describes the
hardware.  but this information not only needs to be read at boot time
but also needs to be read at runtime, dynamically!  it's a removable
card, it's going to get.... removed :)

so... *deep breath*.... where do we even begin to tackle this? :)

as it's - duh - a project which - duh - is intended to be of benefit
to the Software (Libre) Community, obviously (duh) we're asking rather
than telling or working "in secret" which is what would happen with a
Ltd profit-maximising Company.  the priorities are different for a
CIC, so this needs to happen as an open project, but it has _to_
happen.

i figured it would make a great gsoc project, apart from anything
else, and for that to work, it would be great to have an experienced
linux kernel mentor.  bearing in mind that that mentor needs to have a
general overview of the *entire* range of architecture ports for
linux, not just ARM or x86.

thoughts greatly appreciated.

l.
