Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1JHMff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 08:35:35 -0400
Received: from hemera.binary-island.eu ([97.107.138.233]:45952 "EHLO
	hemera.binary-island.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1JHMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 08:35:31 -0400
Date: Sat, 8 Oct 2011 14:35:25 +0200
From: Matthias Dahl <ml_linux-kernel@binary-island.eu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.1-rc9] kernel tried to execute NX-protected... w/ page fault
Message-ID: <20111008143525.50d9b834@dreamgate.localdomain>
In-Reply-To: <alpine.LRH.2.00.1110080938030.29079@twin.jikos.cz>
References: <20111008081435.6ddbaa61@dreamgate.localdomain>
	<alpine.LRH.2.00.1110080938030.29079@twin.jikos.cz>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri.

On Sat, 8 Oct 2011 09:39:51 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> First, please inline the text into your e-mails next time, it's much more 
> convenient to look at them as such rather than having to process gzipped 
> attachments.

Ok, will do. Just thought because of the text size this was inappropriate  or
would cause trouble with some restricitions of the list.

> Is it nvidia gfx driver? If so, does the problem appear also with it not 
> loaded?

Yes, nvidia 285.05.09 _but_ I just went through  the  trouble to  get nouveau
up and running and tested with that and I ran into the same problems as well,
so this is not related to the nvidia blob.

Here three more incidents.   The first one again with the nvidia blob and the
following two with nouveau. The last one caused a partial hang up btw.  Don't
mind the tainted mark on the last one.    By accident I modprobe'd the nvidia
blob which simply said it found no devices because nouveau was already active
and did nothing (exited).

Last but not least, I am now on 3.0.6 and I do not see anything alike at all.

[ 7353.662147] BUG: unable to handle kernel paging request at ffffffffa00d7040
[ 7353.662152] IP: [<ffffffffa00d7040>] 0xffffffffa00d703f
[ 7353.662159] PGD 1561067 PUD 1565063 PMD 21cf28067 PTE 0
[ 7353.662163] Oops: 0010 [#1] PREEMPT SMP 
[ 7353.662166] CPU 1 
[ 7353.662167] Modules linked in: nvidia(P) it87 hwmon_vid coretemp xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah nf_nat_tftp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables snd_pcm_oss snd_mixer_oss xts gf1
 28mul usblp isl6421 cx24116 cx88_vp3054_i2c videobuf_dvb dvb_core snd_hda_codec_hdmi rc_hauppauge tuner cx8800 cx8802 cx88xx ir_lirc_codec lirc_dev snd_hda_codec_realtek ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder snd_hda_intel rc_core snd_hda_codec i2c_algo_bit snd_virtuoso snd_oxygen_lib tveeprom snd_hwdep v4l2_common snd_pcm videodev v4l2_compat_ioctl32 snd_mpu401_uart btcx_risc snd_rawmidi videobuf_dma_sg snd_timer snd videobuf_core joydev evdev xpad snd_page_alloc soundcore fuse ext2 mbcache dm_snapshot dm_mirror dm_region_hash dm_log scsi_wait_scan usb_storage
[ 7353.662246] 
[ 7353.662249] Pid: 20362, comm: knotify4 Tainted: P            3.1.0-rc9 #1 Gigabyte Technology Co., Ltd. P55-UD5/P55-UD5
[ 7353.662253] RIP: 0010:[<ffffffffa00d7040>]  [<ffffffffa00d7040>] 0xffffffffa00d703f
[ 7353.662261] RSP: 0018:ffff880100c7de70  EFLAGS: 00010282
[ 7353.662262] RAX: ffffffffa00d7040 RBX: ffff88021d9e7000 RCX: 000000000048e1c1
[ 7353.662265] RDX: 000000000048e1b9 RSI: 0000000000000001 RDI: ffff88021d119000
[ 7353.662267] RBP: ffff880100c7dea8 R08: 0000000000000000 R09: 0000000000000000
[ 7353.662269] R10: ffff8801eaba5310 R11: 0000000000000246 R12: ffff8801fe815800
[ 7353.662271] R13: ffff8801eaba5300 R14: ffff88021d9e7218 R15: ffff88021d9e7070
[ 7353.662274] FS:  00007f8123191780(0000) GS:ffff880227c40000(0000) knlGS:0000000000000000
[ 7353.662276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7353.662278] CR2: ffffffffa00d7040 CR3: 00000001c0c8b000 CR4: 00000000000006e0
[ 7353.662281] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7353.662283] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7353.662286] Process knotify4 (pid: 20362, threadinfo ffff880100c7c000, task ffff88021d884e00)
[ 7353.662287] Stack:
[ 7353.662289]  ffffffffa00bfc6a ffff88020a3accf0 ffff88021d112000 ffff8801eaba5300
[ 7353.662293]  ffff8802007742a8 ffff880201c64d80 ffff88021d16cd00 ffff880100c7dec8
[ 7353.662296]  ffffffffa01171eb ffff8801eaba5300 0000000000000008 ffff880100c7df18
[ 7353.662300] Call Trace:
[ 7353.662307]  [<ffffffffa00bfc6a>] ? video_release+0xda/0x1e0 [cx8800]
[ 7353.662315]  [<ffffffffa01171eb>] v4l2_release+0x4b/0x70 [videodev]
[ 7353.662320]  [<ffffffff810d81e2>] fput+0xd2/0x200
[ 7353.662324]  [<ffffffff810d4a21>] filp_close+0x61/0x90
[ 7353.662327]  [<ffffffff810d4b01>] sys_close+0xb1/0x110
[ 7353.662331]  [<ffffffff813df03b>] system_call_fastpath+0x16/0x1b
[ 7353.662333] Code:  Bad RIP value.
[ 7353.662337] RIP  [<ffffffffa00d7040>] 0xffffffffa00d703f
[ 7353.662343]  RSP <ffff880100c7de70>
[ 7353.662345] CR2: ffffffffa00d7040
[ 7353.662347] ---[ end trace f0533e94307d7f16 ]---


