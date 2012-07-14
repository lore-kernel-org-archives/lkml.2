Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2GNMLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:11:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48289 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2GNMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:11:23 -0400
MIME-Version: 1.0
Date: Sat, 14 Jul 2012 17:56:22 +0545
Message-ID: <CAHdPZaM8Vnfkkon_vCF-jPQLq6WH482ozhH3U08hF30bOMr7Ow@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000010 on 3.5-rc6
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I started my testing with trinity fuzzer, I found a bug something like
the below one in the dmesg .

Please pardon me if its a false alarm.

command:

./trinity as user in a lenovo box,

how it came:

ran the above command for more than 3 mins,
mean while do apt-get and vim.

kernel:

3.5-rc6 with git head at fdb1335a82e. (from Torvald's branch)

dmesg:

[43610.535421] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[43610.535458] IP: [<ffffffff81040999>] __ticket_spin_lock+0x9/0x30
[43610.535482] PGD a5f5e067 PUD d3eb3067 PMD 0
[43610.535501] Oops: 0002 [#1] SMP
[43610.535516] CPU 0
[43610.535524] Modules linked in: l2tp_ppp l2tp_core ipt_ULOG x_tables
dn_rtmsg can_bcm nfnetlink xfrm_user can_raw hidp af_alg caif_socket
caif phonet af_rxrpc can llc2 pppoe pppox irda crc_ccitt af_key
xfrm_algo atm appletalk ipx p8022 psnap llc p8023 pl2303 usbserial
hid_generic usbhid hid usb_storage uas cdc_acm rfcomm bnep parport_pc
ppdev snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel
snd_hda_codec thinkpad_acpi snd_hwdep snd_pcm snd_seq_midi arc4
snd_rawmidi snd_seq_midi_event binfmt_misc snd_seq joydev snd_timer
snd_seq_device rtl8192ce rtl8192c_common rtlwifi mac80211 coretemp
i915 snd uvcvideo videobuf2_core videodev kvm_intel btusb kvm
ghash_clmulni_intel cryptd drm_kms_helper drm soundcore bluetooth
cfg80211 videobuf2_vmalloc snd_page_alloc mac_hid i2c_algo_bit psmouse
serio_raw microcode lpc_ich videobuf2_memops mei wmi tpm_tis video
nvram lp parport firewire_ohci sdhci_pci sdhci firewire_core crc_itu_t
e1000e
[43610.535901]
[43610.535905] Pid: 28712, comm: trinity-child0 Tainted: G        W
3.5.0-rc6+ #2 LENOVO 4177CTO/4177CTO
[43610.535938] RIP: 0010:[<ffffffff81040999>]  [<ffffffff81040999>]
__ticket_spin_lock+0x9/0x30
[43610.535965] RSP: 0018:ffff8800346d1bd8  EFLAGS: 00010282
[43610.535982] RAX: 0000000000010000 RBX: 0000000000000010 RCX: 0000000000000001
[43610.536004] RDX: ffff8800346d1cc8 RSI: ffff8800346d1d48 RDI: 0000000000000010
[43610.536025] RBP: ffff8800346d1bd8 R08: ffff8800346d0000 R09: 0000000000000800
[43610.536046] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800346d1d48
[43610.536067] R13: ffff880114c216f0 R14: ffff8800346d1cc8 R15: ffff8800346d1d48
[43610.536089] FS:  00007f65d88f1700(0000) GS:ffff88011e200000(0000)
knlGS:0000000000000000
[43610.536112] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[43610.536130] CR2: 0000000000000010 CR3: 000000003ad66000 CR4: 00000000000407f0
[43610.536151] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[43610.536172] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[43610.536194] Process trinity-child0 (pid: 28712, threadinfo
ffff8800346d0000, task ffff880114c216f0)
[43610.536220] Stack:
[43610.536228]  ffff8800346d1be8 ffffffff81661efe ffff8800346d1c28
ffffffff810af084
[43610.536255]  0000000050015f72 0000000000000000 0000000000000000
ffff8800346d1cc8
[43610.536282]  0000000000000010 ffff8800346d1f40 ffff8800346d1de8
ffffffff810ac696
[43610.536308] Call Trace:
[43610.536320]  [<ffffffff81661efe>] _raw_spin_lock+0xe/0x20
[43610.536339]  [<ffffffff810af084>] rt_mutex_finish_proxy_lock+0x34/0xd0
[43610.536360]  [<ffffffff810ac696>] futex_wait_requeue_pi+0x296/0x3f0
[43610.536380]  [<ffffffff81121eb9>] ? generic_file_aio_write+0x99/0xe0
[43610.536402]  [<ffffffff8107a920>] ? update_rmtp+0x70/0x70
[43610.536420]  [<ffffffff8107b5a4>] ? hrtimer_start_range_ns+0x14/0x20
[43610.536441]  [<ffffffff810ad899>] do_futex+0x339/0xb00
[43610.536458]  [<ffffffff8107b30b>] ? __hrtimer_start_range_ns+0x16b/0x3d0
[43610.536480]  [<ffffffff8107adc0>] ? lock_hrtimer_base.isra.24+0x30/0x60
[43610.536502]  [<ffffffff8107b588>] ? hrtimer_start+0x18/0x20
[43610.536521]  [<ffffffff81059944>] ? do_setitimer+0x194/0x2c0
[43610.536539]  [<ffffffff810ae16a>] sys_futex+0x10a/0x1a0
[43610.537495]  [<ffffffff8166a2e9>] system_call_fastpath+0x16/0x1b
[43610.538422] Code: 00 00 48 c7 c1 a1 07 04 81 48 c7 c2 9e 07 04 81
e9 dd fe ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 55 b8 00 00 01
00 48 89 e5 <f0> 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 13 66 0f 1f 84 00
00 00
[43610.540380] RIP  [<ffffffff81040999>] __ticket_spin_lock+0x9/0x30
[43610.541417]  RSP <ffff8800346d1bd8>
[43610.542427] CR2: 0000000000000010
[43610.560072] ---[ end trace 035e6ea48214012f ]---
[43626.265472] irda_poll(), POLLHUP

Thanks,
Devendra.
