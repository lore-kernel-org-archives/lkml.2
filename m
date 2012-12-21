Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2LUR7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:59:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2LUR7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:59:24 -0500
Message-ID: <1356112760.32581.2.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 21 Dec 2012 18:59:20 +0100
In-Reply-To: <1356108846.4547.66.camel@marge.simpson.net>
References: <alpine.LFD.2.02.1212211413200.3148@ionos>
	 <1356106865.4547.60.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1212211729240.3148@ionos>
	 <1356107797.4547.61.camel@marge.simpson.net>
	 <1356108846.4547.66.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:RUcjvyKFeocTmKKuBm7n2uNw3fZEdWsM9WTVxxFTDVN
 ml5yH4YMVd17vvxOxVz4bFiZGzts6ESZ3sMJhRCltJFSNLXAAu
 ke61gGGIKFoe0sjywlqwDI/j8dHccK04+63B+4Sb37ujY373SU
 a6Qi8tO82SvrpN8uXxtrNnmd6AGDMfL9B7hVWfDS/sYBAq5DA/
 5KG8sZ7hzDGfg03d720YdLHOuXpNKzOc88nfLo8AY/IUjgjPTs
 Xu9c7/Ut420vmXnMsaODOQJPhtpmQL8UDl2vj/ZMHDlgN42QPG
 y45pi/B9ETPhGXRT5WgltKMZLTbN5cRb5EQIuGmQNXy87/6dNQ
 CyZQseCfrFnEkJxoLZD9wjaLmaxsGdwbFrOvsIgxQ4H+ZM8TWd
 +CrsvToYfmFhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 17:54 +0100, Mike Galbraith wrote: 
> On Fri, 2012-12-21 at 17:36 +0100, Mike Galbraith wrote: 
> > On Fri, 2012-12-21 at 17:29 +0100, Thomas Gleixner wrote: 
> > > On Fri, 21 Dec 2012, Mike Galbraith wrote:
> > > > Just got this apocalypse day hiccup.
> > > 
> > > Can you revert the block chill patch ?
> > 
> > Sure, will do, and beat the box up a bit.
> 
> Hm, while I was away, box must have had a fit, then boot didn't go well.

It did that again (chill is reverted), but what it was up to prior to
reboot was endless soft lockup.

