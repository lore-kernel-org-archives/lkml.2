Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2JRJyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:54:50 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:38136 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2JRJys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:54:48 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqGVAIPQf1BV5h1yPGdsb2JhbABFiky0awSBABkBAQEBHxkNJ4JOExwjGBEGRiUKGhOICLw9FItEOIUqYAOVaoVyjTQ
X-IronPort-AV: E=Sophos;i="4.80,606,1344204000"; 
   d="scan'208";a="431748413"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 18 Oct 2012 11:58:09 +0200
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [REGRESSION] nouveau: Severe screen corruption on (0xaf, nv50)
Message-ID: <20121018095809.GA336@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 1.7.11.1
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

3.7-rc1 messed up the screen on my MacBookAir3,1 (nv50, 0xaf) pretty
badly. Not surprisingly,

commit 3863c9bc887e9638a9d905d55f6038641ece78d6
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Sat Jul 14 19:09:17 2012 +1000

    drm/nouveau/instmem: completely new implementation, as a subdev module

is the first bad commit. Standing on that commit, booting and then
starting X yields the output below. Hints are especially appreciated,
considering the patch is almost 8000 lines.

Thanks,
Henrik

---

[    0.611281] nouveau 0000:02:00.0: setting latency timer to 64
[    0.611291] nouveau 0000:02:00.0: enabling device (0006 -> 0007)
[    0.611861] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0af100a2
[    0.611869] nouveau  [  DEVICE][0000:02:00.0] Chipset: NVAF
[    0.611876] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    0.616624] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    0.697355] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    0.697364] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    0.697541] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    0.697550] nouveau  [   VBIOS][0000:02:00.0] version 70.89.13.00
[    0.800761] nouveau  [     PFB][0000:02:00.0] RAM type: DDR1
[    0.800807] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    0.819745] [drm] nouveau 0000:02:00.0: Detected an NV50 generation card (0x0af100a2)
[    0.819761] [drm] nouveau 0000:02:00.0: BIT BIOS found
[    0.819767] [drm] nouveau 0000:02:00.0: Bios version 70.89.13.00
[    0.819776] [drm] nouveau 0000:02:00.0: TMDS table version 2.0
[    0.819782] [drm] nouveau 0000:02:00.0: MXM: no VBIOS data, nothing to do
[    0.819789] [drm] nouveau 0000:02:00.0: DCB version 4.0
[    0.819795] [drm] nouveau 0000:02:00.0: DCB outp 00: 040001b6 0f220010
[    0.819801] [drm] nouveau 0000:02:00.0: DCB outp 01: 020112a6 0f220010
[    0.819807] [drm] nouveau 0000:02:00.0: DCB outp 02: 02011262 00020010
[    0.819813] [drm] nouveau 0000:02:00.0: DCB conn 00: 00002047
[    0.819820] [drm] nouveau 0000:02:00.0: DCB conn 01: 00101146
[    0.822388] [drm] nouveau 0000:02:00.0: 512 MiB GART (aperture)
[    2.554491] [drm] nouveau 0000:02:00.0: 4 available performance level(s)
[    2.554502] [drm] nouveau 0000:02:00.0: 0: core 405MHz shader 405MHz memory 405MHz voltage 900mV
[    2.554513] [drm] nouveau 0000:02:00.0: 1: core 450MHz shader 810MHz memory 450MHz voltage 900mV
[    2.554523] [drm] nouveau 0000:02:00.0: 2: core 450MHz shader 810MHz memory 450MHz voltage 900mV
[    2.554533] [drm] nouveau 0000:02:00.0: 3: core 450MHz shader 950MHz memory 450MHz voltage 900mV
[    2.554542] [drm] nouveau 0000:02:00.0: c: core 405MHz shader 810MHz
[    2.780162] [drm] nouveau 0000:02:00.0: MM: using M2MF for buffer copies
[    2.867850] [drm] nouveau 0000:02:00.0: allocated 1366x768 fb: 0x50000, bo ffff88006ec7c800
[    2.924536] fb0: nouveaufb frame buffer device
[    2.924623] [drm] Initialized nouveau 1.0.0 20120316 for 0000:02:00.0 on minor 0
[    6.352282] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.354595] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.356811] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.358992] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.361159] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.363304] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.365415] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.367474] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000438200 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.369537] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.371566] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.373570] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.375544] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.377493] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.379406] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.381281] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.383116] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.384929] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.386689] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.388431] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[    6.390145] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044c1c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
X started here
[   32.614966] nouveau_ratelimit: 1 callbacks suppressed
[   32.614984] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044e800 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615024] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000434800 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615059] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000042f840 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615089] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000440040 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615117] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000440040 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615145] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000440040 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615183] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044e880 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615219] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000432880 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615248] nouveau E[     PFB][0000:02:00.0] trapped write at 0x00004308c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615281] nouveau E[     PFB][0000:02:00.0] trapped write at 0x00004448c0 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615309] nouveau E[     PFB][0000:02:00.0] trapped read at 0x00004440c0 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615338] nouveau E[     PFB][0000:02:00.0] trapped read at 0x00004440c0 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615374] nouveau E[     PFB][0000:02:00.0] trapped write at 0x000044e900 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615403] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000430100 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615440] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000445940 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615475] nouveau E[     PFB][0000:02:00.0] trapped write at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_WRITE/FB reason: VRAM_LIMIT
[   32.615504] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000448140 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615536] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615564] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
[   32.615596] nouveau E[     PFB][0000:02:00.0] trapped read at 0x0000434180 on channel 0x0000fee0 BAR/PFIFO_READ/FB reason: VRAM_LIMIT
