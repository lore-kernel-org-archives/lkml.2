Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961Ab2DOTUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 15:20:11 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:53663 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2DOTUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 15:20:08 -0400
Message-ID: <4F8B1F64.9030502@msgid.tls.msk.ru>
Date: Sun, 15 Apr 2012 23:20:04 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-acpi@vger.kernel.org
Subject: Recent intel Cedarview motherboards: does not poweroff
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Intel produced a set of very nice mini-ITX boards with new Cedarview
Atom CPUs onboard -- D2500CC, D2700MUD, D2800MT etc.  Apparently
all of these boards have issues powering off from linux.

Here's the last few lines left on the screen when the system should
turn the power off:

ACPI: Preparing to enter system sleep state S5
ACPI Error (psargs-8359): [\_SB_.PCI0.LPCB.TPM_.PTS_] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-8537): Method parse/execution failed [\_PTS] (Node f703c504), AE_NOT_FOUND
Disabling non-boot CPUs ...
CPU1 is now offline
SNP alternatives: switching to UP code
Power down.
_


The cursor is blinking, and power staus on.

Is there anything can be done with this?

Thanks!


Besides, these boards have a bios bug which is kinda difficult to work
around if you don't know how.  Even with latest BIOS, the beasts don't
REboot if the active partition is something not FAT/NTFS -- eg, any linux
native filesystem.  It boots fine after power on, but on reboot, instead
of displaying bootloader prompt, the screen becomes blank with cursor
blinking at the upper left corner, and after about 30..40 seconds staying
in this state and not reacting to Ctrl+Alt+Del, the system reboots, ad
infinitum.  One can powercycle the motherboard and it will boot again
(just once again), or it is possible to enter bios settings and save
settings (without changing anything) -- this way it will also boot, but
also just once.  The workaround is to create a small fat16 /boot partition...

Maybe this information will save quite some time and frustration to
someone... ;)

/mjt
