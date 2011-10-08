Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1JHHj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:39:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1JHHj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:39:56 -0400
Date: Sat, 8 Oct 2011 09:39:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Matthias Dahl <ml_linux-kernel@binary-island.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.1-rc9] kernel tried to execute NX-protected... w/ page
 fault
In-Reply-To: <20111008081435.6ddbaa61@dreamgate.localdomain>
Message-ID: <alpine.LRH.2.00.1110080938030.29079@twin.jikos.cz>
References: <20111008081435.6ddbaa61@dreamgate.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Oct 2011, Matthias Dahl wrote:

> Since kernel.org is now up and running again, I thought I'd give 3.1-rc9 
> a whirl and ran into the attached bug ("kernel tried to execute 
> NX-protected..." with page fault) which I never ever ran into before. 
> And considering all the security issues that have happened over the last 
> few month, the "exploit warning" really gets one thinking. ;) So I 
> thought I better post it here and see if there is any reason to be 
> concerned. :-)

First, please inline the text into your e-mails next time, it's much more 
convenient to look at them as such rather than having to process gzipped 
attachments.

Now, in your dmesg.bug I can see this:

> [ 3514.063164] kernel tried to execute NX-protected page - exploit attempt? (uid: 1000)
> [ 3514.063167] BUG: unable to handle kernel paging request at ffff88020ace1ef8
> [ 3514.063170] IP: [<ffff88020ace1ef8>] 0xffff88020ace1ef7
> [ 3514.063177] PGD 1560063 PUD 227ffa067 PMD 800000020ac001e3 
> [ 3514.063180] Oops: 0011 [#1] PREEMPT SMP 
> [ 3514.063184] CPU 0 
> [ 3514.063185] Modules linked in: it87 hwmon_vid coretemp xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah nf_nat_tftp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables snd_pcm_oss snd_mixer_oss xts gf128mul us
 blp snd_hda_codec_hdmi isl6421 cx24116 ir_lirc_codec cx88_vp3054_i2c videobuf_dvb lirc_dev nvidia(P) dvb_core ir_mce_kbd_decoder rc_hauppauge ir_sony_decoder ir_jvc_decoder ir_rc6_decoder snd_hda_codec_realtek snd_virtuoso snd_hda_intel tuner snd_oxygen_lib snd_hda_codec cx8800 cx8802 cx88xx ir_rc5_decoder ir_nec_decoder rc_core i2c_algo_bit snd_hwdep tveeprom snd_pcm v4l2_common snd_timer snd_mpu401_uart snd_rawmidi videodev snd v4l2_compat_ioctl32 btcx_risc videobuf_dma_sg videobuf_core xpad joydev evdev soundcore snd_page_alloc fuse ext2 mbcache dm_snapshot dm_mirror dm_region_hash dm_log scsi_wait_scan usb_storage
> [ 3514.063265] 
> [ 3514.063268] Pid: 2235, comm: knotify4 Tainted: P            3.1.0-rc9 #1 Gigabyte Technology Co., Ltd. P55-UD5/P55-UD5
> [ 3514.063272] RIP: 0010:[<ffff88020ace1ef8>]  [<ffff88020ace1ef8>] 0xffff88020ace1ef7
> [ 3514.063279] RSP: 0018:ffff88020ace1ee0  EFLAGS: 00010282
> [ 3514.063281] RAX: 0000000000000000 RBX: ffff88020ace1ec8 RCX: 00000000003a4268
> [ 3514.063283] RDX: 0000000000000008 RSI: 0000000000000008 RDI: ffff8801d4c39a18
> [ 3514.063285] RBP: ffffffff810d81e2 R08: 0000000000000000 R09: 0000000000000000
> [ 3514.063287] R10: ffff88020930c3d0 R11: 0000000000000246 R12: ffffffffa00fa1eb
> [ 3514.063290] R13: ffff88020930c3c0 R14: 0000000000000008 R15: ffff88020ace1f18
> [ 3514.063292] FS:  00007f4bdf907780(0000) GS:ffff880227c00000(0000) knlGS:0000000000000000
> [ 3514.063295] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3514.063297] CR2: ffff88020ace1ef8 CR3: 00000001d4f02000 CR4: 00000000000006f0
> [ 3514.063299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 3514.063301] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 3514.063303] Process knotify4 (pid: 2235, threadinfo ffff88020ace0000, task ffff88021d923600)
> [ 3514.063305] Stack:
> [ 3514.063307]  ffff88020930c3d0 00000000fffffffe ffff88020930c3c0 ffff88021cd6b9c0
> [ 3514.063310]  0000000000000000 ffff88021cd6ba40 0000000000000000 ffff88020ace1f48
> [ 3514.063314]  ffffffff810d4a21 00007fffb6a3d340 ffff88020930c3c0 ffff88021cd6b9c0
> [ 3514.063318] Call Trace:
> [ 3514.063324]  [<ffffffff810d4a21>] ? filp_close+0x61/0x90
> [ 3514.063328]  [<ffffffff810d4b01>] ? sys_close+0xb1/0x110
> [ 3514.063332]  [<ffffffff813df03b>] ? system_call_fastpath+0x16/0x1b
> [ 3514.063334] Code: 00 00 00 e0 1e ce 0a 02 88 ff ff 18 00 00 00 00 00 00 00 d0 c3 30 09 02 88 ff ff fe ff ff ff 00 00 00 00 c0 c3 30 09 02 88 ff ff <c0> b9 d6 1c 02 88 ff ff 00 00 00 00 00 00 00 00 40 ba d6 1c 02 
> [ 3514.063361] RIP  [<ffff88020ace1ef8>] 0xffff88020ace1ef7
> [ 3514.063367]  RSP <ffff88020ace1ee0>
> [ 3514.063369] CR2: ffff88020ace1ef8
> [ 3514.063371] ---[ end trace fe334273bc099adf ]---
> [ 3607.478553] nvidia 0000:01:00.0: irq 49 for MSI/MSI-X
> [ 4467.569552] nvidia 0000:01:00.0: irq 49 for MSI/MSI-X
> [ 4483.889527] nvidia 0000:01:00.0: irq 49 for MSI/MSI-X

You have Tainted: P there, which means that some proprietary module has 
been loaded.

Is it nvidia gfx driver? If so, does the problem appear also with it not 
loaded?

-- 
Jiri Kosina
SUSE Labs

