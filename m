Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab0L2Gvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 01:51:51 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41948 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0L2Gvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 01:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=cVNKrX8vSYCBv6bFY+QJePIkhqj2YpEQZgxTkLy/fofMsnmuWAud2j416daiviTA7j
         RXPPrmsK6i4skVNRGS6yeuI7MkOdviSzrjjr3W3fp4zf5tk1Bz8qUwdCT8BStFmGWO2H
         K0eT5znoZGek2KNZvtt19W1yNRXWD2N2q8PAk=
Date: Wed, 29 Dec 2010 14:51:39 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc8
Message-ID: <Pine.LNX.4.64.1012291435580.10939@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, Dec 29, 2010 at 9:18 AM, Linus Torvalds 
<torvalds@linux-foundation.org> wrote:
> The -rc8 release shouldn't be all that exciting. The most noticeable
> is probably the fact that hopefully the "blank screen" problem with
> intel graphics is fixed. But on the whole, it's all just a collection
> of random fixes all over.

> Chris Wilson (5):
>      drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks


For some reason, this does not work on my Lenovo X201s. Reverting the 
commit solves the "blank screen" problem.


# lspci -v
00:02.0 0300: 8086:0046 (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Core Processor 
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
         Subsystem: Lenovo Device 215a
         Flags: bus master, fast devsel, latency 0, IRQ 42
         Memory at f2000000 (64-bit, non-prefetchable) [size=4M]
         Memory at d0000000 (64-bit, prefetchable) [size=256M]
         I/O ports at 1800 [size=8]
         Expansion ROM at <unassigned> [disabled]
         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Capabilities: [d0] Power Management version 2
         Capabilities: [a4] PCI Advanced Features
         Kernel driver in use: i915
         Kernel modules: i915


# dmesg
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 42 for MSI/MSI-X
vgaarb: device changed decodes: 
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
Console: switching to colour frame buffer device 180x56
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
acpi device:02: registered as cooling_device4
input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0



commit 448f53a1ede54eb854d036abf54573281412d650
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Dec 14 20:06:20 2010 +0000

     drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks

     Fixes the lack of output on the LVDS panel of the Lenovo U160.

     Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=31596
     Reported-and-tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
     Cc: stable@kernel.org
     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index b0b1200..2b20786 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -270,7 +270,7 @@ parse_general_features(struct drm_i915_private *dev_priv,
  					general->ssc_freq ? 66 : 48;
  			else if (IS_GEN5(dev) || IS_GEN6(dev))
  				dev_priv->lvds_ssc_freq =
-					general->ssc_freq ? 100 : 120;
+					general->ssc_freq ? 120 : 100;
  			else
  				dev_priv->lvds_ssc_freq =
  					general->ssc_freq ? 100 : 96;



Thanks,
Jeff

