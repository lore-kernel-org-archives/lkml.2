Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab1LYAJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 19:09:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42397 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1LYAJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 19:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <CABhjJhOgTKDif9cpgGs2EpYLvM1AJ7+t-rYCLBoRMp7zSykA_g@mail.gmail.com>
References: <CABhjJhOgTKDif9cpgGs2EpYLvM1AJ7+t-rYCLBoRMp7zSykA_g@mail.gmail.com>
Date: Sun, 25 Dec 2011 01:09:41 +0100
Message-ID: <CAMeQTsZFhWi5WNTrS0=OMibtPJpv-8EQq7ZN=+Ar3F8qN8iqsQ@mail.gmail.com>
Subject: Re: gma500: Attempting to load psb_gfx causes NULL pointer
 dereference error
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: "Dainius (GreatEmerald)" <pastas4@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 9:36 PM, Dainius (GreatEmerald)
<pastas4@gmail.com> wrote:
> When attempting to launch a Linux system with any kernel version with
> psb_gfx, I always get an error at boot time. The error includes these
> lines:
>
>    ioremap error for 0x7f579000-0x7f57a000, requested 0x10, got 0x0
>    BUG: unable to handle kernel NULL pointer dereference at   (null)
>    Oops: 0000 [#1] SMP
>
> The full error message and a stack trace can be found here:
> On openSUSE with kernel 3.1.0 - http://pastebin.com/raw.php?i=ABfX7rJQ
> On Kubuntu with kernel 3.2.0 - http://paste.ubuntu.com/781414/
>
> The device I'm using is running on the Oak Trail platform (it's a
> Fujitsu Stylistic Q550 tablet).
>
> One strange thing about it is if I try to boot the system with the
> vga=0x318 option, it throws me this error on boot, but it still loads
> the X server, although with the non-native resolution and seemingly
> without backlight control and other features. It still seems that the
> psb_gfx driver is running, however, since lsmod lists it and fbdev
> seems to be running. And if I don't pass the vga option, the X server
> crashes, complaining about /dev/fb0 not existing and fbdev failing to
> load.

Could this be a vesa driver clash? Try blacklisting vesafb and make sure
X is using the fbdev driver. Vesa and psb_gfx doesn't play well together.

Patrik
