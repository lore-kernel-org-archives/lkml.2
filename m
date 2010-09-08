Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0IHI2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:28:20 -0400
Received: from mao.cendio.se ([193.12.253.101]:41168 "EHLO mail.cendio.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756383Ab0IHI2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:28:16 -0400
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Sep 2010 04:28:16 EDT
Message-ID: <4C8744D1.1010405@cendio.se>
Date: Wed, 08 Sep 2010 10:09:53 +0200
From: Aaron Sowry <aaron@cendio.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pierre Ossman <ossman@cendio.se>
Subject: Help decoding oom-killer output
X-Enigmail-Version: 1.1.2
OpenPGP: id=1F7902FD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8E2E53F80F903E90FF2F64A8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8E2E53F80F903E90FF2F64A8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

After running in to problems with the amount of vmalloc memory on a SLED
11 SP1 system (due to a large number of ncp mounts), we have increased
this with the kernel parameter 'vmalloc=3D512M'.

Since this change, oom-killer seems to think we are running out of
memory, and starts killing arbitrary processes. Output from 'free' does
not indicate any lack of memory resource:

tle-thn19:/var/log # free
             total    used     free  shared    buffers     cached
Mem:      37115096 2899604 34215492       0      14100     635888
-/+ buffers/cache: 2249616 34865480
Swap:      4200988       0  4200988

tle-thn19:/var/log # uname -a
Linux tle-thn19 2.6.32.13-0.5-pae #1 SMP 2010-07-20 14:12:19 +0200 i686
i686 i386 GNU/Linux

Relevant dmesg output:

[10888.164363] kfmclient invoked oom-killer: gfp_mask=3D0xd0, order=3D1,
oom_adj=3D0
[10888.164366] kfmclient cpuset=3D/ mems_allowed=3D0-1
[10888.164369] Pid: 9591, comm: kfmclient Tainted: P          NX
2.6.32.13-0.5-pae #1
[10888.164371] Call Trace:
[10888.164391]  [<c02069a1>] try_stack_unwind+0x1b1/0x1f0
[10888.164395]  [<c020596f>] dump_trace+0x3f/0xe0
[10888.164398]  [<c02065ab>] show_trace_log_lvl+0x4b/0x60
[10888.164401]  [<c02065d8>] show_trace+0x18/0x20
[10888.164406]  [<c052e8a9>] dump_stack+0x6d/0x74
[10888.164412]  [<c029e3df>] oom_kill_process+0x9f/0x2b0
[10888.164416]  [<c029eac3>] out_of_memory+0xf3/0x170
[10888.164420]  [<c02a1da8>] __alloc_pages_slowpath+0x448/0x490
[10888.164423]  [<c02a1f08>] __alloc_pages_nodemask+0x118/0x120
[10888.164428]  [<c02c9785>] alloc_pages_current+0x65/0xc0
[10888.164432]  [<c02a0f75>] __get_free_pages+0x5/0x20
[10888.164436]  [<c023c5cd>] dup_task_struct+0x3d/0xe0
[10888.164439]  [<c023d508>] copy_process+0x88/0xe10
[10888.164442]  [<c023e300>] do_fork+0x70/0x330
[10888.164444]  [<c0201955>] sys_clone+0x35/0x50
[10888.164447]  [<c0203144>] sysenter_do_call+0x12/0x22
[10888.164464]  [<ffffe424>] 0xffffe424
[10888.164465] Mem-Info:
[10888.164467] Node 0 DMA per-cpu:
[10888.164469] CPU    0: hi:    0, btch:   1 usd:   0
[10888.164470] CPU    1: hi:    0, btch:   1 usd:   0
[10888.164472] CPU    2: hi:    0, btch:   1 usd:   0
[10888.164473] CPU    3: hi:    0, btch:   1 usd:   0
[10888.164474] CPU    4: hi:    0, btch:   1 usd:   0
[10888.164476] CPU    5: hi:    0, btch:   1 usd:   0
[10888.164477] CPU    6: hi:    0, btch:   1 usd:   0
[10888.164479] CPU    7: hi:    0, btch:   1 usd:   0
[10888.164480] CPU    8: hi:    0, btch:   1 usd:   0
[10888.164482] CPU    9: hi:    0, btch:   1 usd:   0
[10888.164483] CPU   10: hi:    0, btch:   1 usd:   0
[10888.164485] CPU   11: hi:    0, btch:   1 usd:   0
[10888.164486] CPU   12: hi:    0, btch:   1 usd:   0
[10888.164488] CPU   13: hi:    0, btch:   1 usd:   0
[10888.164489] CPU   14: hi:    0, btch:   1 usd:   0
[10888.164490] CPU   15: hi:    0, btch:   1 usd:   0
[10888.164492] Node 0 Normal per-cpu:
[10888.164493] CPU    0: hi:  186, btch:  31 usd:   0
[10888.164495] CPU    1: hi:  186, btch:  31 usd:   0
[10888.164496] CPU    2: hi:  186, btch:  31 usd:   0
[10888.164498] CPU    3: hi:  186, btch:  31 usd:   0
[10888.164499] CPU    4: hi:  186, btch:  31 usd:   0
[10888.164500] CPU    5: hi:  186, btch:  31 usd:   0
[10888.164502] CPU    6: hi:  186, btch:  31 usd:   0
[10888.164503] CPU    7: hi:  186, btch:  31 usd:   0
[10888.164505] CPU    8: hi:  186, btch:  31 usd:   0
[10888.164506] CPU    9: hi:  186, btch:  31 usd:   0
[10888.164507] CPU   10: hi:  186, btch:  31 usd:   0
[10888.164509] CPU   11: hi:  186, btch:  31 usd:   0
[10888.164510] CPU   12: hi:  186, btch:  31 usd:   0
[10888.164512] CPU   13: hi:  186, btch:  31 usd:   0
[10888.164513] CPU   14: hi:  186, btch:  31 usd:   0
[10888.164514] CPU   15: hi:  186, btch:  31 usd:   0
[10888.164516] Node 0 HighMem per-cpu:
[10888.164517] CPU    0: hi:  186, btch:  31 usd:   0
[10888.164518] CPU    1: hi:  186, btch:  31 usd:   0
[10888.164520] CPU    2: hi:  186, btch:  31 usd:   0
[10888.164521] CPU    3: hi:  186, btch:  31 usd:   0
[10888.164523] CPU    4: hi:  186, btch:  31 usd:   0
[10888.164524] CPU    5: hi:  186, btch:  31 usd: 170
[10888.164526] CPU    6: hi:  186, btch:  31 usd:   0
[10888.164527] CPU    7: hi:  186, btch:  31 usd:   0
[10888.164528] CPU    8: hi:  186, btch:  31 usd:   0
[10888.164530] CPU    9: hi:  186, btch:  31 usd:   0
[10888.164531] CPU   10: hi:  186, btch:  31 usd:   0
[10888.164533] CPU   11: hi:  186, btch:  31 usd:   0
[10888.164534] CPU   12: hi:  186, btch:  31 usd:   0
[10888.164535] CPU   13: hi:  186, btch:  31 usd:   0
[10888.164537] CPU   14: hi:  186, btch:  31 usd:   0
[10888.164538] CPU   15: hi:  186, btch:  31 usd:   0
[10888.164539] Node 1 HighMem per-cpu:
[10888.164541] CPU    0: hi:  186, btch:  31 usd:   0
[10888.164542] CPU    1: hi:  186, btch:  31 usd:   0
[10888.164544] CPU    2: hi:  186, btch:  31 usd:   0
[10888.164545] CPU    3: hi:  186, btch:  31 usd:   0
[10888.164546] CPU    4: hi:  186, btch:  31 usd:   0
[10888.164548] CPU    5: hi:  186, btch:  31 usd: 169
[10888.164549] CPU    6: hi:  186, btch:  31 usd:   0
[10888.164551] CPU    7: hi:  186, btch:  31 usd:   0
[10888.164552] CPU    8: hi:  186, btch:  31 usd:   0
[10888.164553] CPU    9: hi:  186, btch:  31 usd:   0
[10888.164555] CPU   10: hi:  186, btch:  31 usd:   0
[10888.164556] CPU   11: hi:  186, btch:  31 usd:   0
[10888.164558] CPU   12: hi:  186, btch:  31 usd:   0
[10888.164559] CPU   13: hi:  186, btch:  31 usd:   0
[10888.164561] CPU   14: hi:  186, btch:  31 usd:   0
[10888.164562] CPU   15: hi:  186, btch:  31 usd:   0
[10888.164565] active_anon:768330 inactive_anon:35823 isolated_anon:0
[10888.164566]  active_file:63618 inactive_file:82225 isolated_file:0
[10888.164567]  unevictable:0 dirty:92 writeback:0 unstable:0
[10888.164568]  free:8217931 slab_reclaimable:5587 slab_unreclaimable:224=
39
[10888.164569]  mapped:68776 shmem:20830 pagetables:16501 bounce:0
[10888.164570] Node 0 DMA free:1960kB min:88kB low:108kB high:132kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15852kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:588kB slab_unreclaimable:3408kB kernel_stack:2760kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[10888.164578] lowmem_reserve[]: 0 468 18101 18101
[10888.164581] Node 0 Normal free:17488kB min:2720kB low:3400kB
high:4080kB active_anon:0kB inactive_anon:0kB active_file:196kB
inactive_file:116kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:479544kB mlocked:0kB dirty:184kB
writeback:0kB mapped:216kB shmem:0kB slab_reclaimable:21760kB
slab_unreclaimable:86348kB kernel_stack:15376kB pagetables:0kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[10888.164588] lowmem_reserve[]: 0 0 141065 141065
[10888.164591] Node 0 HighMem free:15784236kB min:512kB low:26132kB
high:51756kB active_anon:1746212kB inactive_anon:143292kB
active_file:156308kB inactive_file:179344kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:18056404kB mlocked:0kB
dirty:132kB writeback:0kB mapped:180040kB shmem:55868kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:36696kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[10888.164599] lowmem_reserve[]: 0 0 0 0
[10888.164601] Node 1 HighMem free:17068784kB min:512kB low:26872kB
high:53236kB active_anon:1326020kB inactive_anon:0kB active_file:97968kB
inactive_file:149440kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:18577404kB mlocked:0kB dirty:52kB
writeback:0kB mapped:94848kB shmem:27452kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:29308kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[10888.164609] lowmem_reserve[]: 0 0 0 0
[10888.164611] Node 0 DMA: 206*4kB 10*8kB 8*16kB 3*32kB 3*64kB 1*128kB
0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB =3D 1960kB
[10888.164618] Node 0 Normal: 4083*4kB 56*8kB 3*16kB 2*32kB 0*64kB
1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB =3D 17788kB
[10888.164623] Node 0 HighMem: 6475*4kB 3343*8kB 3510*16kB 11778*32kB
3811*64kB 1028*128kB 334*256kB 61*512kB 17*1024kB 6*2048kB 3608*4096kB =3D=

15785988kB
[10888.164631] Node 1 HighMem: 1060*4kB 614*8kB 691*16kB 2387*32kB
1666*64kB 360*128kB 116*256kB 36*512kB 12*1024kB 8*2048kB 4088*4096kB =3D=

17070544kB
[10888.164637] 166542 total pagecache pages
[10888.164638] 0 pages in swap cache
[10888.164640] Swap cache stats: add 0, delete 0, find 0/0
[10888.164641] Free swap  =3D 4200988kB
[10888.164641] Total swap =3D 4200988kB
[10888.304740] 9659903 pages RAM
[10888.304742] 9534977 pages HighMem
[10888.304744] 381129 pages reserved
[10888.304745] 1221363 pages shared
[10888.304746] 973264 pages non-shared
[10888.304749] No available memory (MPOL_BIND): kill process 9591
(kfmclient) score 0 or a child
[10888.304751] Killed process 9591 (kfmclient)

Same thing from a different (but identical) machine:

[ 8988.210773] firefox invoked oom-killer: gfp_mask=3D0xd0, order=3D1, oo=
m_adj=3D0
[ 8988.210776] firefox cpuset=3D/ mems_allowed=3D0-1
[ 8988.210779] Pid: 31313, comm: firefox Tainted: G          N
2.6.32.13-0.5-pae #1
[ 8988.210782] Call Trace:
[ 8988.210802]  [<c02069a1>] try_stack_unwind+0x1b1/0x1f0
[ 8988.210810]  [<c020596f>] dump_trace+0x3f/0xe0
[ 8988.210815]  [<c02065ab>] show_trace_log_lvl+0x4b/0x60
[ 8988.210818]  [<c02065d8>] show_trace+0x18/0x20
[ 8988.210824]  [<c052e8a9>] dump_stack+0x6d/0x74
[ 8988.210834]  [<c029e3df>] oom_kill_process+0x9f/0x2b0
[ 8988.210839]  [<c029eac3>] out_of_memory+0xf3/0x170
[ 8988.210843]  [<c02a1da8>] __alloc_pages_slowpath+0x448/0x490
[ 8988.210847]  [<c02a1f08>] __alloc_pages_nodemask+0x118/0x120
[ 8988.210856]  [<c02c9785>] alloc_pages_current+0x65/0xc0
[ 8988.210861]  [<c02a0f75>] __get_free_pages+0x5/0x20
[ 8988.210866]  [<c023c5cd>] dup_task_struct+0x3d/0xe0
[ 8988.210870]  [<c023d508>] copy_process+0x88/0xe10
[ 8988.210873]  [<c023e300>] do_fork+0x70/0x330
[ 8988.210877]  [<c0201955>] sys_clone+0x35/0x50
[ 8988.210880]  [<c0203205>] syscall_call+0x7/0xb
[ 8988.210898]  [<b75211d8>] 0xb75211d8
[ 8988.210900] Mem-Info:
[ 8988.210902] Node 0 DMA per-cpu:
[ 8988.210904] CPU    0: hi:    0, btch:   1 usd:   0
[ 8988.210906] CPU    1: hi:    0, btch:   1 usd:   0
[ 8988.210908] CPU    2: hi:    0, btch:   1 usd:   0
[ 8988.210909] CPU    3: hi:    0, btch:   1 usd:   0
[ 8988.210911] CPU    4: hi:    0, btch:   1 usd:   0
[ 8988.210913] CPU    5: hi:    0, btch:   1 usd:   0
[ 8988.210915] CPU    6: hi:    0, btch:   1 usd:   0
[ 8988.210916] CPU    7: hi:    0, btch:   1 usd:   0
[ 8988.210918] CPU    8: hi:    0, btch:   1 usd:   0
[ 8988.210920] CPU    9: hi:    0, btch:   1 usd:   0
[ 8988.210922] CPU   10: hi:    0, btch:   1 usd:   0
[ 8988.210923] CPU   11: hi:    0, btch:   1 usd:   0
[ 8988.210925] CPU   12: hi:    0, btch:   1 usd:   0
[ 8988.210927] CPU   13: hi:    0, btch:   1 usd:   0
[ 8988.210929] CPU   14: hi:    0, btch:   1 usd:   0
[ 8988.210930] CPU   15: hi:    0, btch:   1 usd:   0
[ 8988.210932] Node 0 Normal per-cpu:
[ 8988.210934] CPU    0: hi:  186, btch:  31 usd:   0
[ 8988.210935] CPU    1: hi:  186, btch:  31 usd:   0
[ 8988.210937] CPU    2: hi:  186, btch:  31 usd:   0
[ 8988.210939] CPU    3: hi:  186, btch:  31 usd:   0
[ 8988.210940] CPU    4: hi:  186, btch:  31 usd:   0
[ 8988.210942] CPU    5: hi:  186, btch:  31 usd:   0
[ 8988.210944] CPU    6: hi:  186, btch:  31 usd:   0
[ 8988.210946] CPU    7: hi:  186, btch:  31 usd:   0
[ 8988.210948] CPU    8: hi:  186, btch:  31 usd:   0
[ 8988.210949] CPU    9: hi:  186, btch:  31 usd:   0
[ 8988.210951] CPU   10: hi:  186, btch:  31 usd:   0
[ 8988.210953] CPU   11: hi:  186, btch:  31 usd:   0
[ 8988.210955] CPU   12: hi:  186, btch:  31 usd:   0
[ 8988.210956] CPU   13: hi:  186, btch:  31 usd:   0
[ 8988.210958] CPU   14: hi:  186, btch:  31 usd:   0
[ 8988.210960] CPU   15: hi:  186, btch:  31 usd:   0
[ 8988.210961] Node 0 HighMem per-cpu:
[ 8988.210963] CPU    0: hi:  186, btch:  31 usd:   0
[ 8988.210965] CPU    1: hi:  186, btch:  31 usd:   0
[ 8988.210967] CPU    2: hi:  186, btch:  31 usd:   0
[ 8988.210969] CPU    3: hi:  186, btch:  31 usd:   0
[ 8988.210970] CPU    4: hi:  186, btch:  31 usd:   0
[ 8988.210972] CPU    5: hi:  186, btch:  31 usd:   0
[ 8988.210974] CPU    6: hi:  186, btch:  31 usd:   0
[ 8988.210976] CPU    7: hi:  186, btch:  31 usd:   0
[ 8988.210978] CPU    8: hi:  186, btch:  31 usd:   0
[ 8988.210980] CPU    9: hi:  186, btch:  31 usd:   0
[ 8988.210982] CPU   10: hi:  186, btch:  31 usd:   0
[ 8988.210983] CPU   11: hi:  186, btch:  31 usd:   0
[ 8988.210985] CPU   12: hi:  186, btch:  31 usd:   0
[ 8988.210987] CPU   13: hi:  186, btch:  31 usd:   0
[ 8988.210989] CPU   14: hi:  186, btch:  31 usd:   0
[ 8988.210991] CPU   15: hi:  186, btch:  31 usd:   0
[ 8988.210992] Node 1 HighMem per-cpu:
[ 8988.210994] CPU    0: hi:  186, btch:  31 usd:   0
[ 8988.210996] CPU    1: hi:  186, btch:  31 usd:   0
[ 8988.210998] CPU    2: hi:  186, btch:  31 usd:   0
[ 8988.211000] CPU    3: hi:  186, btch:  31 usd:   0
[ 8988.211001] CPU    4: hi:  186, btch:  31 usd:   0
[ 8988.211003] CPU    5: hi:  186, btch:  31 usd:   0
[ 8988.211005] CPU    6: hi:  186, btch:  31 usd:   0
[ 8988.211007] CPU    7: hi:  186, btch:  31 usd:   0
[ 8988.211009] CPU    8: hi:  186, btch:  31 usd:   0
[ 8988.211010] CPU    9: hi:  186, btch:  31 usd:   0
[ 8988.211012] CPU   10: hi:  186, btch:  31 usd:   0
[ 8988.211014] CPU   11: hi:  186, btch:  31 usd:   0
[ 8988.211016] CPU   12: hi:  186, btch:  31 usd:   0
[ 8988.211017] CPU   13: hi:  186, btch:  31 usd:   0
[ 8988.211019] CPU   14: hi:  186, btch:  31 usd:   0
[ 8988.211021] CPU   15: hi:  186, btch:  31 usd:   0
[ 8988.211026] active_anon:1201229 inactive_anon:54769 isolated_anon:0
[ 8988.211027]  active_file:69262 inactive_file:77515 isolated_file:0
[ 8988.211028]  unevictable:0 dirty:98 writeback:408 unstable:0
[ 8988.211029]  free:7801964 slab_reclaimable:6147 slab_unreclaimable:218=
16
[ 8988.211030]  mapped:65316 shmem:22872 pagetables:19032 bounce:0
[ 8988.211033] Node 0 DMA free:1960kB min:88kB low:108kB high:132kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15852kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:948kB slab_unreclaimable:3400kB kernel_stack:2320kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[ 8988.211043] lowmem_reserve[]: 0 468 18101 18101
[ 8988.211047] Node 0 Normal free:19928kB min:2720kB low:3400kB
high:4080kB active_anon:0kB inactive_anon:0kB active_file:92kB
inactive_file:248kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:479544kB mlocked:0kB dirty:0kB writeback:0kB
mapped:0kB shmem:0kB slab_reclaimable:23640kB slab_unreclaimable:83864kB
kernel_stack:18096kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 8988.211057] lowmem_reserve[]: 0 0 141065 141065
[ 8988.211060] Node 0 HighMem free:14732912kB min:512kB low:26132kB
high:51756kB active_anon:2773444kB inactive_anon:219076kB
active_file:182328kB inactive_file:211560kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:18056404kB mlocked:0kB
dirty:588kB writeback:544kB mapped:170660kB shmem:56504kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:41132kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[ 8988.211071] lowmem_reserve[]: 0 0 0 0
[ 8988.211074] Node 1 HighMem free:16453056kB min:512kB low:26872kB
high:53236kB active_anon:2031472kB inactive_anon:0kB active_file:94628kB
inactive_file:98252kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:18577404kB mlocked:0kB dirty:0kB
writeback:1088kB mapped:90604kB shmem:34984kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:34996kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[ 8988.211084] lowmem_reserve[]: 0 0 0 0
[ 8988.211087] Node 0 DMA: 192*4kB 5*8kB 4*16kB 0*32kB 1*64kB 0*128kB
0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB =3D 1960kB
[ 8988.211095] Node 0 Normal: 4473*4kB 199*8kB 15*16kB 0*32kB 1*64kB
1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB =3D 20684kB
[ 8988.211103] Node 0 HighMem: 1071*4kB 2939*8kB 1858*16kB 602*32kB
94*64kB 38*128kB 22*256kB 10*512kB 0*1024kB 2*2048kB 3572*4096kB =3D
14733428kB
[ 8988.211111] Node 1 HighMem: 1835*4kB 853*8kB 63*16kB 27*32kB 20*64kB
14*128kB 9*256kB 6*512kB 2*1024kB 3*2048kB 4009*4096kB =3D 16453540kB
[ 8988.211119] 169846 total pagecache pages
[ 8988.211121] 0 pages in swap cache
[ 8988.211122] Swap cache stats: add 0, delete 0, find 0/0
[ 8988.211124] Free swap  =3D 4200988kB
[ 8988.211125] Total swap =3D 4200988kB
[ 8988.342375] 9659903 pages RAM
[ 8988.342378] 9534977 pages HighMem
[ 8988.342379] 381129 pages reserved
[ 8988.342380] 1465162 pages shared
[ 8988.342380] 1396494 pages non-shared
[ 8988.342383] No available memory (MPOL_BIND): kill process 31313
(firefox) score 0 or a child
[ 8988.342385] Killed process 31313 (firefox)

