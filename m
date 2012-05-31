Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2EaQEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:04:15 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:45523 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634Ab2EaQEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:04:14 -0400
Message-ID: <4FC7967B.4010202@msgid.tls.msk.ru>
Date: Thu, 31 May 2012 20:04:11 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: help debugging suspend/resume problem?
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I've an old problem with suspend/resume on a laptop.
The laptop is from 2006, still working fine and is
sufficient, except of one issue which, as far as I
remember, were always present with linux.

Namely, it never resumed properly in linux, starting
with old kernels and up to current 3.4 series.

The hardware is based on NVIDIA C51/MCP51 chipset,
GeForce Go 7600 built-in video card and AMD Turion
X2-64 TL-52 (1.6GHz) CPU.  It is Acer Aspire 9300
laptop.

The system suspends fine - either to RAM or to disk.
But does not resume.  I thought it is a nouveau bug
(but the issue was present before nouveau module
existed), and filed a bugreport against nouveau,
https://bugs.freedesktop.org/show_bug.cgi?id=29766 .
At the time of 2.6.32 and 2.6.38 kernels (in the bugreport),
it was possible to resume the system withe external monitor
connected.  However, now with any 3.x kernels, it does not
resume even with external monitor.

But there's more.

The problem is that during resume, the screen stays blank,
so it is hardly possible to say what the problem is.  The
system does not respond to pings either.  Sometimes it
panikes, as can be said by fast-blinking capslock indicator,
sometimes it does not.

I asked in #nouveau on irc.freenode.net and someone suggested
to try kexec with a crash kernel on panic.  So I did.  And
just once I was able to get working crash kernel -- over
network, since the screen stays blank while the system is
booted crash kernel too, I can't re-enable the screen output
untile real reboot (bios initializes the video card so it
starts showing stuff again).

But I was able to do that just once, and got a elf64 dump
of memory, which - apparently - gdb can't handle (at least
i wasn't able to load the image in gdb, it displays garbage).

Other times, the system does not do anything: it powers on
(the power indicator turns on after I hit "space" key on
the keyboard -- it is suspend to RAM), and nothing happens
at all, no visible indication of what is going on.

Without crash kernel configured, it panicks in a few seconds
usually.  With crash kernel I don't see the caps lock
indicator blinking anymore, but the system does not overheat
as is usual if it "stuck" somewhere - so I can think it is
linux kernel running there.  But it does not react to, say,
capslock or numlock keys.

There's no COM port in this machine, so serial console is
not an option.  I tried netconsole before, but there's no
output in there after last "suspending" messages, ie, no
information at all about resume process.

I tried attaching an USB-to-Ethernet adaptor, but it stays
silent too.

Windows (XP or 7, 32 or 64bits) can suspend/resume just fine
on this machine, to either ram or disk.

Is there any way to debug this issue?

Thank you!

/mjt