[   17.271064] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.271074] nouveau 0000:01:00.0: setting latency timer to 64
[   17.274536] [drm] nouveau 0000:01:00.0: Detected an NVc0 generation card (0x0c0680a3)
[   17.290213] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   17.389788] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   17.389791] [drm] nouveau 0000:01:00.0: BIT BIOS found
[   17.389794] [drm] nouveau 0000:01:00.0: Bios version 70.00.35.00
[   17.389797] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[   17.389799] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[   17.389801] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02000300 00000000
[   17.389804] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000302 00020030
[   17.389806] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 04011380 00000000
[   17.389807] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 08011382 00020030
[   17.389809] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 02022362 00020010
[   17.389812] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[   17.389815] [drm] nouveau 0000:01:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[   17.389817] [drm] nouveau 0000:01:00.0:   1: 0x00010130: type 0x30 idx 1 tag 0x51
[   17.389819] [drm] nouveau 0000:01:00.0:   2: 0x00002261: type 0x61 idx 2 tag 0x08
[   17.389823] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0x6ABA
[   17.423234] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0x7151
[   17.436199] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0x83C0
[   17.436202] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0x83CA
[   17.436275] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0x85D3
[   17.436277] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0x8638
[   17.456226] [drm] nouveau 0000:01:00.0: 0x8638: Condition still not met after 20ms, skipping following opcodes
[   17.456237] [drm] nouveau 0000:01:00.0: voltage table 0x40 unknown
[   17.475304] [drm] nouveau 0000:01:00.0: 4 available performance level(s)
[   17.475308] [drm] nouveau 0000:01:00.0: 0: memory 135MHz core 50MHz shader 101MHz timing 2
[   17.475311] [drm] nouveau 0000:01:00.0: 1: memory 324MHz core 405MHz shader 810MHz voltage 10mV timing 1
[   17.475314] [drm] nouveau 0000:01:00.0: 2: memory 1701MHz core 405MHz shader 810MHz voltage 20mV timing 0
[   17.475318] [drm] nouveau 0000:01:00.0: 3: memory 1701MHz core 656MHz shader 1312MHz voltage 20mV timing 0
[   17.482694] [TTM] Zone  kernel: Available graphics memory: 4081528 kiB.
[   17.482696] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   17.482697] [TTM] Initializing pool allocator.
[   17.482708] [drm] nouveau 0000:01:00.0: Detected 1280MiB VRAM
[   17.482713] mtrr: type mismatch for d8000000,8000000 old: write-back new: write-combining
[   17.482723] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   17.494676] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   17.494678] [drm] No driver support for vblank timestamp query.
[   17.809336] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x1e0000, bo ffff88021d07e000
[   17.809362] fbcon: nouveaufb (fb0) is primary device
[   17.856515] Console: switching to colour frame buffer device 240x75
[   17.863092] fb0: nouveaufb frame buffer device
[   17.863093] drm: registered panic notifier
[   17.863097] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   18.694798] usbcore: registered new interface driver usblp
[   21.982736] EXT4-fs (md127p1): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered
[   22.156848] EXT4-fs (md127p2): mounted filesystem with ordered data mode. Opts: commit=45,barrier=1,stripe=32,data=ordered
[   22.231456] EXT4-fs (md127p3): mounted filesystem with ordered data mode. Opts: commit=45,barrier=1,stripe=32,data=ordered
[   22.252325] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: commit=15,barrier=1,data=ordered
[   25.469675] Adding 4000060k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:4000060k 
[   27.615512] ip_tables: (C) 2000-2006 Netfilter Core Team
[   29.426771] Netfilter messages via NETLINK v0.30.
[   29.449860] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   29.705214] ctnetlink v0.93: registering with nfnetlink.
[   30.215031] xt_time: kernel timezone is +0200
[   31.525180] r8169 0000:02:00.0: eth0: link down
[   31.525185] r8169 0000:02:00.0: eth0: link down
[   33.197522] r8169 0000:02:00.0: eth0: link up
[   48.210515] it87: Found IT8720F chip at 0x290, revision 8
[   48.210526] it87: VID is disabled (pins used for GPIO)
[   48.210538] it87: Routing internal VCCH to in7
[   48.210544] it87: Beeping is supported
[  159.977593] ata1.00: configured for UDMA/133
[  159.977601] ata1: EH complete
[  159.999115] ata2.00: configured for UDMA/133
[  159.999123] ata2: EH complete
[  160.105969] ata3.00: configured for UDMA/133
[  160.105976] ata3: EH complete
[  160.271205] ata4.00: configured for UDMA/133
[  160.271212] ata4: EH complete
[  161.567449] EXT4-fs (md127p1): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered,commit=0
[  161.952021] EXT4-fs (md127p2): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered,commit=0
[  161.955064] EXT4-fs (md127p3): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered,commit=0
[  182.843219] kernel tried to execute NX-protected page - exploit attempt? (uid: 1000)
[  182.843251] BUG: unable to handle kernel paging request at ffff8802140dfd80
[  182.843275] IP: [<ffff8802140dfd80>] 0xffff8802140dfd7f
[  182.843300] PGD 1560063 PUD 227ffa067 PMD 80000002140001e3 
[  182.843324] Oops: 0011 [#1] PREEMPT SMP 
[  182.843343] CPU 7 
[  182.843351] Modules linked in: it87 hwmon_vid coretemp xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah nf_nat_tftp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables snd_pcm_oss snd_mixer_oss xts gf128mul usbl
 p snd_hda_codec_hdmi isl6421 cx24116 nouveau cx88_vp3054_i2c videobuf_dvb dvb_core snd_hda_codec_realtek rc_hauppauge snd_hda_intel snd_hda_codec ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sony_decoder fbcon ir_jvc_decoder tuner ttm snd_virtuoso font bitblit softcursor ir_rc6_decoder drm_kms_helper cx8802 snd_oxygen_lib ir_rc5_decoder snd_hwdep cx8800 drm cx88xx snd_pcm ir_nec_decoder rc_core snd_mpu401_uart snd_timer snd_rawmidi fb snd tveeprom fbdev i2c_algo_bit v4l2_common cfbcopyarea mxm_wmi videodev v4l2_compat_ioctl32 btcx_risc videobuf_dma_sg xpad soundcore videobuf_core wmi snd_page_alloc evdev cfbimgblt cfbfillrect joydev fuse ext2 mbcache dm_snapshot dm_mirror dm_region_hash dm_log scsi_wait_scan usb_storage
[  182.844113] 
[  182.844123] Pid: 15327, comm: knotify4 Not tainted 3.1.0-rc9 #2 Gigabyte Technology Co., Ltd. P55-UD5/P55-UD5
[  182.844154] RIP: 0010:[<ffff8802140dfd80>]  [<ffff8802140dfd80>] 0xffff8802140dfd7f
[  182.844182] RSP: 0018:ffff8801f05d1ea0  EFLAGS: 00010282
[  182.844197] RAX: ffffffffa0116040 RBX: ffff8801f3b8c400 RCX: 00000000000257bf
[  182.844215] RDX: 00000000000257b7 RSI: 0000000000000001 RDI: ffff88021ea2e000
[  182.844232] RBP: ffff88021db53530 R08: 0000000000000000 R09: 0000000000000000
[  182.844251] R10: ffff8801ddedf490 R11: 0000000000000246 R12: ffffffffa0261c6a
[  182.844273] R13: ffff880214150cf0 R14: ffff88021d836000 R15: ffff8801ddedf480
[  182.844292] FS:  00007faee290c780(0000) GS:ffff880227dc0000(0000) knlGS:0000000000000000
[  182.844311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  182.844327] CR2: ffff8802140dfd80 CR3: 00000001f0571000 CR4: 00000000000006e0
[  182.844344] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  182.844362] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  182.844380] Process knotify4 (pid: 15327, threadinfo ffff8801f05d0000, task ffff88021d91d400)
[  182.844399] Stack:
[  182.844408]  ffff88021d14b300 ffff8801f05d1ec8 ffffffffa00d51eb ffff8801ddedf480
[  182.844437]  0000000000000008 ffff8801f05d1f18 ffffffff810d81e2 ffff8801f05d1ef8
[  182.844466]  ffff8801ddedf490 00000000fffffffe ffff8801ddedf480 ffff88021cc86ec0
[  182.844495] Call Trace:
[  182.844517]  [<ffffffffa00d51eb>] ? v4l2_release+0x4b/0x70 [videodev]
[  182.844539]  [<ffffffff810d81e2>] ? fput+0xd2/0x200
[  182.844556]  [<ffffffff810d4a21>] ? filp_close+0x61/0x90
[  182.844575]  [<ffffffff810d4b01>] ? sys_close+0xb1/0x110
[  182.844593]  [<ffffffff813df03b>] ? system_call_fastpath+0x16/0x1b
[  182.844608] Code: 88 ff ff d0 15 14 14 02 88 ff ff 60 fd 0d 14 02 88 ff ff 60 fd 0d 14 02 88 ff ff b0 43 4e 1c 02 88 ff ff b0 43 4e 1c 02 88 ff ff 
[  182.844764]  00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 30 f5 fa 1e 02 
[  182.844839] RIP  [<ffff8802140dfd80>] 0xffff8802140dfd7f
[  182.844862]  RSP <ffff8801f05d1ea0>
[  182.844872] CR2: ffff8802140dfd80
[  182.865521] ---[ end trace f5fb49efc531d0ed ]---


