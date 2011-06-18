Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1FRQaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 12:30:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45065 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1FRQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 12:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=mDgoeAAKix3P/0knyNRISqhsFb+riAvyJLy6uggck5AEc6a4yNaa6kYmxHFJVkNU1N
         618pvRGzMYC2cq2xk3PlY2PUUknDlhnCWfWpd5uWD4eYXrsvQ02lW15uz0Z2cYebISTb
         y/zuDqf+khBJu94KYjjoTGuCQkq8RH4XJdcI8=
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Sat, 18 Jun 2011 13:29:47 -0300
Message-ID: <BANLkTikAJEma_NNi0NYnjBEB6RkFJK3Dpg@mail.gmail.com>
Subject: i915, framebuffer: wrong xoffset?
To: lkml <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.0-rc1 when booting my computer the text in the fb console is
displayed with a wrong xoffset. I took a picture (sorry for the poor
quality):

http://www.politreco.com/files/IMG_20110610_090045.jpg

It appears that there's a negative xoffset applied when booting the
computer. After starting X and returning to console everything is back
to normal, though.

I started  to bisect this, but there are too many iterations missing:

$ git bisect log
git bisect start
# good: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 2.6.39
git bisect good 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf
# bad: [55922c9d1b84b89cb946c777fddccb3247e7df2c] Linux 3.0-rc1
git bisect bad 55922c9d1b84b89cb946c777fddccb3247e7df2c
# good: [c44dead70a841d90ddc01968012f323c33217c9e] Merge branch
'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git bisect good c44dead70a841d90ddc01968012f323c33217c9e
# bad: [a09ed5e00084448453c8bada4dcd31e5fbfc2f21] vmscan: change
shrink_slab() interfaces by passing shrink_control
git bisect bad a09ed5e00084448453c8bada4dcd31e5fbfc2f21
# good: [9461702d2a54cd4d9da09b7755c96815791a9d07] m68k: let Makefile
sort out compiling mmu and non-mmu lib/checksum.c
git bisect good 9461702d2a54cd4d9da09b7755c96815791a9d07


My card:

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)

dmesg:

[    0.619044] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.619049] i915 0000:00:02.0: setting latency timer to 64
[    0.712209] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    0.712215] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.712216] [drm] Driver supports precise vblank timestamp query.
[    0.764605] composite sync not supported
[    0.765713] fixme: max PWM is zero.
[    0.813774] composite sync not supported
[    0.827331] fbcon: inteldrmfb (fb0) is primary device
[    0.863748] Console: switching to colour frame buffer device 160x50
[    0.866442] fb0: inteldrmfb frame buffer device
[    0.866443] drm: registered panic notifier
[    0.904054] acpi device:06: registered as cooling_device0
[    0.904172] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    0.904179] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.904208] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0


It says "multi-head: yes", but there's no other monitor connected whatsoever.




Any ideas what could be happening?

-- 

Lucas De Marchi
