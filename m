Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2JBWDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:03:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34384 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932463Ab2JBWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:03:17 -0400
Content-Type: text/plain; charset="utf-8"
Date: Wed, 03 Oct 2012 00:03:13 +0200
From: "Jochen Katz" <kernel@gmx-topmail.de>
Message-ID: <20121002220313.222050@gmx.net>
MIME-Version: 1.0
Subject: kernel BUG at fs/buffer.c:3205
To: linux-kernel@vger.kernel.org
X-Authenticated: #1983134
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX191T5k+tIl1A//ndYX2jQPsfET7qhr4dqR5LwR+Uw
 HTrO3MFMfbe5KMYaRHEp+Ng77ShNcLDEQXOA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: 9gEZcNk3eSEqUf8hdXQhqTl+IGRvb4BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there is currently a thread "kernel BUG at fs/buffer.c:3205 (stable 3.5.3)" on this list.

I have reached the same BUG_ON(), but in an older kernel and with a different environment, so maybe the following information is helpfull.

- Kernel is from openSUSE 12.2: kernel-desktop-3.4.6-2.10.1.x86_64
- I have no SSD and no USB 3.0
- The BUG occured when updating DVD ISOs with jigdo on an ext4 partition (old and new ISOs are on the same partition).
- No fglrx module, but unfortunately a nvidia module

[ 9485.931360] kernel BUG at /home/abuild/rpmbuild/BUILD/kernel-desktop-3.4.6/linux-3.4/fs/buffer.c:3205!
[ 9485.931362] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 9485.931365] CPU 1 
[ 9485.931366] Modules linked in: nls_utf8 loop fuse ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables bridge stp cpufreq_conservative cpufreq_userspace cpufreq_powersave raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx stv0299 ves1x93 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep dvb_ttpci snd_pcm nvidia(PO) dvb_core sr_mod saa7146_vv raid1 cdrom snd_seq snd_timer sg acpi_cpufreq mperf firewire_ohci pcspkr iTCO_wdt videodev saa7146 videobuf_dma_sg videobuf_core firewire_core atl1 ttpci_eeprom iTCO_vendor_support crc_itu_t i2c_i801 snd_seq_device snd soundcore snd_page_alloc kvm_intel kvm coretemp asus_atk0110 button microcode autofs4 btrfs zlib_deflate crc32c libcrc32c processor thermal_sys scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh ata_generic ata_piix pata_jmicron
[ 9485.931407] 
[ 9485.931409] Pid: 32, comm: kswapd0 Tainted: P           O 3.4.6-2.10-desktop #1 System manufacturer P5K/P5K
[ 9485.931412] RIP: 0010:[<ffffffff8118c4af>]  [<ffffffff8118c4af>] free_buffer_head+0x6f/0x80
[ 9485.931419] RSP: 0018:ffff8802218e7a08  EFLAGS: 00010287
[ 9485.931420] RAX: ffff880002e3aba0 RBX: ffff880002e3ab58 RCX: 0000000000000000
[ 9485.931422] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff880002e3ab58
[ 9485.931423] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000002750d83
[ 9485.931425] R10: 0000000000000001 R11: dead000000100100 R12: ffff8800822afe08
[ 9485.931427] R13: ffffea0002847598 R14: ffff8802218e7ae0 R15: ffffea0002847578
[ 9485.931428] FS:  0000000000000000(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
[ 9485.931430] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9485.931432] CR2: 0000000002ecda18 CR3: 000000021ab5a000 CR4: 00000000000007e0
[ 9485.931434] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9485.931435] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 9485.931437] Process kswapd0 (pid: 32, threadinfo ffff8802218e6000, task ffff8802218e4840)
[ 9485.931438] Stack:
[ 9485.931439]  ffffffff8118c539 ffff8802218e7dd8 ffff880002e3ab58 ffff8802218e7bd0
[ 9485.931443]  ffff8802218e7dd8 ffff8802218e7ad0 ffffffff81111eb7 ffff88022fc8fae8
[ 9485.931445]  ffff880200000001 ffff8800822afd80 ffffea0000000001 0000000000000000
[ 9485.931448] Call Trace:
[ 9485.931456]  [<ffffffff8118c539>] try_to_free_buffers+0x79/0xc0
[ 9485.931460]  [<ffffffff81111eb7>] shrink_page_list+0x5d7/0x940
[ 9485.931465]  [<ffffffff81112662>] shrink_inactive_list+0x182/0x4f0
[ 9485.931468]  [<ffffffff81113132>] shrink_mem_cgroup_zone+0x3b2/0x520
[ 9485.931472]  [<ffffffff81113310>] shrink_zone+0x70/0x90
[ 9485.931475]  [<ffffffff81114579>] balance_pgdat+0x509/0x710
[ 9485.931478]  [<ffffffff811148d9>] kswapd+0x159/0x3c0
[ 9485.931482]  [<ffffffff81060a85>] kthread+0x85/0x90
[ 9485.931486]  [<ffffffff81593c94>] kernel_thread_helper+0x4/0x10
[ 9485.931489] Code: ff 0f 00 00 7e 05 e8 71 f5 ff ff 65 48 8b 04 25 70 b8 00 00 83 a8 44 e0 ff ff 01 48 8b 80 38 e0 ff ff a8 08 75 07 48 83 c4 08 c3 <0f> 0b 5a e9 d9 e2 3f 00 66 0f 1f 84 00 00 00 00 00 41 54 55 53 
[ 9485.931512] RIP  [<ffffffff8118c4af>] free_buffer_head+0x6f/0x80
[ 9485.931514]  RSP <ffff8802218e7a08>

Regards,
Jochen