[  330.529754] BUG: soft lockup - CPU#41 stuck for 22s! [init_buildsyste:28863]
[  330.529801] Modules linked in: iptable_filter ip_tables x_tables nfsv3 nfs_acl nfs fscache lockd sunrpc autofs4 ipmi_devintf ipmi_si ipmi_msghandler edd af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq mperf fuse loop dm_mod ipv6 bnx2 coretemp kvm_intel iTCO_wdt sr_mod cdrom netxen_nic iTCO_vendor_support shpchp rtc_cmos kvm hpwdt joydev hid_generic sg container hpilo lpc_ich crc32c_intel pci_hotplug i7core_edac microcode mfd_core edac_core serio_raw pcspkr acpi_power_meter button ext3 jbd mbcache usbhid hid radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore thermal usb_common processor thermal_sys hwmon scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh ata_generic ata_piix libata hpsa cciss scsi_mod
[  330.529808] CPU 41 
[  330.529808] Pid: 28863, comm: init_buildsyste Not tainted 3.6.11-rt24-rt_trace #7 Hewlett-Packard ProLiant DL980 G7
[  330.529820] RIP: 0010:[<ffffffff81481f95>]  [<ffffffff81481f95>] _raw_spin_lock+0x35/0x40
[  330.529822] RSP: 0018:ffff88026bd41a38  EFLAGS: 00000283
[  330.529823] RAX: 0000000000006372 RBX: ffff88026d6f8580 RCX: ffff88026d6f8580
[  330.529824] RDX: 000000000000273d RSI: 0000000000000001 RDI: ffff880200524f40
[  330.529825] RBP: ffff88026bd41a38 R08: 0000000000014669 R09: 0000000000014667
[  330.529826] R10: 0000000000000000 R11: 0000000000014620 R12: ffff88026d6f8cf8
[  330.529827] R13: 0000000000000030 R14: ffff88026bd40000 R15: ffff88026bd40010
[  330.529829] FS:  00007f0e637a4700(0000) GS:ffff88027eb20000(0000) knlGS:0000000000000000
[  330.529830] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  330.529831] CR2: 00007f0e62e12c30 CR3: 000000027273c000 CR4: 00000000000007e0
[  330.529832] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  330.529832] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  330.529834] Process init_buildsyste (pid: 28863, threadinfo ffff88026bd40000, task ffff88026d6f8580)
[  330.529834] Stack:
[  330.529846]  ffff88026bd41b18 ffffffff81481356 0000000000000000 0000000000000000
[  330.529849]  0000000000000002 0000000000000003 ffff88026bd41b28 ffffffff81120252
[  330.529854]  ffff88027ffebe00 ffff880200000002 ffff88026bd41fd8 ffff88026d6f8580
[  330.529854] Call Trace:
[  330.529860]  [<ffffffff81481356>] rt_spin_lock_slowlock+0x36/0x320
[  330.529867]  [<ffffffff81120252>] ? __alloc_pages_nodemask+0x162/0x260
[  330.529870]  [<ffffffff81481c87>] rt_spin_lock+0x27/0x30
[  330.529874]  [<ffffffff811252fb>] __lru_cache_add+0x5b/0x120
[  330.529877]  [<ffffffff811253e8>] lru_cache_add_lru+0x28/0x40
[  330.529884]  [<ffffffff8114a9b5>] page_add_new_anon_rmap+0xa5/0xd0
[  330.529888]  [<ffffffff8113de4d>] do_anonymous_page+0x28d/0x330
[  330.529892]  [<ffffffff81142e1a>] handle_pte_fault+0x20a/0x210
[  330.529895]  [<ffffffff81142fcc>] handle_mm_fault+0x1ac/0x240
[  330.529897]  [<ffffffff8114324c>] __get_user_pages+0x11c/0x580
[  330.529900]  [<ffffffff81143762>] get_user_pages+0x52/0x60

