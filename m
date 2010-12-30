Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0L3Tju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:39:50 -0500
Received: from mail.agmk.net ([91.192.224.71]:50987 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab0L3Tjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 14:39:49 -0500
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [2.6.37-rc8] BUG kmalloc-256: Poison overwritten.
Date: Thu, 30 Dec 2010 20:39:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2-2; KDE/4.5.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, neilb@suse.de
References: <201012301608.40859.pluto@agmk.net> <1293723098.25156.2.camel@jaguar>
In-Reply-To: <1293723098.25156.2.camel@jaguar>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201012302039.33305.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 of December 2010 16:31:38 Pekka Enberg wrote:
> On Thu, 2010-12-30 at 16:08 +0100, Pawel Sikora wrote:
> > [ 1863.448308] =============================================================================
> > [ 1863.448313] BUG kmalloc-256: Poison overwritten
> > [ 1863.448315] -----------------------------------------------------------------------------
> > [ 1863.448316] 
> > [ 1863.448319] INFO: 0xffff8807ffc7e7c4-0xffff8807ffc7e7c5. First byte 0x6c instead of 0x6b
> > [ 1863.448331] INFO: Allocated in setup_conf+0x12b/0x360 [raid10] age=554800 cpu=5 pid=2766
> > [ 1863.448336] INFO: Freed in stop+0x66/0x80 [raid10] age=4271 cpu=3 pid=5266
> > [ 1863.448339] INFO: Slab 0xffffea001bff3b90 objects=24 used=11 fp=0xffff8807ffc7e7b0 flags=0x6000000000040c1
> > [ 1863.448341] INFO: Object 0xffff8807ffc7e7b0 @offset=1968 fp=0xffff8807ffc7f338
> > [ 1863.448343] 
> > [ 1863.448345] Bytes b4 0xffff8807ffc7e7a0:  a9 c6 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ����....ZZZZZZZZ
> > [ 1863.448353]   Object 0xffff8807ffc7e7b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448362]   Object 0xffff8807ffc7e7c0:  6b 6b 6b 6b 6c 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkllkkkkkkkkkk
> > [ 1863.448369]   Object 0xffff8807ffc7e7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448377]   Object 0xffff8807ffc7e7e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448384]   Object 0xffff8807ffc7e7f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448391]   Object 0xffff8807ffc7e800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448399]   Object 0xffff8807ffc7e810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448406]   Object 0xffff8807ffc7e820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448413]   Object 0xffff8807ffc7e830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448421]   Object 0xffff8807ffc7e840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448428]   Object 0xffff8807ffc7e850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448435]   Object 0xffff8807ffc7e860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448442]   Object 0xffff8807ffc7e870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448450]   Object 0xffff8807ffc7e880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448457]   Object 0xffff8807ffc7e890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [ 1863.448464]   Object 0xffff8807ffc7e8a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
> > [ 1863.448472]  Redzone 0xffff8807ffc7e8b0:  bb bb bb bb bb bb bb bb                         ��������        
> > [ 1863.448478]  Padding 0xffff8807ffc7e8f0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
> > [ 1863.448487] Pid: 5282, comm: udevd Not tainted 2.6.37-rc8 #1
> > [ 1863.448489] Call Trace:
> > [ 1863.448499]  [<ffffffff8111ea1e>] print_trailer+0xfe/0x160
> > [ 1863.448503]  [<ffffffff8111f074>] check_bytes_and_report+0xf4/0x130
> > [ 1863.448506]  [<ffffffff8111f2da>] check_object+0x22a/0x270
> > [ 1863.448512]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
> > [ 1863.448515]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
> > [ 1863.448519]  [<ffffffff81120380>] alloc_debug_processing+0x110/0x1f0
> > [ 1863.448522]  [<ffffffff811211c9>] __slab_alloc+0x3a9/0x410
> > [ 1863.448528]  [<ffffffff8140254c>] ? do_page_fault+0x1cc/0x4b0
> > [ 1863.448531]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
> > [ 1863.448534]  [<ffffffff81121888>] kmem_cache_alloc_notrace+0xb8/0xc0
> > [ 1863.448538]  [<ffffffff81137cc9>] do_execve+0x59/0x390
> > [ 1863.448543]  [<ffffffff8121f0c1>] ? strncpy_from_user+0x31/0x50
> > [ 1863.448548]  [<ffffffff8100b205>] sys_execve+0x45/0x70
> > [ 1863.448553]  [<ffffffff8100319c>] stub_execve+0x6c/0xc0
> > [ 1863.448556] FIX kmalloc-256: Restoring 0xffff8807ffc7e7c4-0xffff8807ffc7e7c5=0x6b
> > [ 1863.448557] 
> > [ 1863.448559] FIX kmalloc-256: Marking all objects used 
> 
> This looks like a use-after-free bug somewhere in drivers/md/raid10.c.
> 
> 			Pekka