[    9.787983] MXM: GUID detected in BIOS
[    9.788028] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.788036] nouveau 0000:01:00.0: setting latency timer to 64
[    9.790142] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
[    9.790149] cx88[0]: TV tuner type -1, Radio tuner type -1
[    9.790788] [drm] nouveau 0000:01:00.0: Detected an NVc0 generation card (0x0c0680a3)
[    9.795664] IR RC6 protocol handler initialized
[    9.806440] snd_virtuoso 0000:06:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.806581] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    9.808168] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    9.876155] IR JVC protocol handler initialized
[    9.907779] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    9.907782] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    9.907784] [drm] nouveau 0000:01:00.0: Bios version 70.00.35.00
[    9.907787] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    9.907789] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    9.907791] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02000300 00000000
[    9.907793] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 01000302 00020030
[    9.907795] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 04011380 00000000
[    9.907797] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 08011382 00020030
[    9.907799] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 02022362 00020010
[    9.907801] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[    9.907804] [drm] nouveau 0000:01:00.0:   0: 0x00001030: type 0x30 idx 0 tag 0x07
[    9.907806] [drm] nouveau 0000:01:00.0:   1: 0x00010130: type 0x30 idx 1 tag 0x51
[    9.907809] [drm] nouveau 0000:01:00.0:   2: 0x00002261: type 0x61 idx 2 tag 0x08
[    9.907812] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0x6ABA
[    9.924879] IR Sony protocol handler initialized
[    9.933606] IR MCE Keyboard/mouse protocol handler initialized
[    9.941191] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0x7151
[    9.941703] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    9.941744] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    9.941764] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    9.946802] i2c-core: driver [tuner] using legacy suspend method
[    9.946804] i2c-core: driver [tuner] using legacy resume method
[    9.947548] lirc_dev: IR Remote Control driver registered, major 251 
[    9.953617] IR LIRC bridge handler initialized
[    9.954175] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0x83C0
[    9.954178] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0x83CA
[    9.954263] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0x85D3
[    9.954264] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0x8638
[    9.973779] [drm] nouveau 0000:01:00.0: 0x8638: Condition still not met after 20ms, skipping following opcodes
[    9.973789] [drm] nouveau 0000:01:00.0: voltage table 0x40 unknown
[    9.992860] [drm] nouveau 0000:01:00.0: 4 available performance level(s)
[    9.992863] [drm] nouveau 0000:01:00.0: 0: memory 135MHz core 50MHz shader 101MHz timing 2
[    9.992867] [drm] nouveau 0000:01:00.0: 1: memory 324MHz core 405MHz shader 810MHz voltage 10mV timing 1
[    9.992870] [drm] nouveau 0000:01:00.0: 2: memory 1701MHz core 405MHz shader 810MHz voltage 20mV timing 0
[    9.992874] [drm] nouveau 0000:01:00.0: 3: memory 1701MHz core 656MHz shader 1312MHz voltage 20mV timing 0
[   10.000278] [TTM] Zone  kernel: Available graphics memory: 4081528 kiB.
[   10.000281] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   10.000282] [TTM] Initializing pool allocator.
[   10.000291] [drm] nouveau 0000:01:00.0: Detected 1280MiB VRAM
[   10.000295] mtrr: type mismatch for d8000000,8000000 old: write-back new: write-combining
[   10.000305] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   10.002677] tveeprom 1-0050: Hauppauge model 69100, rev B2C3, serial# 5328235
[   10.002680] tveeprom 1-0050: MAC address is 00:0d:fe:51:4d:6b
[   10.002682] tveeprom 1-0050: tuner model is Conexant CX24118A (idx 123, type 4)
[   10.002684] tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
[   10.002686] tveeprom 1-0050: audio processor is None (idx 0)
[   10.002688] tveeprom 1-0050: decoder processor is CX882 (idx 25)
[   10.002690] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
[   10.002692] cx88[0]: hauppauge eeprom: model=69100
[   10.012397] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   10.012399] [drm] No driver support for vblank timestamp query.
[   10.051943] Registered IR keymap rc-hauppauge
[   10.052011] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:08:02.0/rc/rc0/input6
[   10.052033] rc0: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:08:02.0/rc/rc0
[   10.052084] input: MCE IR Keyboard/Mouse (cx88xx) as /devices/virtual/input/input7
[   10.052127] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
[   10.052132] cx88[0]/0: found at 0000:08:02.0, rev: 5, irq: 18, latency: 32, mmio: 0xfa000000
[   10.052210] cx88[0]/0: registered device video0 [v4l2]
[   10.052224] cx88[0]/0: registered device vbi0
[   10.052237] cx88[0]/2: cx2388x 8802 Driver Manager
[   10.052245] cx88-mpeg driver manager 0000:08:02.2: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.052251] cx88[0]/2: found at 0000:08:02.2, rev: 5, irq: 18, latency: 32, mmio: 0xf8000000
[   10.201019] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[   10.201025] cx88/2: registering cx8802 driver, type: dvb access: shared
[   10.201032] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[   10.201036] cx88[0]/2: cx2388x based DVB/ATSC card
[   10.201040] cx8802_alloc_frontends() allocating 1 frontend(s)
[   10.253054] DVB: registering new adapter (cx88[0])
[   10.253056] DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
[   10.253638] cx88[0]: videobuf_dvb_register_frontend failed (errno = -12)
[   10.253641] cx88[0]/2: dvb_register failed (err = -12)
[   10.253643] cx88[0]/2: cx8802 probe failed, err = -12
[   10.330776] [drm] nouveau 0000:01:00.0: allocated 1920x1200 fb: 0x1e0000, bo ffff88021cc3d000
[   10.330837] fbcon: nouveaufb (fb0) is primary device
[   10.386001] Console: switching to colour frame buffer device 240x75
[   10.392578] fb0: nouveaufb frame buffer device
[   10.392580] drm: registered panic notifier
[   10.392584] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   10.392613] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   10.392654] snd_hda_intel 0000:01:00.1: irq 48 for MSI/MSI-X
[   10.392673] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[   10.606474] HDMI status: Codec=0 Pin=5 Presence_Detect=0 ELD_Valid=0
[   10.642376] HDMI status: Codec=1 Pin=5 Presence_Detect=0 ELD_Valid=0
[   10.678281] HDMI status: Codec=2 Pin=5 Presence_Detect=0 ELD_Valid=0
[   10.714179] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[   11.585871] usbcore: registered new interface driver usblp
[   12.709526] EXT4-fs (md127p1): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered
[   12.871801] EXT4-fs (md127p2): mounted filesystem with ordered data mode. Opts: commit=45,barrier=1,stripe=32,data=ordered
[   12.966222] EXT4-fs (md127p3): mounted filesystem with ordered data mode. Opts: commit=45,barrier=1,stripe=32,data=ordered
[   12.982062] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: commit=15,barrier=1,data=ordered
[   16.221398] Adding 4000060k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:4000060k 
[   18.441126] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.161017] Netfilter messages via NETLINK v0.30.
[   20.200707] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.464374] ctnetlink v0.93: registering with nfnetlink.
[   20.999117] xt_time: kernel timezone is +0200
[   22.235315] r8169 0000:02:00.0: eth0: link down
[   22.235320] r8169 0000:02:00.0: eth0: link down
[   23.928564] r8169 0000:02:00.0: eth0: link up
[   38.085066] it87: Found IT8720F chip at 0x290, revision 8
[   38.085077] it87: VID is disabled (pins used for GPIO)
[   38.085089] it87: Routing internal VCCH to in7
[   38.085095] it87: Beeping is supported
[  210.607698] ata1.00: configured for UDMA/133
[  210.607701] ata1: EH complete
[  210.647399] ata2.00: configured for UDMA/133
[  210.647402] ata2: EH complete
[  210.783226] ata3.00: configured for UDMA/133
[  210.783230] ata3: EH complete
[  210.979126] ata4.00: configured for UDMA/133
[  210.979130] ata4: EH complete
[  214.841875] EXT4-fs (md127p1): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered,commit=0
[  215.330416] EXT4-fs (md127p2): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered,commit=0
[  215.332890] EXT4-fs (md127p3): re-mounted. Opts: commit=45,barrier=1,stripe=32,data=ordered,commit=0
[  234.517728] ------------[ cut here ]------------
[  234.517736] WARNING: at mm/page_alloc.c:2088 __alloc_pages_nodemask+0x163/0x710()
[  234.517738] Hardware name: P55-UD5
[  234.517739] Modules linked in: it87 hwmon_vid coretemp xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah nf_nat_tftp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables snd_pcm_oss snd_mixer_oss xts gf128mul usbl
 p snd_hda_codec_hdmi isl6421 cx24116 cx88_vp3054_i2c videobuf_dvb dvb_core snd_hda_codec_realtek rc_hauppauge ir_lirc_codec lirc_dev tuner snd_hda_intel ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder cx8802 snd_virtuoso ir_rc6_decoder nouveau snd_hda_codec cx8800 ir_rc5_decoder snd_oxygen_lib cx88xx ir_nec_decoder snd_hwdep rc_core ttm snd_pcm tveeprom snd_timer v4l2_common videodev fbcon font bitblit softcursor drm_kms_helper drm snd_mpu401_uart fb fbdev snd_rawmidi i2c_algo_bit snd cfbcopyarea v4l2_compat_ioctl32 btcx_risc videobuf_dma_sg mxm_wmi cfbimgblt snd_page_alloc wmi videobuf_core joydev xpad cfbfillrect evdev soundcore fuse ext2 mbcache dm_snapshot dm_mirror dm_region_hash dm_log scsi_wait_scan usb_storage
