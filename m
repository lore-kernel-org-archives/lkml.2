Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab1KVIxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:53:12 -0500
Received: from mail2.unitix.de ([176.9.2.175]:46928 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1KVIxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:53:11 -0500
Message-ID: <4ECB62F4.6060602@arndnet.de>
Date: Tue, 22 Nov 2011 09:53:08 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ecryptfs@vger.kernel.org
Subject: 3.2.0-rc2: kernel BUG at fs/ecryptfs/crypto.c:348! regression?
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm regularly hitting below BUG (also with yesterdays Linus git):
3.1.1 is working.

[  198.285682] ------------[ cut here ]------------
[  198.285716] kernel BUG at /home/arnd/Projekte/kernel/linux-2.6/fs/ecryptfs/crypto.c:348!
[  198.285762] invalid opcode: 0000 [#1] SMP
[  198.285789] CPU 1
[  198.285801] Modules linked in: ip6table_filter ip6_tables bnep rfcomm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc kvm_intel kvm joydev dm_crypt arc4 qcserial usb_wwan thinkpad_acpi binfmt_misc usbserial snd_hda_codec_hdmi snd_hda_codec_conexant psmouse serio_raw snd_seq_midi snd_rawmidi iwlwifi snd_hda_intel snd_seq_midi_event snd_hda_codec snd_hwdep snd_seq snd_pcm mac80211 btusb bluetooth snd_seq_device intel_ips cfg80211 snd_timer snd_page_alloc snd mei(C) soundcore tpm_tis nvram btrfs zlib_deflate libcrc32c mxm_wmi i915 firewire_ohci ahci firewire_core crc_itu_t libahci drm_kms_helper drm sdhci_pci i2c_algo_bit sdhci e1000e video wmi
[  198.286283]
[  198.286294] Pid: 2138, comm: dconf-service Tainted: G         C   3.2.0-rc2-aha+ #6 LENOVO 4384GEG/4384GEG
[  198.286352] RIP: 0010:[<ffffffff8126ff70>]  [<ffffffff8126ff70>] ecryptfs_encrypt_extent+0x290/0x3a0
[  198.286412] RSP: 0018:ffff88021e681b98  EFLAGS: 00010246
[  198.286442] RAX: 0000000000000000 RBX: ffff88021e597aa0 RCX: 0000000000000000
[  198.286482] RDX: ffff88021e681c10 RSI: 0000000000000000 RDI: ffff88021e681bf8
[  198.286522] RBP: ffff88021e681c58 R08: 0000000000000000 R09: ffff88021e681bd8
[  198.286562] R10: 0000000000000000 R11: 0000000090b4df2a R12: ffffea00081b8c00
[  198.286602] R13: 0000000000000000 R14: 0000000000000000 R15: ffffea0008b0ea00
[  198.286641] FS:  00007ff9051e67c0(0000) GS:ffff88023bc80000(0000) knlGS:0000000000000000
[  198.286679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  198.286705] CR2: 00007f991e58b150 CR3: 000000021e927000 CR4: 00000000000006e0
[  198.286740] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  198.286777] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  198.286814] Process dconf-service (pid: 2138, threadinfo ffff88021e680000, task ffff88022d1396f0)
[  198.286856] Stack:
[  198.286864]  0000000000001000 0000100000001000 0000000000000000 ffff88023bffcc08
[  198.286888]  ffffea00081b8c02 0000100000000000 0000000000000000 0000000000000000
[  198.286912]  ffffea0008b0ea02 0000100000000000 0000000000000000 0000000000000000
[  198.286937] Call Trace:
[  198.286948]  [<ffffffff8127060d>] ecryptfs_encrypt_page+0xcd/0x190
[  198.286968]  [<ffffffff8126e6c2>] ecryptfs_writepage+0x32/0x90
[  198.286989]  [<ffffffff81117f87>] __writepage+0x17/0x40
[  198.287005]  [<ffffffff811185cd>] write_cache_pages+0x20d/0x460
[  198.287023]  [<ffffffff81117f70>] ? set_page_dirty_lock+0x60/0x60
[  198.287042]  [<ffffffff8111886a>] generic_writepages+0x4a/0x70
[  198.287060]  [<ffffffff81119f55>] do_writepages+0x35/0x40
[  198.287077]  [<ffffffff8110ff2b>] __filemap_fdatawrite_range+0x5b/0x60
[  198.287097]  [<ffffffff81110e1f>] filemap_fdatawrite+0x1f/0x30
[  198.287114]  [<ffffffff81110e65>] filemap_write_and_wait+0x35/0x60
[  198.287132]  [<ffffffff8126b6f4>] ecryptfs_flush+0x24/0x30
[  198.287152]  [<ffffffff8116b23f>] filp_close+0x3f/0x90
[  198.287168]  [<ffffffff8116b342>] sys_close+0xb2/0x120
[  198.287185]  [<ffffffff8160c2c2>] system_call_fastpath+0x16/0x1b
[  198.287202] Code: 00 00 00 48 8b 95 50 ff ff ff 89 c1 48 c7 c6 a0 5a 83 81 48 c7 c7 98 9b a0 81 31 c0 e8 3a d6 ff ff e9 38 ff ff ff e8 80 28 df ff <0f> 0b e8 17 dd 38 00 48 8b 95 50 ff ff ff 31 c9 31 c0 48 c7 c6
[  198.287338] RIP  [<ffffffff8126ff70>] ecryptfs_encrypt_extent+0x290/0x3a0
[  198.287360]  RSP <ffff88021e681b98>
[  198.352203] ---[ end trace 6ba081ed2539e444 ]---


Best regards
Arnd
