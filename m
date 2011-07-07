Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1GGKYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:24:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51568 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1GGKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:24:10 -0400
MIME-Version: 1.0
X-Originating-IP: [41.203.218.102]
From: Brian Marete <marete@toshnix.com>
Date: Thu, 7 Jul 2011 13:23:49 +0300
Message-ID: <CAHVUoiRRGY62BZOMYPYxytG569MD0=8=TEN9pCwYefDBg+J+uQ@mail.gmail.com>
Subject: 3.0.0-r5: ftrace: BUG & OOPS
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Testing 3.0.0-5, trying to echo the string '*:mod:radeon' into
/sys/kernel/debug/tracing/set_ftrace_filter , I get the following BUG
and Oops:

Jul  7 02:10:31 phyllis kernel: [48590.474221] [drm:drm_mode_getfb]
*ERROR* invalid framebuffer id
Jul  7 03:17:13 phyllis kernel: [52590.763360]
[drm:radeon_crtc_page_flip] *ERROR* failed to reserve new rbo buffer
before flip
Jul  7 04:02:28 phyllis kernel: [55303.839946] BUG: unable to handle
kernel paging request at ffffffff8160ec90
Jul  7 04:02:28 phyllis kernel: [55303.847262] IP:
[<ffffffff810d9136>] add_hash_entry+0x66/0xd0
Jul  7 04:02:28 phyllis kernel: [55303.851034] PGD 1a05067 PUD 1a09063
PMD 80000000016001e1
Jul  7 04:02:28 phyllis kernel: [55303.854798] Oops: 0003 [#1] SMP
Jul  7 04:02:28 phyllis kernel: [55303.858604] CPU 1
Jul  7 04:02:28 phyllis kernel: [55303.858622] Modules linked in:
cryptd aes_x86_64 aes_generic binfmt_misc rfcomm bnep ip6table_filter
ip6_tables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp kvm_intel kvm parport_pc
ppdev dm_crypt arc4 iwlagn snd_hda_codec_hdmi snd_hda_codec_idt
snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_pcm snd_seq_midi
snd_rawmidi joydev btusb snd_seq_midi_event snd_seq bluetooth
snd_timer snd_seq_device uvcvideo psmouse cfg80211 mei(C) lp snd
serio_raw soundcore parport dell_laptop dell_wmi videodev intel_ips
media v4l2_compat_ioctl32 snd_page_alloc sparse_keymap dcdbas usbhid
hid radeon r8169 ahci libahci mii ttm drm_kms_helper drm video
i2c_algo_bit intel_agp intel_gtt
Jul  7 04:02:28 phyllis kernel: [55303.881803]
Jul  7 04:02:28 phyllis kernel: [55303.885592] Pid: 10344, comm: bash
Tainted: G        WC  3.0.0-rc5 #1 Dell Inc. Inspiron N5010/0YXXJJ
Jul  7 04:02:28 phyllis kernel: [55303.889401] RIP:
0010:[<ffffffff810d9136>]  [<ffffffff810d9136>]
add_hash_entry+0x66/0xd0
Jul  7 04:02:28 phyllis kernel: [55303.893167] RSP:
0018:ffff88003a96bda8  EFLAGS: 00010246
Jul  7 04:02:28 phyllis kernel: [55303.896898] RAX: ffff8801301735c0
RBX: ffffffff8160ec80 RCX: 0000000000306ee0
Jul  7 04:02:28 phyllis kernel: [55303.900562] RDX: 0000000000000000
RSI: 0000000000000000 RDI: ffff880137c92940
Jul  7 04:02:28 phyllis kernel: [55303.904429] RBP: ffff88003a96bdb8
R08: ffff880137c95680 R09: 0000000000000000
Jul  7 04:02:28 phyllis kernel: [55303.908000] R10: 0000000000000001
R11: 0000000000000000 R12: ffffffff81c9df78
Jul  7 04:02:28 phyllis kernel: [55303.911525] R13: ffff8801153d1000
R14: 0000000000000000 R15: 0000000000000000
Jul  7 04:02:28 phyllis kernel: [55303.915018] FS:
00007f329c18a700(0000) GS:ffff880137c80000(0000)
knlGS:0000000000000000
Jul  7 04:02:28 phyllis kernel: [55303.918434] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul  7 04:02:28 phyllis kernel: [55303.921793] CR2: ffffffff8160ec90
CR3: 000000003002b000 CR4: 00000000000006e0
Jul  7 04:02:28 phyllis kernel: [55303.925400] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jul  7 04:02:28 phyllis kernel: [55303.928657] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  7 04:02:28 phyllis kernel: [55303.931862] Process bash (pid:
10344, threadinfo ffff88003a96a000, task ffff88012fcfc470)
Jul  7 04:02:28 phyllis kernel: [55303.935266] Stack:
Jul  7 04:02:28 phyllis kernel: [55303.938363]  0000000000000fd0
00000000000000fc ffff88003a96be38 ffffffff810d92f5
Jul  7 04:02:28 phyllis kernel: [55303.941442]  ffff88011c4c4e00
ffff880000000000 000000000b69f4d0 ffffffff8160ec80
Jul  7 04:02:28 phyllis kernel: [55303.944579]  ffff8800300e6f06
0000000081130295 0000000000000282 ffff8800300e6f00
Jul  7 04:02:28 phyllis kernel: [55303.947671] Call Trace:
Jul  7 04:02:28 phyllis kernel: [55303.950557]  [<ffffffff810d92f5>]
match_records+0x155/0x1b0
Jul  7 04:02:28 phyllis kernel: [55303.953445]  [<ffffffff810d940c>]
ftrace_mod_callback+0xbc/0x100
Jul  7 04:02:28 phyllis kernel: [55303.956211]  [<ffffffff810dafdf>]
ftrace_regex_write+0x16f/0x210
Jul  7 04:02:28 phyllis kernel: [55303.958908]  [<ffffffff810db09f>]
ftrace_filter_write+0xf/0x20
Jul  7 04:02:28 phyllis kernel: [55303.961568]  [<ffffffff81166e48>]
vfs_write+0xc8/0x190
Jul  7 04:02:28 phyllis kernel: [55303.964125]  [<ffffffff81167001>]
sys_write+0x51/0x90
Jul  7 04:02:28 phyllis kernel: [55303.966610]  [<ffffffff815c7e02>]
system_call_fastpath+0x16/0x1b
Jul  7 04:02:28 phyllis kernel: [55303.969115] Code: 48 8b 33 31 d2 48
85 f6 75 33 49 89 d4 4c 03 63 08 49 8b 14 24 48 85 d2 48 89 10 74 04
48 89 42 08 49 89 04 24 4c 89 60 08 31 d2
Jul  7 04:02:28 phyllis kernel: [55303.974815] RIP
[<ffffffff810d9136>] add_hash_entry+0x66/0xd0
Jul  7 04:02:28 phyllis kernel: [55303.977529]  RSP <ffff88003a96bda8>
Jul  7 04:02:28 phyllis kernel: [55303.980322] CR2: ffffffff8160ec90
Jul  7 04:02:28 phyllis kernel: [55303.993628] ---[ end trace
a5d031828efdd88e ]---

The taint is, I think, due to the following prior WARN, also
apparently in the tracing code (while running Kernelshark):

Jul  7 01:38:18 phyllis kernel: [46668.806315] WARNING: at
kernel/trace/trace.c:2726 tracing_ctrl_write+0x1ae/0x1d0()
Jul  7 01:38:18 phyllis kernel: [46668.806321] Hardware name: Inspiron N5010
Jul  7 01:38:18 phyllis kernel: [46668.806325] tracing_enabled is
deprecated. Use tracing_on
Jul  7 01:38:18 phyllis kernel: [46668.806329] Modules linked in:
binfmt_misc rfcomm bnep ip6table_filter ip6_tables ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp kvm_intel kvm parport_pc ppdev dm_crypt arc4 iwlagn
snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel mac80211
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi joydev btusb
snd_seq_midi_event snd_seq bluetooth snd_timer snd_seq_device uvcvideo
psmouse cfg80211 mei(C) lp snd serio_raw soundcore parport dell_laptop
dell_wmi videodev intel_ips media v4l2_compat_ioctl32 snd_page_alloc
sparse_keymap dcdbas usbhid hid radeon r8169 ahci libahci mii ttm
drm_kms_helper drm video i2c_algo_bit intel_agp intel_gtt
Jul  7 01:38:18 phyllis kernel: [46668.806416] Pid: 7388, comm:
latencytop Tainted: G         C  3.0.0-rc5 #1
Jul  7 01:38:18 phyllis kernel: [46668.806420] Call Trace:
Jul  7 01:38:18 phyllis kernel: [46668.806429]  [<ffffffff8105f92f>]
warn_slowpath_common+0x7f/0xc0
Jul  7 01:38:18 phyllis kernel: [46668.806435]  [<ffffffff8105fa26>]
warn_slowpath_fmt+0x46/0x50
Jul  7 01:38:18 phyllis kernel: [46668.806442]  [<ffffffff810e1d90>] ?
copy_from_user+0x30/0x40
Jul  7 01:38:18 phyllis kernel: [46668.806447]  [<ffffffff810e404e>]
tracing_ctrl_write+0x1ae/0x1d0
Jul  7 01:38:18 phyllis kernel: [46668.806454]  [<ffffffff812b3cc8>] ?
apparmor_file_permission+0x18/0x20
Jul  7 01:38:18 phyllis kernel: [46668.806463]  [<ffffffff81280af3>] ?
security_file_permission+0x23/0x90
Jul  7 01:38:18 phyllis kernel: [46668.806471]  [<ffffffff81166e48>]
vfs_write+0xc8/0x190
Jul  7 01:38:18 phyllis kernel: [46668.806476]  [<ffffffff81167001>]
sys_write+0x51/0x90
Jul  7 01:38:18 phyllis kernel: [46668.806484]  [<ffffffff815c7e02>]
system_call_fastpath+0x16/0x1b

I am happy to answer any questions.

Thanks!

-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