> It the end of the world as we know it, it's the.... lalalalala :)
> 
> [    7.485144] Unpacking initramfs...
> [    7.490424] BUG: unable to handle kernel paging request at ffff87ffb5c04f70
> [    7.490430] IP: [<ffffffff811252e8>] __lru_cache_add+0x48/0x120
> [    7.490432] PGD 0 
> [    7.490434] Oops: 0000 [#1] PREEMPT SMP 
> [    7.490437] Modules linked in:
> [    7.490442] CPU 0 
> [    7.490442] Pid: 1, comm: swapper/0 Not tainted 3.6.11-rt24-rt_trace #6 Hewlett-Packard ProLiant DL980 G7
> [    7.490445] RIP: 0010:[<ffffffff811252e8>]  [<ffffffff811252e8>] __lru_cache_add+0x48/0x120
> [    7.490447] RSP: 0018:ffff880035d2b8f0  EFLAGS: 00010283
> [    7.490448] RAX: 0000000000000000 RBX: ffff87ffb5c04f40 RCX: ffff880035d2a000
> [    7.490449] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffea0000b215b0
> [    7.490450] RBP: ffff880035d2b920 R08: 0000000000014603 R09: 0000000000014601
> [    7.490451] R10: 00000000000000e0 R11: 00000000000145b8 R12: ffff880035d28040
> [    7.490452] R13: ffffea0000b215b0 R14: 0000000000000002 R15: ffffffff81a04f40
> [    7.490453] FS:  0000000000000000(0000) GS:ffff880034200000(0000) knlGS:0000000000000000
> [    7.490454] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    7.490455] CR2: ffff87ffb5c04f70 CR3: 0000000028a0e000 CR4: 00000000000007f0
> [    7.490456] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    7.490457] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    7.490458] Process swapper/0 (pid: 1, threadinfo ffff880035d2a000, task ffff880035d28040)
> [    7.490458] Stack:
> [    7.490463]  ffff880035d2b920 ffffea0000b215b0 0000000000000000 0000000000000000
> [    7.490467]  ffff88003290f480 00000000000200d2 ffff880035d2b940 ffffffff81116a9d
> [    7.490471]  ffffea0000b215b0 0000000000000000 ffff880035d2b990 ffffffff81116b3c
> [    7.490472] Call Trace:
> [    7.490479]  [<ffffffff81116a9d>] add_to_page_cache_lru+0x4d/0x50
> [    7.490481]  [<ffffffff81116b3c>] grab_cache_page_write_begin+0x9c/0xf0
> [    7.490484]  [<ffffffff81195f4b>] simple_write_begin+0x3b/0x100
> [    7.490487]  [<ffffffff81115721>] generic_perform_write+0xc1/0x1e0
> [    7.490490]  [<ffffffff8104f3a7>] ? current_fs_time+0x27/0x30
> [    7.490493]  [<ffffffff811158a5>] generic_file_buffered_write+0x65/0xa0
> [    7.490496]  [<ffffffff81118356>] __generic_file_aio_write+0x1b6/0x390
> [    7.490499]  [<ffffffff811185a7>] generic_file_aio_write+0x77/0xe0
> [    7.490509]  [<ffffffff81b03460>] ? bunzip2+0x38f/0x38f
> [    7.490512]  [<ffffffff8116edc9>] do_sync_write+0xa9/0xf0
> [    7.490515]  [<ffffffff8116f3cb>] vfs_write+0xcb/0x130
> [    7.490517]  [<ffffffff8116f525>] sys_write+0x55/0x90
> [    7.490524]  [<ffffffff81ad84e8>] do_copy+0x6d/0xe7
> [    7.490526]  [<ffffffff81ad7fd9>] flush_buffer+0x4d/0xa8
> [    7.490528]  [<ffffffff81b0373b>] gunzip+0x2d0/0x385
> [    7.490531]  [<ffffffff81ad7f8c>] ? do_reset+0x88/0x88
> [    7.490533]  [<ffffffff81ad83ca>] unpack_to_rootfs+0x260/0x311
> [    7.490536]  [<ffffffff81ad7e00>] ? md_run_setup+0x9a/0x9a
> [    7.490544]  [<ffffffff8147ed91>] ? printk+0x4f/0x51
> [    7.490546]  [<ffffffff81ad8c4d>] ? do_header+0x292/0x292
> [    7.490549]  [<ffffffff81ad8ca9>] populate_rootfs+0x5c/0x118
> [    7.490552]  [<ffffffff810001c2>] do_one_initcall+0x42/0x180
> [    7.490555]  [<ffffffff81ad6616>] do_basic_setup+0xad/0xce
> [    7.490557]  [<ffffffff81ad6637>] ? do_basic_setup+0xce/0xce
> [    7.490560]  [<ffffffff81ad6825>] kernel_init+0x196/0x21c
> [    7.490562]  [<ffffffff8148a904>] kernel_thread_helper+0x4/0x10
> [    7.490565]  [<ffffffff81ad668f>] ? repair_env_string+0x58/0x58
> [    7.490567]  [<ffffffff8148a900>] ? gs_change+0x13/0x13
> [    7.490581] Code: 66 66 66 90 49 c7 c7 40 4f a0 81 49 89 fd 41 89 f6 4c 89 fb e8 da b3 f5 ff 65 48 03 1c 25 28 ae 00 00 65 4c 8b 24 25 40 99 00 00 <4c> 39 63 30 74 11 e8 bd b3 f5 ff 48 89 df e8 75 c9 35 00 4c 89 
> [    7.490583] RIP  [<ffffffff811252e8>] __lru_cache_add+0x48/0x120
> [    7.490584]  RSP <ffff880035d2b8f0>
> [    7.490585] CR2: ffff87ffb5c04f70
> [    8.146910] ---[ end trace 0000000000000001 ]---
> [    8.146974] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> 
> 