[  234.518053] Pid: 21406, comm: knotify4 Tainted: P            3.1.0-rc9 #2
[  234.518054] Call Trace:
[  234.518060]  [<ffffffff8103c03a>] warn_slowpath_common+0x7a/0xb0
[  234.518064]  [<ffffffff810b3e28>] ? __do_fault+0x1d8/0x4d0
[  234.518067]  [<ffffffff8103c085>] warn_slowpath_null+0x15/0x20
[  234.518070]  [<ffffffff810a1a23>] __alloc_pages_nodemask+0x163/0x710
[  234.518073]  [<ffffffff810b652c>] ? handle_pte_fault+0x7c/0x7a0
[  234.518083]  [<ffffffffa01915d0>] ? v4l_printk_ioctl+0x80/0x80 [videodev]
[  234.518087]  [<ffffffff810e58d5>] ? release_open_intent+0x35/0x40
[  234.518090]  [<ffffffff810b7ea5>] ? handle_mm_fault+0x165/0x300
[  234.518093]  [<ffffffff810a1fe2>] __get_free_pages+0x12/0x40
[  234.518096]  [<ffffffff810ce336>] __kmalloc+0x136/0x150
[  234.518102]  [<ffffffffa00bd181>] usblp_write+0x1d1/0x310 [usblp]
[  234.518107]  [<ffffffffa01901eb>] v4l2_release+0x4b/0x70 [videodev]
[  234.518111]  [<ffffffff810d81e2>] fput+0xd2/0x200
[  234.518114]  [<ffffffff810d4a21>] filp_close+0x61/0x90
[  234.518117]  [<ffffffff810d4b01>] sys_close+0xb1/0x110
[  234.518121]  [<ffffffff813df03b>] system_call_fastpath+0x16/0x1b
[  234.518130] ---[ end trace 6fb2e5d4254083e3 ]---


So long,
matthias.
