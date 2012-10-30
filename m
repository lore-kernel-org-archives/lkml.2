Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2J3FSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:18:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2J3FSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:18:50 -0400
Message-ID: <1351574241.3810.5.camel@turiel>
Subject: Re: nouveau, linux3.7-rc3: BUG: unable to handle kernel paging
 request at fffffffffffffff8
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 15:17:21 +1000
In-Reply-To: <20121029231624.1476a25a62a0c219cc25627a@studenti.unina.it>
References: <20121029231624.1476a25a62a0c219cc25627a@studenti.unina.it>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 23:16 +0100, Antonio Ospite wrote:
> Hi,
> 
> I am experiencing a bug with nouveau with linux-3.7-rc3 (and since rc1),
> my video adapter is the one integrated on the MSI M3N78-VM motherboard
> (hence x86_64):
> 
> 02:00.0 VGA compatible controller: NVIDIA Corporation C77 [GeForce 8200] (rev a2) (prog-if 00 [VGA controller])
>         Subsystem: ASUSTeK Computer Inc. Device 82f2
>         Flags: bus master, fast devsel, latency 0, IRQ 21
>         Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
>         Memory at f0000000 (64-bit, prefetchable) [size=128M]
>         Memory at fa000000 (64-bit, prefetchable) [size=32M]
>         I/O ports at ec00 [size=128]
>         Expansion ROM at febe0000 [disabled] [size=128K]
>         Capabilities: [60] Power Management version 2
>         Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Kernel driver in use: nouveau
> 
> The problem presents itself as soon as I use a gnome-shell session from
> gdm3, if I use the fall-back mode (gnome-panel) it does not happen
> immediately, until maybe some processes do something stressful (firefox
> triggered it twice).
If you boot into fallback mode and run glxgears (or whatever, some 3d
app) does this happen too?

> 
> Here is the kernel trace, please let me know if the disassembled
> nouveau.o —or any other information— is necessary:
Are you able to post me your entire kernel log from before this happens?

Thanks,
Ben.

