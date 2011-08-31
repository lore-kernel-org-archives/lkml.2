Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1HaKcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:32:25 -0400
Received: from smtp6.freeserve.com ([193.252.22.190]:16727 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1HaKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:32:24 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Aug 2011 06:32:24 EDT
X-ME-UUID: 20110831102317253.3DF087000088@mwinf3632.me.freeserve.com
Date: Wed, 31 Aug 2011 11:23:11 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: nouveau regression in 3.1-rc4
Message-ID: <20110831112311.534d68d5@boulder.homenet>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nouveau graphics driver has a regression in 3.1-rc4 on my ancient
nvidia GeForce2 MX/MX 400 card.  It works OK in kernel 3.0.4 (I have
not tested with earlier versions of 3.1-rc).

The following is logged to syslog:

grep nouveau /var/log/syslog
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
Aug 31 11:06:35 boulder kernel: IP: [<e0ba3f17>] nouveau_bo_vma_add+0xd/0xa8 [nouveau]
Aug 31 11:06:35 boulder kernel: Modules linked in: nouveau(+) snd_emu10k1 snd_rawmidi fbcon snd_ac97_codec ac97_bus tileblit snd_pcm font bitblit ttm snd_seq_device softcursor snd_timer drm_kms_helper uhci_hcd snd_page_alloc snd_util_mem drm snd_hwdep snd ehci_hcd soundcore i2c_algo_bit parport_pc processor thermal_sys parport hwmon 8139too mii i2c_core mxm_wmi wmi button sr_mod sg cdrom intel_agp intel_gtt evdev agpgart
Aug 31 11:06:35 boulder kernel: EIP is at nouveau_bo_vma_add+0xd/0xa8 [nouveau]
Aug 31 11:06:35 boulder kernel:  [<e0ba4bae>] ? nouveau_fence_channel_init+0x4b/0x1da [nouveau]
Aug 31 11:06:35 boulder kernel:  [<e0ba2447>] ? nouveau_dma_init+0x247/0x280 [nouveau]
Aug 31 11:06:35 boulder kernel:  [<e0b9db06>] ? nouveau_channel_alloc+0x355/0x5a2 [nouveau]
Aug 31 11:06:35 boulder kernel:  [<e0b9c759>] ? nouveau_card_init+0xf34/0x1085 [nouveau]
Aug 31 11:06:35 boulder kernel:  [<e0b9ccc6>] ? nouveau_load+0x355/0x60c [nouveau]
Aug 31 11:06:35 boulder kernel: EIP: [<e0ba3f17>] nouveau_bo_vma_add+0xd/0xa8 [nouveau] SS:ESP 0068:df7a7cc8

The following is logged to messages:

grep nouveau /var/log/messages
Aug 31 11:06:35 boulder kernel: nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Detected an NV10 generation card (0x011000b2)
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: ... appears to be valid
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: BMP BIOS found
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: BMP version 5.20
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Bios version 03.11.01.30
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 1.5
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Raw DCB entry 0: f0003f00 000088b8
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Raw DCB entry 1: f2204001 ffffffff
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Raw DCB entry 2: f2244001 ffffffff
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xAB70
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xB25E
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xAB8B
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xB205
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xAC1E
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 5 at offset 0xAD72
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 6 at offset 0xAC43
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 7 at offset 0xAD0D
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: 0 available performance level(s)
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: c: memory 334MHz core 174MHz
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Detected 64MiB VRAM
Aug 31 11:06:35 boulder kernel: nouveau 0000:01:00.0: putting AGP V2 device into 4x mode
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: 128 MiB GART (aperture)
Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Saving VGA fonts


