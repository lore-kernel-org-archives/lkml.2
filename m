Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab0LER2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:28:17 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:54356 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0LER2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:28:16 -0500
Message-ID: <a07a23e9b233db5f3095b8658198311c.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTikbjZXMio0CZ_AYGpi_8784EyWStK9sD23jSZzD@mail.gmail.com>
References: <AANLkTikbjZXMio0CZ_AYGpi_8784EyWStK9sD23jSZzD@mail.gmail.com>
Date: Sun, 5 Dec 2010 18:28:12 +0100 (CET)
Subject: Re: Linux 2.6.37-rc4
From: "Indan Zupancic" <indan@nul.nu>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 897836312160ed0141c32cdc6ac56212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, November 30, 2010 06:36, Linus Torvalds wrote:
>
> So give it a try, and report any regressions you see,

For everyone trying to bisect regressions, beware of the following:

- Bisect doesn't save your old .config.

- When bisecting between 2.6.36 and HEAD there are enough config
  options changed so you have to manually choose new (old) options.
  This means you can't run it fully automatic, because user input
  is needed.

- Somewhere between there and here, the kernel will stop updating
  arch/x86/boot/bzImage. Maybe only if you have CONFIG_KERNEL_LZMA
  set, but still. The result is that you'll be testing the same
  kernel over and over while recompiling for naught, messing up the
  whole bisecting thing. Or something else weird may be going on.

The latter is fixed at least in rc4 (haven't tried earlier kernels),
but it still bites you when bisecting. (Or only me)

Other than, it takes ages to bisect on a slow laptop with an even
slower hard disk, because you throw the whole file cache away after
each reboot. Perhaps I should have installed ccache.

I've also seen internal compiler errors a couple of times. Retrying
did seem to get past it, and I think I only got it with higher -j
options (2, 3, 4), so maybe it's just something running out of memory.
Or it's my laptop getting too stressed out and giving hardware errors,
but I'd say that's unlikely. Could also just be a bug in newer gcc.
Or it's related to whatever causes the bugs I see. I'm too grumpy
to find out.

The regressions I hit are:

https://bugzilla.kernel.org/show_bug.cgi?id=23472
https://bugzilla.kernel.org/show_bug.cgi?id=22672

This on a Thinkpad X40 with Intel 855GM chipset.

As far as I know, the BIOS is the one controlling the backlight on
this laptop, and everything always worked fine. Now the backlight
gets messed up when resuming, and it doesn't turn on until a s2ram
cycle after a "xset dpms force suspend". So it seems that something
started messing with the backlight control while it didn't before,
and it does it wrong.

I'll add a "me too" to those bugzilla's.

xf86-video-intel 2.13 has major problems, so I'm running 2.12, but
that's another problem for another day, and off-topic here.

Good day,

Indan