> 
> [ 1943.858601] BUG: unable to handle kernel paging request at fffffffffffffff8
> [ 1943.858669] IP: [<ffffffffa031a67a>] nouveau_mm_head+0x30/0x127 [nouveau]
> [ 1943.858779] PGD 160d067 PUD 160e067 PMD 0 
> [ 1943.858803] Oops: 0000 [#1] SMP 
> [ 1943.858823] Modules linked in: hidp ebtable_nat ebtables cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace ipt_MASQUERADE xt_CHECKSUM bridge stp llc ppdev lp bnep rfcomm tun sit tunnel4 binfmt_misc uinput ib_iser rdma_cm ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip6table_raw ip6table_mangle ip6t_REJECT xt_LOG nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6table_filter ip6_tables xt_tcpudp ipt_REJECT ipt_ULOG xt_limit xt_multiport xt_conntrack iptable_filter iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw ip_tables x_tables hwmon_vid loop fuse snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc nouveau snd_seq_midi snd_seq_midi_event powernow_k8 snd_rawmidi snd_seq kvm_amd snd_seq_device kvm snd_timer ttm snd edac_mce_amd btusb drm_kms_helper bluetooth edac_core drm rfkill i2c!
 _a!
>  lgo_bit
> mxm_wmi shpchp asus_atk0110 soundcore crc16 k8temp evdev pcspkr parport_pc parport video wmi processor thermal_sys i2c_nforce2 i2c_core button ext3 mbcache jbd dm_mod sg hid_generic sr_mod sd_mod cdrom crc_t10dif usbhid usb_storage hid uas ohci_hcd ahci libahci libata ehci_hcd forcedeth scsi_mod usbcore usb_common floppy
> [ 1943.859565] CPU 0 
> [ 1943.859580] Pid: 2985, comm: Xorg Not tainted 3.7.0-rc3-ao2 #1 System manufacturer System Product Name/M3N78-VM
> [ 1943.859609] RIP: 0010:[<ffffffffa031a67a>]  [<ffffffffa031a67a>] nouveau_mm_head+0x30/0x127 [nouveau]
> [ 1943.859670] RSP: 0018:ffff8801179519a8  EFLAGS: 00010212
> [ 1943.859687] RAX: 00000000ffffffff RBX: fffffffffffffff0 RCX: 000000000000007e
> [ 1943.859708] RDX: 000000000000007e RSI: 0000000000000001 RDI: ffff880117bfbce8
> [ 1943.859728] RBP: ffff88011785fd38 R08: 0000000000000000 R09: ffff88011785fd38
> [ 1943.859748] R10: ffff880117bfbc00 R11: ffff88011785fc80 R12: 000000000000007e
> [ 1943.859769] R13: ffff880117bfbc01 R14: ffff880117bfbc20 R15: ffff880117951a70
> [ 1943.859791] FS:  00007f1099383880(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
> [ 1943.859813] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1943.859830] CR2: fffffffffffffff8 CR3: 0000000118473000 CR4: 00000000000007f0
> [ 1943.859850] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1943.859870] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1943.859891] Process Xorg (pid: 2985, threadinfo ffff880117950000, task ffff8801181cc8e0)
> [ 1943.859911] Stack:
> [ 1943.859920]  0000000000000246 ffffffff810fa13d ffffffff81060f13 00000000000003f0
> [ 1943.859955]  0000000000000002 0000000000000010 ffff880117bfbc00 ffff880117bfbc20
> [ 1943.859986]  ffff880117951a70 ffffffffa032a10a ffff880100000000 000003f000000008
> [ 1943.860018] Call Trace:
> [ 1943.860019]  [<ffffffff810fa13d>] ? kmem_cache_alloc_trace+0xbf/0xcf
> [ 1943.860019]  [<ffffffff81060f13>] ? should_resched+0x5/0x23
> [ 1943.860019]  [<ffffffffa032a10a>] ? nv50_fb_vram_new+0xc5/0x1f2 [nouveau]
> [ 1943.860019]  [<ffffffffa03687b6>] ? nouveau_vram_manager_new+0x62/0xa4 [nouveau]
> [ 1943.860019]  [<ffffffffa0294334>] ? ttm_bo_handle_move_mem+0x1ab/0x2ec [ttm]
> [ 1943.860019]  [<ffffffffa0294d34>] ? ttm_bo_mem_space+0x112/0x2f8 [ttm]
> [ 1943.860019]  [<ffffffffa0294fbd>] ? ttm_bo_move_buffer+0xa3/0xee [ttm]
> [ 1943.860019]  [<ffffffff810fa13d>] ? kmem_cache_alloc_trace+0xbf/0xcf
> [ 1943.860019]  [<ffffffffa02950ae>] ? ttm_bo_validate+0xa6/0xeb [ttm]
> [ 1943.860019]  [<ffffffffa0295466>] ? ttm_bo_init+0x373/0x3b2 [ttm]
> [ 1943.860019]  [<ffffffffa036a021>] ? nouveau_bo_new+0x23f/0x264 [nouveau]
> [ 1943.860019]  [<ffffffffa0369c55>] ? nouveau_ttm_tt_unpopulate+0xa3/0xa3 [nouveau]
> [ 1943.860019]  [<ffffffffa036b77a>] ? nouveau_gem_new+0x53/0xf7 [nouveau]
> [ 1943.860019]  [<ffffffff81060f13>] ? should_resched+0x5/0x23
> [ 1943.860019]  [<ffffffff8137031a>] ? _cond_resched+0x6/0x1b
> [ 1943.860019]  [<ffffffffa036b8bd>] ? nouveau_gem_ioctl_new+0x9f/0x107 [nouveau]
> [ 1943.860019]  [<ffffffffa022507b>] ? drm_gem_flink_ioctl+0xc1/0xde [drm]
> [ 1943.860019]  [<ffffffffa0223603>] ? drm_ioctl+0x28c/0x36a [drm]
> [ 1943.860019]  [<ffffffff810dfe6e>] ? handle_pte_fault+0x6ff/0x770
> [ 1943.860019]  [<ffffffffa036b81e>] ? nouveau_gem_new+0xf7/0xf7 [nouveau]
> [ 1943.860019]  [<ffffffff81373f12>] ? __do_page_fault+0x2d8/0x376
> [ 1943.860019]  [<ffffffff8110eb82>] ? vfs_ioctl+0x1e/0x31
> [ 1943.860019]  [<ffffffff8110f3ba>] ? do_vfs_ioctl+0x3ee/0x430
> [ 1943.860019]  [<ffffffff8110289c>] ? vfs_read+0xac/0xf5
> [ 1943.860019]  [<ffffffff8110f449>] ? sys_ioctl+0x4d/0x7c
> [ 1943.860019]  [<ffffffff81376129>] ? system_call_fastpath+0x16/0x1b
> [ 1943.860019] Code: 44 89 c0 41 56 f7 d0 41 55 41 88 f5 41 54 41 89 d4 55 4c 89 cd 53 48 83 ec 18 48 8b 5f 10 89 44 24 0c 48 83 eb 10 e9 da 00 00 00 <48> 8b 43 08 44 8b 53 34 44 8b 7b 38 48 39 f8 45 89 d3 47 8d 0c 
> [ 1943.860019] RIP  [<ffffffffa031a67a>] nouveau_mm_head+0x30/0x127 [nouveau]
> [ 1943.860019]  RSP <ffff8801179519a8>
> [ 1943.860019] CR2: fffffffffffffff8
> [ 1943.860019] ---[ end trace cbc160afe55cb77d ]---
> [ 1945.878352] nouveau E[     DRM] EvoCh 1 Mthd 0x0080 Data 0x00000000 (0x000b 0x05)
> [ 1945.880013] [sched_delayed] sched: RT throttling activated
> 
> Thanks,
>    Antonio
> 