i think it's quite easy to reproduce this problem. here's a mini howto:

- setup two raid10 matrices.

[root@odra ~]# cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10]
md3 : active raid10 sdd4[1] sdc4[0]
      424757248 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
      [>....................]  resync =  0.4% (1966592/424757248) finish=82.4min speed=85504K/sec

md2 : active raid10 sdb4[1] sda4[0]
      424757248 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
      [>....................]  resync =  0.5% (2446080/424757248) finish=97.1min speed=72432K/sec

- stop matrices.

[root@odra ~]# mdadm --stop /dev/md2
mdadm: stopped /dev/md2
[root@odra ~]# mdadm --stop /dev/md3
mdadm: stopped /dev/md3

- create raid0 on devices previously used by raid10.

[root@odra ~]# mdadm -C /dev/md2 -l 0 -n 4 /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdd4

mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.

[root@odra ~]# cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10]
md2 : active raid0 sdd4[3] sdc4[2] sdb4[1] sda4[0]
      1699028992 blocks super 1.2 512k chunks

- stop it.

[root@odra ~]# mdadm --stop /dev/md2
mdadm: stopped /dev/md2

- create one raid10 matrix once more.

[root@odra ~]# mdadm -C /dev/md2 -l 10 -n 2 --layout f2 /dev/sda4 /dev/sdb4
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.

- in this moment i can see a bug report.

