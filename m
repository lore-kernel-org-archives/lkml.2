Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1INBHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 21:07:44 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54797 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1INBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 21:07:42 -0400
Message-ID: <4E6FFE3E.1090702@gmail.com>
Date: Tue, 13 Sep 2011 19:07:10 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, nouveau@lists.freedesktop.org
Subject: 3.0.3 nouveau: page allocation failure and oops
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just saw this page allocation failure followed by a null pointer 
dereference in Fedora 15 2.6.40.3-0 (aka 3.0.3). This is with a GeForce 
9600GT. Is this already known?

Sep 13 17:30:02 newcastle kernel: [2307769.792783] Xorg: page allocation 
failure: order:6, mode:0x40d0
Sep 13 17:30:02 newcastle kernel: [2307769.792787] Pid: 13010, comm: 
Xorg Not tainted 2.6.40.3-0.fc15.x86_64 #1
Sep 13 17:30:02 newcastle kernel: [2307769.792788] Call Trace:
Sep 13 17:30:02 newcastle kernel: [2307769.792796]  [<ffffffff810dfd72>] 
warn_alloc_failed+0x111/0x13d
Sep 13 17:30:02 newcastle kernel: [2307769.792803]  [<ffffffff810e2d25>] 
__alloc_pages_nodemask+0x6c5/0x736
Sep 13 17:30:02 newcastle kernel: [2307769.792807]  [<ffffffff8110db8e>] 
alloc_pages_current+0xbe/0xd8
Sep 13 17:30:02 newcastle kernel: [2307769.792810]  [<ffffffff811f2cf6>] 
? security_capable+0x2a/0x2c
Sep 13 17:30:02 newcastle kernel: [2307769.792812]  [<ffffffff810df6b7>] 
__get_free_pages+0xe/0x4a
Sep 13 17:30:02 newcastle kernel: [2307769.792816]  [<ffffffff81114cfb>] 
kmalloc_order_trace+0x2c/0x5e
Sep 13 17:30:02 newcastle kernel: [2307769.792818]  [<ffffffff8111658e>] 
__kmalloc+0x37/0x115
Sep 13 17:30:02 newcastle kernel: [2307769.792836]  [<ffffffffa008eafa>] 
nouveau_sgdma_populate+0x8a/0x167 [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.792841]  [<ffffffffa00730ff>] 
ttm_tt_populate+0x63/0x7c [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792845]  [<ffffffffa007314a>] 
ttm_tt_bind+0x32/0x66 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792850]  [<ffffffffa00747bb>] 
ttm_bo_handle_move_mem+0x10c/0x299 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792854]  [<ffffffffa0074be7>] 
ttm_bo_evict+0x29f/0x2e8 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792859]  [<ffffffffa0074d82>] 
ttm_mem_evict_first+0x152/0x180 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792863]  [<ffffffffa00753f7>] 
ttm_bo_mem_space+0x29b/0x2ea [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792868]  [<ffffffffa00754fc>] 
ttm_bo_move_buffer+0xb6/0x10c [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792877]  [<ffffffffa0031be4>] 
? drm_mm_insert_helper+0xd3/0xec [drm]
Sep 13 17:30:02 newcastle kernel: [2307769.792882]  [<ffffffffa0075608>] 
ttm_bo_validate+0xb6/0xf4 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792886]  [<ffffffffa0075946>] 
ttm_bo_init+0x300/0x339 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.792894]  [<ffffffffa008fe82>] 
nouveau_bo_new+0x246/0x283 [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.792901]  [<ffffffffa008fa45>] 
? nouveau_bo_create_ttm_backend_entry+0x6c/0x6c [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.792909]  [<ffffffffa0092103>] 
nouveau_gem_new+0x5e/0xee [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.792918]  [<ffffffffa0092272>] 
nouveau_gem_ioctl_new+0xdf/0x18d [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.792923]  [<ffffffffa00287f7>] 
drm_ioctl+0x29e/0x37b [drm]
Sep 13 17:30:02 newcastle kernel: [2307769.792931]  [<ffffffffa0092193>] 
? nouveau_gem_new+0xee/0xee [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.792934]  [<ffffffff811f6290>] 
? inode_has_perm+0x32/0x34
Sep 13 17:30:02 newcastle kernel: [2307769.792936]  [<ffffffff811f6339>] 
? file_has_perm+0xa7/0xc9
Sep 13 17:30:02 newcastle kernel: [2307769.792939]  [<ffffffff81134e06>] 
do_vfs_ioctl+0x460/0x4a1
Sep 13 17:30:02 newcastle kernel: [2307769.792941]  [<ffffffff81134e9d>] 
sys_ioctl+0x56/0x79
Sep 13 17:30:02 newcastle kernel: [2307769.792944]  [<ffffffff8148e182>] 
system_call_fastpath+0x16/0x1b
Sep 13 17:30:02 newcastle kernel: [2307769.792946] Mem-Info:
Sep 13 17:30:02 newcastle kernel: [2307769.792947] Node 0 DMA per-cpu:
Sep 13 17:30:02 newcastle kernel: [2307769.792949] CPU    0: hi:    0, 
btch:   1 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792950] CPU    1: hi:    0, 
btch:   1 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792952] CPU    2: hi:    0, 
btch:   1 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792953] CPU    3: hi:    0, 
btch:   1 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792954] Node 0 DMA32 per-cpu:
Sep 13 17:30:02 newcastle kernel: [2307769.792956] CPU    0: hi:  186, 
btch:  31 usd: 182
Sep 13 17:30:02 newcastle kernel: [2307769.792957] CPU    1: hi:  186, 
btch:  31 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792959] CPU    2: hi:  186, 
btch:  31 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792960] CPU    3: hi:  186, 
btch:  31 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792961] Node 0 Normal per-cpu:
Sep 13 17:30:02 newcastle kernel: [2307769.792962] CPU    0: hi:  186, 
btch:  31 usd:  19
Sep 13 17:30:02 newcastle kernel: [2307769.792964] CPU    1: hi:  186, 
btch:  31 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792965] CPU    2: hi:  186, 
btch:  31 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792966] CPU    3: hi:  186, 
btch:  31 usd:   0
Sep 13 17:30:02 newcastle kernel: [2307769.792970] active_anon:274123 
inactive_anon:129509 isolated_anon:0
Sep 13 17:30:02 newcastle kernel: [2307769.792970]  active_file:186256 
inactive_file:186149 isolated_file:0
Sep 13 17:30:02 newcastle kernel: [2307769.792971]  unevictable:0 
dirty:139 writeback:0 unstable:0
Sep 13 17:30:02 newcastle kernel: [2307769.792972]  free:38182 
slab_reclaimable:54924 slab_unreclaimable:15567
Sep 13 17:30:02 newcastle kernel: [2307769.792973]  mapped:18264 
shmem:174 pagetables:7390 bounce:0
Sep 13 17:30:02 newcastle kernel: [2307769.792974] Node 0 DMA 
free:15892kB min:256kB low:320kB high:384kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15684kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Sep 13 17:30:02 newcastle kernel: [2307769.792981] lowmem_reserve[]: 0 
2998 4008 4008
Sep 13 17:30:02 newcastle kernel: [2307769.792984] Node 0 DMA32 
free:112068kB min:50360kB low:62948kB high:75540kB active_anon:917768kB 
inactive_anon:294768kB active_file:605172kB inactive_file:604988kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3070624kB 
mlocked:0kB dirty:164kB writeback:0kB mapped:32080kB shmem:224kB 
slab_reclaimable:181476kB slab_unreclaimable:19488kB kernel_stack:408kB 
pagetables:6268kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
Sep 13 17:30:02 newcastle kernel: [2307769.792992] lowmem_reserve[]: 0 0 
1010 1010
Sep 13 17:30:02 newcastle kernel: [2307769.792994] Node 0 Normal 
free:24768kB min:16960kB low:21200kB high:25440kB active_anon:178724kB 
inactive_anon:223268kB active_file:139852kB inactive_file:139608kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1034240kB 
mlocked:0kB dirty:392kB writeback:0kB mapped:40976kB shmem:472kB 
slab_reclaimable:38220kB slab_unreclaimable:42764kB kernel_stack:2408kB 
pagetables:23292kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:15 all_unreclaimable? no
Sep 13 17:30:02 newcastle kernel: [2307769.793001] lowmem_reserve[]: 0 0 0 0
Sep 13 17:30:02 newcastle kernel: [2307769.793003] Node 0 DMA: 1*4kB 
0*8kB 1*16kB 0*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 
3*4096kB = 15892kB
Sep 13 17:30:02 newcastle kernel: [2307769.793009] Node 0 DMA32: 
20279*4kB 912*8kB 798*16kB 24*32kB 144*64kB 12*128kB 0*256kB 0*512kB 
0*1024kB 0*2048kB 0*4096kB = 112700kB
Sep 13 17:30:02 newcastle kernel: [2307769.793015] Node 0 Normal: 
6052*4kB 17*8kB 10*16kB 1*32kB 2*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 0*4096kB = 24792kB
Sep 13 17:30:02 newcastle kernel: [2307769.793021] 374663 total 
pagecache pages
Sep 13 17:30:02 newcastle kernel: [2307769.793022] 2064 pages in swap cache
Sep 13 17:30:02 newcastle kernel: [2307769.793023] Swap cache stats: add 
27763, delete 25699, find 46592/47603
Sep 13 17:30:02 newcastle kernel: [2307769.793024] Free swap  = 4035800kB
Sep 13 17:30:02 newcastle kernel: [2307769.793025] Total swap = 4095996kB
Sep 13 17:30:02 newcastle kernel: [2307769.805755] 1048560 pages RAM
Sep 13 17:30:02 newcastle kernel: [2307769.805757] 34340 pages reserved
Sep 13 17:30:02 newcastle kernel: [2307769.805758] 300133 pages shared
Sep 13 17:30:02 newcastle kernel: [2307769.805759] 737872 pages non-shared
Sep 13 17:30:02 newcastle kernel: [2307769.806182] BUG: unable to handle 
kernel NULL pointer dereference at           (null)
Sep 13 17:30:02 newcastle kernel: [2307769.806198] IP: 
[<ffffffffa00e5ed6>] nv50_vm_map_sg+0x29/0x8f [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806222] PGD 117e4c067 PUD 
1291b5067 PMD 0
Sep 13 17:30:02 newcastle kernel: [2307769.806231] Oops: 0000 [#1] SMP
Sep 13 17:30:02 newcastle kernel: [2307769.806237] CPU 1
Sep 13 17:30:02 newcastle kernel: [2307769.806240] Modules linked in: 
cdc_acm snd_seq_dummy nls_utf8 vfat fat tcp_lp ppdev parport_pc lp 
parport cpufreq_ondemand acpi_cpufreq freq_table mperf bnep bluetooth 
rfkill coretemp gspca_spca561 gspca_main videodev media 
v4l2_compat_ioctl32 joydev fuse snd_hda_codec_via snd_hda_intel 
snd_hda_codec snd_hwdep snd_seq snd_seq_device r8169 mii snd_pcm 
serio_raw xhci_hcd asus_atk0110 snd_timer i2c_i801 i7core_edac edac_core 
snd soundcore snd_page_alloc iTCO_wdt microcode iTCO_vendor_support ipv6 
firewire_ohci pata_acpi firewire_core ata_generic uas usb_storage 
crc_itu_t pata_jmicron nouveau ttm drm_kms_helper drm i2c_algo_bit 
i2c_core mxm_wmi wmi video [last unloaded: scsi_wait_scan]
Sep 13 17:30:02 newcastle kernel: [2307769.806367]
Sep 13 17:30:02 newcastle kernel: [2307769.806370] Pid: 13010, comm: 
Xorg Not tainted 2.6.40.3-0.fc15.x86_64 #1 System manufacturer System 
Product Name/P7P55D PRO
Sep 13 17:30:02 newcastle kernel: [2307769.806385] RIP: 
0010:[<ffffffffa00e5ed6>]  [<ffffffffa00e5ed6>] nv50_vm_map_sg+0x29/0x8f 
[nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806406] RSP: 
0018:ffff880137b8f808  EFLAGS: 00010206
Sep 13 17:30:02 newcastle kernel: [2307769.806411] RAX: 0000000000005a50 
RBX: ffff8800023ed380 RCX: 0000000000013286
Sep 13 17:30:02 newcastle kernel: [2307769.806418] RDX: ffff8800023ed380 
RSI: ffff8801368572a0 RDI: ffff8800023ed3a8
Sep 13 17:30:02 newcastle kernel: [2307769.806425] RBP: ffff880137b8f848 
R08: 0000000000005a50 R09: 0000000000000000
Sep 13 17:30:02 newcastle kernel: [2307769.806432] R10: 0000000000018cd6 
R11: 0000000000020000 R12: 0000000000099430
Sep 13 17:30:02 newcastle kernel: [2307769.806438] R13: ffff8800023ed3a8 
R14: ffff8801368572a0 R15: 0000000000005a50
Sep 13 17:30:02 newcastle kernel: [2307769.806446] FS: 
00007f734ef638a0(0000) GS:ffff88013fc20000(0000) knlGS:0000000000000000
Sep 13 17:30:02 newcastle kernel: [2307769.806453] CS:  0010 DS: 0000 
ES: 0000 CR0: 0000000080050033
Sep 13 17:30:02 newcastle kernel: [2307769.806459] CR2: 0000000000000000 
CR3: 0000000117ee0000 CR4: 00000000000006e0
Sep 13 17:30:02 newcastle kernel: [2307769.806466] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Sep 13 17:30:02 newcastle kernel: [2307769.806473] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep 13 17:30:02 newcastle kernel: [2307769.806480] Process Xorg (pid: 
13010, threadinfo ffff880137b8e000, task ffff88003b7fc590)
Sep 13 17:30:02 newcastle kernel: [2307769.806487] Stack:
Sep 13 17:30:02 newcastle kernel: [2307769.806490]  ffff880137081200 
ffff880136980000 0000000000002000 ffff880137081200
Sep 13 17:30:02 newcastle kernel: [2307769.806501]  ffff8800023ed3a8 
0000000000000001 0000000000000000 0000000000005a50
Sep 13 17:30:02 newcastle kernel: [2307769.806512]  ffff880137b8f8b8 
ffffffffa00a83ca ffff880137b8f8a8 ffffffff00020000
Sep 13 17:30:02 newcastle kernel: [2307769.806523] Call Trace:
Sep 13 17:30:02 newcastle kernel: [2307769.806537]  [<ffffffffa00a83ca>] 
nouveau_vm_map_sg+0xc1/0xfd [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806549]  [<ffffffffa008f872>] 
nouveau_bo_move_ntfy+0x76/0x82 [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806562]  [<ffffffffa0074813>] 
ttm_bo_handle_move_mem+0x164/0x299 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.806572]  [<ffffffffa0074be7>] 
ttm_bo_evict+0x29f/0x2e8 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.806584]  [<ffffffffa0074d82>] 
ttm_mem_evict_first+0x152/0x180 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.806595]  [<ffffffffa00753f7>] 
ttm_bo_mem_space+0x29b/0x2ea [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.806605]  [<ffffffffa00754fc>] 
ttm_bo_move_buffer+0xb6/0x10c [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.806621]  [<ffffffffa0031be4>] 
? drm_mm_insert_helper+0xd3/0xec [drm]
Sep 13 17:30:02 newcastle kernel: [2307769.806632]  [<ffffffffa0075608>] 
ttm_bo_validate+0xb6/0xf4 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.806642]  [<ffffffffa0075946>] 
ttm_bo_init+0x300/0x339 [ttm]
Sep 13 17:30:02 newcastle kernel: [2307769.806657]  [<ffffffffa008fe82>] 
nouveau_bo_new+0x246/0x283 [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806670]  [<ffffffffa008fa45>] 
? nouveau_bo_create_ttm_backend_entry+0x6c/0x6c [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806684]  [<ffffffffa0092103>] 
nouveau_gem_new+0x5e/0xee [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806697]  [<ffffffffa0092272>] 
nouveau_gem_ioctl_new+0xdf/0x18d [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806708]  [<ffffffffa00287f7>] 
drm_ioctl+0x29e/0x37b [drm]
Sep 13 17:30:02 newcastle kernel: [2307769.806720]  [<ffffffffa0092193>] 
? nouveau_gem_new+0xee/0xee [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806729]  [<ffffffff811f6290>] 
? inode_has_perm+0x32/0x34
Sep 13 17:30:02 newcastle kernel: [2307769.806736]  [<ffffffff811f6339>] 
? file_has_perm+0xa7/0xc9
Sep 13 17:30:02 newcastle kernel: [2307769.806743]  [<ffffffff81134e06>] 
do_vfs_ioctl+0x460/0x4a1
Sep 13 17:30:02 newcastle kernel: [2307769.806749]  [<ffffffff81134e9d>] 
sys_ioctl+0x56/0x79
Sep 13 17:30:02 newcastle kernel: [2307769.806756]  [<ffffffff8148e182>] 
system_call_fastpath+0x16/0x1b
Sep 13 17:30:02 newcastle kernel: [2307769.806762] Code: 5d c3 55 48 89 
e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 66 66 66 66 90 49 89 fd 49 89 
f6 48 89 d3 44 8d 24 cd 00 00 00 00 eb 52
Sep 13 17:30:02 newcastle kernel: [2307769.806851] RIP 
[<ffffffffa00e5ed6>] nv50_vm_map_sg+0x29/0x8f [nouveau]
Sep 13 17:30:02 newcastle kernel: [2307769.806870]  RSP <ffff880137b8f808>
Sep 13 17:30:02 newcastle kernel: [2307769.806874] CR2: 0000000000000000
Sep 13 17:30:02 newcastle kernel: [2307769.820562] ---[ end trace 
5540a1fff12a5d7f ]---
