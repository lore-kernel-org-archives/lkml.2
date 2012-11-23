Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2KWOkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:40:10 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38804 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2KWOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:40:08 -0500
Date: Fri, 23 Nov 2012 15:39:45 +0100
From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Nouveau] Regression on a NV30 card: garbled output
Message-ID: <20121123143945.GA15624@kashmir>
Mail-Followup-To: Mathieu Chouquet-Stringer <mathieu@csetco.com>,
	Ben Skeggs <bskeggs@redhat.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
 3:{EoxBR
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello Ben,

I am here with a regression in the current 3.6 tree.

I just tried the latest tree from Linus (g26d29d0) and while nouveau
does find my card and its two connected displays, the ouput is somewhat
garbled: the colors are way wrong.  For instance, the text console is a
pale green instead of the standard gray and gdm login screen is what
gnome 3 looks like when you're on LSD: flashy with shiny rainbow like colors...

The graphic card is an old Quadro:

05:00.0 VGA compatible controller: NVIDIA Corporation NV37GL [Quadro PCI-E Series] (rev a2) (prog-if 00 [VGA controller])
        Subsystem: NVIDIA Corporation Device 0215
        Flags: bus master, fast devsel, latency 0, IRQ 18
        Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at fa000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [78] Express Legacy Endpoint, MSI 00
        Kernel driver in use: nouveau

On Fedora f18 default kernel, this is what nouveau says (on a plain 3.6 it works too):
[    2.771146] [drm] nouveau 0000:05:00.0: Detected an NV30 generation card (0x034a00b1)
[    2.771854] [drm] nouveau 0000:05:00.0: Checking PRAMIN for VBIOS
[    2.833813] [drm] nouveau 0000:05:00.0: ... appears to be valid
[    2.833927] [drm] nouveau 0000:05:00.0: Using VBIOS from PRAMIN
[    2.834180] [drm] nouveau 0000:05:00.0: BMP BIOS found
[    2.834292] [drm] nouveau 0000:05:00.0: BMP version 5.41
[    2.834405] [drm] nouveau 0000:05:00.0: Bios version 04.34.20.84
[    2.835418] [drm] nouveau 0000:05:00.0: MXM: no VBIOS data, nothing to do
[    2.835544] [drm] nouveau 0000:05:00.0: DCB version 2.2
[    2.835658] [drm] nouveau 0000:05:00.0: DCB outp 00: 01000300 000088b8
[    2.835773] [drm] nouveau 0000:05:00.0: DCB outp 01: 02010310 000088b8
[    2.835888] [drm] nouveau 0000:05:00.0: DCB outp 02: 01000302 00000000
[    2.836015] [drm] nouveau 0000:05:00.0: DCB outp 03: 04010312 00000000
[    2.836257] [drm] nouveau 0000:05:00.0: Parsing VBIOS init table 0 at offset 0xC188
[    2.838484] [drm] nouveau 0000:05:00.0: Parsing VBIOS init table 1 at offset 0xC43D
[    2.838673] [drm] nouveau 0000:05:00.0: Parsing VBIOS init table 2 at offset 0xC583
[    2.838912] [drm] nouveau 0000:05:00.0: Parsing VBIOS init table 3 at offset 0xC70C
[    2.839102] [drm] nouveau 0000:05:00.0: Parsing VBIOS init table 4 at offset 0xC729
[    2.839284] [drm] nouveau 0000:05:00.0: Parsing VBIOS init table 5 at offset 0xC746
[    2.862820] [drm] nouveau 0000:05:00.0: Parsing VBIOS init table 6 at offset 0xC8DF
[    2.863754] [drm] nouveau 0000:05:00.0: Detected 64MiB VRAM (DDR1)
[    2.866037] [drm] nouveau 0000:05:00.0: 128 MiB GART (aperture)
[    2.866260] [drm] nouveau 0000:05:00.0: Saving VGA fonts
[    2.952088] [drm] nouveau 0000:05:00.0: 0 available performance level(s)
[    2.952204] [drm] nouveau 0000:05:00.0: c: core 252MHz memory 405MHz
[    2.952720] [drm] nouveau 0000:05:00.0: MM: using M2MF for buffer copies
[    2.952839] [drm] nouveau 0000:05:00.0: 0xB64D: Parsing digital output script table
[    3.003062] [drm] nouveau 0000:05:00.0: 0xB73A: Parsing digital output script table
[    3.140624] [drm] nouveau 0000:05:00.0: allocated 1280x1024 fb: 0x49000, bo ffff880132e61400
[    3.141106] fbcon: nouveaufb (fb0) is primary device
[    3.153447] [drm] nouveau 0000:05:00.0: 0xB64D: Parsing digital output script table
[    3.216743] [drm] nouveau 0000:05:00.0: 0xB73A: Parsing digital output script table
[    3.270215] fb0: nouveaufb frame buffer device
[    3.270690] [drm] Initialized nouveau 1.0.0 20120316 for 0000:05:00.0 on minor 0
[    3.496449] [drm] nouveau 0000:05:00.0: 0xB64D: Parsing digital output script table
[    3.586118] [drm] nouveau 0000:05:00.0: 0xB73A: Parsing digital output script table

Using the latest git, I get:
[    2.558878] nouveau  [  DEVICE][0000:05:00.0] BOOT0  : 0x034a00b1
[    2.559155] nouveau  [  DEVICE][0000:05:00.0] Chipset: NV34 (NV34)
[    2.559408] nouveau  [  DEVICE][0000:05:00.0] Family : NV30
[    2.560896] nouveau  [   VBIOS][0000:05:00.0] checking PRAMIN for image...
[    2.624127] nouveau  [   VBIOS][0000:05:00.0] ... appears to be valid
[    2.624384] nouveau  [   VBIOS][0000:05:00.0] using image from PRAMIN
[    2.624641] nouveau  [   VBIOS][0000:05:00.0] BMP version 5.29
[    2.625109] nouveau  [   VBIOS][0000:05:00.0] version 04.34.20.84
[    2.629947] nouveau W[  PTIMER][0000:05:00.0] unknown input clock freq
[    2.630235] nouveau  [     PFB][0000:05:00.0] RAM type: DDR1
[    2.630491] nouveau  [     PFB][0000:05:00.0] RAM size: 64 MiB
[    2.634333] nouveau  [     DRM] VRAM: 63 MiB
[    2.634589] nouveau  [     DRM] GART: 128 MiB
[    2.635104] nouveau  [     DRM] BMP BIOS found
[    2.635356] nouveau  [     DRM] BMP version 5.41
[    2.635608] nouveau  [     DRM] Bios version 04.34.20.84
[    2.635861] nouveau  [     DRM] DCB version 2.2
[    2.636123] nouveau  [     DRM] DCB outp 00: 01000300 000088b8
[    2.636377] nouveau  [     DRM] DCB outp 01: 02010310 000088b8
[    2.636631] nouveau  [     DRM] DCB outp 02: 01000302 00000000
[    2.636884] nouveau  [     DRM] DCB outp 03: 04010312 00000000
[    2.637923] nouveau  [     DRM] Saving VGA fonts
[    2.719185] nouveau  [     DRM] 0xB64D: Parsing digital output script table
[    2.769474] nouveau  [     DRM] 0xB73A: Parsing digital output script table
[    2.820886] nouveau  [     DRM] 0 available performance level(s)
[    2.821155] nouveau  [     DRM] c: core 252MHz memory 405MHz
[    2.822667] nouveau  [     DRM] MM: using M2MF for buffer copies
[    2.909675] nouveau  [     DRM] allocated 1280x1024 fb: 0x9000, bo ffff880137aa3000
[    2.910502] fbcon: nouveaufb (fb0) is primary device
[    2.926568] nouveau  [     DRM] 0xB64D: Parsing digital output script table
[    2.990085] nouveau  [     DRM] 0xB73A: Parsing digital output script table

Is there anything I could do to help?  Verbose output?

Cheers,

-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
