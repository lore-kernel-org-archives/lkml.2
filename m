Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab2AZHNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 02:13:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37839 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2AZHNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 02:13:10 -0500
MIME-Version: 1.0
From: Andrey Moshbear <andrey.vul@gmail.com>
Date: Thu, 26 Jan 2012 02:12:48 -0500
Message-ID: <CAFnZeoTz+RN9PDdfqR=JzsO6kSWVB_iZcLK2cfi2Le99mgZATg@mail.gmail.com>
Subject: screen lockup after modprobe nouveau on kernel 3.1.6
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After running modprobe nouveau, the screen locks up into a gabled
mess.  Using a ssh shell, I was able to get the following from the
dmesg log:

[  156.304733] [drm] Initialized drm 1.1.0 20060810
[  156.364954] nouveau 0000:01:00.0: setting latency timer to 64
[  156.367223] [drm] nouveau 0000:01:00.0: Detected an NV50 generation
card (0x096400a1)
[  156.371425] [drm] nouveau 0000:01:00.0: Attempting to load BIOS
image from PRAMIN
[  156.460255] [drm] nouveau 0000:01:00.0: ... appears to be valid
[  156.460259] [drm] nouveau 0000:01:00.0: BIT BIOS found
[  156.460261] [drm] nouveau 0000:01:00.0: Bios version 62.94.3c.00
[  156.460264] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[  156.460266] [drm] nouveau 0000:01:00.0: Found Display Configuration
Block version 4.0
[  156.460268] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000323 00010034
[  156.460270] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02011300 00000028
[  156.460272] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02022312 00020010
[  156.460274] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000
[  156.460277] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[  156.460279] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40
idx 0 tag 0xff
[  156.460282] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00
idx 1 tag 0xff
[  156.460284] [drm] nouveau 0000:01:00.0:   2: 0x00002261: type 0x61
idx 2 tag 0x08
[  156.460287] [drm] nouveau 0000:01:00.0:   3: 0x00000310: type 0x10
idx 3 tag 0xff
[  156.460289] [drm] nouveau 0000:01:00.0:   4: 0x00000311: type 0x11
idx 4 tag 0xff
[  156.460291] [drm] nouveau 0000:01:00.0:   5: 0x00000313: type 0x13
idx 5 tag 0xff
[  156.460295] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0
at offset 0xD101
[  156.485939] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1
at offset 0xD4F2
[  156.489291] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2
at offset 0xE542
[  156.489300] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3
at offset 0xE68B
[  156.490387] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4
at offset 0xE8F3
[  156.490390] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at
offset 0xE958
[  156.510395] [drm] nouveau 0000:01:00.0: 0xE958: Condition still not
met after 20ms, skipping following opcodes
[  156.529778] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[  156.529783] [drm] nouveau 0000:01:00.0: 0: memory 100MHz core
169MHz shader 338MHz voltage 890mV fanspeed 100% timing 0
[  156.529787] [drm] nouveau 0000:01:00.0: 1: memory 250MHz core
275MHz shader 550MHz voltage 890mV fanspeed 100% timing 1
[  156.529791] [drm] nouveau 0000:01:00.0: 2: memory 400MHz core
400MHz shader 800MHz voltage 890mV fanspeed 100% timing 2
[  156.529811] [drm] nouveau 0000:01:00.0: c: memory 249MHz core
275MHz shader 550MHz voltage 890mV
[  156.532624] [TTM] Zone  kernel: Available graphics memory: 2023286 kiB.
[  156.532626] [TTM] Initializing pool allocator.
[  156.532636] [drm] nouveau 0000:01:00.0: Detected 1024MiB VRAM
[  156.532642] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[  156.532657] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[  156.535144] [drm] nouveau 0000:01:00.0: ACPI backlight interface
available, not registering our own
[  156.536197] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[  156.536199] [drm] No driver support for vblank timestamp query.
[  156.655035] [drm] nouveau 0000:01:00.0: VM: trapped write at
0x0001694ec0 on ch 0 [0x00000050] BAR/PFIFO_WRITE/IN reason:
PAGE_NOT_PRESENT
[  156.704584] [drm] nouveau 0000:01:00.0: allocated 1680x1050 fb:
0x310000, bo ffff880138d19000
[  156.704624] fbcon: nouveaufb (fb1) is primary device
[  156.704633] fbcon: Remapping primary device, fb1, to tty 1-63
[  158.255801] [drm] nouveau 0000:01:00.0: unknown PDISPLAY_INTR_1: 0x00000100
[  159.765988] fb1: nouveaufb frame buffer device
[  159.765990] drm: registered panic notifier
[  159.765994] [drm] Initialized nouveau 0.0.16 20090420 for
0000:01:00.0 on minor 0

Kernel is 3.1.6, with .config located at http://pastebin.com/mfMAkYYR
and lspci -vv at http://pastebin.com/Jf78wz7N .
