Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1AVJfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 04:35:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58439 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab1AVJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 04:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=vc6dBdlvGctXPVhyiPZZXHdbuu0FqVY3NPznW0QOyvrvbbsKh6RauxjveyPJb8Qp01
         U5aGa9i0aDawVpAe8Foq+uwVJASWYEoL86V6avwsjn0K01aDxU2QVHrTBQNMCIIkHvi7
         u0yXRmmBhX+kBOkJwGABjjHPZVgQDOMq0PLVQ=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: DRM BUG - X fails to start with 2.6.38-rc2+
Date: Sat, 22 Jan 2011 09:35:03 +0000
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101220935.03623.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not subscribed, so please cc me on any reply,

I've built and installed the latest -git kernel (pulled this morning) and X 
fails to start.  I see the grey X background and, for a split second, what 
looks like the kdm login dialogue box appears before disappearing again. Then 
the screen goes black and the monitor goes into power saving made. I can't 
access consoles with Alt-Fn - the machine is effectively locked and can be 
rcovered only by powering off and then on again.

The only diagnostics I can find in the logs is at the end of/var/log/kernel:

Jan 22 08:20:08 upstairs kernel: r8169 0000:02:00.0: eth0: link up
Jan 22 08:20:17 upstairs kernel: [drm] Initialized drm 1.1.0 20060810
Jan 22 08:20:19 upstairs kernel: pci 0000:00:02.0: PCI INT A -> GSI 16 (level, 
low) -> IRQ 16
Jan 22 08:20:19 upstairs kernel: pci 0000:00:02.0: setting latency timer to 64
Jan 22 08:20:19 upstairs kernel: ioremap error for 0xbdce0000-0xbdce3000, 
requested 0x10, got 0x0
Jan 22 08:20:19 upstairs kernel: [drm] Supports vblank timestamp caching Rev 1 
(10.10.2010).
Jan 22 08:20:19 upstairs kernel: [drm] Driver supports precise vblank timestamp 
query.
Jan 22 08:20:19 upstairs kernel: [drm] Initialized i915 1.6.0 20080730 for 
0000:00:02.0 on minor 0
Jan 22 08:20:37 upstairs kernel: BUG: unable to handle kernel NULL pointer 
dereference at 00000194
Jan 22 08:20:37 upstairs kernel: IP: [<f87c1aae>] 
drm_calc_vbltimestamp_from_scanoutpos+0x3e/0x4b0 [drm]

/var/log/Xorg.0.log appears not to have been written to because it contains what 
appears to be only random data rather than the usual text.

The graphics-related lspci output shows:

00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset Integrated 
Graphics Controller (rev 03) (prog-if 00 [VGAcontroller])
        Subsystem: Giga-byte Technology Device d000
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at e1000000 (64-bit, non-prefetchable) [size=4M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        I/O ports at e000 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Capabilities: [a4] PCI Advanced Features

00:02.1 Display controller: Intel Corporation 4 Series Chipset Integrated 
Graphics Controller (rev 03)
        Subsystem: Giga-byte Technology Device d000
        Flags: bus master, fast devsel, latency 0
        Memory at e1400000 (64-bit, non-prefetchable) [size=1M]
        Capabilities: [d0] Power Management version 2

All works fine with 2.6.37 .

Please let me know if any additional diagnostics are needed or if you want any 
patches testing.

Thanks in advance

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
