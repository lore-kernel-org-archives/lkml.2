Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0IHPKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:10:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0IHPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=S/PsxYUql/OeRpYyMYXgd7zyZjmqa/BFWtUThOxzWpY8eVqyB/DLDtvjYEcgfE+5kU
         FwA1jzb/OBbMEytBdpoh61t75GRgbFr2yCGXc0NlT0Q3smJDwq9GqJ4D55hjFIpN65rr
         WHjqHGNzyweFi114eMa4zCg5rw2g1tuKGGdbk=
MIME-Version: 1.0
Date: Wed, 8 Sep 2010 11:10:42 -0400
Message-ID: <AANLkTim2mrVRCKg-2couMTFV7krHQp0+2e_cbaiT_KYW@mail.gmail.com>
Subject: [regression] i915 incorrectly detects bogus LVDS connection instead
 of LVDS1
From: Woody Suwalski <terraluna977@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a system where display is connected as LVDS1, however LVDS
seems to be still detectable.
The problem was present in 2.6.31, then fixed in 2.6.32, still working
in 2.6.35, broken in 2.6.36, still broken in 2.6.36-rc3-git1.

from dmesg 2.6.35:
[    0.749174] Linux agpgart interface v0.103
[    0.749231] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
[    0.749555] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.755069] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    0.755395] [drm] Initialized drm 1.1.0 20060810
[    0.755460] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.755475] i915 0000:00:02.0: setting latency timer to 64
[    0.775954] [drm] set up 7M of stolen space
[    1.299163] fbcon: inteldrmfb (fb0) is primary device
[    1.559095] [drm] LVDS-8: set mode 1440x900 c
[    1.827032] Console: switching to colour frame buffer device 180x56
[    1.861877] fb0: inteldrmfb frame buffer device
[    1.861884] registered panic notifier
[    1.861976] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

xrandr on 2.6.35
Screen 0: minimum 320 x 200, current 1440 x 900, maximum 4096 x 4096
VGA1 disconnected (normal left inverted right x axis y axis)
LVDS1 connected 1440x900+0+0 (normal left inverted right x axis y
axis) 0mm x 0mm
   1440x900       60.0*+   59.9
   1360x768       59.8
   1152x864      100.0     85.1     85.0     75.0     75.0     70.0     60.0
   1024x768       85.0     75.0     70.1     60.0
   832x624        74.6
   800x600        85.1     72.2     75.0     60.3     56.2
   640x480        85.0     72.8     75.0     59.9
   720x400        85.0
   640x400        85.1
   640x350        85.1


dmesg on 2.6.36-rc3-git1
[    1.518997] ACPI: Video Device [IGD] (multi-head: yes  rom: no  post: no)
[    1.519266] ERST: Table is not found!
[    1.718700] Linux agpgart interface v0.103
[    1.719778] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
[    1.720594] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    1.726546] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.727743] [drm] Initialized drm 1.1.0 20060810
[    1.728175] [drm] VGACON disable radeon kernel modesetting.
[    1.729679] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.729773] pci 0000:00:02.0: setting latency timer to 64
[    1.816591] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

same xrandr on 2.6.36 - bogus LVDS prebenting LVD1 to run correctly:
Screen 0: minimum 320 x 200, current 800 x 600, maximum 2048 x 2048
VGA disconnected (normal left inverted right x axis y axis)
LVDS connected 800x600+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   840x1050       60.0 +
   832x624        74.6
   800x600        85.1     72.2     75.0     60.3*    56.2
   640x480        85.0     72.8     75.0     59.9
   720x400        85.0
   640x400        85.1
   640x350        85.1
LVDS-1 connected 800x600+0+0 (normal left inverted right x axis y
axis) 0mm x 0mm
   1440x900       60.0 +   59.9
   1360x768       59.8
   1152x864       60.0
   1024x768       60.0
   800x600        60.3*
   640x480        59.9

If I boot "normally" - I get a black screen (maybe crashed?)
I can only boot if "nomodeset=y" is added to the command line... But
then it runs in this 800x600 mode...

Woody
