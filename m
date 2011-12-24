Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1LXUgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 15:36:20 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47961 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1LXUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 15:36:18 -0500
MIME-Version: 1.0
Date: Sat, 24 Dec 2011 22:36:17 +0200
Message-ID: <CABhjJhOgTKDif9cpgGs2EpYLvM1AJ7+t-rYCLBoRMp7zSykA_g@mail.gmail.com>
Subject: gma500: Attempting to load psb_gfx causes NULL pointer dereference error
From: "Dainius (GreatEmerald)" <pastas4@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attempting to launch a Linux system with any kernel version with
psb_gfx, I always get an error at boot time. The error includes these
lines:

    ioremap error for 0x7f579000-0x7f57a000, requested 0x10, got 0x0
    BUG: unable to handle kernel NULL pointer dereference at   (null)
    Oops: 0000 [#1] SMP

The full error message and a stack trace can be found here:
On openSUSE with kernel 3.1.0 - http://pastebin.com/raw.php?i=ABfX7rJQ
On Kubuntu with kernel 3.2.0 - http://paste.ubuntu.com/781414/

The device I'm using is running on the Oak Trail platform (it's a
Fujitsu Stylistic Q550 tablet).

One strange thing about it is if I try to boot the system with the
vga=0x318 option, it throws me this error on boot, but it still loads
the X server, although with the non-native resolution and seemingly
without backlight control and other features. It still seems that the
psb_gfx driver is running, however, since lsmod lists it and fbdev
seems to be running. And if I don't pass the vga option, the X server
crashes, complaining about /dev/fb0 not existing and fbdev failing to
load.
