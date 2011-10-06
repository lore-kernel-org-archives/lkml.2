Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965184Ab1JFRZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:25:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38410 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754Ab1JFRYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:24:42 -0400
Date: Thu, 6 Oct 2011 10:24:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: nouveau@lists.freedesktop.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: NOUVEAU: allocation failure and subsequent oops in 3.1-rc8
Message-ID: <20111006172432.GA2093@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just seen X die on me (not remember doing anythign remarkable, was just
reading a web page). The kernel is 3.1-rc8 plus contents of my input
queue which only touches stuff in drivers/input.

Thanks!

-- 
Dmitry


[161028.250162] X: page allocation failure: order:4, mode:0x40d0
[161028.250168] Pid: 1516, comm: X Not tainted 3.1.0-rc8+ #683
[161028.250171] Call Trace:
[161028.250181]  [<ffffffff8111aeb5>] warn_alloc_failed+0xc5/0x150
[161028.250203]  [<ffffffff815650fd>] ? sub_preempt_count.part.59+0x5d/0xa0
[161028.250208]  [<ffffffff8111efd7>] __alloc_pages_nodemask+0x6f7/0x900
[161028.250214]  [<ffffffff81155b53>] alloc_pages_current+0xa3/0x110
[161028.250218]  [<ffffffff8111a08e>] __get_free_pages+0xe/0x40
[161028.250223]  [<ffffffff8116057f>] kmalloc_order_trace+0x3f/0x180
[161028.250227]  [<ffffffff81161788>] __kmalloc+0x258/0x260
[161028.250257]  [<ffffffffa009af82>] nouveau_sgdma_populate+0x52/0x1f0 [nouveau]
[161028.250281]  [<ffffffffa007b625>] ttm_tt_populate+0x95/0xc0 [ttm]
[161028.250288]  [<ffffffffa007b68d>] ttm_tt_bind+0x3d/0x80 [ttm]
[161028.250295]  [<ffffffffa007d68f>] ttm_bo_handle_move_mem+0x36f/0x3e0 [ttm]
[161028.250302]  [<ffffffffa007d8c5>] ttm_bo_evict+0x1c5/0x2b0 [ttm]
[161028.250320]  [<ffffffff8104f023>] ? get_parent_ip+0x33/0x50
[161028.250328]  [<ffffffffa007dafb>] ttm_mem_evict_first+0x14b/0x1f0 [ttm]
[161028.250336]  [<ffffffffa007e3fe>] ttm_bo_mem_space+0x34e/0x460 [ttm]
[161028.250343]  [<ffffffffa007e5f8>] ttm_bo_move_buffer+0xe8/0x160 [ttm]
[161028.250348]  [<ffffffff8104f023>] ? get_parent_ip+0x33/0x50
[161028.250355]  [<ffffffffa007e757>] ttm_bo_validate+0xe7/0xf0 [ttm]
[161028.250362]  [<ffffffffa007e921>] ttm_bo_init+0x1c1/0x260 [ttm]
[161028.250373]  [<ffffffffa009cad0>] nouveau_bo_new+0x150/0x1b0 [nouveau]
[161028.250397]  [<ffffffffa009c710>] ? nouveau_bo_create_ttm_backend_entry+0x90/0x90 [nouveau]
[161028.250410]  [<ffffffffa00a0268>] nouveau_gem_new+0x58/0x120 [nouveau]
[161028.250415]  [<ffffffff811392b3>] ? might_fault+0x53/0xb0
[161028.250418]  [<ffffffff811392b3>] ? might_fault+0x53/0xb0
[161028.250442]  [<ffffffffa00a039e>] nouveau_gem_ioctl_new+0x6e/0x170 [nouveau]
[161028.250446]  [<ffffffff811392b3>] ? might_fault+0x53/0xb0
[161028.250462]  [<ffffffffa002a5f4>] drm_ioctl+0x3f4/0x4d0 [drm]
[161028.250474]  [<ffffffffa00a0330>] ? nouveau_gem_new+0x120/0x120 [nouveau]
[161028.250492]  [<ffffffff8118a68a>] do_vfs_ioctl+0x8a/0x340
[161028.250498]  [<ffffffff81261754>] ? selinux_file_ioctl+0x74/0x160
[161028.250502]  [<ffffffff8118a9d1>] sys_ioctl+0x91/0xa0
[161028.250506]  [<ffffffff8156962b>] system_call_fastpath+0x16/0x1b
[161028.250509] Mem-Info:
[161028.250511] Node 0 DMA per-cpu:
[161028.250515] CPU    0: hi:    0, btch:   1 usd:   0
[161028.250518] CPU    1: hi:    0, btch:   1 usd:   0
[161028.250520] Node 0 DMA32 per-cpu:
[161028.250523] CPU    0: hi:  186, btch:  31 usd:   0
[161028.250526] CPU    1: hi:  186, btch:  31 usd:   0
[161028.250528] Node 0 Normal per-cpu:
[161028.250531] CPU    0: hi:  186, btch:  31 usd:   7
[161028.250534] CPU    1: hi:  186, btch:  31 usd:   0
[161028.250538] active_anon:312086 inactive_anon:85461 isolated_anon:0
[161028.250540]  active_file:95300 inactive_file:94568 isolated_file:0
[161028.250541]  unevictable:24 dirty:218 writeback:0 unstable:0
[161028.250542]  free:31003 slab_reclaimable:260096 slab_unreclaimable:51239
[161028.250543]  mapped:31708 shmem:1057 pagetables:16715 bounce:0
[161028.250546] Node 0 DMA free:15912kB min:256kB low:320kB high:384kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15656kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[161028.250557] lowmem_reserve[]: 0 3502 4006 4006
[161028.250563] Node 0 DMA32 free:96452kB min:58856kB low:73568kB high:88284kB active_anon:1168556kB inactive_anon:261956kB active_file:335752kB inactive_file:337352kB unevictable:80kB isolated(anon):0kB isolated(file):0kB present:3586664kB mlocked:80kB dirty:796kB writeback:0kB mapped:90116kB shmem:1540kB slab_reclaimable:1009696kB slab_unreclaimable:133388kB kernel_stack:2872kB pagetables:55440kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[161028.250575] lowmem_reserve[]: 0 0 503 503
[161028.250581] Node 0 Normal free:11648kB min:8468kB low:10584kB high:12700kB active_anon:79788kB inactive_anon:79888kB active_file:45448kB inactive_file:40920kB unevictable:16kB isolated(anon):0kB isolated(file):0kB present:516088kB mlocked:16kB dirty:76kB writeback:0kB mapped:36716kB shmem:2688kB slab_reclaimable:30688kB slab_unreclaimable:71568kB kernel_stack:1016kB pagetables:11420kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:29 all_unreclaimable? no
[161028.250592] lowmem_reserve[]: 0 0 0 0
[161028.250598] Node 0 DMA: 0*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15912kB
[161028.250614] Node 0 DMA32: 5557*4kB 7390*8kB 518*16kB 131*32kB 9*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 96452kB
[161028.250629] Node 0 Normal: 1960*4kB 402*8kB 29*16kB 2*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 11648kB
[161028.250644] 196976 total pagecache pages
[161028.250646] 6058 pages in swap cache
[161028.250649] Swap cache stats: add 184290, delete 178232, find 168290/181184
[161028.250651] Free swap  = 8192696kB
[161028.250653] Total swap = 8388604kB
[161028.277250] 1048560 pages RAM
[161028.277254] 38081 pages reserved
[161028.277256] 224808 pages shared
[161028.277258] 875777 pages non-shared
[161028.277448] BUG: unable to handle kernel NULL pointer dereference at           (null)
[161028.277527] IP: [<ffffffffa0118b99>] nv50_vm_map_sg+0x59/0xd0 [nouveau]
[161028.277606] PGD 116e5d067 PUD 114244067 PMD 0 
[161028.277648] Oops: 0000 [#1] PREEMPT SMP 
[161028.277687] CPU 1 
[161028.277705] Modules linked in: iwlagn tun joydev vmnet fuse vsock vmci vmmon sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf rfcomm bnep ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables coretemp arc4 ppdev snd_hda_codec_idt dell_wmi sparse_keymap snd_hda_intel snd_hda_codec snd_hwdep snd_seq dell_laptop snd_seq_device snd_pcm microcode dcdbas btusb i2c_i801 iTCO_wdt snd_timer tg3 pcspkr iTCO_vendor_support bluetooth mac80211 snd soundcore cfg80211 snd_page_alloc rfkill parport_pc parport mac_hid ipv6 firewire_ohci firewire_core crc_itu_t yenta_socket nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core mxm_wmi wmi video [last unloaded: iwlagn]
[161028.278013] 
[161028.278013] Pid: 1516, comm: X Not tainted 3.1.0-rc8+ #683 Dell Inc. Latitude D630                   /0WM416
[161028.278013] RIP: 0010:[<ffffffffa0118b99>]  [<ffffffffa0118b99>] nv50_vm_map_sg+0x59/0xd0 [nouveau]
[161028.278013] RSP: 0018:ffff880113b41728  EFLAGS: 00010212
[161028.278013] RAX: 0000000000000008 RBX: ffff880115abdd00 RCX: 0000000000000015
[161028.278013] RDX: ffff88004bd44600 RSI: 00000000000000a8 RDI: ffff880115abdd00
[161028.278013] RBP: ffff880113b41778 R08: 0000000000009700 R09: 0000000000000000
[161028.278013] R10: 0000000000000001 R11: 0000000000020000 R12: ffff880088715f78
[161028.278013] R13: ffff88004bd44600 R14: 0000000000000000 R15: 00000000000000a8
[161028.278013] FS:  00007f1a810348a0(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
[161028.278013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[161028.278013] CR2: 0000000000000000 CR3: 000000011411b000 CR4: 00000000000006e0
[161028.278013] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[161028.278013] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[161028.278013] Process X (pid: 1516, threadinfo ffff880113b40000, task ffff88011630bf80)
[161028.278013] Stack:
[161028.278013]  ffff880113b41738 ffffffff8109b9fd ffff880113b41768 0000000000009700
[161028.278013]  00000000010f0000 ffff8801159bbe40 00000000000012e0 ffff880088715f78
[161028.278013]  0000000000000000 ffff88004bd44600 ffff880113b417d8 ffffffffa00c0ee3
[161028.278013] Call Trace:
[161028.278013]  [<ffffffff8109b9fd>] ? trace_hardirqs_on+0xd/0x10
[161028.278013]  [<ffffffffa00c0ee3>] nouveau_vm_map_sg+0xb3/0x120 [nouveau]
[161028.278013]  [<ffffffffa009dbc6>] ? nouveau_bo_move_m2mf+0x196/0x1b0 [nouveau]
[161028.278013]  [<ffffffffa009c4b1>] nouveau_vma_getmap+0x71/0xb0 [nouveau]
[161028.278013]  [<ffffffffa009daff>] nouveau_bo_move_m2mf+0xcf/0x1b0 [nouveau]
[161028.278013]  [<ffffffffa00c0ff8>] ? nouveau_vm_unmap_at+0xa8/0xe0 [nouveau]
[161028.278013]  [<ffffffffa009df9a>] nouveau_bo_move+0xba/0x270 [nouveau]
[161028.278013]  [<ffffffffa00c104b>] ? nouveau_vm_unmap+0x1b/0x20 [nouveau]
[161028.278013]  [<ffffffffa007d52c>] ttm_bo_handle_move_mem+0x20c/0x3e0 [ttm]
[161028.278013]  [<ffffffffa007d8c5>] ttm_bo_evict+0x1c5/0x2b0 [ttm]
[161028.278013]  [<ffffffff8104f023>] ? get_parent_ip+0x33/0x50
[161028.278013]  [<ffffffffa007dafb>] ttm_mem_evict_first+0x14b/0x1f0 [ttm]
[161028.278013]  [<ffffffffa007e3fe>] ttm_bo_mem_space+0x34e/0x460 [ttm]
[161028.278013]  [<ffffffffa007e5f8>] ttm_bo_move_buffer+0xe8/0x160 [ttm]
[161028.278013]  [<ffffffff8104f023>] ? get_parent_ip+0x33/0x50
[161028.278013]  [<ffffffffa007e757>] ttm_bo_validate+0xe7/0xf0 [ttm]
[161028.278013]  [<ffffffffa007e921>] ttm_bo_init+0x1c1/0x260 [ttm]
[161028.278013]  [<ffffffffa009cad0>] nouveau_bo_new+0x150/0x1b0 [nouveau]
[161028.278013]  [<ffffffffa009c710>] ? nouveau_bo_create_ttm_backend_entry+0x90/0x90 [nouveau]
[161028.278013]  [<ffffffffa00a0268>] nouveau_gem_new+0x58/0x120 [nouveau]
[161028.278013]  [<ffffffff811392b3>] ? might_fault+0x53/0xb0
[161028.278013]  [<ffffffff811392b3>] ? might_fault+0x53/0xb0
[161028.278013]  [<ffffffffa00a039e>] nouveau_gem_ioctl_new+0x6e/0x170 [nouveau]
[161028.278013]  [<ffffffff811392b3>] ? might_fault+0x53/0xb0
[161028.278013]  [<ffffffffa002a5f4>] drm_ioctl+0x3f4/0x4d0 [drm]
[161028.278013]  [<ffffffffa00a0330>] ? nouveau_gem_new+0x120/0x120 [nouveau]
[161028.278013]  [<ffffffff8118a68a>] do_vfs_ioctl+0x8a/0x340
[161028.278013]  [<ffffffff81261754>] ? selinux_file_ioctl+0x74/0x160
[161028.278013]  [<ffffffff8118a9d1>] sys_ioctl+0x91/0xa0
[161028.278013]  [<ffffffff8156962b>] system_call_fastpath+0x16/0x1b
[161028.278013] Code: e8 01 4e 8d 04 c0 44 8d 3c cd 00 00 00 00 4c 89 45 c8 eb 0a 66 0f 1f 44 00 00 48 83 c0 08 45 8b b5 d8 00 00 00 44 89 fe 48 89 df 
[161028.278013]  8b 11 48 89 45 b8 48 89 45 c0 49 c1 e6 28 49 83 ce 21 49 09 
[161028.278013] RIP  [<ffffffffa0118b99>] nv50_vm_map_sg+0x59/0xd0 [nouveau]
[161028.278013]  RSP <ffff880113b41728>
[161028.278013] CR2: 0000000000000000
[161028.336412] ---[ end trace 53e759753af0a3d1 ]---
