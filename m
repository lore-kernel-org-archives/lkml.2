Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0L2KZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 05:25:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43344 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab0L2KZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 05:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U0QhkrYcZYmMrPyyAZULJoWuogDZBCQLYN1UZ6ECPQjRsOp/pkFyO/4CGQX6qnHah5
         GpVpH2QqGSMwNiW90W/b9ocNw0I134RSIUNtE+geL8BlelmegcHdCzqx+BO+MNOauZ3e
         XRKrfGf70uYyP4MwZO1WUKvNQ19lppNd8WX9w=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1012291435580.10939@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1012291435580.10939@boston.corp.fedex.com>
Date: Wed, 29 Dec 2010 11:25:30 +0100
Message-ID: <AANLkTi=qRmRGCff_8_t-VyOjcP0pcFLxA-Y+XYdcoPOo@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8
From: Alex Riesen <raa.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 07:51, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Wed, Dec 29, 2010 at 9:18 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> The -rc8 release shouldn't be all that exciting. The most noticeable
>> is probably the fact that hopefully the "blank screen" problem with
>> intel graphics is fixed. But on the whole, it's all just a collection
>> of random fixes all over.
>
>> Chris Wilson (5):
>>     drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
>
>
> For some reason, this does not work on my Lenovo X201s. Reverting the commit
> solves the "blank screen" problem.
>

-rc8 does not fix the problem for this Dell XPS M1330 (GM965/GL960) too.

> # lspci -v

00:02.0 VGA compatible controller: Intel Corporation Mobile
GM965/GL960 Integrated Graphics Controller (rev 0c)
	Subsystem: Dell Device 0209
	Flags: bus master, fast devsel, latency 0, IRQ 40
	Memory at f6e00000 (64-bit, non-prefetchable) [size=1M]
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at eff8 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
	Capabilities: [d0] Power Management version 3
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 0c)
	Subsystem: Dell Device 0209
	Flags: bus master, fast devsel, latency 0
	Memory at f6f00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3

> # dmesg

I afraid mine is not as full as Jeff's, but here it is:

[    0.376455] Linux agpgart interface v0.103
[    0.376717] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.376960] agpgart-intel 0000:00:00.0: detected gtt size: 524288K
total, 262144K mappable
[    0.377981] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.381891] ACPI: Battery Slot [BAT0] (battery present)
[    0.385140] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.385283] [drm] Initialized drm 1.1.0 20060810
[    0.385328] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.385358] i915 0000:00:02.0: setting latency timer to 64
[    0.414146] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.630199] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.630554] [drm] initialized overlay support
[    0.914282] Console: switching to colour frame buffer device 160x50
[    0.916905] fb0: inteldrmfb frame buffer device
[    0.916928] drm: registered panic notifier
[    0.929874] acpi device:35: registered as cooling_device2
[    0.930341] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/LNXVIDEO:01/input/input3
[    0.930395] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    0.930446] [Firmware Bug]: Duplicate ACPI video bus devices for
the same VGA controller, please try module parameter
"video.allow_duplicates=1"if the current driver doesn't work.
[    0.930573] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

> commit 448f53a1ede54eb854d036abf54573281412d650
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Tue Dec 14 20:06:20 2010 +0000
>
>    drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks

Reverting this commit does not change anything on the laptop.
Still blank (well, no backlight) after DPMS suspend. I use this
line to test:

  $ xset dpms force standby; sleep 1; xset dpms force on

The screen is always back on in 2.6.35 and always comes back with
backlight off in 2.6.36.