Dec 30 20:08:46 odra kernel: [12501.627162] =============================================================================
Dec 30 20:08:46 odra kernel: [12501.627166] BUG kmalloc-256: Poison overwritten
Dec 30 20:08:46 odra kernel: [12501.627168] -----------------------------------------------------------------------------
Dec 30 20:08:46 odra kernel: [12501.627169]
Dec 30 20:08:46 odra kernel: [12501.627172] INFO: 0xffff8803feb5e15c-0xffff8803feb5e15d. First byte 0x6c instead of 0x6b
Dec 30 20:08:46 odra kernel: [12501.627178] INFO: Allocated in setup_conf+0x12b/0x360 [raid10] age=58297 cpu=2 pid=12007
Dec 30 20:08:46 odra kernel: [12501.627182] INFO: Freed in stop+0x66/0x80 [raid10] age=47657 cpu=2 pid=12047
Dec 30 20:08:46 odra kernel: [12501.627185] INFO: Slab 0xffffea000dfb7c90 objects=24 used=2 fp=0xffff8803feb5e148 flags=0x2000000000040c1
Dec 30 20:08:46 odra kernel: [12501.627188] INFO: Object 0xffff8803feb5e148 @offset=328 fp=0xffff8803feb5e3d8
Dec 30 20:08:46 odra kernel: [12501.627189]
Dec 30 20:08:46 odra kernel: [12501.627191] Bytes b4 0xffff8803feb5e138:  df a8 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ߨ��....ZZZZZZZZ
Dec 30 20:08:46 odra kernel: [12501.627199]   Object 0xffff8803feb5e148:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627208]   Object 0xffff8803feb5e158:  6b 6b 6b 6b 6c 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkllkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627215]   Object 0xffff8803feb5e168:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627223]   Object 0xffff8803feb5e178:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627230]   Object 0xffff8803feb5e188:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627237]   Object 0xffff8803feb5e198:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627245]   Object 0xffff8803feb5e1a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627252]   Object 0xffff8803feb5e1b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627259]   Object 0xffff8803feb5e1c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627267]   Object 0xffff8803feb5e1d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627274]   Object 0xffff8803feb5e1e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627281]   Object 0xffff8803feb5e1f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627289]   Object 0xffff8803feb5e208:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627296]   Object 0xffff8803feb5e218:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627303]   Object 0xffff8803feb5e228:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
Dec 30 20:08:46 odra kernel: [12501.627311]   Object 0xffff8803feb5e238:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
Dec 30 20:08:46 odra kernel: [12501.627318]  Redzone 0xffff8803feb5e248:  bb bb bb bb bb bb bb bb                         ��������
Dec 30 20:08:46 odra kernel: [12501.627325]  Padding 0xffff8803feb5e288:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
Dec 30 20:08:46 odra kernel: [12501.627334] Pid: 12168, comm: mdadm Not tainted 2.6.37-rc8 #1
Dec 30 20:08:46 odra kernel: [12501.627336] Call Trace:
Dec 30 20:08:46 odra kernel: [12501.627343]  [<ffffffff8111ea1e>] print_trailer+0xfe/0x160
Dec 30 20:08:46 odra kernel: [12501.627347]  [<ffffffff8111f074>] check_bytes_and_report+0xf4/0x130
Dec 30 20:08:46 odra kernel: [12501.627350]  [<ffffffff8111f2da>] check_object+0x22a/0x270
Dec 30 20:08:46 odra kernel: [12501.627354]  [<ffffffffa03ff1eb>] ? setup_conf+0x12b/0x360 [raid10]
Dec 30 20:08:46 odra kernel: [12501.627358]  [<ffffffffa03ff1eb>] ? setup_conf+0x12b/0x360 [raid10]
Dec 30 20:08:46 odra kernel: [12501.627361]  [<ffffffff81120380>] alloc_debug_processing+0x110/0x1f0
Dec 30 20:08:46 odra kernel: [12501.627365]  [<ffffffff811211c9>] __slab_alloc+0x3a9/0x410
Dec 30 20:08:46 odra kernel: [12501.627369]  [<ffffffff810de600>] ? mempool_alloc_slab+0x10/0x20
Dec 30 20:08:46 odra kernel: [12501.627372]  [<ffffffff8112166f>] ? kmem_cache_alloc_node_notrace+0xbf/0xe0
Dec 30 20:08:46 odra kernel: [12501.627376]  [<ffffffff810de7fe>] ? mempool_create_node+0x7e/0x1a0
Dec 30 20:08:46 odra kernel: [12501.627379]  [<ffffffffa03ff1eb>] ? setup_conf+0x12b/0x360 [raid10]
Dec 30 20:08:46 odra kernel: [12501.627382]  [<ffffffff81121888>] kmem_cache_alloc_notrace+0xb8/0xc0
Dec 30 20:08:46 odra kernel: [12501.627386]  [<ffffffffa03ff1eb>] setup_conf+0x12b/0x360 [raid10]
Dec 30 20:08:46 odra kernel: [12501.627390]  [<ffffffffa04026b1>] run+0x21/0x3c0 [raid10]
Dec 30 20:08:46 odra kernel: [12501.627413]  [<ffffffffa00ca322>] md_run+0x322/0x920 [md_mod]
Dec 30 20:08:46 odra kernel: [12501.627417]  [<ffffffff813fd7a0>] ? __mutex_lock_interruptible_slowpath+0x1e0/0x2b0
Dec 30 20:08:46 odra kernel: [12501.627425]  [<ffffffffa00ca939>] do_md_run+0x19/0xa0 [md_mod]
Dec 30 20:08:46 odra kernel: [12501.627432]  [<ffffffffa00cbefc>] md_ioctl+0xa1c/0x1350 [md_mod]
Dec 30 20:08:46 odra kernel: [12501.627435]  [<ffffffff8111f15f>] ? check_object+0xaf/0x270
Dec 30 20:08:46 odra kernel: [12501.627438]  [<ffffffff8111f706>] ? init_object+0x46/0x80
Dec 30 20:08:46 odra kernel: [12501.627442]  [<ffffffff812039e0>] blkdev_ioctl+0x230/0x720
Dec 30 20:08:46 odra kernel: [12501.627445]  [<ffffffff81120846>] ? __slab_free+0x136/0x150
Dec 30 20:08:46 odra kernel: [12501.627449]  [<ffffffff811607dc>] block_ioctl+0x3c/0x40
Dec 30 20:08:46 odra kernel: [12501.627453]  [<ffffffff811412f8>] do_vfs_ioctl+0x98/0x580
Dec 30 20:08:46 odra kernel: [12501.627456]  [<ffffffff81101af9>] ? remove_vma+0x69/0x90
Dec 30 20:08:46 odra kernel: [12501.627460]  [<ffffffff81103244>] ? do_munmap+0x2e4/0x360
Dec 30 20:08:46 odra kernel: [12501.627463]  [<ffffffff81141861>] sys_ioctl+0x81/0xa0
Dec 30 20:08:46 odra kernel: [12501.627467]  [<ffffffff81002d7b>] system_call_fastpath+0x16/0x1b
