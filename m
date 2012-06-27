Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2F0Tin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:38:43 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:48480 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756230Ab2F0Til (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:38:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Massimo Piccioni <dafastidio@libero.it>
Subject: ALS100: no interrupts in Linux but works fine in DOS
Date: Wed, 27 Jun 2012 21:38:03 +0200
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201206272138.07244.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have a Freetek PRO32PNP card - an ISA card with ALS100 chip and onboard
Crystal wavetable MIDI.
The card works fine as SB16 in DOS - without any initialization utility,
PnP BIOS configures the card to 0x220, irq5, dma1, dma5.

However it does not work in Linux. Driver loads fine (snd-als100, even tried
old OSS sb) but when I try to play anything, the player hangs without
producing any sound. /proc/interrupts show that no interrupts are generated.
Mixer works fine.

The only suspicious thing is "unknown tag 0xff" and "invalid checksum" in
dmesg (this is from patched kernel that shows size of the unknown tag):

[    0.159650] isapnp: Scanning for PnP cards...
[    0.246683] pnp 01:01.00:   dependent set 0 (preferred) io  min 0x220 max 0x220 align 0 size 16 flags 0x2
[    0.246889] pnp 01:01.00:   dependent set 0 (preferred) irq 5 flags 0x1
[    0.247072] pnp 01:01.00:   dependent set 0 (preferred) dma 5 (bitmask 0x20) flags 0x72
[    0.247253] pnp 01:01.00:   dependent set 0 (preferred) dma 1 (bitmask 0x2) flags 0x68
[    0.247872] pnp 01:01.00:   dependent set 1 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x0
[    0.248078] pnp 01:01.00:   dependent set 1 (acceptable) irq 5 7 9 10 flags 0x1
[    0.248265] pnp 01:01.00:   dependent set 1 (acceptable) dma 5 6 7 (bitmask 0xe0) flags 0x72
[    0.248450] pnp 01:01.00:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x68
[    0.248963] pnp 01:01.00:   dependent set 2 (functional) io  min 0x100 max 0x3f0 align 16 size 16 flags 0x0
[    0.249213] pnp 01:01.00:   dependent set 2 (functional) irq 5 7 9 10 11 12 15 flags 0xf
[    0.249404] pnp 01:01.00:   dependent set 2 (functional) dma 0 1 3 5 6 7 (bitmask 0xeb) flags 0x79
[    0.249996] pnp 01:01.01:   independent io  min 0x388 max 0x388 align 0 size 8 flags 0x2
[    0.250535] pnp 01:01.02:   independent io  min 0x200 max 0x200 align 0 size 2 flags 0x2
[    0.251171] pnp 01:01.03:   dependent set 0 (preferred) io  min 0x330 max 0x330 align 0 size 2 flags 0x2
[    0.251365] pnp 01:01.03:   dependent set 0 (preferred) irq 9 flags 0x1
[    0.251984] pnp 01:01.03:   dependent set 1 (acceptable) io  min 0x100 max 0x3f0 align 16 size 2 flags 0x0
[    0.252244] pnp 01:01.03:   dependent set 1 (acceptable) irq 5 7 9 10 11 12 15 flags 0xf
[    0.256256] pnp 01:01.03: unknown tag 0xff (card 1) size=18041, ignored
[    4.527093]  01:01: invalid checksum 0xad
[    4.527257] Switching to clocksource tsc
[    4.528594]  01:01: card 'ALS100 Media Audio Controller'
[    4.528699] isapnp: 1 Plug & Play card detected total

I've even tried to disable Linux pnp completely (noisapnp pnpbios=off) and
load snd-sb16 module manually (modprobe snd-sb16 isapnp=0) with exactly the
same result (everything seems to be OK but there's no sound and interrupts).

Any ideas?

-- 
Ondrej Zary
