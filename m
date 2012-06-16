Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab2FPMel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 08:34:41 -0400
Received: from mx.techhouse.brown.edu ([138.16.60.3]:38151 "EHLO
	mx.techhouse.brown.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2FPMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 08:34:40 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2012 08:34:39 EDT
Date: Sat, 16 Jun 2012 08:26:48 -0400
From: David Feuer <dfeuer@techhouse.org>
To: linux-kernel@vger.kernel.org
Subject: Kernel bug logged
Message-ID: <20120616122648.GA11023@techhouse.brown.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dfeuer@Lemur ~ $ uname -a
Linux Lemur 3.4.0-030400-generic #201205210521 SMP Mon May 21 09:22:02 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

I was attempting to perform a system backup at the time, and the CPU temperature had been going up into the high range and back down, causing the kernel to throttle and unthrottle the CPU a few times. I believe it was unthrottled when the following occurred:

Just before the error occurred:

Jun 16 07:43:22 Lemur kernel: [390212.779448] iwlwifi 0000:02:00.0: FH register values:
Jun 16 07:43:22 Lemur kernel: [390212.779487] iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1eae4000
Jun 16 07:43:22 Lemur kernel: [390212.779523] iwlwifi 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01eae0e0
Jun 16 07:43:22 Lemur kernel: [390212.779543] iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000078
Jun 16 07:43:22 Lemur kernel: [390212.779563] iwlwifi 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
Jun 16 07:43:22 Lemur kernel: [390212.779577] iwlwifi 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jun 16 07:43:22 Lemur kernel: [390212.779591] iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Jun 16 07:43:22 Lemur kernel: [390212.779605] iwlwifi 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jun 16 07:43:22 Lemur kernel: [390212.779624] iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jun 16 07:43:22 Lemur kernel: [390212.779645] iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000

When the error occurred:

Jun 16 07:43:22 Lemur kernel: [390212.779661] ------------[ cut here ]------------
Jun 16 07:43:22 Lemur kernel: [390212.779690] kernel BUG at /home/apw/COD/linux/mm/slub.c:3471!
Jun 16 07:43:22 Lemur kernel: [390212.779720] invalid opcode: 0000 [#1] SMP 
Jun 16 07:43:22 Lemur kernel: [390212.779744] CPU 0 
Jun 16 07:43:22 Lemur kernel: [390212.779756] Modules linked in: usb_storage rfcomm bnep bluetooth pci_stub vboxpci(O) vboxnetadp(
O) vboxnetflt(O) vboxdrv(O) speedstep_lib parport_pc ppdev binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek joydev uvcvideo videobuf2_core videodev videobuf2_vmalloc videobuf2_memops ghash_clmulni_intel aesni_intel cryptd aes_x86_64 arc4 snd_hda_intel snd_
hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event microcode iwlwifi snd_seq mac80211 snd_timer snd_seq_devic
e cfg80211 i915 psmouse serio_raw wmi snd mac_hid drm_kms_helper drm jmb38x_ms i2c_algo_bit memstick video soundcore mei(C) snd_pa
ge_alloc coretemp lp parport sdhci_pci sdhci jme
Jun 16 07:43:22 Lemur kernel: [390212.780134] 
Jun 16 07:43:22 Lemur kernel: [390212.780144] Pid: 1012, comm: python Tainted: G         C O 3.4.0-030400-generic #201205210521 System76, Inc. Lemur Ultra/Lemur Ultra
Jun 16 07:43:22 Lemur kernel: [390212.780203] RIP: 0010:[<ffffffff8116eb25>]  [<ffffffff8116eb25>] kfree+0x115/0x120
Jun 16 07:43:22 Lemur kernel: [390212.780243] RSP: 0018:ffff880119e23e98  EFLAGS: 00010246
Jun 16 07:43:22 Lemur kernel: [390212.780267] RAX: 0100000000000400 RBX: ffffffff81183bf1 RCX: ffffffff81183bf1
Jun 16 07:43:22 Lemur kernel: [390212.780303] RDX: ffff880119e23f48 RSI: 0000000000004000 RDI: ffffea00000460c0
Jun 16 07:43:22 Lemur kernel: [390212.780337] RBP: ffff880119e23eb8 R08: 0000000000000000 R09: 000000000000000a
Jun 16 07:43:22 Lemur kernel: [390212.780368] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880119e23f48
Jun 16 07:43:22 Lemur kernel: [390212.780403] R13: ffffffffa02c45d4 R14: 0000000000000000 R15: 0000000000000000
Jun 16 07:43:22 Lemur kernel: [390212.780440] FS:  00007f3808e13700(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
Jun 16 07:43:22 Lemur kernel: [390212.780480] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 16 07:43:22 Lemur kernel: [390212.780509] CR2: 000000000290ef98 CR3: 00000001103f4000 CR4: 00000000000427f0
Jun 16 07:43:22 Lemur kernel: [390212.780545] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 16 07:43:22 Lemur kernel: [390212.780580] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 16 07:43:22 Lemur kernel: [390212.780614] Process python (pid: 1012, threadinfo ffff880119e22000, task ffff8800bd79c4a0)
Jun 16 07:43:22 Lemur kernel: [390212.780653] Stack:
Jun 16 07:43:22 Lemur kernel: [390212.780665]  ffff880119e23ec8 0000000000004000 ffff880119e23f48 00007f37fc00ca74
Jun 16 07:43:22 Lemur kernel: [390212.782021]  ffff880119e23ef8 ffffffffa02c45d4 ffff880119e23ef8 ffffffff81183bf1
Jun 16 07:43:22 Lemur kernel: [390212.783328]  0000000000004000 00007f37fc00ca74 ffff880119e23f48 ffff880119e5bf00
Jun 16 07:43:22 Lemur kernel: [390212.784610] Call Trace:
Jun 16 07:43:22 Lemur kernel: [390212.785939]  [<ffffffffa02c45d4>] iwl_dbgfs_fh_reg_read+0x64/0x80 [iwlwifi]
Jun 16 07:43:22 Lemur kernel: [390212.787317]  [<ffffffff81183bf1>] ? rw_verify_area+0x61/0xf0
Jun 16 07:43:22 Lemur kernel: [390212.788714]  [<ffffffff81184285>] vfs_read+0xc5/0x190
Jun 16 07:43:22 Lemur kernel: [390212.790100]  [<ffffffff81184451>] sys_read+0x51/0x90
Jun 16 07:43:22 Lemur kernel: [390212.791468]  [<ffffffff81674e69>] system_call_fastpath+0x16/0x1b
Jun 16 07:43:22 Lemur kernel: [390212.792833] Code: cf e8 30 fa ff ff eb af 66 f7 07 00 c0 74 1c 0f 1f 80 00 00 00 00 e8 cb f2 fb ff eb 9a 48 8b 7f 30 0f 1f 44 00 00 e9 42 ff ff ff <0f> 0b eb fe 0f 1f 80 00 00 00 00 55 48 89 e5 53 48 83 ec 08 66 
Jun 16 07:43:22 Lemur kernel: [390212.795784] RIP  [<ffffffff8116eb25>] kfree+0x115/0x120
Jun 16 07:43:22 Lemur kernel: [390212.797170]  RSP <ffff880119e23e98>
Jun 16 07:43:22 Lemur kernel: [390212.856268] ---[ end trace e23d25595c367a1d ]-
