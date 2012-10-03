Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2JCDla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:41:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56434 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2JCDl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
References: <CALjC5hYxtPymauFddf4Qci3S-KsZHHck0LKQPZY5ocHcLw-XrQ@mail.gmail.com>
Date: Tue, 2 Oct 2012 20:41:27 -0700
Message-ID: <CALjC5hZwVwRdY6muizzK-+jrq0RH43H6f2kgXstZuco7oM7FyQ@mail.gmail.com>
Subject: Re: crash in ocfs2_fast_symlink_readpage in kernel 3.5.0
From: Bret Towe <magnade@gmail.com>
To: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 1:16 PM, Bret Towe <magnade@gmail.com> wrote:
> just booted a fresh 3.5 kernel and got the following on login via gdm
> on the client computer
> didn't see any crashes yet on any other computer but didn't give it
> long to try after seeing this
> let me know if you need more info
> this client is running debian wheezy 64bit
>
> Jul 22 12:48:38 ghoststar kernel: [  382.563886] general protection
> fault: 0000 [#1] PREEMPT SMP
> Jul 22 12:48:38 ghoststar kernel: [  382.563918] CPU 0
> Jul 22 12:48:38 ghoststar kernel: [  382.563927] Modules linked in:
> ocfs2 quota_tree jbd2 sch_fq_codel xt_LOG xt_tcpudp nf_conntrack_ipv6
> nf_defrag_ipv6 xt_state nf_conntrack ip6table_mangle ip6table_filter
> ip6_tables x_tables cpufreq_userspace cpufreq_powersave
> cpufreq_conservative binfmt_misc iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi tcp_bic ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
> ocfs2_nodemanager nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc
> af_packet ocfs2_stack_user dlm sctp crc32c libcrc32c ipv6
> ocfs2_stackglue configfs loop fuse aoe msr joydev snd_hda_codec_hdmi
> snd_hda_codec_realtek evdev snd_hda_intel snd_hda_codec snd_hwdep
> snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
> powernow_k8 mperf kvm_amd kvm snd_seq_device snd_timer psmouse pcspkr
> serio_raw asus_atk0110 snd k10temp soundcore i2c_piix4 button
> processor dm_mod uas usb_storage firewire_ohci r8169 firewire_core
> crc_itu_t [last unloaded: scsi_wait_scan]
> Jul 22 12:48:38 ghoststar kernel: [  382.564352]
> Jul 22 12:48:38 ghoststar kernel: [  382.564354] Pid: 3690, comm:
> fbsetbg Not tainted 3.5.0+ #4 System manufacturer System Product
> Name/M3A78-EM
> Jul 22 12:48:38 ghoststar kernel: [  382.564395] RIP:
> 0010:[<ffffffff812901fd>]  [<ffffffff812901fd>] strnlen+0xd/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.564428] RSP:
> 0000:ffff88011ed31b78  EFLAGS: 00010202
> Jul 22 12:48:38 ghoststar kernel: [  382.564449] RAX: ffff880122caac00
> RBX: 495441c589455601 RCX: 0000000000000f3f
> Jul 22 12:48:38 ghoststar kernel: [  382.564476] RDX: 0000000000000001
> RSI: 0000000000000f40 RDI: 495441c589455601
> Jul 22 12:48:38 ghoststar kernel: [  382.564503] RBP: ffff88011ed31b78
> R08: ffff88011ed31b50 R09: ffffffffa0588fa0
> Jul 22 12:48:38 ghoststar kernel: [  382.564530] R10: 0000000000000000
> R11: 0000000000000001 R12: ffffea00046ee040
> Jul 22 12:48:38 ghoststar kernel: [  382.564557] R13: ffff88011e0ef138
> R14: ffffea00046ee040 R15: ffffffffa05e2a50
> Jul 22 12:48:38 ghoststar kernel: [  382.564585] FS:
> 00007f6632782700(0000) GS:ffff88012fc00000(0000)
> knlGS:0000000000000000
> Jul 22 12:48:38 ghoststar kernel: [  382.564616] CS:  0010 DS: 0000
> ES: 0000 CR0: 000000008005003b
> Jul 22 12:48:38 ghoststar kernel: [  382.564638] CR2: 00007f24b14ea340
> CR3: 000000011ee66000 CR4: 00000000000007f0
> Jul 22 12:48:38 ghoststar kernel: [  382.564665] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Jul 22 12:48:38 ghoststar kernel: [  382.564692] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jul 22 12:48:38 ghoststar kernel: [  382.564719] Process fbsetbg (pid:
> 3690, threadinfo ffff88011ed30000, task ffff880122382c80)
> Jul 22 12:48:38 ghoststar kernel: [  382.564750] Stack:
> Jul 22 12:48:38 ghoststar kernel: [  382.564758]  ffff88011ed31bc8
> ffffffffa05e2aac ffff88011e0ef278 00000000000200da
> Jul 22 12:48:38 ghoststar kernel: [  382.564790]  ffff88011ed31bc8
> ffffffff810db189 ffff88011e0ef278 0000000000000000
> Jul 22 12:48:38 ghoststar kernel: [  382.564822]  ffff88011e0ef278
> 00000000000200da ffff88011ed31c28 ffffffff810db225
> Jul 22 12:48:38 ghoststar kernel: [  382.564854] Call Trace:
> Jul 22 12:48:38 ghoststar kernel: [  382.564892]  [<ffffffffa05e2aac>]
> ocfs2_fast_symlink_readpage+0x5c/0x1a0 [ocfs2]
> Jul 22 12:48:38 ghoststar kernel: [  382.564922]  [<ffffffff810db189>]
> ? add_to_page_cache_lru+0x29/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.564947]  [<ffffffff810db225>]
> do_read_cache_page+0x85/0x180
> Jul 22 12:48:38 ghoststar kernel: [  382.564971]  [<ffffffff810db354>]
> read_cache_page_async+0x14/0x20
> Jul 22 12:48:38 ghoststar kernel: [  382.564995]  [<ffffffff810db369>]
> read_cache_page+0x9/0x20
> Jul 22 12:48:38 ghoststar kernel: [  382.565018]  [<ffffffff81133115>]
> page_getlink.isra.21+0x25/0x80
> Jul 22 12:48:38 ghoststar kernel: [  382.565042]  [<ffffffff81133191>]
> page_follow_link_light+0x21/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.565066]  [<ffffffff81133e1b>]
> link_path_walk+0x48b/0x950
> Jul 22 12:48:38 ghoststar kernel: [  382.565089]  [<ffffffff81134e62>]
> path_lookupat+0x52/0x7c0
> Jul 22 12:48:38 ghoststar kernel: [  382.565112]  [<ffffffff811dac47>]
> ? xfs_file_aio_read+0x187/0x370
> Jul 22 12:48:38 ghoststar kernel: [  382.565136]  [<ffffffff811355fc>]
> do_path_lookup+0x2c/0xc0
> Jul 22 12:48:38 ghoststar kernel: [  382.565159]  [<ffffffff81132ffe>]
> ? getname_flags+0x4e/0xf0
> Jul 22 12:48:38 ghoststar kernel: [  382.565181]  [<ffffffff811374d8>]
> user_path_at_empty+0x58/0xa0
> Jul 22 12:48:38 ghoststar kernel: [  382.565205]  [<ffffffff812581d6>]
> ? smack_cred_prepare+0x46/0x70
> Jul 22 12:48:38 ghoststar kernel: [  382.565229]  [<ffffffff8113752c>]
> user_path_at+0xc/0x10
> Jul 22 12:48:38 ghoststar kernel: [  382.565251]  [<ffffffff81126c1e>]
> sys_faccessat+0x9e/0x1c0
> Jul 22 12:48:38 ghoststar kernel: [  382.565274]  [<ffffffff815846fd>]
> system_call_fastpath+0x1a/0x1f
> Jul 22 12:48:38 ghoststar kernel: [  382.565297] Code: c0 01 80 38 00
> 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00
> 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8
> 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83
> Jul 22 12:48:38 ghoststar kernel: [  382.565435] RIP
> [<ffffffff812901fd>] strnlen+0xd/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.565457]  RSP <ffff88011ed31b78>
> Jul 22 12:48:38 ghoststar kernel: [  382.573578] ---[ end trace
> 91842dd982a1cff1 ]---
> Jul 22 12:48:38 ghoststar kernel: [  382.635330] general protection
> fault: 0000 [#2] PREEMPT SMP
> Jul 22 12:48:38 ghoststar kernel: [  382.635440] CPU 1
> Jul 22 12:48:38 ghoststar kernel: [  382.635473] Modules linked in:
> ocfs2 quota_tree jbd2 sch_fq_codel xt_LOG xt_tcpudp nf_conntrack_ipv6
> nf_defrag_ipv6 xt_state nf_conntrack ip6table_mangle ip6table_filter
> ip6_tables x_tables cpufreq_userspace cpufreq_powersave
> cpufreq_conservative binfmt_misc iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi tcp_bic ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm
> ocfs2_nodemanager nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc
> af_packet ocfs2_stack_user dlm sctp crc32c libcrc32c ipv6
> ocfs2_stackglue configfs loop fuse aoe msr joydev snd_hda_codec_hdmi
> snd_hda_codec_realtek evdev snd_hda_intel snd_hda_codec snd_hwdep
> snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
> powernow_k8 mperf kvm_amd kvm snd_seq_device snd_timer psmouse pcspkr
> serio_raw asus_atk0110 snd k10temp soundcore i2c_piix4 button
> processor dm_mod uas usb_storage firewire_ohci r8169 firewire_core
> crc_itu_t [last unloaded: scsi_wait_scan]
> Jul 22 12:48:38 ghoststar kernel: [  382.637093]
> Jul 22 12:48:38 ghoststar kernel: [  382.637101] Pid: 3680, comm:
> gnome-settings- Tainted: G      D      3.5.0+ #4 System manufacturer
> System Product Name/M3A78-EM
> Jul 22 12:48:38 ghoststar kernel: [  382.637280] RIP:
> 0010:[<ffffffff812901fd>]  [<ffffffff812901fd>] strnlen+0xd/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.637404] RSP:
> 0018:ffff88011efe3d08  EFLAGS: 00010202
> Jul 22 12:48:38 ghoststar kernel: [  382.637485] RAX: ffff880122caac00
> RBX: 495441c589455601 RCX: 0000000000000f3f
> Jul 22 12:48:38 ghoststar kernel: [  382.637591] RDX: 0000000000000001
> RSI: 0000000000000f40 RDI: 495441c589455601
> Jul 22 12:48:38 ghoststar kernel: [  382.637696] RBP: ffff88011efe3d08
> R08: ffff88011efe3ce0 R09: ffffffffa0588fa0
> Jul 22 12:48:38 ghoststar kernel: [  382.637801] R10: 0000000000000000
> R11: 0000000000000001 R12: ffffea0004762480
> Jul 22 12:48:38 ghoststar kernel: [  382.637905] R13: ffff88011e0f12f8
> R14: ffffea0004762480 R15: ffffffffa05e2a50
> Jul 22 12:48:38 ghoststar kernel: [  382.638012] FS:
> 00007f24c7a7e920(0000) GS:ffff88012fc40000(0000)
> knlGS:0000000000000000
> Jul 22 12:48:38 ghoststar kernel: [  382.644668] CS:  0010 DS: 0000
> ES: 0000 CR0: 0000000080050033
> Jul 22 12:48:38 ghoststar kernel: [  382.651302] CR2: 00007f24a7dc8000
> CR3: 0000000122fa1000 CR4: 00000000000007e0
> Jul 22 12:48:38 ghoststar kernel: [  382.657814] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Jul 22 12:48:38 ghoststar kernel: [  382.664131] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jul 22 12:48:38 ghoststar kernel: [  382.670238] Process
> gnome-settings- (pid: 3680, threadinfo ffff88011efe2000, task
> ffff8801223e1640)
> Jul 22 12:48:38 ghoststar kernel: [  382.676242] Stack:
> Jul 22 12:48:38 ghoststar kernel: [  382.682018]  ffff88011efe3d58
> ffffffffa05e2aac ffff88011e0f1438 00000000000200da
> Jul 22 12:48:38 ghoststar kernel: [  382.687788]  ffff88011efe3d58
> ffffffff810db189 ffff88011e0f1438 0000000000000000
> Jul 22 12:48:38 ghoststar kernel: [  382.693458]  ffff88011e0f1438
> 00000000000200da ffff88011efe3db8 ffffffff810db225
> Jul 22 12:48:38 ghoststar kernel: [  382.699075] Call Trace:
> Jul 22 12:48:38 ghoststar kernel: [  382.704682]  [<ffffffffa05e2aac>]
> ocfs2_fast_symlink_readpage+0x5c/0x1a0 [ocfs2]
> Jul 22 12:48:38 ghoststar kernel: [  382.710309]  [<ffffffff810db189>]
> ? add_to_page_cache_lru+0x29/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.715919]  [<ffffffff810db225>]
> do_read_cache_page+0x85/0x180
> Jul 22 12:48:38 ghoststar kernel: [  382.721500]  [<ffffffff810db354>]
> read_cache_page_async+0x14/0x20
> Jul 22 12:48:38 ghoststar kernel: [  382.727068]  [<ffffffff810db369>]
> read_cache_page+0x9/0x20
> Jul 22 12:48:38 ghoststar kernel: [  382.732598]  [<ffffffff81133115>]
> page_getlink.isra.21+0x25/0x80
> Jul 22 12:48:38 ghoststar kernel: [  382.738092]  [<ffffffff81133191>]
> page_follow_link_light+0x21/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.743549]  [<ffffffff81132d0d>]
> generic_readlink+0x3d/0xa0
> Jul 22 12:48:38 ghoststar kernel: [  382.748970]  [<ffffffff811374e3>]
> ? user_path_at_empty+0x63/0xa0
> Jul 22 12:48:38 ghoststar kernel: [  382.754404]  [<ffffffff812a2005>]
> ? __percpu_counter_add+0x75/0xc0
> Jul 22 12:48:38 ghoststar kernel: [  382.759869]  [<ffffffff81105428>]
> ? do_munmap+0x338/0x410
> Jul 22 12:48:38 ghoststar kernel: [  382.765286]  [<ffffffff8112cb91>]
> sys_readlinkat+0xa1/0xc0
> Jul 22 12:48:38 ghoststar kernel: [  382.770652]  [<ffffffff8112cbc6>]
> sys_readlink+0x16/0x20
> Jul 22 12:48:38 ghoststar kernel: [  382.775960]  [<ffffffff815846fd>]
> system_call_fastpath+0x1a/0x1f
> Jul 22 12:48:38 ghoststar kernel: [  382.781300] Code: c0 01 80 38 00
> 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00
> 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8
> 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83
> Jul 22 12:48:38 ghoststar kernel: [  382.792778] RIP
> [<ffffffff812901fd>] strnlen+0xd/0x40
> Jul 22 12:48:38 ghoststar kernel: [  382.798385]  RSP <ffff88011efe3d08>
> Jul 22 12:48:38 ghoststar kernel: [  382.804556] ---[ end trace
> 91842dd982a1cff2 ]---

it looks like you have a patch for this problem in a queue somewhere
(email found on ocfs2-dev:
https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008677.html )
but its not in 3.6, any reason for the delay?
I've been running that patch on 3.5 for a while now likely since
around the time i found that email
and its been working well