Can anyone explain why oom-killer is being invoked in this case?

--=20
Aaron Sowry
Developer / Technical Sales
Cendio AB
Wallenbergs Gata 4
583 30  LINK=D6PING
Sweden
aaron@cendio.se
Tel + 46 13 29 08 54
Fax + 46 13 21 47 00


--------------enig8E2E53F80F903E90FF2F64A8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMh0TWAAoJECw8YUUfeQL9Pg0IANJ5a0GduRo2sbOVfHX5bfbf
IIwqvZqd+EZ6ZEhcFnjT4+bDexWoZtOd4CLGa/qNo7bGxyoAPCG3ZVNqyUJMhJtv
EC2IlYPupK6Knl7ppc1wgtjw3ftzxFCrmBEVAwm3wOyDfoB79L2340E7w6V8RpCs
9CD7+Sd8AiCgGkFj1iLJREXHy6O+j+4dRZ7s94Gm6C1yHhl54CeZRMFQwTzKixpb
oYqLKeonm6LvNwwWDA54a1woB8rNR7HUXWm2pd4ZPWO/P0wsAewjvEI9H4w7iXhu
NJtImQf1kooJyMaXCxBXi2wtt+18yxVeKFCLU5UOCR8bmvi1SIPOXyZ+yLVKn+g=
=v3Rm
-----END PGP SIGNATURE-----

--------------enig8E2E53F80F903E90FF2F64A8--
