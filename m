Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1ILPPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:15:38 -0400
Received: from lucidpixels.com ([72.73.18.11]:55048 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab1ILPPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:15:35 -0400
Date: Mon, 12 Sep 2011 11:15:31 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues? (now shows further
 DEBUG w/DEBUG_SLAB! possibly(?)]
In-Reply-To: <alpine.DEB.2.02.1109120438340.16088@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1109121112130.16088@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan> <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan> <alpine.DEB.2.02.1109120351470.16088@p34.internal.lan> <CAF1ivSa8fFq6hemzJr6A_kgfNN4tOeEfD8kGfx==7JKV6M2hDg@mail.gmail.com>
 <alpine.DEB.2.02.1109120438340.16088@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1209471688-1315840531=:16088"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1209471688-1315840531=:16088
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 12 Sep 2011, Justin Piszcz wrote:

>
>
> On Mon, 12 Sep 2011, Lin Ming wrote:
>
>>> [27336.007233] =A0[<ffffffff81089fc3>] kswapd+0xb3/0x250
>>> [27336.007237] =A0[<ffffffff8104fea0>] ? abort_exclusive_wait+0xb0/0xb0
>>> [27336.007241] =A0[<ffffffff81089f10>] ? balance_pgdat+0x6a0/0x6a0
>>> [27336.007244] =A0[<ffffffff8104f457>] kthread+0x87/0x90
>>> [27336.007248] =A0[<ffffffff81648814>] kernel_thread_helper+0x4/0x10
>>> [27336.007252] =A0[<ffffffff8104f3d0>] ? kthread_flush_work_fn+0x10/0x1=
0
>>> [27336.007256] =A0[<ffffffff81648810>] ? gs_change+0xb/0xb
>>=20
>> No more info got.
>>=20
>> Could you try to make a test case which can trigger this bug reliably?
>> You may also try some benchmarks, for example, fio, ffsb, etc.
>>=20
>> Lin Ming
>
> Hi,
>
> I do not unfortunately, it seems to occur at random times during heavy I/=
O+
> mem and processing time, are there any other debug options that would hel=
p us
> here?

With the DEBUG options enabled, it has now shown more detail in the logs
than it has ever shown before, let me know what you think:

Relevant bits below (and then all of the errors below that)

  730 Sep 12 09:01:53 p34 kernel: [50893.830753] Process kswapd1 (pid: 1045=
, threadinfo ffff880626782000, task ffff880626d2a840)
  731 Sep 12 09:01:53 p34 kernel: [50893.830756] Stack:
  732 Sep 12 09:01:53 p34 kernel: [50893.830757]  ffff880c3fcc3d68 ffffffff=
812a885a ffff880c3fcc3d78 ffffffff812a8887
  733 Sep 12 09:01:53 p34 kernel: [50893.830764]  ffff880c3fcc3d98 ffffffff=
81019c3a 0000000000000002 000000000000c502
  734 Sep 12 09:01:53 p34 kernel: [50893.830776]  ffff880c3fcc3de8 ffffffff=
8101a8e8 7fffffff00000023 0000000000000013
  735 Sep 12 09:01:53 p34 kernel: [50893.830786] Call Trace:
  736 Sep 12 09:01:53 p34 kernel: [50893.830790]  <IRQ>
  737 Sep 12 09:01:53 p34 kernel: [50893.830794]  [<ffffffff812a885a>] __de=
lay+0xa/0x10
  738 Sep 12 09:01:53 p34 kernel: [50893.830800]  [<ffffffff812a8887>] __co=
nst_udelay+0x27/0x30
  739 Sep 12 09:01:53 p34 kernel: [50893.830810]  [<ffffffff81019c3a>] nati=
ve_safe_apic_wait_icr_idle+0x1a/0x50
  740 Sep 12 09:01:53 p34 kernel: [50893.830818]  [<ffffffff8101a8e8>] defa=
ult_send_IPI_mask_sequence_phys+0xb8/0xd0
  741 Sep 12 09:01:53 p34 kernel: [50893.830829]  [<ffffffff8101d462>] phys=
flat_send_IPI_all+0x12/0x20
  742 Sep 12 09:01:53 p34 kernel: [50893.830835]  [<ffffffff8101aae5>] arch=
_trigger_all_cpu_backtrace+0x55/0x90
  743 Sep 12 09:01:53 p34 kernel: [50893.830843]  [<ffffffff8106e189>] __rc=
u_pending+0x169/0x3a0
  744 Sep 12 09:01:53 p34 kernel: [50893.830851]  [<ffffffff8106eef7>] rcu_=
check_callbacks+0x67/0x120
  745 Sep 12 09:01:53 p34 kernel: [50893.830862]  [<ffffffff81041f93>] upda=
te_process_times+0x43/0x80
  746 Sep 12 09:01:53 p34 kernel: [50893.830871]  [<ffffffff8105ef7f>] tick=
_sched_timer+0x5f/0xb0
  747 Sep 12 09:01:53 p34 kernel: [50893.830881]  [<ffffffff8105315d>] __ru=
n_hrtimer.isra.34+0x4d/0x100
  748 Sep 12 09:01:53 p34 kernel: [50893.830888]  [<ffffffff81053bbf>] hrti=
mer_interrupt+0xdf/0x200
  749 Sep 12 09:01:53 p34 kernel: [50893.830896]  [<ffffffff81019ee4>] smp_=
apic_timer_interrupt+0x64/0xa0
  750 Sep 12 09:01:53 p34 kernel: [50893.830904]  [<ffffffff816481d3>] apic=
_timer_interrupt+0x13/0x20
  751 Sep 12 09:01:53 p34 kernel: [50893.830909]  <EOI>
  752 Sep 12 09:01:53 p34 kernel: [50893.830916]  [<ffffffff8107a981>] ? fi=
nd_get_pages+0x61/0x150
  753 Sep 12 09:01:53 p34 kernel: [50893.830928]  [<ffffffff8108597d>] page=
vec_lookup+0x1d/0x30
  754 Sep 12 09:01:53 p34 kernel: [50893.830935]  [<ffffffff8108607f>] inva=
lidate_mapping_pages+0x5f/0x170
  755 Sep 12 09:01:53 p34 kernel: [50893.830946]  [<ffffffff810d37b5>] shri=
nk_icache_memory+0x2d5/0x320
  756 Sep 12 09:01:53 p34 kernel: [50893.830954]  [<ffffffff81086f5d>] shri=
nk_slab+0x11d/0x190
  757 Sep 12 09:01:53 p34 kernel: [50893.830960]  [<ffffffff81089d6a>] bala=
nce_pgdat+0x4fa/0x6a0
  758 Sep 12 09:01:53 p34 kernel: [50893.830968]  [<ffffffff81089fc3>] kswa=
pd+0xb3/0x250
  759 Sep 12 09:01:53 p34 kernel: [50893.830975]  [<ffffffff8104fea0>] ? ab=
ort_exclusive_wait+0xb0/0xb0
  760 Sep 12 09:01:53 p34 kernel: [50893.830982]  [<ffffffff81089f10>] ? ba=
lance_pgdat+0x6a0/0x6a0
  761 Sep 12 09:01:53 p34 kernel: [50893.830990]  [<ffffffff8104f457>] kthr=
ead+0x87/0x90
  762 Sep 12 09:01:53 p34 kernel: [50893.830999]  [<ffffffff81648814>] kern=
el_thread_helper+0x4/0x10
  763 Sep 12 09:01:53 p34 kernel: [50893.831006]  [<ffffffff8104f3d0>] ? kt=
hread_flush_work_fn+0x10/0x10
  764 Sep 12 09:01:53 p34 kernel: [50893.831014]  [<ffffffff81648810>] ? gs=
_change+0xb/0xb
  765 Sep 12 09:01:53 p34 kernel: [50893.831019] Code: 48 89 e5 0f 1f 00 0f=
 ae e8 0f 31 89 c6 eb 16 0f 1f 80 00 00 00 00 f3 90 65 8b 0c 25 f0 c4 00 00=
 41 39 c8 75 17 0f 1f 00 0f ae e8 <0f> 31 89 c0 48 89 c2 48 29 f2 48 39 fa =
72 dc 5d c3 48 29 c6 48
  766 Sep 12 09:01:53 p34 kernel: [50893.831084] Call Trace:
  767 Sep 12 09:01:53 p34 kernel: [50893.831088]  <IRQ>  [<ffffffff812a885a=
>] __delay+0xa/0x10
  768 Sep 12 09:01:53 p34 kernel: [50893.831098]  [<ffffffff812a8887>] __co=
nst_udelay+0x27/0x30
  769 Sep 12 09:01:53 p34 kernel: [50893.831105]  [<ffffffff81019c3a>] nati=
ve_safe_apic_wait_icr_idle+0x1a/0x50
  770 Sep 12 09:01:53 p34 kernel: [50893.831113]  [<ffffffff8101a8e8>] defa=
ult_send_IPI_mask_sequence_phys+0xb8/0xd0
  771 Sep 12 09:01:53 p34 kernel: [50893.831122]  [<ffffffff8101d462>] phys=
flat_send_IPI_all+0x12/0x20
  772 Sep 12 09:01:53 p34 kernel: [50893.831129]  [<ffffffff8101aae5>] arch=
_trigger_all_cpu_backtrace+0x55/0x90
  773 Sep 12 09:01:53 p34 kernel: [50893.831136]  [<ffffffff8106e189>] __rc=
u_pending+0x169/0x3a0
  774 Sep 12 09:01:53 p34 kernel: [50893.831145]  [<ffffffff8106eef7>] rcu_=
check_callbacks+0x67/0x120
  775 Sep 12 09:01:53 p34 kernel: [50893.831151]  [<ffffffff81041f93>] upda=
te_process_times+0x43/0x80
  776 Sep 12 09:01:53 p34 kernel: [50893.831159]  [<ffffffff8105ef7f>] tick=
_sched_timer+0x5f/0xb0
  777 Sep 12 09:01:53 p34 kernel: [50893.831166]  [<ffffffff8105315d>] __ru=
n_hrtimer.isra.34+0x4d/0x100
  778 Sep 12 09:01:53 p34 kernel: [50893.831174]  [<ffffffff81053bbf>] hrti=
mer_interrupt+0xdf/0x200
  779 Sep 12 09:01:53 p34 kernel: [50893.831181]  [<ffffffff81019ee4>] smp_=
apic_timer_interrupt+0x64/0xa0
  780 Sep 12 09:01:53 p34 kernel: [50893.831188]  [<ffffffff816481d3>] apic=
_timer_interrupt+0x13/0x20
  781 Sep 12 09:01:53 p34 kernel: [50893.831193]  <EOI>  [<ffffffff8107a981=
>] ? find_get_pages+0x61/0x150
  782 Sep 12 09:01:53 p34 kernel: [50893.831205]  [<ffffffff8108597d>] page=
vec_lookup+0x1d/0x30
  783 Sep 12 09:01:53 p34 kernel: [50893.831212]  [<ffffffff8108607f>] inva=
lidate_mapping_pages+0x5f/0x170
  784 Sep 12 09:01:53 p34 kernel: [50893.831220]  [<ffffffff810d37b5>] shri=
nk_icache_memory+0x2d5/0x320
  785 Sep 12 09:01:53 p34 kernel: [50893.831228]  [<ffffffff81086f5d>] shri=
nk_slab+0x11d/0x190
  786 Sep 12 09:01:53 p34 kernel: [50893.831234]  [<ffffffff81089d6a>] bala=
nce_pgdat+0x4fa/0x6a0
  787 Sep 12 09:01:53 p34 kernel: [50893.831241]  [<ffffffff81089fc3>] kswa=
pd+0xb3/0x250
  788 Sep 12 09:01:53 p34 kernel: [50893.831248]  [<ffffffff8104fea0>] ? ab=
ort_exclusive_wait+0xb0/0xb0
  789 Sep 12 09:01:53 p34 kernel: [50893.831256]  [<ffffffff81089f10>] ? ba=
lance_pgdat+0x6a0/0x6a0
  790 Sep 12 09:01:53 p34 kernel: [50893.831262]  [<ffffffff8104f457>] kthr=
ead+0x87/0x90
  791 Sep 12 09:01:53 p34 kernel: [50893.831270]  [<ffffffff81648814>] kern=
el_thread_helper+0x4/0x10
  792 Sep 12 09:01:53 p34 kernel: [50893.831277]  [<ffffffff8104f3d0>] ? kt=
hread_flush_work_fn+0x10/0x10
  793 Sep 12 09:01:53 p34 kernel: [50893.831283]  [<ffffffff81648810>] ? gs=
_change+0xb/0xb

--

All of the log:

Sep 12 01:02:06 p34 kernel: [22150.790986] IPMI message handler: Event queu=
e full, discarding incoming events
Sep 12 02:28:39 p34 kernel: [27336.007038] BUG: soft lockup - CPU#9 stuck f=
or 22s! [kswapd1:1045]
Sep 12 02:28:39 p34 kernel: [27336.007043] CPU 9=20
Sep 12 02:28:39 p34 kernel: [27336.007047] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 02:28:39 p34 kernel: [27336.007053] RIP: 0010:[<ffffffff8107a981>]  =
[<ffffffff8107a981>] find_get_pages+0x61/0x150
Sep 12 02:28:39 p34 kernel: [27336.007062] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 02:28:39 p34 kernel: [27336.007065] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 02:28:39 p34 kernel: [27336.007067] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000f617890
Sep 12 02:28:39 p34 kernel: [27336.007070] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 02:28:39 p34 kernel: [27336.007072] R10: 0000000000000009 R11: ffff8=
803badfde18 R12: ffffffff816481ce
Sep 12 02:28:39 p34 kernel: [27336.007075] R13: ffffffff810821cd R14: ffff8=
80626783ad0 R15: ffff88063fffbe00
Sep 12 02:28:39 p34 kernel: [27336.007078] FS:  0000000000000000(0000) GS:f=
fff880c3fc60000(0000) knlGS:0000000000000000
Sep 12 02:28:39 p34 kernel: [27336.007081] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 02:28:39 p34 kernel: [27336.007084] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 02:28:39 p34 kernel: [27336.007086] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 02:28:39 p34 kernel: [27336.007089] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 02:28:39 p34 kernel: [27336.007092] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 02:28:39 p34 kernel: [27336.007094] Stack:
Sep 12 02:28:39 p34 kernel: [27336.007096]  ffff880c3fc6d520 00000000000000=
05 ffff880070743320 ffff880070743328
Sep 12 02:28:39 p34 kernel: [27336.007103]  ffff880626783ba0 ffff880626783b=
e0 000000000000041c ffffffffffffffff
Sep 12 02:28:39 p34 kernel: [27336.007108]  ffff880070743320 ffffea000f6178=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 02:28:39 p34 kernel: [27336.007114] Call Trace:
Sep 12 02:28:39 p34 kernel: [27336.007121]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 02:28:39 p34 kernel: [27336.007125]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 02:28:39 p34 kernel: [27336.007132]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 02:28:39 p34 kernel: [27336.007139]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 02:28:39 p34 kernel: [27336.007144]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 02:28:39 p34 kernel: [27336.007148]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 02:28:39 p34 kernel: [27336.007153]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 02:28:39 p34 kernel: [27336.007157]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 02:28:39 p34 kernel: [27336.007160]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 02:28:39 p34 kernel: [27336.007167]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 02:28:39 p34 kernel: [27336.007171]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 02:28:39 p34 kernel: [27336.007175]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 02:28:39 p34 kernel: [27336.007177] Code: 89 ea e8 33 95 22 00 85 c0=
 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b 07 48 8b 38 48 85=
 ff 74 5b 40 f6 c7 01 75 7a=20
Sep 12 02:28:39 p34 kernel: <48>[27336.007198]  63 83 44 e0 ff ff a9 00 ff =
ff 07 0f 85 8d 00 00 00 44 8b 47=20
Sep 12 02:28:39 p34 kernel: [27336.007209] Call Trace:
Sep 12 02:28:39 p34 kernel: [27336.007213]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 02:28:39 p34 kernel: [27336.007217]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 02:28:39 p34 kernel: [27336.007222]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 02:28:39 p34 kernel: [27336.007226]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 02:28:39 p34 kernel: [27336.007229]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 02:28:39 p34 kernel: [27336.007233]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 02:28:39 p34 kernel: [27336.007237]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 02:28:39 p34 kernel: [27336.007241]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 02:28:39 p34 kernel: [27336.007244]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 02:28:39 p34 kernel: [27336.007248]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 02:28:39 p34 kernel: [27336.007252]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 02:28:39 p34 kernel: [27336.007256]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 06:38:31 p34 kernel: [42305.627346] 3w-sas: scsi0: AEN: INFO (0x04:0=
x0007): Initialize completed:unit=3D0.
Sep 12 07:40:10 p34 kernel: [45998.630840] 3w-sas: scsi0: AEN: INFO (0x04:0=
x0055): Battery charging started:.
Sep 12 07:53:05 p34 kernel: [46772.490484] 3w-sas: scsi0: AEN: INFO (0x04:0=
x0056): Battery charging completed:.
Sep 12 09:01:20 p34 kernel: [50861.102463] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:01:20 p34 kernel: [50861.102468] CPU 18=20
Sep 12 09:01:20 p34 kernel: [50861.102472] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:20 p34 kernel: [50861.102478] RIP: 0010:[<ffffffff8107a981>]  =
[<ffffffff8107a981>] find_get_pages+0x61/0x150
Sep 12 09:01:20 p34 kernel: [50861.102487] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:01:20 p34 kernel: [50861.102489] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:01:20 p34 kernel: [50861.102492] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:01:20 p34 kernel: [50861.102494] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:01:20 p34 kernel: [50861.102497] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:01:20 p34 kernel: [50861.102500] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:01:20 p34 kernel: [50861.102503] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:01:20 p34 kernel: [50861.102506] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:20 p34 kernel: [50861.102508] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:20 p34 kernel: [50861.102511] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:20 p34 kernel: [50861.102513] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:20 p34 kernel: [50861.102516] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:01:20 p34 kernel: [50861.102519] Stack:
Sep 12 09:01:20 p34 kernel: [50861.102521]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:01:20 p34 kernel: [50861.102527]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:01:20 p34 kernel: [50861.102533]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:01:20 p34 kernel: [50861.102538] Call Trace:
Sep 12 09:01:20 p34 kernel: [50861.102545]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:01:20 p34 kernel: [50861.102550]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:01:20 p34 kernel: [50861.102557]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:01:20 p34 kernel: [50861.102562]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:01:20 p34 kernel: [50861.102566]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:01:20 p34 kernel: [50861.102569]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:01:20 p34 kernel: [50861.102574]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:01:20 p34 kernel: [50861.102578]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:01:20 p34 kernel: [50861.102582]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:01:20 p34 kernel: [50861.102589]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:01:20 p34 kernel: [50861.102593]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:01:20 p34 kernel: [50861.102596]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:01:20 p34 kernel: [50861.102598] Code: 89 ea e8 33 95 22 00 85 c0=
 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b 07 48 8b 38 48 85=
 ff 74 5b 40 f6 c7 01 75 7a=20
Sep 12 09:01:20 p34 kernel: <48>[50861.102619]  63 83 44 e0 ff ff a9 00 ff =
ff 07 0f 85 8d 00 00 00 44 8b 47=20
Sep 12 09:01:20 p34 kernel: [50861.102630] Call Trace:
Sep 12 09:01:20 p34 kernel: [50861.102634]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:01:20 p34 kernel: [50861.102638]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:01:20 p34 kernel: [50861.102642]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:01:20 p34 kernel: [50861.102647]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:01:20 p34 kernel: [50861.102650]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:01:20 p34 kernel: [50861.102654]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:01:20 p34 kernel: [50861.102657]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:01:20 p34 kernel: [50861.102663]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:01:20 p34 kernel: [50861.102668]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:01:20 p34 kernel: [50861.102672]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:01:20 p34 kernel: [50861.102675]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:01:20 p34 kernel: [50861.102679]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:01:48 p34 kernel: [50889.060210] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:01:48 p34 kernel: [50889.060215] CPU 18=20
Sep 12 09:01:48 p34 kernel: [50889.060219] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:48 p34 kernel: [50889.060224] RIP: 0010:[<ffffffff8107a981>]  =
[<ffffffff8107a981>] find_get_pages+0x61/0x150
Sep 12 09:01:48 p34 kernel: [50889.060233] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:01:48 p34 kernel: [50889.060236] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:01:48 p34 kernel: [50889.060238] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:01:48 p34 kernel: [50889.060241] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:01:48 p34 kernel: [50889.060244] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:01:48 p34 kernel: [50889.060246] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:01:48 p34 kernel: [50889.060249] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:01:48 p34 kernel: [50889.060252] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:48 p34 kernel: [50889.060255] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:48 p34 kernel: [50889.060257] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:48 p34 kernel: [50889.060260] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:48 p34 kernel: [50889.060263] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:01:48 p34 kernel: [50889.060265] Stack:
Sep 12 09:01:48 p34 kernel: [50889.060267]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:01:48 p34 kernel: [50889.060274]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:01:48 p34 kernel: [50889.060279]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:01:48 p34 kernel: [50889.060285] Call Trace:
Sep 12 09:01:48 p34 kernel: [50889.060291]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:01:48 p34 kernel: [50889.060296]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:01:48 p34 kernel: [50889.060303]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:01:48 p34 kernel: [50889.060307]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:01:48 p34 kernel: [50889.060311]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:01:48 p34 kernel: [50889.060315]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:01:48 p34 kernel: [50889.060320]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:01:48 p34 kernel: [50889.060324]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:01:48 p34 kernel: [50889.060328]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:01:48 p34 kernel: [50889.060335]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:01:48 p34 kernel: [50889.060338]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:01:48 p34 kernel: [50889.060342]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:01:48 p34 kernel: [50889.060344] Code: 89 ea e8 33 95 22 00 85 c0=
 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b 07 48 8b 38 48 85=
 ff 74 5b 40 f6 c7 01 75 7a=20
Sep 12 09:01:48 p34 kernel: <48>[50889.060365]  63 83 44 e0 ff ff a9 00 ff =
ff 07 0f 85 8d 00 00 00 44 8b 47=20
Sep 12 09:01:48 p34 kernel: [50889.060376] Call Trace:
Sep 12 09:01:48 p34 kernel: [50889.060380]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:01:48 p34 kernel: [50889.060384]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:01:48 p34 kernel: [50889.060388]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:01:48 p34 kernel: [50889.060392]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:01:48 p34 kernel: [50889.060396]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:01:48 p34 kernel: [50889.060399]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:01:48 p34 kernel: [50889.060403]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:01:48 p34 kernel: [50889.060408]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:01:48 p34 kernel: [50889.060413]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:01:48 p34 kernel: [50889.060417]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:01:48 p34 kernel: [50889.060420]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:01:48 p34 kernel: [50889.060424]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:01:53 p34 kernel: [50893.826205] INFO: rcu_sched_state detected s=
tall on CPU 18 (t=3D60000 jiffies)
Sep 12 09:01:53 p34 kernel: [50893.826210] sending NMI to all CPUs:
Sep 12 09:01:53 p34 kernel: [50893.826266] NMI backtrace for cpu 0
Sep 12 09:01:53 p34 kernel: [50893.826271] CPU 0=20
Sep 12 09:01:53 p34 kernel: [50893.826276] Pid: 0, comm: swapper Not tainte=
d 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.826281] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.826291] RSP: 0018:ffffffff81a01eb8  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.826293] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.826296] RDX: 0000000000000000 RSI: fffff=
fff81a01fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.826298] RBP: ffffffff81a01f08 R08: 00000=
000fffffffd R09: 00000000000003b1
Sep 12 09:01:53 p34 kernel: [50893.826301] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.826304] R13: 1242c6b2f2e8ac75 R14: fffff=
fffffffffff R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826307] FS:  0000000000000000(0000) GS:f=
fff88063fc00000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826310] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.826312] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006f0
Sep 12 09:01:53 p34 kernel: [50893.826315] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826318] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.826321] Process swapper (pid: 0, threadi=
nfo ffffffff81a00000, task ffffffff81a4b020)
Sep 12 09:01:53 p34 kernel: [50893.826323] Stack:
Sep 12 09:01:53 p34 kernel: [50893.826324]  ffffffff81a01f08 ffffffff814e7d=
92 0000000000000000 00000000000de0ae
Sep 12 09:01:53 p34 kernel: [50893.826331]  0000000000000000 00000000000de0=
ae ffff88063fc16170 ffff88063fc16170
Sep 12 09:01:53 p34 kernel: [50893.826336]  ffff88063fc16240 ffff880c3ffdf8=
00 ffffffff81a01f28 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.826342] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.826349]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.826354]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.826358]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.826364]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:01:53 p34 kernel: [50893.826370]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:01:53 p34 kernel: [50893.826374]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:01:53 p34 kernel: [50893.826378]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:01:53 p34 kernel: [50893.826380] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.826411] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.826415]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.826419]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.826422]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.826426]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:01:53 p34 kernel: [50893.826430]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:01:53 p34 kernel: [50893.826434]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:01:53 p34 kernel: [50893.826438]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:01:53 p34 kernel: [50893.826442] NMI backtrace for cpu 1
Sep 12 09:01:53 p34 kernel: [50893.826446] CPU 1=20
Sep 12 09:01:53 p34 kernel: [50893.826449] Pid: 0, comm: kworker/0:0 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.826457] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.826464] RSP: 0018:ffff8806275b1e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.826467] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.826472] RDX: 0000000000000000 RSI: ffff8=
806275b1fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.826477] RBP: ffff8806275b1ee8 R08: 00000=
000fffffffd R09: 0000000000000393
Sep 12 09:01:53 p34 kernel: [50893.826481] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.826484] R13: 1242c6b2f2f81a17 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826487] FS:  0000000000000000(0000) GS:f=
fff88063fc20000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826490] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.826492] CR2: 0000000002342da8 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.826497] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826502] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.826505] Process kworker/0:0 (pid: 0, thr=
eadinfo ffff8806275b0000, task ffff8806275ab1e0)
Sep 12 09:01:53 p34 kernel: [50893.826507] Stack:
Sep 12 09:01:53 p34 kernel: [50893.826510]  ffff8806275b1ee8 ffffffff814e7d=
92 0000000000000000 00000000000db6eb
Sep 12 09:01:53 p34 kernel: [50893.826518]  0000000000000000 00000001000db6=
eb ffff88063fc36170 ffff88063fc36170
Sep 12 09:01:53 p34 kernel: [50893.826524]  ffff88063fc36240 00000000000000=
00 ffff8806275b1f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.826529] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.826534]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.826539]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.826543]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.826549]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.826553] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.826589] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.826593]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.826598]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.826603]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.826609]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.826615] NMI backtrace for cpu 2
Sep 12 09:01:53 p34 kernel: [50893.826619] CPU 2=20
Sep 12 09:01:53 p34 kernel: [50893.826624] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.826632] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.826642] RSP: 0018:ffff8806275c3e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.826647] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.826652] RDX: 0000000000000000 RSI: ffff8=
806275c3fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.826657] RBP: ffff8806275c3ee8 R08: 00000=
000fffffffd R09: 00000000000003aa
Sep 12 09:01:53 p34 kernel: [50893.826662] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.826667] R13: 1242c6b2f2f81bc5 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826671] FS:  0000000000000000(0000) GS:f=
fff88063fc40000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826676] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.826680] CR2: 00007f952e86d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.826684] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826689] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.826694] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275c2000, task ffff8806275bb220)
Sep 12 09:01:53 p34 kernel: [50893.826698] Stack:
Sep 12 09:01:53 p34 kernel: [50893.826700]  ffff8806275c3ee8 ffffffff814e7d=
92 0000000000000000 00000000000db6c3
Sep 12 09:01:53 p34 kernel: [50893.826709]  0000000000000000 00000002000db6=
c3 ffff88063fc56170 ffff88063fc56170
Sep 12 09:01:53 p34 kernel: [50893.826717]  ffff88063fc56240 00000000000000=
00 ffff8806275c3f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.826763] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.826770]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.826776]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.826781]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.826788]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.826792] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.826836] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.826841]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.826847]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.826852]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.826858]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.826864] NMI backtrace for cpu 3
Sep 12 09:01:53 p34 kernel: [50893.826868] CPU 3=20
Sep 12 09:01:53 p34 kernel: [50893.826873] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.826881] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.826888] RSP: 0018:ffff8806275d7e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.826890] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.826893] RDX: 0000000000000000 RSI: ffff8=
806275d7fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.826896] RBP: ffff8806275d7ee8 R08: 00000=
000fffffffd R09: 000000000000038f
Sep 12 09:01:53 p34 kernel: [50893.826898] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.826901] R13: 1242c6b2f2f8040d R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826904] FS:  0000000000000000(0000) GS:f=
fff88063fc60000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826907] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.826910] CR2: 00007f3d5df2d520 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.826913] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.826915] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.826919] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275d6000, task ffff8806275cf260)
Sep 12 09:01:53 p34 kernel: [50893.826973] Stack:
Sep 12 09:01:53 p34 kernel: [50893.826975]  ffff8806275d7ee8 ffffffff814e7d=
92 0000000000000000 00000000000dce76
Sep 12 09:01:53 p34 kernel: [50893.826984]  0000000000000000 00000003000dce=
76 ffff88063fc76170 ffff88063fc76170
Sep 12 09:01:53 p34 kernel: [50893.826992]  ffff88063fc76240 00000000000000=
00 ffff8806275d7f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.827001] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827007]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827013]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827019]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827026]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827028] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.827063] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827068]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827074]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827080]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827086]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827092] NMI backtrace for cpu 4
Sep 12 09:01:53 p34 kernel: [50893.827096] CPU 4=20
Sep 12 09:01:53 p34 kernel: [50893.827101] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.827108] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.827117] RSP: 0018:ffff88062760be98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.827119] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.827122] RDX: 0000000000000000 RSI: ffff8=
8062760bfd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.827125] RBP: ffff88062760bee8 R08: 00000=
000fffffffc R09: 00000000000003ab
Sep 12 09:01:53 p34 kernel: [50893.827127] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.827131] R13: 1242c6b2f2f7fe4a R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827176] FS:  0000000000000000(0000) GS:f=
fff88063fc80000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827182] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.827186] CR2: 00007fa4d7907d90 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.827190] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827194] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.827199] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062760a000, task ffff8806276052a0)
Sep 12 09:01:53 p34 kernel: [50893.827202] Stack:
Sep 12 09:01:53 p34 kernel: [50893.827204]  ffff88062760bee8 ffffffff814e7d=
92 0000000000000000 00000000000dd396
Sep 12 09:01:53 p34 kernel: [50893.827214]  0000000000000000 00000004000dd3=
96 ffff88063fc96170 ffff88063fc96170
Sep 12 09:01:53 p34 kernel: [50893.827223]  ffff88063fc962a0 00000000000000=
00 ffff88062760bf08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.827228] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827233]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827238]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827242]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827247]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827249] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.827288] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827293]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827299]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827304]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827310]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827316] NMI backtrace for cpu 5
Sep 12 09:01:53 p34 kernel: [50893.827320] CPU 5=20
Sep 12 09:01:53 p34 kernel: [50893.827325] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.827332] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.827340] RSP: 0018:ffff88062761de98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.827342] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.827345] RDX: 0000000000000000 RSI: ffff8=
8062761dfd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.827348] RBP: ffff88062761dee8 R08: 00000=
000fffffffc R09: 00000000000003ab
Sep 12 09:01:53 p34 kernel: [50893.827351] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.827353] R13: 1242c6b2f2f7947f R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827356] FS:  0000000000000000(0000) GS:f=
fff88063fca0000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827360] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.827362] CR2: 00007f667da9d520 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.827365] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827367] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.827372] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062761c000, task ffff8806276192e0)
Sep 12 09:01:53 p34 kernel: [50893.827376] Stack:
Sep 12 09:01:53 p34 kernel: [50893.827378]  ffff88062761dee8 ffffffff814e7d=
92 0000000000000000 00000000000e3b19
Sep 12 09:01:53 p34 kernel: [50893.827387]  0000000000000000 00000005000e3b=
19 ffff88063fcb6170 ffff88063fcb6170
Sep 12 09:01:53 p34 kernel: [50893.827395]  ffff88063fcb62a0 00000000000000=
00 ffff88062761df08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.827403] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827409]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827415]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827421]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827429]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827433] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.827478] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827483]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827490]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827496]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827503]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827508] NMI backtrace for cpu 6
Sep 12 09:01:53 p34 kernel: [50893.827514] CPU 6=20
Sep 12 09:01:53 p34 kernel: [50893.827524] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.827536] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.827552] RSP: 0018:ffff880627625e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.827559] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.827567] RDX: 0000000000000000 RSI: ffff8=
80627625fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.827574] RBP: ffff880627625ee8 R08: 00000=
000fffffffc R09: 00000000000003df
Sep 12 09:01:53 p34 kernel: [50893.827581] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.827589] R13: 1242c6b2f2f6a94b R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827596] FS:  0000000000000000(0000) GS:f=
fff880c3fc00000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827605] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.827612] CR2: 00007fed30b2c000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.827619] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827626] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.827634] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627624000, task ffff880627618780)
Sep 12 09:01:53 p34 kernel: [50893.827641] Stack:
Sep 12 09:01:53 p34 kernel: [50893.827645]  ffff880627625ee8 ffffffff814e7d=
92 0000000000000000 00000000000f24ab
Sep 12 09:01:53 p34 kernel: [50893.827666]  0000000000000000 00000006000f24=
ab ffff880c3fc16170 ffff880c3fc16170
Sep 12 09:01:53 p34 kernel: [50893.827684]  ffff880c3fc162a0 00000000000000=
00 ffff880627625f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.827703] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827713]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827724]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827734]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827746]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827753] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.827842] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.827850]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.827860]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.827870]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.827880]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.827888] NMI backtrace for cpu 7
Sep 12 09:01:53 p34 kernel: [50893.827893] CPU 7=20
Sep 12 09:01:53 p34 kernel: [50893.827900] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.827912] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.827924] RSP: 0018:ffff88062762fe98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.827930] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.827937] RDX: 0000000000000000 RSI: ffff8=
8062762ffd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.827943] RBP: ffff88062762fee8 R08: 00000=
000fffffffc R09: 000000000000038f
Sep 12 09:01:53 p34 kernel: [50893.827949] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.827955] R13: 1242c6b2f2f7e3b3 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827962] FS:  0000000000000000(0000) GS:f=
fff880c3fc20000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827969] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.827975] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.827982] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.827988] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.827995] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062762e000, task ffff88062762d8d0)
Sep 12 09:01:53 p34 kernel: [50893.828002] Stack:
Sep 12 09:01:53 p34 kernel: [50893.828005]  ffff88062762fee8 ffffffff814e7d=
92 0000000000000000 00000000000ded3b
Sep 12 09:01:53 p34 kernel: [50893.828022]  0000000000000000 00000007000ded=
3b ffff880c3fc36170 ffff880c3fc36170
Sep 12 09:01:53 p34 kernel: [50893.828036]  ffff880c3fc362a0 00000000000000=
00 ffff88062762ff08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.828051] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.828059]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.828067]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.828076]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.828085]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.828089] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.828153] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.828159]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.828166]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.828171]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.828178]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.828185] NMI backtrace for cpu 8
Sep 12 09:01:53 p34 kernel: [50893.828190] CPU 8=20
Sep 12 09:01:53 p34 kernel: [50893.828197] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.828201] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.828216] RSP: 0018:ffff880627635e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.828222] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.828229] RDX: 0000000000000000 RSI: ffff8=
80627635fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.828234] RBP: ffff880627635ee8 R08: 00000=
000fffffffd R09: 00000000000002f2
Sep 12 09:01:53 p34 kernel: [50893.828241] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.828247] R13: 1242c6b2f2f74d5e R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828254] FS:  0000000000000000(0000) GS:f=
fff880c3fc40000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828262] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.828268] CR2: 00007fed30b0b000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.828274] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828281] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.828288] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627634000, task ffff88062762cd70)
Sep 12 09:01:53 p34 kernel: [50893.828295] Stack:
Sep 12 09:01:53 p34 kernel: [50893.828298]  ffff880627635ee8 ffffffff814e7d=
92 0000000000000000 00000000000e8226
Sep 12 09:01:53 p34 kernel: [50893.828313]  0000000000000000 00000008000e82=
26 ffff880c3fc56170 ffff880c3fc56170
Sep 12 09:01:53 p34 kernel: [50893.828327]  ffff880c3fc56240 00000000000000=
00 ffff880627635f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.828342] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.828350]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.828360]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.828368]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.828377]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.828381] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.828445] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.828451]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.828458]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.828464]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.828471]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.828478] NMI backtrace for cpu 9
Sep 12 09:01:53 p34 kernel: [50893.828484] CPU 9=20
Sep 12 09:01:53 p34 kernel: [50893.828490] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.828504] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.828517] RSP: 0018:ffff88062763de98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.828522] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.828527] RDX: 0000000000000000 RSI: ffff8=
8062763dfd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.828533] RBP: ffff88062763dee8 R08: 00000=
000fffffffc R09: 0000000000000390
Sep 12 09:01:53 p34 kernel: [50893.828540] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.828546] R13: 1242c6b2f2f7e699 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828552] FS:  0000000000000000(0000) GS:f=
fff880c3fc60000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828558] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.828564] CR2: 00007fbc7c84bc28 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.828570] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828577] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.828583] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062763c000, task ffff88062762c210)
Sep 12 09:01:53 p34 kernel: [50893.828588] Stack:
Sep 12 09:01:53 p34 kernel: [50893.828592]  ffff88062763dee8 ffffffff814e7d=
92 0000000000000000 00000000000dea48
Sep 12 09:01:53 p34 kernel: [50893.828607]  0000000000000000 00000009000dea=
48 ffff880c3fc76170 ffff880c3fc76170
Sep 12 09:01:53 p34 kernel: [50893.828625]  ffff880c3fc762a0 00000000000000=
00 ffff88062763df08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.828640] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.828649]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.828658]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.828665]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.828674]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.828679] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.828761] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.828769]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.828776]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.828785]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.828793]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.828800] NMI backtrace for cpu 10
Sep 12 09:01:53 p34 kernel: [50893.828806] CPU 10=20
Sep 12 09:01:53 p34 kernel: [50893.828813] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.828825] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.828837] RSP: 0018:ffff880627665e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.828842] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.828848] RDX: 0000000000000000 RSI: ffff8=
80627665fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.828854] RBP: ffff880627665ee8 R08: 00000=
000fffffffd R09: 0000000000000390
Sep 12 09:01:53 p34 kernel: [50893.828860] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.828867] R13: 1242c6b2f2f7edea R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828873] FS:  0000000000000000(0000) GS:f=
fff880c3fc80000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828880] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.828886] CR2: 00007fa1ebd0d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.828891] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.828897] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.828904] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627664000, task ffff88062763f360)
Sep 12 09:01:53 p34 kernel: [50893.828910] Stack:
Sep 12 09:01:53 p34 kernel: [50893.828913]  ffff880627665ee8 ffffffff814e7d=
92 0000000000000000 00000000000de12e
Sep 12 09:01:53 p34 kernel: [50893.828929]  0000000000000000 0000000a000de1=
2e ffff880c3fc96170 ffff880c3fc96170
Sep 12 09:01:53 p34 kernel: [50893.828944]  ffff880c3fc96240 00000000000000=
00 ffff880627665f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.828961] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.828969]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.828978]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.828987]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.828996]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829001] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.829077] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.829081]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.829088]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.829095]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.829103]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829110] NMI backtrace for cpu 11
Sep 12 09:01:53 p34 kernel: [50893.829116] CPU 11=20
Sep 12 09:01:53 p34 kernel: [50893.829123] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.829134] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.829148] RSP: 0018:ffff88062766be98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.829154] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.829160] RDX: 0000000000000000 RSI: ffff8=
8062766bfd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.829166] RBP: ffff88062766bee8 R08: 00000=
000fffffffc R09: 000000000000038f
Sep 12 09:01:53 p34 kernel: [50893.829172] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.829177] R13: 1242c6b2f3072cdb R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829183] FS:  0000000000000000(0000) GS:f=
fff880c3fca0000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829191] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.829197] CR2: 0000000002317008 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.829200] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829208] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.829215] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062766a000, task ffff88062763e800)
Sep 12 09:01:53 p34 kernel: [50893.829221] Stack:
Sep 12 09:01:53 p34 kernel: [50893.829225]  ffff88062766bee8 ffffffff814e7d=
92 0000000000000000 00000000000de552
Sep 12 09:01:53 p34 kernel: [50893.829244]  0000000000000000 0000000b000de5=
52 ffff880c3fcb6170 ffff880c3fcb6170
Sep 12 09:01:53 p34 kernel: [50893.829261]  ffff880c3fcb62a0 00000000000000=
00 ffff88062766bf08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.829276] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.829285]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.829293]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.829301]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.829310]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829315] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.829392] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.829399]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.829408]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.829415]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.829423]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829432] NMI backtrace for cpu 12
Sep 12 09:01:53 p34 kernel: [50893.829436] CPU 12=20
Sep 12 09:01:53 p34 kernel: [50893.829441] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.829447] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.829455] RSP: 0018:ffff88062767fe98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.829459] RAX: 0000000000000000 RBX: 00000=
00000000002 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.829463] RDX: 0000000000000000 RSI: ffff8=
8062767ffd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.829467] RBP: ffff88062767fee8 R08: 00000=
000ffffffff R09: 000000000000031c
Sep 12 09:01:53 p34 kernel: [50893.829471] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829474] R13: 1242c6b2f309020f R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829479] FS:  0000000000000000(0000) GS:f=
fff88063fcc0000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829483] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.829487] CR2: 00007fbaef0fc000 CR3: 00000=
00c1f486000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.829491] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829494] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.829499] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062767e000, task ffff880627670840)
Sep 12 09:01:53 p34 kernel: [50893.829502] Stack:
Sep 12 09:01:53 p34 kernel: [50893.829505]  ffff88062767fee8 ffffffff814e7d=
92 0000000000000000 00000000000c0ccb
Sep 12 09:01:53 p34 kernel: [50893.829515]  0000000000000000 0000000c000c0c=
cb ffff88063fcd6170 ffff88063fcd6170
Sep 12 09:01:53 p34 kernel: [50893.829525]  ffff88063fcd61e0 00000000000000=
00 ffff88062767ff08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.829534] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.829540]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.829546]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.829551]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.829558]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829561] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.829612] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.829618]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.829623]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.829629]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.829634]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829639] NMI backtrace for cpu 13
Sep 12 09:01:53 p34 kernel: [50893.829643] CPU 13=20
Sep 12 09:01:53 p34 kernel: [50893.829647] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.829655] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.829664] RSP: 0018:ffff880627693e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.829668] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.829673] RDX: 0000000000000000 RSI: ffff8=
80627693fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.829678] RBP: ffff880627693ee8 R08: 00000=
000fffffffc R09: 0000000000000383
Sep 12 09:01:53 p34 kernel: [50893.829684] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.829690] R13: 1242c6b2f305efa6 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829696] FS:  0000000000000000(0000) GS:f=
fff88063fce0000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829703] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.829709] CR2: 00007fed30b3b000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.829715] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829721] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.829728] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627692000, task ffff880627684880)
Sep 12 09:01:53 p34 kernel: [50893.829734] Stack:
Sep 12 09:01:53 p34 kernel: [50893.829737]  ffff880627693ee8 ffffffff814e7d=
92 0000000000000000 00000000000f2250
Sep 12 09:01:53 p34 kernel: [50893.829750]  0000000000000000 0000000d000f22=
50 ffff88063fcf6170 ffff88063fcf6170
Sep 12 09:01:53 p34 kernel: [50893.829763]  ffff88063fcf62a0 00000000000000=
00 ffff880627693f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.829777] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.829785]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.829794]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.829802]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.829812]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829817] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.829883] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.829890]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.829896]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.829904]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.829910]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.829917] NMI backtrace for cpu 14
Sep 12 09:01:53 p34 kernel: [50893.829920] CPU 14=20
Sep 12 09:01:53 p34 kernel: [50893.829924] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.829930] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.829938] RSP: 0018:ffff8806276c5e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.829940] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.829945] RDX: 0000000000000000 RSI: ffff8=
806276c5fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.829948] RBP: ffff8806276c5ee8 R08: 00000=
000fffffffc R09: 0000000000000380
Sep 12 09:01:53 p34 kernel: [50893.829951] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.829954] R13: 1242c6b2f3068132 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829959] FS:  0000000000000000(0000) GS:f=
fff88063fd00000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829962] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.829965] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.829970] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.829974] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.829979] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276c4000, task ffff8806276968c0)
Sep 12 09:01:53 p34 kernel: [50893.829983] Stack:
Sep 12 09:01:53 p34 kernel: [50893.829985]  ffff8806276c5ee8 ffffffff814e7d=
92 0000000000000000 00000000000e9125
Sep 12 09:01:53 p34 kernel: [50893.829993]  0000000000000000 0000000e000e91=
25 ffff88063fd16170 ffff88063fd16170
Sep 12 09:01:53 p34 kernel: [50893.830001]  ffff88063fd162a0 00000000000000=
00 ffff8806276c5f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.830009] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830016]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830022]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830027]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830034]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830038] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.830080] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830085]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830090]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830095]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830101]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830107] NMI backtrace for cpu 15
Sep 12 09:01:53 p34 kernel: [50893.830111] CPU 15=20
Sep 12 09:01:53 p34 kernel: [50893.830114] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.830121] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.830131] RSP: 0018:ffff8806276d9e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.830134] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.830138] RDX: 0000000000000000 RSI: ffff8=
806276d9fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.830143] RBP: ffff8806276d9ee8 R08: 00000=
000fffffffc R09: 0000000000000386
Sep 12 09:01:53 p34 kernel: [50893.830148] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.830152] R13: 1242c6b2f3067efd R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830158] FS:  0000000000000000(0000) GS:f=
fff88063fd20000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830163] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.830167] CR2: 00007f5b7f231e24 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.830171] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830174] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.830177] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276d8000, task ffff8806276ca900)
Sep 12 09:01:53 p34 kernel: [50893.830179] Stack:
Sep 12 09:01:53 p34 kernel: [50893.830181]  ffff8806276d9ee8 ffffffff814e7d=
92 0000000000000000 00000000000e92fd
Sep 12 09:01:53 p34 kernel: [50893.830187]  0000000000000000 0000000f000e92=
fd ffff88063fd36170 ffff88063fd36170
Sep 12 09:01:53 p34 kernel: [50893.830192]  ffff88063fd362a0 00000000000000=
00 ffff8806276d9f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.830200] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830207]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830212]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830217]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830224]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830228] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.830269] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830274]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830280]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830285]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830291]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830296] NMI backtrace for cpu 16
Sep 12 09:01:53 p34 kernel: [50893.830300] CPU 16=20
Sep 12 09:01:53 p34 kernel: [50893.830304] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.830310] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.830319] RSP: 0018:ffff8806276ede98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.830323] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.830327] RDX: 0000000000000000 RSI: ffff8=
806276edfd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.830332] RBP: ffff8806276edee8 R08: 00000=
000fffffffd R09: 0000000000000389
Sep 12 09:01:53 p34 kernel: [50893.830337] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.830340] R13: 1242c6b2f305eed6 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830345] FS:  0000000000000000(0000) GS:f=
fff88063fd40000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830348] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.830351] CR2: 00007f5b7f231e24 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.830354] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830359] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.830363] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276ec000, task ffff8806276de600)
Sep 12 09:01:53 p34 kernel: [50893.830367] Stack:
Sep 12 09:01:53 p34 kernel: [50893.830369]  ffff8806276edee8 ffffffff814e7d=
92 0000000000000000 00000000000f22a7
Sep 12 09:01:53 p34 kernel: [50893.830377]  0000000000000000 00000010000f22=
a7 ffff88063fd56170 ffff88063fd56170
Sep 12 09:01:53 p34 kernel: [50893.830386]  ffff88063fd56240 00000000000000=
00 ffff8806276edf08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.830393] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830399]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830405]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830411]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830417]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830421] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.830463] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830467]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830471]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830474]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830479]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830482] NMI backtrace for cpu 17
Sep 12 09:01:53 p34 kernel: [50893.830485] CPU 17=20
Sep 12 09:01:53 p34 kernel: [50893.830488] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.830494] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.830503] RSP: 0018:ffff88062771de98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.830507] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.830511] RDX: 0000000000000000 RSI: ffff8=
8062771dfd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.830515] RBP: ffff88062771dee8 R08: 00000=
000fffffffd R09: 00000000000003a4
Sep 12 09:01:53 p34 kernel: [50893.830519] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:01:53 p34 kernel: [50893.830524] R13: 1242c6b2f305efd0 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830529] FS:  0000000000000000(0000) GS:f=
fff88063fd60000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830534] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.830538] CR2: 00007fa4d78dcba0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.830543] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830547] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.830552] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062771c000, task ffff8806276f0640)
Sep 12 09:01:53 p34 kernel: [50893.830556] Stack:
Sep 12 09:01:53 p34 kernel: [50893.830557]  ffff88062771dee8 ffffffff814e7d=
92 0000000000000000 00000000000f210b
Sep 12 09:01:53 p34 kernel: [50893.830564]  0000000000000000 00000011000f21=
0b ffff88063fd76170 ffff88063fd76170
Sep 12 09:01:53 p34 kernel: [50893.830572]  ffff88063fd76240 00000000000000=
00 ffff88062771df08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.830580] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830586]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830592]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830598]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830605]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830609] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.830650] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830655]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.830661]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.830666]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830672]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.830677] NMI backtrace for cpu 18
Sep 12 09:01:53 p34 kernel: [50893.830682] CPU 18=20
Sep 12 09:01:53 p34 kernel: [50893.830688] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.830697] RIP: 0010:[<ffffffff812a8805>]  =
[<ffffffff812a8805>] delay_tsc+0x35/0x60
Sep 12 09:01:53 p34 kernel: [50893.830708] RSP: 0018:ffff880c3fcc3d58  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.830714] RAX: 00000000e564a626 RBX: 00000=
000000003e9 RCX: 0000000000000012
Sep 12 09:01:53 p34 kernel: [50893.830720] RDX: 0000000000000029 RSI: 00000=
000e564a5fd RDI: 000000000003a97d
Sep 12 09:01:53 p34 kernel: [50893.830725] RBP: ffff880c3fcc3d58 R08: 00000=
00000000012 R09: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830734] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000001000
Sep 12 09:01:53 p34 kernel: [50893.830736] R13: ffffffff81aa8d50 R14: 00000=
00000000400 R15: 0000000000000092
Sep 12 09:01:53 p34 kernel: [50893.830740] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830743] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.830745] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.830748] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.830750] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.830753] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:01:53 p34 kernel: [50893.830756] Stack:
Sep 12 09:01:53 p34 kernel: [50893.830757]  ffff880c3fcc3d68 ffffffff812a88=
5a ffff880c3fcc3d78 ffffffff812a8887
Sep 12 09:01:53 p34 kernel: [50893.830764]  ffff880c3fcc3d98 ffffffff81019c=
3a 0000000000000002 000000000000c502
Sep 12 09:01:53 p34 kernel: [50893.830776]  ffff880c3fcc3de8 ffffffff8101a8=
e8 7fffffff00000023 0000000000000013
Sep 12 09:01:53 p34 kernel: [50893.830786] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.830790]  <IRQ>=20
Sep 12 09:01:53 p34 kernel: [50893.830794]  [<ffffffff812a885a>] __delay+0x=
a/0x10
Sep 12 09:01:53 p34 kernel: [50893.830800]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:01:53 p34 kernel: [50893.830810]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:01:53 p34 kernel: [50893.830818]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:01:53 p34 kernel: [50893.830829]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:01:53 p34 kernel: [50893.830835]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:01:53 p34 kernel: [50893.830843]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:01:53 p34 kernel: [50893.830851]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:01:53 p34 kernel: [50893.830862]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:01:53 p34 kernel: [50893.830871]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830881]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:01:53 p34 kernel: [50893.830888]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:01:53 p34 kernel: [50893.830896]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:01:53 p34 kernel: [50893.830904]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:01:53 p34 kernel: [50893.830909]  <EOI>=20
Sep 12 09:01:53 p34 kernel: [50893.830916]  [<ffffffff8107a981>] ? find_get=
_pages+0x61/0x150
Sep 12 09:01:53 p34 kernel: [50893.830928]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:01:53 p34 kernel: [50893.830935]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:01:53 p34 kernel: [50893.830946]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:01:53 p34 kernel: [50893.830954]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:01:53 p34 kernel: [50893.830960]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:01:53 p34 kernel: [50893.830968]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:01:53 p34 kernel: [50893.830975]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:01:53 p34 kernel: [50893.830982]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:01:53 p34 kernel: [50893.830990]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:01:53 p34 kernel: [50893.830999]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:01:53 p34 kernel: [50893.831006]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:01:53 p34 kernel: [50893.831014]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:01:53 p34 kernel: [50893.831019] Code: 48 89 e5 0f 1f 00 0f ae e8=
 0f 31 89 c6 eb 16 0f 1f 80 00 00 00 00 f3 90 65 8b 0c 25 f0 c4 00 00 41 39=
 c8 75 17 0f 1f 00 0f ae e8 <0f> 31 89 c0 48 89 c2 48 29 f2 48 39 fa 72 dc =
5d c3 48 29 c6 48=20
Sep 12 09:01:53 p34 kernel: [50893.831084] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.831088]  <IRQ>  [<ffffffff812a885a>] __d=
elay+0xa/0x10
Sep 12 09:01:53 p34 kernel: [50893.831098]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:01:53 p34 kernel: [50893.831105]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:01:53 p34 kernel: [50893.831113]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:01:53 p34 kernel: [50893.831122]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:01:53 p34 kernel: [50893.831129]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:01:53 p34 kernel: [50893.831136]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:01:53 p34 kernel: [50893.831145]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:01:53 p34 kernel: [50893.831151]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:01:53 p34 kernel: [50893.831159]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:01:53 p34 kernel: [50893.831166]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:01:53 p34 kernel: [50893.831174]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:01:53 p34 kernel: [50893.831181]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:01:53 p34 kernel: [50893.831188]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:01:53 p34 kernel: [50893.831193]  <EOI>  [<ffffffff8107a981>] ? f=
ind_get_pages+0x61/0x150
Sep 12 09:01:53 p34 kernel: [50893.831205]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:01:53 p34 kernel: [50893.831212]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:01:53 p34 kernel: [50893.831220]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:01:53 p34 kernel: [50893.831228]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:01:53 p34 kernel: [50893.831234]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:01:53 p34 kernel: [50893.831241]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:01:53 p34 kernel: [50893.831248]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:01:53 p34 kernel: [50893.831256]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:01:53 p34 kernel: [50893.831262]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:01:53 p34 kernel: [50893.831270]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:01:53 p34 kernel: [50893.831277]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:01:53 p34 kernel: [50893.831283]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:01:53 p34 kernel: [50893.831350] NMI backtrace for cpu 19
Sep 12 09:01:53 p34 kernel: [50893.831355] CPU 19=20
Sep 12 09:01:53 p34 kernel: [50893.831361] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.831373] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.831385] RSP: 0018:ffff88062772fe98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.831391] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.831397] RDX: 0000000000000000 RSI: ffff8=
8062772ffd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.831400] RBP: ffff88062772fee8 R08: 00000=
000fffffffc R09: 00000000000003b2
Sep 12 09:01:53 p34 kernel: [50893.831402] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.831405] R13: 1242c6b2f343b62a R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831408] FS:  0000000000000000(0000) GS:f=
fff880c3fce0000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831411] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.831414] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.831417] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831419] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.831422] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062772e000, task ffff880627724c30)
Sep 12 09:01:53 p34 kernel: [50893.831428] Stack:
Sep 12 09:01:53 p34 kernel: [50893.831431]  ffff88062772fee8 ffffffff814e7d=
92 0000000000000000 00000000000e6480
Sep 12 09:01:53 p34 kernel: [50893.831445]  0000000000000000 00000013000e64=
80 ffff880c3fcf6170 ffff880c3fcf6170
Sep 12 09:01:53 p34 kernel: [50893.831457]  ffff880c3fcf62a0 00000000000000=
00 ffff88062772ff08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.831469] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.831478]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.831488]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.831494]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.831502]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.831504] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.831535] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.831539]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.831543]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.831547]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.831551]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.831558] NMI backtrace for cpu 20
Sep 12 09:01:53 p34 kernel: [50893.831563] CPU 20=20
Sep 12 09:01:53 p34 kernel: [50893.831569] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.831578] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.831590] RSP: 0018:ffff880627735e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.831596] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.831599] RDX: 0000000000000000 RSI: ffff8=
80627735fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.831601] RBP: ffff880627735ee8 R08: 00000=
000fffffffc R09: 00000000000003ad
Sep 12 09:01:53 p34 kernel: [50893.831604] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.831607] R13: 1242c6b2f343b544 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831610] FS:  0000000000000000(0000) GS:f=
fff880c3fd00000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831613] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.831615] CR2: 00007fed30b2c000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.831618] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831621] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.831624] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627734000, task ffff8806277240d0)
Sep 12 09:01:53 p34 kernel: [50893.831626] Stack:
Sep 12 09:01:53 p34 kernel: [50893.831627]  ffff880627735ee8 ffffffff814e7d=
92 0000000000000000 00000000000e65f5
Sep 12 09:01:53 p34 kernel: [50893.831633]  0000000000000000 00000014000e65=
f5 ffff880c3fd16170 ffff880c3fd16170
Sep 12 09:01:53 p34 kernel: [50893.831644]  ffff880c3fd162a0 00000000000000=
00 ffff880627735f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.831655] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.831663]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.831671]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.831677]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.831685]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.831690] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.831724] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.831728]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.831732]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.831736]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.831740]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.831744] NMI backtrace for cpu 21
Sep 12 09:01:53 p34 kernel: [50893.831747] CPU 21=20
Sep 12 09:01:53 p34 kernel: [50893.831751] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.831756] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.831769] RSP: 0018:ffff88062773fe98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.831774] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.831780] RDX: 0000000000000000 RSI: ffff8=
8062773ffd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.831786] RBP: ffff88062773fee8 R08: 00000=
000fffffffc R09: 00000000000003af
Sep 12 09:01:53 p34 kernel: [50893.831792] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.831797] R13: 1242c6b2f343bd66 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831803] FS:  0000000000000000(0000) GS:f=
fff880c3fd20000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831810] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.831815] CR2: 00007f29489dcba0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.831821] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.831827] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.831833] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062773e000, task ffff880627739220)
Sep 12 09:01:53 p34 kernel: [50893.831838] Stack:
Sep 12 09:01:53 p34 kernel: [50893.831840]  ffff88062773fee8 ffffffff814e7d=
92 0000000000000000 00000000000e5d64
Sep 12 09:01:53 p34 kernel: [50893.831852]  0000000000000000 00000015000e5d=
64 ffff880c3fd36170 ffff880c3fd36170
Sep 12 09:01:53 p34 kernel: [50893.831863]  ffff880c3fd362a0 00000000000000=
00 ffff88062773ff08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.831875] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.831883]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.831891]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.831897]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.831905]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.831910] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.831976] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.831983]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.831991]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.831997]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.832005]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.832012] NMI backtrace for cpu 22
Sep 12 09:01:53 p34 kernel: [50893.832018] CPU 22=20
Sep 12 09:01:53 p34 kernel: [50893.832024] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.832035] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.832047] RSP: 0018:ffff880627747e98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.832052] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.832058] RDX: 0000000000000000 RSI: ffff8=
80627747fd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.832064] RBP: ffff880627747ee8 R08: 00000=
000fffffffc R09: 000000000000039c
Sep 12 09:01:53 p34 kernel: [50893.832069] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.832075] R13: 1242c6b2f343c82e R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.832081] FS:  0000000000000000(0000) GS:f=
fff880c3fd40000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.832088] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.832094] CR2: 00007f9ff41e3000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.832099] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.832105] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.832108] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627746000, task ffff8806277386c0)
Sep 12 09:01:53 p34 kernel: [50893.832111] Stack:
Sep 12 09:01:53 p34 kernel: [50893.832112]  ffff880627747ee8 ffffffff814e7d=
92 0000000000000000 00000000000e510d
Sep 12 09:01:53 p34 kernel: [50893.832118]  0000000000000000 00000016000e51=
0d ffff880c3fd56170 ffff880c3fd56170
Sep 12 09:01:53 p34 kernel: [50893.832124]  ffff880c3fd562a0 00000000000000=
00 ffff880627747f08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.832129] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.832134]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.832143]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.832150]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.832159]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.832164] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.832232] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.832240]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.832248]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.832252]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.832256]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.832260] NMI backtrace for cpu 23
Sep 12 09:01:53 p34 kernel: [50893.832263] CPU 23=20
Sep 12 09:01:53 p34 kernel: [50893.832267] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:01:53 p34 kernel: [50893.832272] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:01:53 p34 kernel: [50893.832280] RSP: 0018:ffff88062774fe98  EFLA=
GS: 00000046
Sep 12 09:01:53 p34 kernel: [50893.832286] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:01:53 p34 kernel: [50893.832292] RDX: 0000000000000000 RSI: ffff8=
8062774ffd8 RDI: ffffffff81a4d300
Sep 12 09:01:53 p34 kernel: [50893.832297] RBP: ffff88062774fee8 R08: 00000=
000fffffffc R09: 00000000000003ae
Sep 12 09:01:53 p34 kernel: [50893.832303] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:01:53 p34 kernel: [50893.832308] R13: 1242c6b2f343b8d5 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.832314] FS:  0000000000000000(0000) GS:f=
fff880c3fd60000(0000) knlGS:0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.832320] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:01:53 p34 kernel: [50893.832325] CR2: 00007f20b0a46e24 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:01:53 p34 kernel: [50893.832330] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:01:53 p34 kernel: [50893.832335] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:01:53 p34 kernel: [50893.832341] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062774e000, task ffff88062774d810)
Sep 12 09:01:53 p34 kernel: [50893.832347] Stack:
Sep 12 09:01:53 p34 kernel: [50893.832349]  ffff88062774fee8 ffffffff814e7d=
92 0000000000000000 00000000000e61c7
Sep 12 09:01:53 p34 kernel: [50893.832364]  0000000000000000 00000017000e61=
c7 ffff880c3fd76170 ffff880c3fd76170
Sep 12 09:01:53 p34 kernel: [50893.832376]  ffff880c3fd762a0 00000000000000=
00 ffff88062774ff08 ffffffff814e6bb6
Sep 12 09:01:53 p34 kernel: [50893.832387] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.832395]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.832403]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.832411]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.832419]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:01:53 p34 kernel: [50893.832424] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:01:53 p34 kernel: [50893.832489] Call Trace:
Sep 12 09:01:53 p34 kernel: [50893.832494]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:01:53 p34 kernel: [50893.832502]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:01:53 p34 kernel: [50893.832509]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:01:53 p34 kernel: [50893.832516]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:02:20 p34 kernel: [50921.011919] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:02:20 p34 kernel: [50921.011924] CPU 18=20
Sep 12 09:02:20 p34 kernel: [50921.011928] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:02:20 p34 kernel: [50921.011933] RIP: 0010:[<ffffffff8107a97b>]  =
[<ffffffff8107a97b>] find_get_pages+0x5b/0x150
Sep 12 09:02:20 p34 kernel: [50921.011943] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000286
Sep 12 09:02:20 p34 kernel: [50921.011945] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:02:20 p34 kernel: [50921.011948] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:02:20 p34 kernel: [50921.011950] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:02:20 p34 kernel: [50921.011953] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:02:20 p34 kernel: [50921.011956] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:02:20 p34 kernel: [50921.011959] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:02:20 p34 kernel: [50921.011962] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:02:20 p34 kernel: [50921.011965] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:02:20 p34 kernel: [50921.011967] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:02:20 p34 kernel: [50921.011970] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:02:20 p34 kernel: [50921.011973] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:02:20 p34 kernel: [50921.011976] Stack:
Sep 12 09:02:20 p34 kernel: [50921.011977]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:02:20 p34 kernel: [50921.011984]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:02:20 p34 kernel: [50921.011990]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:02:20 p34 kernel: [50921.011995] Call Trace:
Sep 12 09:02:20 p34 kernel: [50921.012002]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:02:20 p34 kernel: [50921.012007]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:02:20 p34 kernel: [50921.012014]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:02:20 p34 kernel: [50921.012018]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:02:20 p34 kernel: [50921.012022]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:02:20 p34 kernel: [50921.012026]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:02:20 p34 kernel: [50921.012031]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:02:20 p34 kernel: [50921.012035]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:02:20 p34 kernel: [50921.012039]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:02:20 p34 kernel: [50921.012046]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:02:20 p34 kernel: [50921.012049]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:02:20 p34 kernel: [50921.012053]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:02:20 p34 kernel: [50921.012055] Code: 89 e6 44 89 f1 4c 89 ea e8=
 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b=
 07 48 8b 38 48 85 ff 74 5b=20
Sep 12 09:02:20 p34 kernel: <40>[50921.012076]  f6 c7 01 75 7a 48 63 83 44 =
e0 ff ff a9 00 ff ff 07 0f 85 8d=20
Sep 12 09:02:20 p34 kernel: [50921.012087] Call Trace:
Sep 12 09:02:20 p34 kernel: [50921.012091]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:02:20 p34 kernel: [50921.012096]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:02:20 p34 kernel: [50921.012100]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:02:20 p34 kernel: [50921.012104]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:02:20 p34 kernel: [50921.012108]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:02:20 p34 kernel: [50921.012111]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:02:20 p34 kernel: [50921.012116]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:02:20 p34 kernel: [50921.012121]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:02:20 p34 kernel: [50921.012125]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:02:20 p34 kernel: [50921.012129]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:02:20 p34 kernel: [50921.012133]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:02:20 p34 kernel: [50921.012137]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:02:48 p34 kernel: [50948.969665] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:02:48 p34 kernel: [50948.969670] CPU 18=20
Sep 12 09:02:48 p34 kernel: [50948.969674] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:02:48 p34 kernel: [50948.969679] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:02:48 p34 kernel: [50948.969689] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:02:48 p34 kernel: [50948.969691] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:02:48 p34 kernel: [50948.969694] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:02:48 p34 kernel: [50948.969697] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:02:48 p34 kernel: [50948.969699] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:02:48 p34 kernel: [50948.969702] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:02:48 p34 kernel: [50948.969705] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:02:48 p34 kernel: [50948.969708] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:02:48 p34 kernel: [50948.969711] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:02:48 p34 kernel: [50948.969714] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:02:48 p34 kernel: [50948.969716] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:02:48 p34 kernel: [50948.969719] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:02:48 p34 kernel: [50948.969722] Stack:
Sep 12 09:02:48 p34 kernel: [50948.969724]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:02:48 p34 kernel: [50948.969730]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:02:48 p34 kernel: [50948.969736]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:02:48 p34 kernel: [50948.969741] Call Trace:
Sep 12 09:02:48 p34 kernel: [50948.969748]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:02:48 p34 kernel: [50948.969753]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:02:48 p34 kernel: [50948.969760]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:02:48 p34 kernel: [50948.969765]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:02:48 p34 kernel: [50948.969769]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:02:48 p34 kernel: [50948.969773]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:02:48 p34 kernel: [50948.969778]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:02:48 p34 kernel: [50948.969782]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:02:48 p34 kernel: [50948.969785]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:02:48 p34 kernel: [50948.969793]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:02:48 p34 kernel: [50948.969796]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:02:48 p34 kernel: [50948.969800]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:02:48 p34 kernel: [50948.969802] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:02:48 p34 kernel: <44>[50948.969823]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:02:48 p34 kernel: [50948.969834] Call Trace:
Sep 12 09:02:48 p34 kernel: [50948.969838]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:02:48 p34 kernel: [50948.969843]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:02:48 p34 kernel: [50948.969847]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:02:48 p34 kernel: [50948.969851]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:02:48 p34 kernel: [50948.969855]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:02:48 p34 kernel: [50948.969858]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:02:48 p34 kernel: [50948.969863]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:02:48 p34 kernel: [50948.969869]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:02:48 p34 kernel: [50948.969872]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:02:48 p34 kernel: [50948.969876]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:02:48 p34 kernel: [50948.969880]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:02:48 p34 kernel: [50948.969884]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:03:16 p34 kernel: [50976.927411] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:03:16 p34 kernel: [50976.927415] CPU 18=20
Sep 12 09:03:16 p34 kernel: [50976.927419] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:03:16 p34 kernel: [50976.927425] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:03:16 p34 kernel: [50976.927434] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:03:16 p34 kernel: [50976.927437] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:03:16 p34 kernel: [50976.927439] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:03:16 p34 kernel: [50976.927442] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:03:16 p34 kernel: [50976.927445] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:03:16 p34 kernel: [50976.927447] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:03:16 p34 kernel: [50976.927451] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:03:16 p34 kernel: [50976.927454] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:03:16 p34 kernel: [50976.927456] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:03:16 p34 kernel: [50976.927459] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:03:16 p34 kernel: [50976.927461] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:03:16 p34 kernel: [50976.927465] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:03:16 p34 kernel: [50976.927467] Stack:
Sep 12 09:03:16 p34 kernel: [50976.927469]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:03:16 p34 kernel: [50976.927475]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:03:16 p34 kernel: [50976.927481]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:03:16 p34 kernel: [50976.927487] Call Trace:
Sep 12 09:03:16 p34 kernel: [50976.927493]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:03:16 p34 kernel: [50976.927498]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:03:16 p34 kernel: [50976.927505]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:03:16 p34 kernel: [50976.927510]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:03:16 p34 kernel: [50976.927514]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:03:16 p34 kernel: [50976.927517]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:03:16 p34 kernel: [50976.927523]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:03:16 p34 kernel: [50976.927526]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:03:16 p34 kernel: [50976.927530]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:03:16 p34 kernel: [50976.927537]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:03:16 p34 kernel: [50976.927541]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:03:16 p34 kernel: [50976.927545]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:03:16 p34 kernel: [50976.927547] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:03:16 p34 kernel: <48>[50976.927568]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:03:16 p34 kernel: [50976.927579] Call Trace:
Sep 12 09:03:16 p34 kernel: [50976.927583]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:03:16 p34 kernel: [50976.927587]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:03:16 p34 kernel: [50976.927591]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:03:16 p34 kernel: [50976.927596]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:03:16 p34 kernel: [50976.927599]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:03:16 p34 kernel: [50976.927603]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:03:16 p34 kernel: [50976.927607]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:03:16 p34 kernel: [50976.927614]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:03:16 p34 kernel: [50976.927618]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:03:16 p34 kernel: [50976.927622]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:03:16 p34 kernel: [50976.927625]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:03:16 p34 kernel: [50976.927629]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:03:44 p34 kernel: [51004.885157] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:03:44 p34 kernel: [51004.885161] CPU 18=20
Sep 12 09:03:44 p34 kernel: [51004.885165] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:03:44 p34 kernel: [51004.885171] RIP: 0010:[<ffffffff8107a981>]  =
[<ffffffff8107a981>] find_get_pages+0x61/0x150
Sep 12 09:03:44 p34 kernel: [51004.885180] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:03:44 p34 kernel: [51004.885183] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:03:44 p34 kernel: [51004.885186] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:03:44 p34 kernel: [51004.885188] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:03:44 p34 kernel: [51004.885191] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:03:44 p34 kernel: [51004.885194] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:03:44 p34 kernel: [51004.885197] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:03:44 p34 kernel: [51004.885200] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:03:44 p34 kernel: [51004.885203] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:03:44 p34 kernel: [51004.885205] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:03:44 p34 kernel: [51004.885208] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:03:44 p34 kernel: [51004.885211] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:03:44 p34 kernel: [51004.885213] Stack:
Sep 12 09:03:44 p34 kernel: [51004.885215]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:03:44 p34 kernel: [51004.885222]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:03:44 p34 kernel: [51004.885227]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:03:44 p34 kernel: [51004.885233] Call Trace:
Sep 12 09:03:44 p34 kernel: [51004.885240]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:03:44 p34 kernel: [51004.885245]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:03:44 p34 kernel: [51004.885252]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:03:44 p34 kernel: [51004.885256]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:03:44 p34 kernel: [51004.885260]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:03:44 p34 kernel: [51004.885264]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:03:44 p34 kernel: [51004.885269]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:03:44 p34 kernel: [51004.885273]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:03:44 p34 kernel: [51004.885277]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:03:44 p34 kernel: [51004.885284]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:03:44 p34 kernel: [51004.885288]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:03:44 p34 kernel: [51004.885292]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:03:44 p34 kernel: [51004.885293] Code: 89 ea e8 33 95 22 00 85 c0=
 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b 07 48 8b 38 48 85=
 ff 74 5b 40 f6 c7 01 75 7a=20
Sep 12 09:03:44 p34 kernel: <48>[51004.885315]  63 83 44 e0 ff ff a9 00 ff =
ff 07 0f 85 8d 00 00 00 44 8b 47=20
Sep 12 09:03:44 p34 kernel: [51004.885325] Call Trace:
Sep 12 09:03:44 p34 kernel: [51004.885329]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:03:44 p34 kernel: [51004.885334]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:03:44 p34 kernel: [51004.885338]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:03:44 p34 kernel: [51004.885342]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:03:44 p34 kernel: [51004.885346]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:03:44 p34 kernel: [51004.885349]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:03:44 p34 kernel: [51004.885354]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:03:44 p34 kernel: [51004.885360]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:03:44 p34 kernel: [51004.885363]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:03:44 p34 kernel: [51004.885367]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:03:44 p34 kernel: [51004.885371]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:03:44 p34 kernel: [51004.885375]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:04:12 p34 kernel: [51032.842903] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:04:12 p34 kernel: [51032.842908] CPU 18=20
Sep 12 09:04:12 p34 kernel: [51032.842912] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:12 p34 kernel: [51032.842917] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:04:12 p34 kernel: [51032.842926] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:04:12 p34 kernel: [51032.842929] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:04:12 p34 kernel: [51032.842932] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:04:12 p34 kernel: [51032.842934] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:04:12 p34 kernel: [51032.842937] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:04:12 p34 kernel: [51032.842940] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:04:12 p34 kernel: [51032.842943] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:04:12 p34 kernel: [51032.842946] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:12 p34 kernel: [51032.842949] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:12 p34 kernel: [51032.842951] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:12 p34 kernel: [51032.842954] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:12 p34 kernel: [51032.842957] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:04:12 p34 kernel: [51032.842960] Stack:
Sep 12 09:04:12 p34 kernel: [51032.842961]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:04:12 p34 kernel: [51032.842968]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:04:12 p34 kernel: [51032.842974]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:04:12 p34 kernel: [51032.842979] Call Trace:
Sep 12 09:04:12 p34 kernel: [51032.842986]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:04:12 p34 kernel: [51032.842991]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:04:12 p34 kernel: [51032.842998]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:04:12 p34 kernel: [51032.843003]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:04:12 p34 kernel: [51032.843007]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:04:12 p34 kernel: [51032.843010]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:04:12 p34 kernel: [51032.843016]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:04:12 p34 kernel: [51032.843019]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:04:12 p34 kernel: [51032.843023]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:04:12 p34 kernel: [51032.843030]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:04:12 p34 kernel: [51032.843034]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:04:12 p34 kernel: [51032.843038]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:04:12 p34 kernel: [51032.843040] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:04:12 p34 kernel: <48>[51032.843061]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:04:12 p34 kernel: [51032.843072] Call Trace:
Sep 12 09:04:12 p34 kernel: [51032.843076]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:04:12 p34 kernel: [51032.843080]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:04:12 p34 kernel: [51032.843084]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:04:12 p34 kernel: [51032.843089]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:04:12 p34 kernel: [51032.843092]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:04:12 p34 kernel: [51032.843096]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:04:12 p34 kernel: [51032.843100]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:04:12 p34 kernel: [51032.843106]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:04:12 p34 kernel: [51032.843109]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:04:12 p34 kernel: [51032.843113]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:04:12 p34 kernel: [51032.843117]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:04:12 p34 kernel: [51032.843121]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:04:24 p34 kernel: [51045.443174] INFO: task gpsd:4705 blocked for=
 more than 120 seconds.
Sep 12 09:04:24 p34 kernel: [51045.443178] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
Sep 12 09:04:24 p34 kernel: [51045.443181] gpsd            D ffff8806260378=
50     0  4705      1 0x00000000
Sep 12 09:04:24 p34 kernel: [51045.443187]  ffff880620e397d8 00000000000000=
86 0000000000000001 ffff880620e39fd8
Sep 12 09:04:24 p34 kernel: [51045.443194]  0000000000004000 ffff880620e39f=
d8 ffff8806276713a0 ffff880626037850
Sep 12 09:04:24 p34 kernel: [51045.443200]  ffff880626d2a840 00000000000000=
20 00000000000005f9 00000000000005f9
Sep 12 09:04:24 p34 kernel: [51045.443205] Call Trace:
Sep 12 09:04:24 p34 kernel: [51045.443214]  [<ffffffff81030533>] ? load_bal=
ance+0xa3/0x5c0
Sep 12 09:04:24 p34 kernel: [51045.443221]  [<ffffffff81645985>] schedule_t=
imeout+0x1a5/0x200
Sep 12 09:04:24 p34 kernel: [51045.443225]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:04:24 p34 kernel: [51045.443230]  [<ffffffff816449cd>] wait_for_c=
ommon+0xbd/0x150
Sep 12 09:04:24 p34 kernel: [51045.443234]  [<ffffffff810316a0>] ? try_to_w=
ake_up+0x260/0x260
Sep 12 09:04:24 p34 kernel: [51045.443238]  [<ffffffff81644b38>] wait_for_c=
ompletion+0x18/0x20
Sep 12 09:04:24 p34 kernel: [51045.443244]  [<ffffffff8104b939>] flush_work=
+0x29/0x40
Sep 12 09:04:24 p34 kernel: [51045.443248]  [<ffffffff81049540>] ? do_work_=
for_cpu+0x30/0x30
Sep 12 09:04:24 p34 kernel: [51045.443254]  [<ffffffff813157c0>] tty_flush_=
to_ldisc+0x10/0x20
Sep 12 09:04:24 p34 kernel: [51045.443258]  [<ffffffff8130fc8f>] n_tty_poll=
+0x5f/0x1d0
Sep 12 09:04:24 p34 kernel: [51045.443262]  [<ffffffff8130bb4a>] tty_poll+0=
x8a/0xa0
Sep 12 09:04:24 p34 kernel: [51045.443266]  [<ffffffff810ccd02>] do_select+=
0x3a2/0x6d0
Sep 12 09:04:24 p34 kernel: [51045.443270]  [<ffffffff810cc4f0>] ? poll_sel=
ect_copy_remaining+0x140/0x140
Sep 12 09:04:24 p34 kernel: [51045.443274]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:04:24 p34 kernel: [51045.443278]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:04:24 p34 kernel: [51045.443281]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:04:24 p34 kernel: [51045.443284]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:04:24 p34 kernel: [51045.443288]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:04:24 p34 kernel: [51045.443294]  [<ffffffff812a382e>] ? radix_tr=
ee_lookup_slot+0xe/0x10
Sep 12 09:04:24 p34 kernel: [51045.443299]  [<ffffffff8107a178>] ? find_get=
_page+0x28/0xd0
Sep 12 09:04:24 p34 kernel: [51045.443302]  [<ffffffff8107a417>] ? filemap_=
fault+0x87/0x470
Sep 12 09:04:24 p34 kernel: [51045.443307]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:04:24 p34 kernel: [51045.443311]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:04:24 p34 kernel: [51045.443315]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:04:24 p34 kernel: [51045.443319]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:04:24 p34 kernel: [51045.443323]  [<ffffffff810cd230>] core_sys_s=
elect+0x200/0x2f0
Sep 12 09:04:24 p34 kernel: [51045.443326]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:04:24 p34 kernel: [51045.443330]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:04:24 p34 kernel: [51045.443335]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:04:24 p34 kernel: [51045.443338]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:04:24 p34 kernel: [51045.443341]  [<ffffffff810cd3d6>] sys_select=
+0xb6/0x100
Sep 12 09:04:24 p34 kernel: [51045.443346]  [<ffffffff816478bb>] system_cal=
l_fastpath+0x16/0x1b
Sep 12 09:04:40 p34 kernel: [51060.800648] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:04:40 p34 kernel: [51060.800653] CPU 18=20
Sep 12 09:04:40 p34 kernel: [51060.800657] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:40 p34 kernel: [51060.800663] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:04:40 p34 kernel: [51060.800672] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:04:40 p34 kernel: [51060.800674] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:04:40 p34 kernel: [51060.800677] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:04:40 p34 kernel: [51060.800680] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:04:40 p34 kernel: [51060.800682] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:04:40 p34 kernel: [51060.800685] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:04:40 p34 kernel: [51060.800688] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:04:40 p34 kernel: [51060.800691] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:40 p34 kernel: [51060.800694] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:40 p34 kernel: [51060.800697] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:40 p34 kernel: [51060.800699] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:40 p34 kernel: [51060.800702] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:04:40 p34 kernel: [51060.800705] Stack:
Sep 12 09:04:40 p34 kernel: [51060.800707]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:04:40 p34 kernel: [51060.800713]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:04:40 p34 kernel: [51060.800719]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:04:40 p34 kernel: [51060.800725] Call Trace:
Sep 12 09:04:40 p34 kernel: [51060.800731]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:04:40 p34 kernel: [51060.800736]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:04:40 p34 kernel: [51060.800743]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:04:40 p34 kernel: [51060.800748]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:04:40 p34 kernel: [51060.800752]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:04:40 p34 kernel: [51060.800756]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:04:40 p34 kernel: [51060.800761]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:04:40 p34 kernel: [51060.800765]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:04:40 p34 kernel: [51060.800769]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:04:40 p34 kernel: [51060.800776]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:04:40 p34 kernel: [51060.800779]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:04:40 p34 kernel: [51060.800784]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:04:40 p34 kernel: [51060.800785] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:04:40 p34 kernel: <44>[51060.800806]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:04:40 p34 kernel: [51060.800817] Call Trace:
Sep 12 09:04:40 p34 kernel: [51060.800821]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:04:40 p34 kernel: [51060.800825]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:04:40 p34 kernel: [51060.800830]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:04:40 p34 kernel: [51060.800834]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:04:40 p34 kernel: [51060.800838]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:04:40 p34 kernel: [51060.800841]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:04:40 p34 kernel: [51060.800846]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:04:40 p34 kernel: [51060.800851]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:04:40 p34 kernel: [51060.800855]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:04:40 p34 kernel: [51060.800859]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:04:40 p34 kernel: [51060.800863]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:04:40 p34 kernel: [51060.800867]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:04:53 p34 kernel: [51073.584526] INFO: rcu_sched_state detected s=
tall on CPU 18 (t=3D240030 jiffies)
Sep 12 09:04:53 p34 kernel: [51073.584531] sending NMI to all CPUs:
Sep 12 09:04:53 p34 kernel: [51073.584571] NMI backtrace for cpu 0
Sep 12 09:04:53 p34 kernel: [51073.584575] CPU 0=20
Sep 12 09:04:53 p34 kernel: [51073.584581] Pid: 0, comm: swapper Not tainte=
d 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.584586] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.584596] RSP: 0018:ffffffff81a01eb8  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.584598] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.584601] RDX: 0000000000000000 RSI: fffff=
fff81a01fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.584604] RBP: ffffffff81a01f08 R08: 00000=
000fffffffd R09: 00000000000003b2
Sep 12 09:04:53 p34 kernel: [51073.584606] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.584609] R13: 1242c6dcdd88797e R14: fffff=
fffffffffff R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.584612] FS:  0000000000000000(0000) GS:f=
fff88063fc00000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.584615] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.584618] CR2: 0000000002342da8 CR3: 00000=
00001a43000 CR4: 00000000000006f0
Sep 12 09:04:53 p34 kernel: [51073.584620] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.584623] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.584626] Process swapper (pid: 0, threadi=
nfo ffffffff81a00000, task ffffffff81a4b020)
Sep 12 09:04:53 p34 kernel: [51073.584628] Stack:
Sep 12 09:04:53 p34 kernel: [51073.584630]  ffffffff81a01f08 ffffffff814e7d=
92 0000000000000000 00000000000de1c5
Sep 12 09:04:53 p34 kernel: [51073.584637]  0000000000000000 00000000000de1=
c5 ffff88063fc16170 ffff88063fc16170
Sep 12 09:04:53 p34 kernel: [51073.584642]  ffff88063fc16240 ffff880c3ffdf8=
00 ffffffff81a01f28 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.584648] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.584655]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.584659]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.584664]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.584670]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:04:53 p34 kernel: [51073.584675]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:04:53 p34 kernel: [51073.584680]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:04:53 p34 kernel: [51073.584684]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:04:53 p34 kernel: [51073.584686] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.584717] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.584721]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.584725]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.584729]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.584732]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:04:53 p34 kernel: [51073.584737]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:04:53 p34 kernel: [51073.584741]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:04:53 p34 kernel: [51073.584745]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:04:53 p34 kernel: [51073.584749] NMI backtrace for cpu 1
Sep 12 09:04:53 p34 kernel: [51073.584752] CPU 1=20
Sep 12 09:04:53 p34 kernel: [51073.584756] Pid: 0, comm: kworker/0:0 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.584764] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.584771] RSP: 0018:ffff8806275b1e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.584775] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.584780] RDX: 0000000000000000 RSI: ffff8=
806275b1fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.584785] RBP: ffff8806275b1ee8 R08: 00000=
000fffffffc R09: 000000000000038b
Sep 12 09:04:53 p34 kernel: [51073.584790] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.584795] R13: 1242c6dcdd97a13a R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.584800] FS:  0000000000000000(0000) GS:f=
fff88063fc20000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.584806] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.584810] CR2: 0000000001cb01b8 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.584815] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.584820] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.584826] Process kworker/0:0 (pid: 0, thr=
eadinfo ffff8806275b0000, task ffff8806275ab1e0)
Sep 12 09:04:53 p34 kernel: [51073.584831] Stack:
Sep 12 09:04:53 p34 kernel: [51073.584833]  ffff8806275b1ee8 ffffffff814e7d=
92 0000000000000000 00000000000dfb14
Sep 12 09:04:53 p34 kernel: [51073.584843]  0000000000000000 00000001000dfb=
14 ffff88063fc36170 ffff88063fc36170
Sep 12 09:04:53 p34 kernel: [51073.584853]  ffff88063fc362a0 00000000000000=
00 ffff8806275b1f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.584864] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.584870]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.584877]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.584883]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.584892]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.584896] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.584947] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.584952]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.584958]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.584964]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.584970]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.584976] NMI backtrace for cpu 2
Sep 12 09:04:53 p34 kernel: [51073.584980] CPU 2=20
Sep 12 09:04:53 p34 kernel: [51073.584984] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.584992] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.585002] RSP: 0018:ffff8806275c3e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.585006] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.585011] RDX: 0000000000000000 RSI: ffff8=
806275c3fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.585016] RBP: ffff8806275c3ee8 R08: 00000=
000fffffffc R09: 000000000000038e
Sep 12 09:04:53 p34 kernel: [51073.585021] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.585026] R13: 1242c6dcdd979ba6 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585031] FS:  0000000000000000(0000) GS:f=
fff88063fc40000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585034] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.585037] CR2: 00007f952e86e000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.585040] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585045] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.585050] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275c2000, task ffff8806275bb220)
Sep 12 09:04:53 p34 kernel: [51073.585055] Stack:
Sep 12 09:04:53 p34 kernel: [51073.585058]  ffff8806275c3ee8 ffffffff814e7d=
92 0000000000000000 00000000000e00cd
Sep 12 09:04:53 p34 kernel: [51073.585068]  0000000000000000 00000002000e00=
cd ffff88063fc56170 ffff88063fc56170
Sep 12 09:04:53 p34 kernel: [51073.585078]  ffff88063fc562a0 00000000000000=
00 ffff8806275c3f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.585089] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585095]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585101]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585107]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585114]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585119] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.585166] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585171]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585177]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585181]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585187]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585191] NMI backtrace for cpu 3
Sep 12 09:04:53 p34 kernel: [51073.585196] CPU 3=20
Sep 12 09:04:53 p34 kernel: [51073.585199] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.585207] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.585215] RSP: 0018:ffff8806275d7e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.585219] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.585224] RDX: 0000000000000000 RSI: ffff8=
806275d7fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.585229] RBP: ffff8806275d7ee8 R08: 00000=
000fffffffc R09: 00000000000003b1
Sep 12 09:04:53 p34 kernel: [51073.585234] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.585239] R13: 1242c6dcdd972312 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585245] FS:  0000000000000000(0000) GS:f=
fff88063fc60000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585250] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.585254] CR2: 00007f0148804000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.585259] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585264] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.585269] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275d6000, task ffff8806275cf260)
Sep 12 09:04:53 p34 kernel: [51073.585274] Stack:
Sep 12 09:04:53 p34 kernel: [51073.585276]  ffff8806275d7ee8 ffffffff814e7d=
92 0000000000000000 00000000000e762f
Sep 12 09:04:53 p34 kernel: [51073.585283]  0000000000000000 00000003000e76=
2f ffff88063fc76170 ffff88063fc76170
Sep 12 09:04:53 p34 kernel: [51073.585289]  ffff88063fc762a0 00000000000000=
00 ffff8806275d7f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.585296] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585302]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585309]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585314]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585321]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585325] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.585369] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585375]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585381]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585386]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585392]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585398] NMI backtrace for cpu 4
Sep 12 09:04:53 p34 kernel: [51073.585402] CPU 4=20
Sep 12 09:04:53 p34 kernel: [51073.585407] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.585414] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.585424] RSP: 0018:ffff88062760be98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.585428] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.585432] RDX: 0000000000000000 RSI: ffff8=
8062760bfd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.585437] RBP: ffff88062760bee8 R08: 00000=
000fffffffc R09: 000000000000038a
Sep 12 09:04:53 p34 kernel: [51073.585441] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.585444] R13: 1242c6dcdd97958e R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585447] FS:  0000000000000000(0000) GS:f=
fff88063fc80000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585450] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.585453] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.585456] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585458] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.585461] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062760a000, task ffff8806276052a0)
Sep 12 09:04:53 p34 kernel: [51073.585464] Stack:
Sep 12 09:04:53 p34 kernel: [51073.585465]  ffff88062760bee8 ffffffff814e7d=
92 0000000000000000 00000000000e0818
Sep 12 09:04:53 p34 kernel: [51073.585471]  0000000000000000 00000004000e08=
18 ffff88063fc96170 ffff88063fc96170
Sep 12 09:04:53 p34 kernel: [51073.585477]  ffff88063fc962a0 00000000000000=
00 ffff88062760bf08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.585483] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585488]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585492]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585498]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585504]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585508] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.585549] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585553]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585557]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585561]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585565]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585569] NMI backtrace for cpu 5
Sep 12 09:04:53 p34 kernel: [51073.585572] CPU 5=20
Sep 12 09:04:53 p34 kernel: [51073.585576] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.585582] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.585591] RSP: 0018:ffff88062761de98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.585595] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.585599] RDX: 0000000000000000 RSI: ffff8=
8062761dfd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.585604] RBP: ffff88062761dee8 R08: 00000=
000fffffffc R09: 000000000000038e
Sep 12 09:04:53 p34 kernel: [51073.585609] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.585613] R13: 1242c6dcdd9797a0 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585618] FS:  0000000000000000(0000) GS:f=
fff88063fca0000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585624] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.585628] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.585632] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585637] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.585642] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062761c000, task ffff8806276192e0)
Sep 12 09:04:53 p34 kernel: [51073.585644] Stack:
Sep 12 09:04:53 p34 kernel: [51073.585646]  ffff88062761dee8 ffffffff814e7d=
92 0000000000000000 00000000000e04d7
Sep 12 09:04:53 p34 kernel: [51073.585652]  0000000000000000 00000005000e04=
d7 ffff88063fcb6170 ffff88063fcb6170
Sep 12 09:04:53 p34 kernel: [51073.585657]  ffff88063fcb62a0 00000000000000=
00 ffff88062761df08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.585663] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585668]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585672]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585676]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585681]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585683] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.585720] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585725]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585731]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585736]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585742]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585748] NMI backtrace for cpu 6
Sep 12 09:04:53 p34 kernel: [51073.585755] CPU 6=20
Sep 12 09:04:53 p34 kernel: [51073.585764] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.585777] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.585795] RSP: 0018:ffff880627625e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.585803] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.585812] RDX: 0000000000000000 RSI: ffff8=
80627625fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.585822] RBP: ffff880627625ee8 R08: 00000=
000fffffffc R09: 00000000000003e2
Sep 12 09:04:53 p34 kernel: [51073.585833] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.585844] R13: 1242c6dcdd966f76 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585848] FS:  0000000000000000(0000) GS:f=
fff880c3fc00000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585851] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.585855] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.585858] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.585861] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.585865] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627624000, task ffff880627618780)
Sep 12 09:04:53 p34 kernel: [51073.585868] Stack:
Sep 12 09:04:53 p34 kernel: [51073.585870]  ffff880627625ee8 ffffffff814e7d=
92 0000000000000000 00000000000f29d0
Sep 12 09:04:53 p34 kernel: [51073.585884]  0000000000000000 00000006000f29=
d0 ffff880c3fc16170 ffff880c3fc16170
Sep 12 09:04:53 p34 kernel: [51073.585902]  ffff880c3fc162a0 00000000000000=
00 ffff880627625f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.585922] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.585933]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.585946]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.585958]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.585970]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.585978] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.586064] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.586072]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.586083]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.586094]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.586104]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.586114] NMI backtrace for cpu 7
Sep 12 09:04:53 p34 kernel: [51073.586119] CPU 7=20
Sep 12 09:04:53 p34 kernel: [51073.586126] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.586136] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.586148] RSP: 0018:ffff88062762fe98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.586154] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.586160] RDX: 0000000000000000 RSI: ffff8=
8062762ffd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.586166] RBP: ffff88062762fee8 R08: 00000=
000fffffffc R09: 0000000000000388
Sep 12 09:04:53 p34 kernel: [51073.586172] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.586177] R13: 1242c6dcdd971884 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586183] FS:  0000000000000000(0000) GS:f=
fff880c3fc20000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586190] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.586194] CR2: 00007f8f297df000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.586199] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586204] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.586210] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062762e000, task ffff88062762d8d0)
Sep 12 09:04:53 p34 kernel: [51073.586216] Stack:
Sep 12 09:04:53 p34 kernel: [51073.586218]  ffff88062762fee8 ffffffff814e7d=
92 0000000000000000 00000000000e81bf
Sep 12 09:04:53 p34 kernel: [51073.586229]  0000000000000000 00000007000e81=
bf ffff880c3fc36170 ffff880c3fc36170
Sep 12 09:04:53 p34 kernel: [51073.586242]  ffff880c3fc362a0 00000000000000=
00 ffff88062762ff08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.586259] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.586267]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.586276]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.586282]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.586290]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.586295] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.586362] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.586368]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.586375]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.586382]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.586389]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.586396] NMI backtrace for cpu 8
Sep 12 09:04:53 p34 kernel: [51073.586402] CPU 8=20
Sep 12 09:04:53 p34 kernel: [51073.586408] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.586417] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.586429] RSP: 0018:ffff880627635e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.586434] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.586440] RDX: 0000000000000000 RSI: ffff8=
80627635fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.586447] RBP: ffff880627635ee8 R08: 00000=
000fffffffd R09: 00000000000003af
Sep 12 09:04:53 p34 kernel: [51073.586453] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.586457] R13: 1242c6dcdd97ae75 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586463] FS:  0000000000000000(0000) GS:f=
fff880c3fc40000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586470] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.586475] CR2: 00007fed30b0c000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.586480] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586485] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.586491] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627634000, task ffff88062762cd70)
Sep 12 09:04:53 p34 kernel: [51073.586497] Stack:
Sep 12 09:04:53 p34 kernel: [51073.586499]  ffff880627635ee8 ffffffff814e7d=
92 0000000000000000 00000000000def25
Sep 12 09:04:53 p34 kernel: [51073.586512]  0000000000000000 00000008000def=
25 ffff880c3fc56170 ffff880c3fc56170
Sep 12 09:04:53 p34 kernel: [51073.586524]  ffff880c3fc56240 00000000000000=
00 ffff880627635f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.586541] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.586548]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.586556]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.586563]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.586571]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.586576] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.586645] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.586652]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.586659]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.586666]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.586674]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.586682] NMI backtrace for cpu 9
Sep 12 09:04:53 p34 kernel: [51073.586687] CPU 9=20
Sep 12 09:04:53 p34 kernel: [51073.586694] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.586703] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.586715] RSP: 0018:ffff88062763de98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.586720] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.586726] RDX: 0000000000000000 RSI: ffff8=
8062763dfd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.586732] RBP: ffff88062763dee8 R08: 00000=
000fffffffc R09: 000000000000038e
Sep 12 09:04:53 p34 kernel: [51073.586737] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.586742] R13: 1242c6dcdd97aff4 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586749] FS:  0000000000000000(0000) GS:f=
fff880c3fc60000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586755] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.586760] CR2: 00007f91a8ad7520 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.586766] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.586771] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.586777] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062763c000, task ffff88062762c210)
Sep 12 09:04:53 p34 kernel: [51073.586783] Stack:
Sep 12 09:04:53 p34 kernel: [51073.586784]  ffff88062763dee8 ffffffff814e7d=
92 0000000000000000 00000000000dec9b
Sep 12 09:04:53 p34 kernel: [51073.586796]  0000000000000000 00000009000dec=
9b ffff880c3fc76170 ffff880c3fc76170
Sep 12 09:04:53 p34 kernel: [51073.586808]  ffff880c3fc762a0 00000000000000=
00 ffff88062763df08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.586822] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.586828]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.586835]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.586842]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.586851]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.586856] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.586918] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.586926]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.586935]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.586943]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.586951]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.586958] NMI backtrace for cpu 10
Sep 12 09:04:53 p34 kernel: [51073.586964] CPU 10=20
Sep 12 09:04:53 p34 kernel: [51073.586971] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.586980] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.586992] RSP: 0018:ffff880627665e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.586997] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.587003] RDX: 0000000000000000 RSI: ffff8=
80627665fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.587009] RBP: ffff880627665ee8 R08: 00000=
000fffffffc R09: 0000000000000388
Sep 12 09:04:53 p34 kernel: [51073.587015] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.587021] R13: 1242c6dcdd97b2d0 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587026] FS:  0000000000000000(0000) GS:f=
fff880c3fc80000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587033] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.587038] CR2: 00000000004f8290 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.587044] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587048] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.587054] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627664000, task ffff88062763f360)
Sep 12 09:04:53 p34 kernel: [51073.587060] Stack:
Sep 12 09:04:53 p34 kernel: [51073.587061]  ffff880627665ee8 ffffffff814e7d=
92 0000000000000000 00000000000deb3d
Sep 12 09:04:53 p34 kernel: [51073.587074]  0000000000000000 0000000a000deb=
3d ffff880c3fc96170 ffff880c3fc96170
Sep 12 09:04:53 p34 kernel: [51073.587086]  ffff880c3fc962a0 00000000000000=
00 ffff880627665f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.587097] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587104]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587112]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587119]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587127]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587132] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.587195] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587201]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587208]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587215]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587223]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587230] NMI backtrace for cpu 11
Sep 12 09:04:53 p34 kernel: [51073.587235] CPU 11=20
Sep 12 09:04:53 p34 kernel: [51073.587242] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.587252] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.587263] RSP: 0018:ffff88062766be98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.587268] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.587274] RDX: 0000000000000000 RSI: ffff8=
8062766bfd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.587280] RBP: ffff88062766bee8 R08: 00000=
000fffffffc R09: 0000000000000392
Sep 12 09:04:53 p34 kernel: [51073.587282] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.587285] R13: 1242c6dcdda6afff R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587288] FS:  0000000000000000(0000) GS:f=
fff880c3fca0000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587291] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.587294] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.587297] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587299] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.587302] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062766a000, task ffff88062763e800)
Sep 12 09:04:53 p34 kernel: [51073.587305] Stack:
Sep 12 09:04:53 p34 kernel: [51073.587306]  ffff88062766bee8 ffffffff814e7d=
92 0000000000000000 00000000000e2fb0
Sep 12 09:04:53 p34 kernel: [51073.587312]  0000000000000000 0000000b000e2f=
b0 ffff880c3fcb6170 ffff880c3fcb6170
Sep 12 09:04:53 p34 kernel: [51073.587318]  ffff880c3fcb62a0 00000000000000=
00 ffff88062766bf08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.587324] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587329]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587336]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587344]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587352]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587357] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.587421] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587426]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587434]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587440]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587447]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587455] NMI backtrace for cpu 12
Sep 12 09:04:53 p34 kernel: [51073.587459] CPU 12=20
Sep 12 09:04:53 p34 kernel: [51073.587464] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.587470] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.587479] RSP: 0018:ffff88062767fe98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.587482] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.587486] RDX: 0000000000000000 RSI: ffff8=
8062767ffd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.587490] RBP: ffff88062767fee8 R08: 00000=
000fffffffc R09: 00000000000003b3
Sep 12 09:04:53 p34 kernel: [51073.587494] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.587498] R13: 1242c6dcdda5bfbc R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587503] FS:  0000000000000000(0000) GS:f=
fff88063fcc0000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587507] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.587510] CR2: 00007f14005c2000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.587514] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587518] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.587522] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062767e000, task ffff880627670840)
Sep 12 09:04:53 p34 kernel: [51073.587526] Stack:
Sep 12 09:04:53 p34 kernel: [51073.587528]  ffff88062767fee8 ffffffff814e7d=
92 0000000000000000 00000000000f1e02
Sep 12 09:04:53 p34 kernel: [51073.587538]  0000000000000000 0000000c000f1e=
02 ffff88063fcd6170 ffff88063fcd6170
Sep 12 09:04:53 p34 kernel: [51073.587547]  ffff88063fcd62a0 00000000000000=
00 ffff88062767ff08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.587556] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587562]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587569]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587575]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587581]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587584] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.587632] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587638]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587644]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587649]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587654]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587660] NMI backtrace for cpu 13
Sep 12 09:04:53 p34 kernel: [51073.587665] CPU 13=20
Sep 12 09:04:53 p34 kernel: [51073.587669] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.587679] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.587691] RSP: 0018:ffff880627693e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.587697] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.587704] RDX: 0000000000000000 RSI: ffff8=
80627693fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.587710] RBP: ffff880627693ee8 R08: 00000=
000fffffffd R09: 0000000000000394
Sep 12 09:04:53 p34 kernel: [51073.587716] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.587723] R13: 1242c6dcdda5c061 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587730] FS:  0000000000000000(0000) GS:f=
fff88063fce0000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587737] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.587743] CR2: 0000000001cac078 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.587749] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587756] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.587763] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627692000, task ffff880627684880)
Sep 12 09:04:53 p34 kernel: [51073.587769] Stack:
Sep 12 09:04:53 p34 kernel: [51073.587772]  ffff880627693ee8 ffffffff814e7d=
92 0000000000000000 00000000000f1cf9
Sep 12 09:04:53 p34 kernel: [51073.587785]  0000000000000000 0000000d000f1c=
f9 ffff88063fcf6170 ffff88063fcf6170
Sep 12 09:04:53 p34 kernel: [51073.587798]  ffff88063fcf6240 00000000000000=
00 ffff880627693f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.587811] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587820]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587828]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587835]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587845]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587850] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.587886] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.587890]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.587894]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.587897]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.587901]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.587905] NMI backtrace for cpu 14
Sep 12 09:04:53 p34 kernel: [51073.587909] CPU 14=20
Sep 12 09:04:53 p34 kernel: [51073.587913] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.587920] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.587930] RSP: 0018:ffff8806276c5e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.587934] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.587938] RDX: 0000000000000000 RSI: ffff8=
806276c5fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.587943] RBP: ffff8806276c5ee8 R08: 00000=
000fffffffd R09: 0000000000000396
Sep 12 09:04:53 p34 kernel: [51073.587948] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.587953] R13: 1242c6dcdda5c3d9 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587958] FS:  0000000000000000(0000) GS:f=
fff88063fd00000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587963] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.587968] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.587973] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.587978] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.587983] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276c4000, task ffff8806276968c0)
Sep 12 09:04:53 p34 kernel: [51073.587988] Stack:
Sep 12 09:04:53 p34 kernel: [51073.587991]  ffff8806276c5ee8 ffffffff814e7d=
92 0000000000000000 00000000000f1849
Sep 12 09:04:53 p34 kernel: [51073.588005]  0000000000000000 0000000e000f18=
49 ffff88063fd16170 ffff88063fd16170
Sep 12 09:04:53 p34 kernel: [51073.588018]  ffff88063fd16240 00000000000000=
00 ffff8806276c5f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.588032] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588041]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588049]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588056]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588062]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588067] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.588112] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588118]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588124]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588129]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588135]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588141] NMI backtrace for cpu 15
Sep 12 09:04:53 p34 kernel: [51073.588145] CPU 15=20
Sep 12 09:04:53 p34 kernel: [51073.588149] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.588157] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.588166] RSP: 0018:ffff8806276d9e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.588170] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.588175] RDX: 0000000000000000 RSI: ffff8=
806276d9fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.588180] RBP: ffff8806276d9ee8 R08: 00000=
000fffffffd R09: 00000000000003b4
Sep 12 09:04:53 p34 kernel: [51073.588185] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.588190] R13: 1242c6dcdda65a31 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588195] FS:  0000000000000000(0000) GS:f=
fff88063fd20000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588201] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.588205] CR2: 00007f0148804000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.588210] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588215] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.588220] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276d8000, task ffff8806276ca900)
Sep 12 09:04:53 p34 kernel: [51073.588225] Stack:
Sep 12 09:04:53 p34 kernel: [51073.588227]  ffff8806276d9ee8 ffffffff814e7d=
92 0000000000000000 00000000000e849e
Sep 12 09:04:53 p34 kernel: [51073.588238]  0000000000000000 0000000f000e84=
9e ffff88063fd36170 ffff88063fd36170
Sep 12 09:04:53 p34 kernel: [51073.588245]  ffff88063fd36240 00000000000000=
00 ffff8806276d9f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.588251] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588256]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588260]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588264]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588269]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588271] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.588311] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588316]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588322]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588327]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588333]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588339] NMI backtrace for cpu 16
Sep 12 09:04:53 p34 kernel: [51073.588343] CPU 16=20
Sep 12 09:04:53 p34 kernel: [51073.588347] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.588354] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.588363] RSP: 0018:ffff8806276ede98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.588367] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.588371] RDX: 0000000000000000 RSI: ffff8=
806276edfd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.588375] RBP: ffff8806276edee8 R08: 00000=
000fffffffd R09: 0000000000000397
Sep 12 09:04:53 p34 kernel: [51073.588380] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.588385] R13: 1242c6dcdda5bd64 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588390] FS:  0000000000000000(0000) GS:f=
fff88063fd40000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588395] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.588399] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.588404] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588408] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.588413] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276ec000, task ffff8806276de600)
Sep 12 09:04:53 p34 kernel: [51073.588417] Stack:
Sep 12 09:04:53 p34 kernel: [51073.588419]  ffff8806276edee8 ffffffff814e7d=
92 0000000000000000 00000000000f1f42
Sep 12 09:04:53 p34 kernel: [51073.588428]  0000000000000000 00000010000f1f=
42 ffff88063fd56170 ffff88063fd56170
Sep 12 09:04:53 p34 kernel: [51073.588436]  ffff88063fd56240 00000000000000=
00 ffff8806276edf08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.588444] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588450]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588456]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588461]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588468]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588471] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.588518] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588523]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588531]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588536]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588542]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588546] NMI backtrace for cpu 17
Sep 12 09:04:53 p34 kernel: [51073.588549] CPU 17=20
Sep 12 09:04:53 p34 kernel: [51073.588552] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.588557] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.588563] RSP: 0018:ffff88062771de98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.588567] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.588572] RDX: 0000000000000000 RSI: ffff8=
8062771dfd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.588576] RBP: ffff88062771dee8 R08: 00000=
000fffffffd R09: 0000000000000397
Sep 12 09:04:53 p34 kernel: [51073.588581] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.588586] R13: 1242c6dcdda5bf8d R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588591] FS:  0000000000000000(0000) GS:f=
fff88063fd60000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588596] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.588601] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.588606] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588610] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.588615] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062771c000, task ffff8806276f0640)
Sep 12 09:04:53 p34 kernel: [51073.588620] Stack:
Sep 12 09:04:53 p34 kernel: [51073.588622]  ffff88062771dee8 ffffffff814e7d=
92 0000000000000000 00000000000f1cef
Sep 12 09:04:53 p34 kernel: [51073.588631]  0000000000000000 00000011000f1c=
ef ffff88063fd76170 ffff88063fd76170
Sep 12 09:04:53 p34 kernel: [51073.588640]  ffff88063fd76240 00000000000000=
00 ffff88062771df08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.588649] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588654]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588660]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588665]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588672]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588675] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.588719] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588725]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.588731]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.588736]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588742]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.588747] NMI backtrace for cpu 18
Sep 12 09:04:53 p34 kernel: [51073.588749] CPU 18=20
Sep 12 09:04:53 p34 kernel: [51073.588752] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.588757] RIP: 0010:[<ffffffff812a87f2>]  =
[<ffffffff812a87f2>] delay_tsc+0x22/0x60
Sep 12 09:04:53 p34 kernel: [51073.588763] RSP: 0018:ffff880c3fcc3d58  EFLA=
GS: 00000093
Sep 12 09:04:53 p34 kernel: [51073.588766] RAX: 000000008044eb76 RBX: 00000=
000000003e9 RCX: 0000000000000023
Sep 12 09:04:53 p34 kernel: [51073.588769] RDX: 0000000000000030 RSI: 00000=
0008044eb46 RDI: 000000000003a97d
Sep 12 09:04:53 p34 kernel: [51073.588771] RBP: ffff880c3fcc3d58 R08: 00000=
00000000012 R09: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588774] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000001000
Sep 12 09:04:53 p34 kernel: [51073.588777] R13: ffffffff81aa8d50 R14: 00000=
00000000400 R15: 0000000000000092
Sep 12 09:04:53 p34 kernel: [51073.588780] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588786] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.588792] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.588798] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.588804] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.588811] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:04:53 p34 kernel: [51073.588817] Stack:
Sep 12 09:04:53 p34 kernel: [51073.588819]  ffff880c3fcc3d68 ffffffff812a88=
5a ffff880c3fcc3d78 ffffffff812a8887
Sep 12 09:04:53 p34 kernel: [51073.588833]  ffff880c3fcc3d98 ffffffff81019c=
3a 0000000000000002 000000000000c502
Sep 12 09:04:53 p34 kernel: [51073.588845]  ffff880c3fcc3de8 ffffffff8101a8=
e8 7fffffff00000023 0000000000000013
Sep 12 09:04:53 p34 kernel: [51073.588858] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.588861]  <IRQ>=20
Sep 12 09:04:53 p34 kernel: [51073.588867]  [<ffffffff812a885a>] __delay+0x=
a/0x10
Sep 12 09:04:53 p34 kernel: [51073.588874]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:04:53 p34 kernel: [51073.588884]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:04:53 p34 kernel: [51073.588894]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:04:53 p34 kernel: [51073.588904]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:04:53 p34 kernel: [51073.588911]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:04:53 p34 kernel: [51073.588920]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:04:53 p34 kernel: [51073.588928]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:04:53 p34 kernel: [51073.588938]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:04:53 p34 kernel: [51073.588948]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:04:53 p34 kernel: [51073.588959]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:04:53 p34 kernel: [51073.588967]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:04:53 p34 kernel: [51073.588975]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:04:53 p34 kernel: [51073.588985]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:04:53 p34 kernel: [51073.588990]  <EOI>=20
Sep 12 09:04:53 p34 kernel: [51073.588998]  [<ffffffff8107a97b>] ? find_get=
_pages+0x5b/0x150
Sep 12 09:04:53 p34 kernel: [51073.589009]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:04:53 p34 kernel: [51073.589016]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:04:53 p34 kernel: [51073.589028]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:04:53 p34 kernel: [51073.589036]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:04:53 p34 kernel: [51073.589044]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:04:53 p34 kernel: [51073.589052]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:04:53 p34 kernel: [51073.589059]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:04:53 p34 kernel: [51073.589067]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:04:53 p34 kernel: [51073.589074]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:04:53 p34 kernel: [51073.589082]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:04:53 p34 kernel: [51073.589090]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:04:53 p34 kernel: [51073.589098]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:04:53 p34 kernel: [51073.589102] Code: c8 5d c3 66 0f 1f 44 00 00=
 55 65 44 8b 04 25 f0 c4 00 00 48 89 e5 0f 1f 00 0f ae e8 0f 31 89 c6 eb 16=
 0f 1f 80 00 00 00 00 f3 90=20
Sep 12 09:04:53 p34 kernel: <65>[51073.589158]  8b 0c 25 f0 c4 00 00 41 39 =
c8 75 17 0f 1f 00 0f ae e8 0f 31=20
Sep 12 09:04:53 p34 kernel: [51073.589186] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.589187]  <IRQ>  [<ffffffff812a885a>] __d=
elay+0xa/0x10
Sep 12 09:04:53 p34 kernel: [51073.589193]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:04:53 p34 kernel: [51073.589197]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:04:53 p34 kernel: [51073.589202]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:04:53 p34 kernel: [51073.589206]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:04:53 p34 kernel: [51073.589210]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:04:53 p34 kernel: [51073.589214]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:04:53 p34 kernel: [51073.589217]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:04:53 p34 kernel: [51073.589225]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:04:53 p34 kernel: [51073.589233]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:04:53 p34 kernel: [51073.589240]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:04:53 p34 kernel: [51073.589248]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:04:53 p34 kernel: [51073.589256]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:04:53 p34 kernel: [51073.589263]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:04:53 p34 kernel: [51073.589269]  <EOI>  [<ffffffff8107a97b>] ? f=
ind_get_pages+0x5b/0x150
Sep 12 09:04:53 p34 kernel: [51073.589280]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:04:53 p34 kernel: [51073.589288]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:04:53 p34 kernel: [51073.589297]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:04:53 p34 kernel: [51073.589304]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:04:53 p34 kernel: [51073.589310]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:04:53 p34 kernel: [51073.589319]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:04:53 p34 kernel: [51073.589325]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:04:53 p34 kernel: [51073.589332]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:04:53 p34 kernel: [51073.589339]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:04:53 p34 kernel: [51073.589346]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:04:53 p34 kernel: [51073.589354]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:04:53 p34 kernel: [51073.589361]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:04:53 p34 kernel: [51073.589435] NMI backtrace for cpu 19
Sep 12 09:04:53 p34 kernel: [51073.589442] CPU 19=20
Sep 12 09:04:53 p34 kernel: [51073.589448] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.589453] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.589460] RSP: 0018:ffff88062772fe98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.589462] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.589465] RDX: 0000000000000000 RSI: ffff8=
8062772ffd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.589468] RBP: ffff88062772fee8 R08: 00000=
000fffffffc R09: 00000000000003b3
Sep 12 09:04:53 p34 kernel: [51073.589471] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.589473] R13: 1242c6dcddd428b3 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589481] FS:  0000000000000000(0000) GS:f=
fff880c3fce0000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589484] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.589486] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.589489] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589496] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.589502] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062772e000, task ffff880627724c30)
Sep 12 09:04:53 p34 kernel: [51073.589508] Stack:
Sep 12 09:04:53 p34 kernel: [51073.589511]  ffff88062772fee8 ffffffff814e7d=
92 0000000000000000 00000000000e7abd
Sep 12 09:04:53 p34 kernel: [51073.589523]  0000000000000000 00000013000e7a=
bd ffff880c3fcf6170 ffff880c3fcf6170
Sep 12 09:04:53 p34 kernel: [51073.589534]  ffff880c3fcf62a0 00000000000000=
00 ffff88062772ff08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.589548] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.589555]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.589564]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.589571]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.589579]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.589585] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.589659] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.589666]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.589674]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.589680]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.589685]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.589689] NMI backtrace for cpu 20
Sep 12 09:04:53 p34 kernel: [51073.589692] CPU 20=20
Sep 12 09:04:53 p34 kernel: [51073.589696] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.589701] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.589708] RSP: 0018:ffff880627735e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.589710] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.589713] RDX: 0000000000000000 RSI: ffff8=
80627735fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.589716] RBP: ffff880627735ee8 R08: 00000=
000fffffffd R09: 00000000000003e0
Sep 12 09:04:53 p34 kernel: [51073.589718] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:04:53 p34 kernel: [51073.589721] R13: 1242c6dcddd7064b R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589724] FS:  0000000000000000(0000) GS:f=
fff880c3fd00000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589731] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.589737] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.589743] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589749] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.589756] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627734000, task ffff8806277240d0)
Sep 12 09:04:53 p34 kernel: [51073.589762] Stack:
Sep 12 09:04:53 p34 kernel: [51073.589765]  ffff880627735ee8 ffffffff814e7d=
92 0000000000000000 00000000000b9e47
Sep 12 09:04:53 p34 kernel: [51073.589777]  0000000000000000 00000014000b9e=
47 ffff880c3fd16170 ffff880c3fd16170
Sep 12 09:04:53 p34 kernel: [51073.589783]  ffff880c3fd16240 00000000000000=
00 ffff880627735f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.589788] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.589793]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.589798]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.589801]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.589806]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.589809] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.589858] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.589864]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.589868]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.589872]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.589876]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.589880] NMI backtrace for cpu 21
Sep 12 09:04:53 p34 kernel: [51073.589883] CPU 21=20
Sep 12 09:04:53 p34 kernel: [51073.589886] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.589891] RIP: 0010:[<ffffffff810524c0>]  =
[<ffffffff810524c0>] process_cpu_nsleep+0x10/0x10
Sep 12 09:04:53 p34 kernel: [51073.589902] RSP: 0018:ffff880c3fd23e90  EFLA=
GS: 00000002
Sep 12 09:04:53 p34 kernel: [51073.589908] RAX: 000000010307e968 RBX: ffff8=
80627739220 RCX: ffff880627739201
Sep 12 09:04:53 p34 kernel: [51073.589914] RDX: ffff880c3fd20000 RSI: 00000=
0010307e968 RDI: ffff880627739220
Sep 12 09:04:53 p34 kernel: [51073.589920] RBP: ffff880c3fd23eb8 R08: 00000=
00000000000 R09: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589926] R10: 000000010307e968 R11: 7ffff=
fffffffffff R12: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589933] R13: 0000000000000015 R14: 7ffff=
fffffffffff R15: 00002e8552f0f1bd
Sep 12 09:04:53 p34 kernel: [51073.589939] FS:  0000000000000000(0000) GS:f=
fff880c3fd20000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589945] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.589951] CR2: 00007f38f80fbe02 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.589957] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.589963] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.589970] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062773e000, task ffff880627739220)
Sep 12 09:04:53 p34 kernel: [51073.589975] Stack:
Sep 12 09:04:53 p34 kernel: [51073.589977]  ffffffff81041fc1 ffff880c3fd2cc=
20 ffff880c3fd2cc20 ffff88062773fde8
Sep 12 09:04:53 p34 kernel: [51073.589992]  00002e8552f0f34a ffff880c3fd23e=
e8 ffffffff8105ef7f 00002e8552f0efad
Sep 12 09:04:53 p34 kernel: [51073.590005]  ffff880c3fd2cc20 ffff880c3fd2cb=
40 ffff880c3fd2cb00 ffff880c3fd23f18
Sep 12 09:04:53 p34 kernel: [51073.590020] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.590024]  <IRQ>=20
Sep 12 09:04:53 p34 kernel: [51073.590032]  [<ffffffff81041fc1>] ? update_p=
rocess_times+0x71/0x80
Sep 12 09:04:53 p34 kernel: [51073.590040]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590048]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:04:53 p34 kernel: [51073.590055]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:04:53 p34 kernel: [51073.590062]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:04:53 p34 kernel: [51073.590070]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:04:53 p34 kernel: [51073.590075]  <EOI>=20
Sep 12 09:04:53 p34 kernel: [51073.590083]  [<ffffffff812d6523>] ? intel_id=
le+0xc3/0x110
Sep 12 09:04:53 p34 kernel: [51073.590090]  [<ffffffff812d6502>] ? intel_id=
le+0xa2/0x110
Sep 12 09:04:53 p34 kernel: [51073.590098]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.590105]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590113]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.590118] Code: e9 6b ff ff ff b9 f2 ff ff=
 ff e9 61 ff ff ff 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 bf fa ff ff ff 48=
 89 e5 e8 d2 fe ff ff 5d c3=20
Sep 12 09:04:53 p34 kernel: <55>[51073.590167]  48 89 e5 41 57 41 56 41 55 =
41 54 4c 8d 65 a8 53 48 89 fb 48=20
Sep 12 09:04:53 p34 kernel: [51073.590189] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.590193]  <IRQ>  [<ffffffff81041fc1>] ? u=
pdate_process_times+0x71/0x80
Sep 12 09:04:53 p34 kernel: [51073.590206]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590213]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:04:53 p34 kernel: [51073.590220]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:04:53 p34 kernel: [51073.590228]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:04:53 p34 kernel: [51073.590235]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:04:53 p34 kernel: [51073.590240]  <EOI>  [<ffffffff812d6523>] ? i=
ntel_idle+0xc3/0x110
Sep 12 09:04:53 p34 kernel: [51073.590252]  [<ffffffff812d6502>] ? intel_id=
le+0xa2/0x110
Sep 12 09:04:53 p34 kernel: [51073.590260]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.590267]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590276]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.590283] NMI backtrace for cpu 22
Sep 12 09:04:53 p34 kernel: [51073.590286] CPU 22=20
Sep 12 09:04:53 p34 kernel: [51073.590290] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.590295] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.590302] RSP: 0018:ffff880627747e98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.590304] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.590307] RDX: 0000000000000000 RSI: ffff8=
80627747fd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.590310] RBP: ffff880627747ee8 R08: 00000=
000fffffffc R09: 0000000000000397
Sep 12 09:04:53 p34 kernel: [51073.590312] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.590318] R13: 1242c6dcdde37f46 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.590326] FS:  0000000000000000(0000) GS:f=
fff880c3fd40000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.590333] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.590339] CR2: 00007f9ff41e3000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.590345] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.590352] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.590358] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627746000, task ffff8806277386c0)
Sep 12 09:04:53 p34 kernel: [51073.590364] Stack:
Sep 12 09:04:53 p34 kernel: [51073.590366]  ffff880627747ee8 ffffffff814e7d=
92 0000000000000000 00000000000e6647
Sep 12 09:04:53 p34 kernel: [51073.590381]  0000000000000000 00000016000e66=
47 ffff880c3fd56170 ffff880c3fd56170
Sep 12 09:04:53 p34 kernel: [51073.590396]  ffff880c3fd562a0 00000000000000=
00 ffff880627747f08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.590412] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.590421]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.590428]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.590432]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590437]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.590439] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.590491] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.590498]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.590505]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.590512]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590521]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.590529] NMI backtrace for cpu 23
Sep 12 09:04:53 p34 kernel: [51073.590535] CPU 23=20
Sep 12 09:04:53 p34 kernel: [51073.590542] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:04:53 p34 kernel: [51073.590553] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:04:53 p34 kernel: [51073.590564] RSP: 0018:ffff88062774fe98  EFLA=
GS: 00000046
Sep 12 09:04:53 p34 kernel: [51073.590570] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:04:53 p34 kernel: [51073.590577] RDX: 0000000000000000 RSI: ffff8=
8062774ffd8 RDI: ffffffff81a4d300
Sep 12 09:04:53 p34 kernel: [51073.590583] RBP: ffff88062774fee8 R08: 00000=
000fffffffc R09: 0000000000000397
Sep 12 09:04:53 p34 kernel: [51073.590589] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:04:53 p34 kernel: [51073.590595] R13: 1242c6dcdde37323 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.590602] FS:  0000000000000000(0000) GS:f=
fff880c3fd60000(0000) knlGS:0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.590609] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:04:53 p34 kernel: [51073.590615] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:04:53 p34 kernel: [51073.590621] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:04:53 p34 kernel: [51073.590627] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:04:53 p34 kernel: [51073.590633] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062774e000, task ffff88062774d810)
Sep 12 09:04:53 p34 kernel: [51073.590639] Stack:
Sep 12 09:04:53 p34 kernel: [51073.590642]  ffff88062774fee8 ffffffff814e7d=
92 0000000000000000 00000000000e739b
Sep 12 09:04:53 p34 kernel: [51073.590657]  0000000000000000 00000017000e73=
9b ffff880c3fd76170 ffff880c3fd76170
Sep 12 09:04:53 p34 kernel: [51073.590672]  ffff880c3fd762a0 00000000000000=
00 ffff88062774ff08 ffffffff814e6bb6
Sep 12 09:04:53 p34 kernel: [51073.590685] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.590694]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.590702]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.590710]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590719]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:04:53 p34 kernel: [51073.590723] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:04:53 p34 kernel: [51073.590798] Call Trace:
Sep 12 09:04:53 p34 kernel: [51073.590805]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:04:53 p34 kernel: [51073.590813]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:04:53 p34 kernel: [51073.590820]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:04:53 p34 kernel: [51073.590824]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:05:20 p34 kernel: [51100.740286] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:05:20 p34 kernel: [51100.740291] CPU 18=20
Sep 12 09:05:20 p34 kernel: [51100.740295] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:05:20 p34 kernel: [51100.740301] RIP: 0010:[<ffffffff8107a97b>]  =
[<ffffffff8107a97b>] find_get_pages+0x5b/0x150
Sep 12 09:05:20 p34 kernel: [51100.740310] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000286
Sep 12 09:05:20 p34 kernel: [51100.740312] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:05:20 p34 kernel: [51100.740315] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:05:20 p34 kernel: [51100.740318] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:05:20 p34 kernel: [51100.740321] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:05:20 p34 kernel: [51100.740323] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:05:20 p34 kernel: [51100.740327] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:05:20 p34 kernel: [51100.740330] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:05:20 p34 kernel: [51100.740332] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:05:20 p34 kernel: [51100.740335] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:05:20 p34 kernel: [51100.740337] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:05:20 p34 kernel: [51100.740341] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:05:20 p34 kernel: [51100.740343] Stack:
Sep 12 09:05:20 p34 kernel: [51100.740345]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:05:20 p34 kernel: [51100.740351]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:05:20 p34 kernel: [51100.740357]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:05:20 p34 kernel: [51100.740363] Call Trace:
Sep 12 09:05:20 p34 kernel: [51100.740370]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:05:20 p34 kernel: [51100.740374]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:05:20 p34 kernel: [51100.740381]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:05:20 p34 kernel: [51100.740386]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:05:20 p34 kernel: [51100.740390]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:05:20 p34 kernel: [51100.740394]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:05:20 p34 kernel: [51100.740399]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:05:20 p34 kernel: [51100.740403]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:05:20 p34 kernel: [51100.740407]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:05:20 p34 kernel: [51100.740414]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:05:20 p34 kernel: [51100.740417]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:05:20 p34 kernel: [51100.740422]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:05:20 p34 kernel: [51100.740423] Code: 89 e6 44 89 f1 4c 89 ea e8=
 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b=
 07 48 8b 38 48 85 ff 74 5b=20
Sep 12 09:05:20 p34 kernel: <40>[51100.740444]  f6 c7 01 75 7a 48 63 83 44 =
e0 ff ff a9 00 ff ff 07 0f 85 8d=20
Sep 12 09:05:20 p34 kernel: [51100.740455] Call Trace:
Sep 12 09:05:20 p34 kernel: [51100.740459]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:05:20 p34 kernel: [51100.740464]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:05:20 p34 kernel: [51100.740468]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:05:20 p34 kernel: [51100.740472]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:05:20 p34 kernel: [51100.740476]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:05:20 p34 kernel: [51100.740479]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:05:20 p34 kernel: [51100.740485]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:05:20 p34 kernel: [51100.740490]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:05:20 p34 kernel: [51100.740493]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:05:20 p34 kernel: [51100.740497]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:05:20 p34 kernel: [51100.740501]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:05:20 p34 kernel: [51100.740505]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:05:48 p34 kernel: [51128.698032] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:05:48 p34 kernel: [51128.698037] CPU 18=20
Sep 12 09:05:48 p34 kernel: [51128.698041] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:05:48 p34 kernel: [51128.698047] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:05:48 p34 kernel: [51128.698056] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:05:48 p34 kernel: [51128.698058] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:05:48 p34 kernel: [51128.698061] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:05:48 p34 kernel: [51128.698064] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:05:48 p34 kernel: [51128.698067] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:05:48 p34 kernel: [51128.698069] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:05:48 p34 kernel: [51128.698072] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:05:48 p34 kernel: [51128.698076] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:05:48 p34 kernel: [51128.698078] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:05:48 p34 kernel: [51128.698081] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:05:48 p34 kernel: [51128.698083] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:05:48 p34 kernel: [51128.698087] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:05:48 p34 kernel: [51128.698089] Stack:
Sep 12 09:05:48 p34 kernel: [51128.698091]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:05:48 p34 kernel: [51128.698098]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:05:48 p34 kernel: [51128.698103]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:05:48 p34 kernel: [51128.698109] Call Trace:
Sep 12 09:05:48 p34 kernel: [51128.698116]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:05:48 p34 kernel: [51128.698120]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:05:48 p34 kernel: [51128.698127]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:05:48 p34 kernel: [51128.698132]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:05:48 p34 kernel: [51128.698136]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:05:48 p34 kernel: [51128.698140]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:05:48 p34 kernel: [51128.698145]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:05:48 p34 kernel: [51128.698149]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:05:48 p34 kernel: [51128.698153]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:05:48 p34 kernel: [51128.698160]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:05:48 p34 kernel: [51128.698163]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:05:48 p34 kernel: [51128.698168]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:05:48 p34 kernel: [51128.698169] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:05:48 p34 kernel: <44>[51128.698190]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:05:48 p34 kernel: [51128.698201] Call Trace:
Sep 12 09:05:48 p34 kernel: [51128.698205]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:05:48 p34 kernel: [51128.698210]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:05:48 p34 kernel: [51128.698214]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:05:48 p34 kernel: [51128.698218]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:05:48 p34 kernel: [51128.698222]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:05:48 p34 kernel: [51128.698225]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:05:48 p34 kernel: [51128.698231]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:05:48 p34 kernel: [51128.698236]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:05:48 p34 kernel: [51128.698239]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:05:48 p34 kernel: [51128.698243]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:05:48 p34 kernel: [51128.698247]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:05:48 p34 kernel: [51128.698251]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:06:16 p34 kernel: [51156.655778] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:06:16 p34 kernel: [51156.655783] CPU 18=20
Sep 12 09:06:16 p34 kernel: [51156.655787] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:06:16 p34 kernel: [51156.655793] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:06:16 p34 kernel: [51156.655802] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:06:16 p34 kernel: [51156.655804] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:06:16 p34 kernel: [51156.655807] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:06:16 p34 kernel: [51156.655809] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:06:16 p34 kernel: [51156.655812] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:06:16 p34 kernel: [51156.655815] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:06:16 p34 kernel: [51156.655818] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:06:16 p34 kernel: [51156.655821] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:06:16 p34 kernel: [51156.655824] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:06:16 p34 kernel: [51156.655826] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:06:16 p34 kernel: [51156.655829] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:06:16 p34 kernel: [51156.655832] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:06:16 p34 kernel: [51156.655835] Stack:
Sep 12 09:06:16 p34 kernel: [51156.655837]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:06:16 p34 kernel: [51156.655843]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:06:16 p34 kernel: [51156.655849]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:06:16 p34 kernel: [51156.655855] Call Trace:
Sep 12 09:06:16 p34 kernel: [51156.655861]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:06:16 p34 kernel: [51156.655866]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:06:16 p34 kernel: [51156.655873]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:06:16 p34 kernel: [51156.655878]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:06:16 p34 kernel: [51156.655882]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:06:16 p34 kernel: [51156.655886]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:06:16 p34 kernel: [51156.655891]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:06:16 p34 kernel: [51156.655894]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:06:16 p34 kernel: [51156.655898]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:06:16 p34 kernel: [51156.655905]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:06:16 p34 kernel: [51156.655909]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:06:16 p34 kernel: [51156.655913]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:06:16 p34 kernel: [51156.655915] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:06:16 p34 kernel: <48>[51156.655936]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:06:16 p34 kernel: [51156.655947] Call Trace:
Sep 12 09:06:16 p34 kernel: [51156.655951]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:06:16 p34 kernel: [51156.655955]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:06:16 p34 kernel: [51156.655959]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:06:16 p34 kernel: [51156.655964]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:06:16 p34 kernel: [51156.655967]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:06:16 p34 kernel: [51156.655971]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:06:16 p34 kernel: [51156.655976]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:06:16 p34 kernel: [51156.655981]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:06:16 p34 kernel: [51156.655985]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:06:16 p34 kernel: [51156.655989]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:06:16 p34 kernel: [51156.655993]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:06:16 p34 kernel: [51156.655996]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:06:24 p34 kernel: [51165.262058] INFO: task gpsd:4705 blocked for=
 more than 120 seconds.
Sep 12 09:06:24 p34 kernel: [51165.262062] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
Sep 12 09:06:24 p34 kernel: [51165.262065] gpsd            D ffff8806260378=
50     0  4705      1 0x00000000
Sep 12 09:06:24 p34 kernel: [51165.262070]  ffff880620e397d8 00000000000000=
86 0000000000000001 ffff880620e39fd8
Sep 12 09:06:24 p34 kernel: [51165.262077]  0000000000004000 ffff880620e39f=
d8 ffff8806276713a0 ffff880626037850
Sep 12 09:06:24 p34 kernel: [51165.262083]  ffff880626d2a840 00000000000000=
20 00000000000005f9 00000000000005f9
Sep 12 09:06:24 p34 kernel: [51165.262089] Call Trace:
Sep 12 09:06:24 p34 kernel: [51165.262097]  [<ffffffff81030533>] ? load_bal=
ance+0xa3/0x5c0
Sep 12 09:06:24 p34 kernel: [51165.262104]  [<ffffffff81645985>] schedule_t=
imeout+0x1a5/0x200
Sep 12 09:06:24 p34 kernel: [51165.262109]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:06:24 p34 kernel: [51165.262113]  [<ffffffff816449cd>] wait_for_c=
ommon+0xbd/0x150
Sep 12 09:06:24 p34 kernel: [51165.262117]  [<ffffffff810316a0>] ? try_to_w=
ake_up+0x260/0x260
Sep 12 09:06:24 p34 kernel: [51165.262122]  [<ffffffff81644b38>] wait_for_c=
ompletion+0x18/0x20
Sep 12 09:06:24 p34 kernel: [51165.262127]  [<ffffffff8104b939>] flush_work=
+0x29/0x40
Sep 12 09:06:24 p34 kernel: [51165.262131]  [<ffffffff81049540>] ? do_work_=
for_cpu+0x30/0x30
Sep 12 09:06:24 p34 kernel: [51165.262137]  [<ffffffff813157c0>] tty_flush_=
to_ldisc+0x10/0x20
Sep 12 09:06:24 p34 kernel: [51165.262141]  [<ffffffff8130fc8f>] n_tty_poll=
+0x5f/0x1d0
Sep 12 09:06:24 p34 kernel: [51165.262145]  [<ffffffff8130bb4a>] tty_poll+0=
x8a/0xa0
Sep 12 09:06:24 p34 kernel: [51165.262150]  [<ffffffff810ccd02>] do_select+=
0x3a2/0x6d0
Sep 12 09:06:24 p34 kernel: [51165.262154]  [<ffffffff810cc4f0>] ? poll_sel=
ect_copy_remaining+0x140/0x140
Sep 12 09:06:24 p34 kernel: [51165.262158]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:06:24 p34 kernel: [51165.262161]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:06:24 p34 kernel: [51165.262164]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:06:24 p34 kernel: [51165.262167]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:06:24 p34 kernel: [51165.262171]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:06:24 p34 kernel: [51165.262178]  [<ffffffff812a382e>] ? radix_tr=
ee_lookup_slot+0xe/0x10
Sep 12 09:06:24 p34 kernel: [51165.262182]  [<ffffffff8107a178>] ? find_get=
_page+0x28/0xd0
Sep 12 09:06:24 p34 kernel: [51165.262186]  [<ffffffff8107a417>] ? filemap_=
fault+0x87/0x470
Sep 12 09:06:24 p34 kernel: [51165.262191]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:06:24 p34 kernel: [51165.262195]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:06:24 p34 kernel: [51165.262198]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:06:24 p34 kernel: [51165.262202]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:06:24 p34 kernel: [51165.262206]  [<ffffffff810cd230>] core_sys_s=
elect+0x200/0x2f0
Sep 12 09:06:24 p34 kernel: [51165.262210]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:06:24 p34 kernel: [51165.262214]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:06:24 p34 kernel: [51165.262218]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:06:24 p34 kernel: [51165.262222]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:06:24 p34 kernel: [51165.262225]  [<ffffffff810cd3d6>] sys_select=
+0xb6/0x100
Sep 12 09:06:24 p34 kernel: [51165.262229]  [<ffffffff816478bb>] system_cal=
l_fastpath+0x16/0x1b
Sep 12 09:06:44 p34 kernel: [51184.613523] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:06:44 p34 kernel: [51184.613528] CPU 18=20
Sep 12 09:06:44 p34 kernel: [51184.613532] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:06:44 p34 kernel: [51184.613538] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:06:44 p34 kernel: [51184.613547] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:06:44 p34 kernel: [51184.613549] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:06:44 p34 kernel: [51184.613552] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:06:44 p34 kernel: [51184.613555] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:06:44 p34 kernel: [51184.613557] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:06:44 p34 kernel: [51184.613560] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:06:44 p34 kernel: [51184.613563] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:06:44 p34 kernel: [51184.613566] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:06:44 p34 kernel: [51184.613569] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:06:44 p34 kernel: [51184.613571] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:06:44 p34 kernel: [51184.613574] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:06:44 p34 kernel: [51184.613577] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:06:44 p34 kernel: [51184.613580] Stack:
Sep 12 09:06:44 p34 kernel: [51184.613582]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:06:44 p34 kernel: [51184.613588]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:06:44 p34 kernel: [51184.613594]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:06:44 p34 kernel: [51184.613600] Call Trace:
Sep 12 09:06:44 p34 kernel: [51184.613606]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:06:44 p34 kernel: [51184.613611]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:06:44 p34 kernel: [51184.613618]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:06:44 p34 kernel: [51184.613623]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:06:44 p34 kernel: [51184.613627]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:06:44 p34 kernel: [51184.613630]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:06:44 p34 kernel: [51184.613636]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:06:44 p34 kernel: [51184.613639]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:06:44 p34 kernel: [51184.613643]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:06:44 p34 kernel: [51184.613650]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:06:44 p34 kernel: [51184.613654]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:06:44 p34 kernel: [51184.613658]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:06:44 p34 kernel: [51184.613660] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:06:44 p34 kernel: <44>[51184.613681]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:06:44 p34 kernel: [51184.613692] Call Trace:
Sep 12 09:06:44 p34 kernel: [51184.613696]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:06:44 p34 kernel: [51184.613700]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:06:44 p34 kernel: [51184.613704]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:06:44 p34 kernel: [51184.613709]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:06:44 p34 kernel: [51184.613712]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:06:44 p34 kernel: [51184.613716]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:06:44 p34 kernel: [51184.613720]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:06:44 p34 kernel: [51184.613725]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:06:44 p34 kernel: [51184.613729]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:06:44 p34 kernel: [51184.613734]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:06:44 p34 kernel: [51184.613737]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:06:44 p34 kernel: [51184.613741]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:07:12 p34 kernel: [51212.571270] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:07:12 p34 kernel: [51212.571275] CPU 18=20
Sep 12 09:07:12 p34 kernel: [51212.571279] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:12 p34 kernel: [51212.571285] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:07:12 p34 kernel: [51212.571294] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:07:12 p34 kernel: [51212.571296] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:07:12 p34 kernel: [51212.571299] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:07:12 p34 kernel: [51212.571302] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:07:12 p34 kernel: [51212.571304] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:07:12 p34 kernel: [51212.571307] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:07:12 p34 kernel: [51212.571310] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:07:12 p34 kernel: [51212.571313] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:12 p34 kernel: [51212.571316] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:12 p34 kernel: [51212.571318] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:12 p34 kernel: [51212.571321] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:12 p34 kernel: [51212.571324] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:07:12 p34 kernel: [51212.571327] Stack:
Sep 12 09:07:12 p34 kernel: [51212.571329]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:07:12 p34 kernel: [51212.571335]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:07:12 p34 kernel: [51212.571341]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:07:12 p34 kernel: [51212.571347] Call Trace:
Sep 12 09:07:12 p34 kernel: [51212.571354]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:07:12 p34 kernel: [51212.571358]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:07:12 p34 kernel: [51212.571365]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:07:12 p34 kernel: [51212.571370]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:07:12 p34 kernel: [51212.571374]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:07:12 p34 kernel: [51212.571378]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:07:12 p34 kernel: [51212.571383]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:07:12 p34 kernel: [51212.571387]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:07:12 p34 kernel: [51212.571390]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:07:12 p34 kernel: [51212.571397]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:07:12 p34 kernel: [51212.571401]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:07:12 p34 kernel: [51212.571405]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:07:12 p34 kernel: [51212.571407] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:07:12 p34 kernel: <48>[51212.571428]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:07:12 p34 kernel: [51212.571439] Call Trace:
Sep 12 09:07:12 p34 kernel: [51212.571443]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:07:12 p34 kernel: [51212.571447]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:07:12 p34 kernel: [51212.571451]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:07:12 p34 kernel: [51212.571456]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:07:12 p34 kernel: [51212.571459]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:07:12 p34 kernel: [51212.571463]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:07:12 p34 kernel: [51212.571468]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:07:12 p34 kernel: [51212.571473]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:07:12 p34 kernel: [51212.571477]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:07:12 p34 kernel: [51212.571481]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:07:12 p34 kernel: [51212.571484]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:07:12 p34 kernel: [51212.571488]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:07:40 p34 kernel: [51240.529015] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:07:40 p34 kernel: [51240.529019] CPU 18=20
Sep 12 09:07:40 p34 kernel: [51240.529024] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:40 p34 kernel: [51240.529029] RIP: 0010:[<ffffffff8107a981>]  =
[<ffffffff8107a981>] find_get_pages+0x61/0x150
Sep 12 09:07:40 p34 kernel: [51240.529038] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:07:40 p34 kernel: [51240.529041] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:07:40 p34 kernel: [51240.529044] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:07:40 p34 kernel: [51240.529046] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:07:40 p34 kernel: [51240.529049] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:07:40 p34 kernel: [51240.529052] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:07:40 p34 kernel: [51240.529055] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:07:40 p34 kernel: [51240.529058] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:40 p34 kernel: [51240.529060] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:40 p34 kernel: [51240.529063] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:40 p34 kernel: [51240.529066] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:40 p34 kernel: [51240.529069] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:07:40 p34 kernel: [51240.529071] Stack:
Sep 12 09:07:40 p34 kernel: [51240.529073]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:07:40 p34 kernel: [51240.529080]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:07:40 p34 kernel: [51240.529085]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:07:40 p34 kernel: [51240.529091] Call Trace:
Sep 12 09:07:40 p34 kernel: [51240.529098]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:07:40 p34 kernel: [51240.529103]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:07:40 p34 kernel: [51240.529110]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:07:40 p34 kernel: [51240.529115]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:07:40 p34 kernel: [51240.529118]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:07:40 p34 kernel: [51240.529122]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:07:40 p34 kernel: [51240.529127]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:07:40 p34 kernel: [51240.529131]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:07:40 p34 kernel: [51240.529135]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:07:40 p34 kernel: [51240.529142]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:07:40 p34 kernel: [51240.529146]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:07:40 p34 kernel: [51240.529150]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:07:40 p34 kernel: [51240.529152] Code: 89 ea e8 33 95 22 00 85 c0=
 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b 07 48 8b 38 48 85=
 ff 74 5b 40 f6 c7 01 75 7a=20
Sep 12 09:07:40 p34 kernel: <48>[51240.529173]  63 83 44 e0 ff ff a9 00 ff =
ff 07 0f 85 8d 00 00 00 44 8b 47=20
Sep 12 09:07:40 p34 kernel: [51240.529184] Call Trace:
Sep 12 09:07:40 p34 kernel: [51240.529188]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:07:40 p34 kernel: [51240.529192]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:07:40 p34 kernel: [51240.529196]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:07:40 p34 kernel: [51240.529200]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:07:40 p34 kernel: [51240.529204]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:07:40 p34 kernel: [51240.529207]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:07:40 p34 kernel: [51240.529212]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:07:40 p34 kernel: [51240.529218]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:07:40 p34 kernel: [51240.529221]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:07:40 p34 kernel: [51240.529225]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:07:40 p34 kernel: [51240.529229]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:07:40 p34 kernel: [51240.529233]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:07:53 p34 kernel: [51253.342847] INFO: rcu_sched_state detected s=
tall on CPU 18 (t=3D420060 jiffies)
Sep 12 09:07:53 p34 kernel: [51253.342853] sending NMI to all CPUs:
Sep 12 09:07:53 p34 kernel: [51253.342897] NMI backtrace for cpu 0
Sep 12 09:07:53 p34 kernel: [51253.342902] CPU 0=20
Sep 12 09:07:53 p34 kernel: [51253.342907] Pid: 0, comm: swapper Not tainte=
d 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.342912] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.342922] RSP: 0018:ffffffff81a01eb8  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.342924] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.342927] RDX: 0000000000000000 RSI: fffff=
fff81a01fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.342930] RBP: ffffffff81a01f08 R08: 00000=
000fffffffc R09: 00000000000003a7
Sep 12 09:07:53 p34 kernel: [51253.342933] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.342935] R13: 1242c706c827dbeb R14: fffff=
fffffffffff R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.342939] FS:  0000000000000000(0000) GS:f=
fff88063fc00000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.342942] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.342944] CR2: 0000000002342da8 CR3: 00000=
00001a43000 CR4: 00000000000006f0
Sep 12 09:07:53 p34 kernel: [51253.342947] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.342949] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.342953] Process swapper (pid: 0, threadi=
nfo ffffffff81a00000, task ffffffff81a4b020)
Sep 12 09:07:53 p34 kernel: [51253.342955] Stack:
Sep 12 09:07:53 p34 kernel: [51253.342957]  ffffffff81a01f08 ffffffff814e7d=
92 0000000000000000 00000000000e48df
Sep 12 09:07:53 p34 kernel: [51253.342963]  0000000000000000 00000000000e48=
df ffff88063fc16170 ffff88063fc16170
Sep 12 09:07:53 p34 kernel: [51253.342969]  ffff88063fc162a0 ffff880c3ffdf8=
00 ffffffff81a01f28 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.342975] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.342981]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.342986]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.342991]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.342996]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:07:53 p34 kernel: [51253.343002]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:07:53 p34 kernel: [51253.343007]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:07:53 p34 kernel: [51253.343011]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:07:53 p34 kernel: [51253.343013] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.343044] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343048]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343052]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343056]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343059]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:07:53 p34 kernel: [51253.343063]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:07:53 p34 kernel: [51253.343068]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:07:53 p34 kernel: [51253.343072]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:07:53 p34 kernel: [51253.343076] NMI backtrace for cpu 1
Sep 12 09:07:53 p34 kernel: [51253.343079] CPU 1=20
Sep 12 09:07:53 p34 kernel: [51253.343083] Pid: 0, comm: kworker/0:0 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.343090] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.343098] RSP: 0018:ffff8806275b1e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.343102] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.343107] RDX: 0000000000000000 RSI: ffff8=
806275b1fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.343113] RBP: ffff8806275b1ee8 R08: 00000=
000fffffffc R09: 0000000000000386
Sep 12 09:07:53 p34 kernel: [51253.343117] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.343122] R13: 1242c706c8376bd4 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343128] FS:  0000000000000000(0000) GS:f=
fff88063fc20000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343133] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.343138] CR2: 0000049520002000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.343142] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343147] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.343152] Process kworker/0:0 (pid: 0, thr=
eadinfo ffff8806275b0000, task ffff8806275ab1e0)
Sep 12 09:07:53 p34 kernel: [51253.343157] Stack:
Sep 12 09:07:53 p34 kernel: [51253.343159]  ffff8806275b1ee8 ffffffff814e7d=
92 0000000000000000 00000000000dfd94
Sep 12 09:07:53 p34 kernel: [51253.343169]  0000000000000000 00000001000dfd=
94 ffff88063fc36170 ffff88063fc36170
Sep 12 09:07:53 p34 kernel: [51253.343179]  ffff88063fc362a0 00000000000000=
00 ffff8806275b1f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.343190] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343196]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343203]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343209]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343218]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343222] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.343274] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343279]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343286]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343292]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343298]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343304] NMI backtrace for cpu 2
Sep 12 09:07:53 p34 kernel: [51253.343308] CPU 2=20
Sep 12 09:07:53 p34 kernel: [51253.343313] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.343322] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.343332] RSP: 0018:ffff8806275c3e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.343336] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.343341] RDX: 0000000000000000 RSI: ffff8=
806275c3fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.343346] RBP: ffff8806275c3ee8 R08: 00000=
000fffffffc R09: 00000000000003a3
Sep 12 09:07:53 p34 kernel: [51253.343351] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.343355] R13: 1242c706c83643a7 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343358] FS:  0000000000000000(0000) GS:f=
fff88063fc40000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343362] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.343366] CR2: 00007f952e86d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.343371] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343376] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.343381] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275c2000, task ffff8806275bb220)
Sep 12 09:07:53 p34 kernel: [51253.343386] Stack:
Sep 12 09:07:53 p34 kernel: [51253.343389]  ffff8806275c3ee8 ffffffff814e7d=
92 0000000000000000 00000000000f231e
Sep 12 09:07:53 p34 kernel: [51253.343399]  0000000000000000 00000002000f23=
1e ffff88063fc56170 ffff88063fc56170
Sep 12 09:07:53 p34 kernel: [51253.343409]  ffff88063fc562a0 00000000000000=
00 ffff8806275c3f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.343419] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343425]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343432]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343438]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343446]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343450] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.343496] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343501]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343505]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343510]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343515]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343521] NMI backtrace for cpu 3
Sep 12 09:07:53 p34 kernel: [51253.343525] CPU 3=20
Sep 12 09:07:53 p34 kernel: [51253.343529] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.343536] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.343544] RSP: 0018:ffff8806275d7e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.343548] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.343553] RDX: 0000000000000000 RSI: ffff8=
806275d7fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.343558] RBP: ffff8806275d7ee8 R08: 00000=
000fffffffc R09: 0000000000000383
Sep 12 09:07:53 p34 kernel: [51253.343563] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.343567] R13: 1242c706c836fd5b R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343573] FS:  0000000000000000(0000) GS:f=
fff88063fc60000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343578] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.343582] CR2: 00007f60c35ed658 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.343587] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343591] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.343597] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275d6000, task ffff8806275cf260)
Sep 12 09:07:53 p34 kernel: [51253.343601] Stack:
Sep 12 09:07:53 p34 kernel: [51253.343603]  ffff8806275d7ee8 ffffffff814e7d=
92 0000000000000000 00000000000e6780
Sep 12 09:07:53 p34 kernel: [51253.343611]  0000000000000000 00000003000e67=
80 ffff88063fc76170 ffff88063fc76170
Sep 12 09:07:53 p34 kernel: [51253.343617]  ffff88063fc762a0 00000000000000=
00 ffff8806275d7f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.343624] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343630]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343637]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343643]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343650]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343654] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.343701] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343707]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343712]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343718]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343724]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343730] NMI backtrace for cpu 4
Sep 12 09:07:53 p34 kernel: [51253.343734] CPU 4=20
Sep 12 09:07:53 p34 kernel: [51253.343739] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.343746] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.343755] RSP: 0018:ffff88062760be98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.343759] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.343764] RDX: 0000000000000000 RSI: ffff8=
8062760bfd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.343767] RBP: ffff88062760bee8 R08: 00000=
000fffffffc R09: 0000000000000381
Sep 12 09:07:53 p34 kernel: [51253.343769] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.343772] R13: 1242c706c836f38a R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343775] FS:  0000000000000000(0000) GS:f=
fff88063fc80000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343778] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.343781] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.343784] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343786] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.343789] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062760a000, task ffff8806276052a0)
Sep 12 09:07:53 p34 kernel: [51253.343792] Stack:
Sep 12 09:07:53 p34 kernel: [51253.343793]  ffff88062760bee8 ffffffff814e7d=
92 0000000000000000 00000000000e7315
Sep 12 09:07:53 p34 kernel: [51253.343799]  0000000000000000 00000004000e73=
15 ffff88063fc96170 ffff88063fc96170
Sep 12 09:07:53 p34 kernel: [51253.343805]  ffff88063fc962a0 00000000000000=
00 ffff88062760bf08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.343811] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343816]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343820]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343826]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343832]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343836] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.343875] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343879]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.343885]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.343890]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.343896]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.343901] NMI backtrace for cpu 5
Sep 12 09:07:53 p34 kernel: [51253.343905] CPU 5=20
Sep 12 09:07:53 p34 kernel: [51253.343910] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.343917] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.343927] RSP: 0018:ffff88062761de98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.343931] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.343935] RDX: 0000000000000000 RSI: ffff8=
8062761dfd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.343940] RBP: ffff88062761dee8 R08: 00000=
000fffffffc R09: 0000000000000383
Sep 12 09:07:53 p34 kernel: [51253.343944] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.343949] R13: 1242c706c8375dd0 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343954] FS:  0000000000000000(0000) GS:f=
fff88063fca0000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343959] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.343963] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.343966] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.343969] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.343972] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062761c000, task ffff8806276192e0)
Sep 12 09:07:53 p34 kernel: [51253.343974] Stack:
Sep 12 09:07:53 p34 kernel: [51253.343976]  ffff88062761dee8 ffffffff814e7d=
92 0000000000000000 00000000000e09dd
Sep 12 09:07:53 p34 kernel: [51253.343982]  0000000000000000 00000005000e09=
dd ffff88063fcb6170 ffff88063fcb6170
Sep 12 09:07:53 p34 kernel: [51253.343988]  ffff88063fcb62a0 00000000000000=
00 ffff88062761df08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.343993] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.343998]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.344004]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.344010]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.344016]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.344020] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.344065] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.344070]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.344076]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.344081]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.344086]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.344089] NMI backtrace for cpu 6
Sep 12 09:07:53 p34 kernel: [51253.344093] CPU 6=20
Sep 12 09:07:53 p34 kernel: [51253.344098] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.344104] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.344117] RSP: 0018:ffff880627625e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.344125] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.344135] RDX: 0000000000000000 RSI: ffff8=
80627625fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.344145] RBP: ffff880627625ee8 R08: 00000=
000fffffffd R09: 00000000000003dd
Sep 12 09:07:53 p34 kernel: [51253.344155] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.344164] R13: 1242c706c83641bd R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344174] FS:  0000000000000000(0000) GS:f=
fff880c3fc00000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344184] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.344193] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.344203] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344212] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.344223] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627624000, task ffff880627618780)
Sep 12 09:07:53 p34 kernel: [51253.344233] Stack:
Sep 12 09:07:53 p34 kernel: [51253.344236]  ffff880627625ee8 ffffffff814e7d=
92 0000000000000000 00000000000f2320
Sep 12 09:07:53 p34 kernel: [51253.344259]  0000000000000000 00000006000f23=
20 ffff880c3fc16170 ffff880c3fc16170
Sep 12 09:07:53 p34 kernel: [51253.344278]  ffff880c3fc16240 00000000000000=
00 ffff880627625f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.344299] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.344311]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.344323]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.344333]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.344347]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.344354] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.344440] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.344447]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.344458]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.344469]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.344481]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.344492] NMI backtrace for cpu 7
Sep 12 09:07:53 p34 kernel: [51253.344498] CPU 7=20
Sep 12 09:07:53 p34 kernel: [51253.344505] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.344515] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.344527] RSP: 0018:ffff88062762fe98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.344533] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.344539] RDX: 0000000000000000 RSI: ffff8=
8062762ffd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.344544] RBP: ffff88062762fee8 R08: 00000=
000fffffffc R09: 0000000000000384
Sep 12 09:07:53 p34 kernel: [51253.344549] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.344555] R13: 1242c706c836f920 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344562] FS:  0000000000000000(0000) GS:f=
fff880c3fc20000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344570] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.344575] CR2: 00007f8f297df000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.344580] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344585] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.344591] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062762e000, task ffff88062762d8d0)
Sep 12 09:07:53 p34 kernel: [51253.344597] Stack:
Sep 12 09:07:53 p34 kernel: [51253.344599]  ffff88062762fee8 ffffffff814e7d=
92 0000000000000000 00000000000e6ce6
Sep 12 09:07:53 p34 kernel: [51253.344612]  0000000000000000 00000007000e6c=
e6 ffff880c3fc36170 ffff880c3fc36170
Sep 12 09:07:53 p34 kernel: [51253.344624]  ffff880c3fc362a0 00000000000000=
00 ffff88062762ff08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.344637] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.344646]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.344654]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.344661]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.344669]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.344674] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.344736] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.344742]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.344748]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.344755]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.344762]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.344769] NMI backtrace for cpu 8
Sep 12 09:07:53 p34 kernel: [51253.344775] CPU 8=20
Sep 12 09:07:53 p34 kernel: [51253.344782] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.344792] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.344804] RSP: 0018:ffff880627635e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.344810] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.344815] RDX: 0000000000000000 RSI: ffff8=
80627635fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.344821] RBP: ffff880627635ee8 R08: 00000=
000fffffffc R09: 00000000000003a1
Sep 12 09:07:53 p34 kernel: [51253.344826] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.344830] R13: 1242c706c837003f R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344837] FS:  0000000000000000(0000) GS:f=
fff880c3fc40000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344844] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.344848] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.344856] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.344863] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.344869] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627634000, task ffff88062762cd70)
Sep 12 09:07:53 p34 kernel: [51253.344875] Stack:
Sep 12 09:07:53 p34 kernel: [51253.344877]  ffff880627635ee8 ffffffff814e7d=
92 0000000000000000 00000000000e6705
Sep 12 09:07:53 p34 kernel: [51253.344890]  0000000000000000 00000008000e67=
05 ffff880c3fc56170 ffff880c3fc56170
Sep 12 09:07:53 p34 kernel: [51253.344902]  ffff880c3fc562a0 00000000000000=
00 ffff880627635f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.344915] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.344922]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.344929]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.344936]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.344944]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.344949] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.345015] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345021]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345029]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345036]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345043]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345050] NMI backtrace for cpu 9
Sep 12 09:07:53 p34 kernel: [51253.345056] CPU 9=20
Sep 12 09:07:53 p34 kernel: [51253.345063] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.345071] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.345083] RSP: 0018:ffff88062763de98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.345088] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.345094] RDX: 0000000000000000 RSI: ffff8=
8062763dfd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.345100] RBP: ffff88062763dee8 R08: 00000=
000fffffffc R09: 0000000000000384
Sep 12 09:07:53 p34 kernel: [51253.345106] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.345111] R13: 1242c706c8370864 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345117] FS:  0000000000000000(0000) GS:f=
fff880c3fc60000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345123] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.345128] CR2: 00007f8f297df000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.345134] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345139] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.345144] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062763c000, task ffff88062762c210)
Sep 12 09:07:53 p34 kernel: [51253.345150] Stack:
Sep 12 09:07:53 p34 kernel: [51253.345152]  ffff88062763dee8 ffffffff814e7d=
92 0000000000000000 00000000000e5ca4
Sep 12 09:07:53 p34 kernel: [51253.345163]  0000000000000000 00000009000e5c=
a4 ffff880c3fc76170 ffff880c3fc76170
Sep 12 09:07:53 p34 kernel: [51253.345174]  ffff880c3fc762a0 00000000000000=
00 ffff88062763df08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.345187] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345193]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345200]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345207]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345215]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345220] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.345288] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345295]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345302]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345309]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345316]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345323] NMI backtrace for cpu 10
Sep 12 09:07:53 p34 kernel: [51253.345329] CPU 10=20
Sep 12 09:07:53 p34 kernel: [51253.345336] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.345346] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.345358] RSP: 0018:ffff880627665e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.345363] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.345369] RDX: 0000000000000000 RSI: ffff8=
80627665fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.345376] RBP: ffff880627665ee8 R08: 00000=
000fffffffd R09: 00000000000003a2
Sep 12 09:07:53 p34 kernel: [51253.345381] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.345386] R13: 1242c706c8371f54 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345392] FS:  0000000000000000(0000) GS:f=
fff880c3fc80000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345399] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.345404] CR2: 000016a96601f000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.345410] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345415] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.345418] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627664000, task ffff88062763f360)
Sep 12 09:07:53 p34 kernel: [51253.345421] Stack:
Sep 12 09:07:53 p34 kernel: [51253.345422]  ffff880627665ee8 ffffffff814e7d=
92 0000000000000000 00000000000e45f2
Sep 12 09:07:53 p34 kernel: [51253.345428]  0000000000000000 0000000a000e45=
f2 ffff880c3fc96170 ffff880c3fc96170
Sep 12 09:07:53 p34 kernel: [51253.345434]  ffff880c3fc96240 00000000000000=
00 ffff880627665f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.345439] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345444]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345449]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345455]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345460]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345465] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.345524] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345529]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345537]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345543]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345550]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345557] NMI backtrace for cpu 11
Sep 12 09:07:53 p34 kernel: [51253.345563] CPU 11=20
Sep 12 09:07:53 p34 kernel: [51253.345569] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.345578] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.345589] RSP: 0018:ffff88062766be98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.345594] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.345599] RDX: 0000000000000000 RSI: ffff8=
8062766bfd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.345605] RBP: ffff88062766bee8 R08: 00000=
000fffffffc R09: 00000000000003ac
Sep 12 09:07:53 p34 kernel: [51253.345607] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.345610] R13: 1242c706c8461114 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345613] FS:  0000000000000000(0000) GS:f=
fff880c3fca0000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345616] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.345619] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.345621] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345624] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.345627] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062766a000, task ffff88062763e800)
Sep 12 09:07:53 p34 kernel: [51253.345630] Stack:
Sep 12 09:07:53 p34 kernel: [51253.345631]  ffff88062766bee8 ffffffff814e7d=
92 0000000000000000 00000000000e96ae
Sep 12 09:07:53 p34 kernel: [51253.345637]  0000000000000000 0000000b000e96=
ae ffff880c3fcb6170 ffff880c3fcb6170
Sep 12 09:07:53 p34 kernel: [51253.345643]  ffff880c3fcb62a0 00000000000000=
00 ffff88062766bf08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.345652] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345660]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345668]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345674]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345681]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345687] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.345752] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345758]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345766]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345773]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345780]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345788] NMI backtrace for cpu 12
Sep 12 09:07:53 p34 kernel: [51253.345792] CPU 12=20
Sep 12 09:07:53 p34 kernel: [51253.345796] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.345803] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.345811] RSP: 0018:ffff88062767fe98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.345815] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.345819] RDX: 0000000000000000 RSI: ffff8=
8062767ffd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.345823] RBP: ffff88062767fee8 R08: 00000=
000fffffffc R09: 00000000000003af
Sep 12 09:07:53 p34 kernel: [51253.345827] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.345830] R13: 1242c706c8458b23 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345835] FS:  0000000000000000(0000) GS:f=
fff88063fcc0000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345839] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.345843] CR2: 00007feb8d11d520 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.345846] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.345850] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.345855] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062767e000, task ffff880627670840)
Sep 12 09:07:53 p34 kernel: [51253.345858] Stack:
Sep 12 09:07:53 p34 kernel: [51253.345860]  ffff88062767fee8 ffffffff814e7d=
92 0000000000000000 00000000000f1da7
Sep 12 09:07:53 p34 kernel: [51253.345870]  0000000000000000 0000000c000f1d=
a7 ffff88063fcd6170 ffff88063fcd6170
Sep 12 09:07:53 p34 kernel: [51253.345880]  ffff88063fcd62a0 00000000000000=
00 ffff88062767ff08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.345888] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345895]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345901]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345907]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345914]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345917] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.345964] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.345970]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.345976]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.345981]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.345987]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.345992] NMI backtrace for cpu 13
Sep 12 09:07:53 p34 kernel: [51253.345997] CPU 13=20
Sep 12 09:07:53 p34 kernel: [51253.346003] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.346011] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.346023] RSP: 0018:ffff880627693e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.346029] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.346035] RDX: 0000000000000000 RSI: ffff8=
80627693fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.346042] RBP: ffff880627693ee8 R08: 00000=
000fffffffc R09: 0000000000000394
Sep 12 09:07:53 p34 kernel: [51253.346048] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.346054] R13: 1242c706c84587b1 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346059] FS:  0000000000000000(0000) GS:f=
fff88063fce0000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346064] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.346068] CR2: 000000000217b388 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.346073] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346076] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.346079] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627692000, task ffff880627684880)
Sep 12 09:07:53 p34 kernel: [51253.346081] Stack:
Sep 12 09:07:53 p34 kernel: [51253.346083]  ffff880627693ee8 ffffffff814e7d=
92 0000000000000000 00000000000f2124
Sep 12 09:07:53 p34 kernel: [51253.346089]  0000000000000000 0000000d000f21=
24 ffff88063fcf6170 ffff88063fcf6170
Sep 12 09:07:53 p34 kernel: [51253.346095]  ffff88063fcf62a0 00000000000000=
00 ffff880627693f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.346100] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346105]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346109]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346115]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346120]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346125] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.346181] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346187]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346195]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346202]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346210]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346217] NMI backtrace for cpu 14
Sep 12 09:07:53 p34 kernel: [51253.346221] CPU 14=20
Sep 12 09:07:53 p34 kernel: [51253.346224] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.346231] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.346240] RSP: 0018:ffff8806276c5e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.346243] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.346248] RDX: 0000000000000000 RSI: ffff8=
806276c5fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.346252] RBP: ffff8806276c5ee8 R08: 00000=
000fffffffd R09: 000000000000023e
Sep 12 09:07:53 p34 kernel: [51253.346257] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.346260] R13: 1242c706c8458d58 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346265] FS:  0000000000000000(0000) GS:f=
fff88063fd00000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346270] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.346274] CR2: 00007f952e86e000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.346278] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346282] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.346286] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276c4000, task ffff8806276968c0)
Sep 12 09:07:53 p34 kernel: [51253.346291] Stack:
Sep 12 09:07:53 p34 kernel: [51253.346292]  ffff8806276c5ee8 ffffffff814e7d=
92 0000000000000000 00000000000f1b23
Sep 12 09:07:53 p34 kernel: [51253.346301]  0000000000000000 0000000e000f1b=
23 ffff88063fd16170 ffff88063fd16170
Sep 12 09:07:53 p34 kernel: [51253.346308]  ffff88063fd16240 00000000000000=
00 ffff8806276c5f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.346315] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346320]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346326]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346332]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346338]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346342] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.346393] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346401]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346409]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346417]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346425]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346431] NMI backtrace for cpu 15
Sep 12 09:07:53 p34 kernel: [51253.346435] CPU 15=20
Sep 12 09:07:53 p34 kernel: [51253.346439] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.346445] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.346454] RSP: 0018:ffff8806276d9e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.346457] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.346461] RDX: 0000000000000000 RSI: ffff8=
806276d9fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.346466] RBP: ffff8806276d9ee8 R08: 00000=
000fffffffd R09: 00000000000003b1
Sep 12 09:07:53 p34 kernel: [51253.346470] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.346474] R13: 1242c706c8462552 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346478] FS:  0000000000000000(0000) GS:f=
fff88063fd20000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346483] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.346487] CR2: 00007f0148804000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.346491] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346495] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.346500] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276d8000, task ffff8806276ca900)
Sep 12 09:07:53 p34 kernel: [51253.346503] Stack:
Sep 12 09:07:53 p34 kernel: [51253.346505]  ffff8806276d9ee8 ffffffff814e7d=
92 0000000000000000 00000000000e857f
Sep 12 09:07:53 p34 kernel: [51253.346513]  0000000000000000 0000000f000e85=
7f ffff88063fd36170 ffff88063fd36170
Sep 12 09:07:53 p34 kernel: [51253.346520]  ffff88063fd36240 00000000000000=
00 ffff8806276d9f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.346526] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346532]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346538]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346541]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346546]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346548] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.346580] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346584]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346590]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346595]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346601]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346606] NMI backtrace for cpu 16
Sep 12 09:07:53 p34 kernel: [51253.346610] CPU 16=20
Sep 12 09:07:53 p34 kernel: [51253.346614] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.346621] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.346630] RSP: 0018:ffff8806276ede98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.346633] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.346638] RDX: 0000000000000000 RSI: ffff8=
806276edfd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.346641] RBP: ffff8806276edee8 R08: 00000=
000fffffffd R09: 00000000000003b2
Sep 12 09:07:53 p34 kernel: [51253.346646] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.346649] R13: 1242c706c84590c8 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346654] FS:  0000000000000000(0000) GS:f=
fff88063fd40000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346658] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.346661] CR2: 00007f20554d3e02 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.346665] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346669] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.346673] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276ec000, task ffff8806276de600)
Sep 12 09:07:53 p34 kernel: [51253.346678] Stack:
Sep 12 09:07:53 p34 kernel: [51253.346679]  ffff8806276edee8 ffffffff814e7d=
92 0000000000000000 00000000000f1803
Sep 12 09:07:53 p34 kernel: [51253.346688]  0000000000000000 00000010000f18=
03 ffff88063fd56170 ffff88063fd56170
Sep 12 09:07:53 p34 kernel: [51253.346696]  ffff88063fd56240 00000000000000=
00 ffff8806276edf08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.346703] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346709]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346714]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346720]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346725]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346727] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.346758] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346762]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346768]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346772]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346778]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346784] NMI backtrace for cpu 17
Sep 12 09:07:53 p34 kernel: [51253.346788] CPU 17=20
Sep 12 09:07:53 p34 kernel: [51253.346792] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.346799] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.346808] RSP: 0018:ffff88062771de98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.346811] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.346815] RDX: 0000000000000000 RSI: ffff8=
8062771dfd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.346819] RBP: ffff88062771dee8 R08: 00000=
000fffffffd R09: 0000000000000398
Sep 12 09:07:53 p34 kernel: [51253.346824] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.346828] R13: 1242c706c84590ff R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346833] FS:  0000000000000000(0000) GS:f=
fff88063fd60000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346838] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.346841] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.346845] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.346850] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.346855] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062771c000, task ffff8806276f0640)
Sep 12 09:07:53 p34 kernel: [51253.346859] Stack:
Sep 12 09:07:53 p34 kernel: [51253.346861]  ffff88062771dee8 ffffffff814e7d=
92 0000000000000000 00000000000f16f5
Sep 12 09:07:53 p34 kernel: [51253.346868]  0000000000000000 00000011000f16=
f5 ffff88063fd76170 ffff88063fd76170
Sep 12 09:07:53 p34 kernel: [51253.346875]  ffff88063fd76240 00000000000000=
00 ffff88062771df08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.346882] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346887]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346894]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346899]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346906]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346909] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.346950] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.346954]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.346959]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.346964]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.346970]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.346975] NMI backtrace for cpu 18
Sep 12 09:07:53 p34 kernel: [51253.346979] CPU 18=20
Sep 12 09:07:53 p34 kernel: [51253.346983] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.346993] RIP: 0010:[<ffffffff812a87e3>]  =
[<ffffffff812a87e3>] delay_tsc+0x13/0x60
Sep 12 09:07:53 p34 kernel: [51253.347003] RSP: 0018:ffff880c3fcc3d58  EFLA=
GS: 00000807
Sep 12 09:07:53 p34 kernel: [51253.347007] RAX: 000000000705ee40 RBX: 00000=
000000003e9 RCX: 0000000000000023
Sep 12 09:07:53 p34 kernel: [51253.347012] RDX: 000000000003a97c RSI: 00000=
00000000018 RDI: 000000000003a97d
Sep 12 09:07:53 p34 kernel: [51253.347016] RBP: ffff880c3fcc3d58 R08: 00000=
00000000012 R09: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347021] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000001000
Sep 12 09:07:53 p34 kernel: [51253.347025] R13: ffffffff81aa8d50 R14: 00000=
00000000400 R15: 0000000000000092
Sep 12 09:07:53 p34 kernel: [51253.347030] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347037] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.347042] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.347047] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347050] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.347056] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:07:53 p34 kernel: [51253.347061] Stack:
Sep 12 09:07:53 p34 kernel: [51253.347063]  ffff880c3fcc3d68 ffffffff812a88=
5a ffff880c3fcc3d78 ffffffff812a8887
Sep 12 09:07:53 p34 kernel: [51253.347074]  ffff880c3fcc3d98 ffffffff81019c=
3a 0000000000000002 000000000000c502
Sep 12 09:07:53 p34 kernel: [51253.347084]  ffff880c3fcc3de8 ffffffff8101a8=
e8 7fffffff00000023 0000000000000013
Sep 12 09:07:53 p34 kernel: [51253.347095] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.347096]  <IRQ>=20
Sep 12 09:07:53 p34 kernel: [51253.347102]  [<ffffffff812a885a>] __delay+0x=
a/0x10
Sep 12 09:07:53 p34 kernel: [51253.347108]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:07:53 p34 kernel: [51253.347117]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:07:53 p34 kernel: [51253.347126]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:07:53 p34 kernel: [51253.347136]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:07:53 p34 kernel: [51253.347143]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:07:53 p34 kernel: [51253.347152]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:07:53 p34 kernel: [51253.347160]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:07:53 p34 kernel: [51253.347170]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:07:53 p34 kernel: [51253.347176]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:07:53 p34 kernel: [51253.347182]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:07:53 p34 kernel: [51253.347187]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:07:53 p34 kernel: [51253.347190]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:07:53 p34 kernel: [51253.347196]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:07:53 p34 kernel: [51253.347198]  <EOI>=20
Sep 12 09:07:53 p34 kernel: [51253.347203]  [<ffffffff8107a981>] ? find_get=
_pages+0x61/0x150
Sep 12 09:07:53 p34 kernel: [51253.347209]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:07:53 p34 kernel: [51253.347213]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:07:53 p34 kernel: [51253.347220]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:07:53 p34 kernel: [51253.347225]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:07:53 p34 kernel: [51253.347228]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:07:53 p34 kernel: [51253.347234]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:07:53 p34 kernel: [51253.347239]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:07:53 p34 kernel: [51253.347246]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:07:53 p34 kernel: [51253.347253]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:07:53 p34 kernel: [51253.347260]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:07:53 p34 kernel: [51253.347267]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:07:53 p34 kernel: [51253.347274]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:07:53 p34 kernel: [51253.347278] Code: 0f 1f 84 00 00 00 00 00 48=
 ff c8 75 fb 48 ff c8 5d c3 66 0f 1f 44 00 00 55 65 44 8b 04 25 f0 c4 00 00=
 48 89 e5 0f 1f 00 0f ae e8 <0f> 31 89 c6 eb 16 0f 1f 80 00 00 00 00 f3 90 =
65 8b 0c 25 f0 c4=20
Sep 12 09:07:53 p34 kernel: [51253.347330] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.347331]  <IRQ>  [<ffffffff812a885a>] __d=
elay+0xa/0x10
Sep 12 09:07:53 p34 kernel: [51253.347342]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:07:53 p34 kernel: [51253.347349]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:07:53 p34 kernel: [51253.347357]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:07:53 p34 kernel: [51253.347365]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:07:53 p34 kernel: [51253.347372]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:07:53 p34 kernel: [51253.347379]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:07:53 p34 kernel: [51253.347386]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:07:53 p34 kernel: [51253.347390]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:07:53 p34 kernel: [51253.347394]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:07:53 p34 kernel: [51253.347398]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:07:53 p34 kernel: [51253.347402]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:07:53 p34 kernel: [51253.347406]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:07:53 p34 kernel: [51253.347412]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:07:53 p34 kernel: [51253.347417]  <EOI>  [<ffffffff8107a981>] ? f=
ind_get_pages+0x61/0x150
Sep 12 09:07:53 p34 kernel: [51253.347427]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:07:53 p34 kernel: [51253.347435]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:07:53 p34 kernel: [51253.347442]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:07:53 p34 kernel: [51253.347450]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:07:53 p34 kernel: [51253.347456]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:07:53 p34 kernel: [51253.347463]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:07:53 p34 kernel: [51253.347470]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:07:53 p34 kernel: [51253.347476]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:07:53 p34 kernel: [51253.347482]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:07:53 p34 kernel: [51253.347489]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:07:53 p34 kernel: [51253.347496]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:07:53 p34 kernel: [51253.347503]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:07:53 p34 kernel: [51253.347646] NMI backtrace for cpu 19
Sep 12 09:07:53 p34 kernel: [51253.347650] CPU 19=20
Sep 12 09:07:53 p34 kernel: [51253.347655] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.347664] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.347676] RSP: 0018:ffff88062772fe98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.347681] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.347686] RDX: 0000000000000000 RSI: ffff8=
8062772ffd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.347690] RBP: ffff88062772fee8 R08: 00000=
000fffffffd R09: 00000000000003b3
Sep 12 09:07:53 p34 kernel: [51253.347694] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.347700] R13: 1242c706c873f382 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347705] FS:  0000000000000000(0000) GS:f=
fff880c3fce0000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347711] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.347715] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.347718] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347720] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.347723] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062772e000, task ffff880627724c30)
Sep 12 09:07:53 p34 kernel: [51253.347725] Stack:
Sep 12 09:07:53 p34 kernel: [51253.347727]  ffff88062772fee8 ffffffff814e7d=
92 0000000000000000 00000000000e7bdc
Sep 12 09:07:53 p34 kernel: [51253.347733]  0000000000000000 00000013000e7b=
dc ffff880c3fcf6170 ffff880c3fcf6170
Sep 12 09:07:53 p34 kernel: [51253.347739]  ffff880c3fcf6240 00000000000000=
00 ffff88062772ff08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.347744] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.347749]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.347753]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.347757]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.347762]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.347764] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.347814] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.347819]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.347823]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.347827]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.347831]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.347835] NMI backtrace for cpu 20
Sep 12 09:07:53 p34 kernel: [51253.347839] CPU 20=20
Sep 12 09:07:53 p34 kernel: [51253.347843] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.347849] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.347857] RSP: 0018:ffff880627735e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.347859] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.347862] RDX: 0000000000000000 RSI: ffff8=
80627735fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.347865] RBP: ffff880627735ee8 R08: 00000=
000fffffffc R09: 00000000000003ac
Sep 12 09:07:53 p34 kernel: [51253.347867] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.347870] R13: 1242c706c873fca1 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347873] FS:  0000000000000000(0000) GS:f=
fff880c3fd00000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347876] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.347879] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.347881] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.347884] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.347887] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627734000, task ffff8806277240d0)
Sep 12 09:07:53 p34 kernel: [51253.347890] Stack:
Sep 12 09:07:53 p34 kernel: [51253.347891]  ffff880627735ee8 ffffffff814e7d=
92 0000000000000000 00000000000e72d8
Sep 12 09:07:53 p34 kernel: [51253.347898]  0000000000000000 00000014000e72=
d8 ffff880c3fd16170 ffff880c3fd16170
Sep 12 09:07:53 p34 kernel: [51253.347903]  ffff880c3fd162a0 00000000000000=
00 ffff880627735f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.347909] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.347914]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.347918]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.347922]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.347927]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.347929] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.347982] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.347988]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.347995]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.348002]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.348009]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.348016] NMI backtrace for cpu 21
Sep 12 09:07:53 p34 kernel: [51253.348021] CPU 21=20
Sep 12 09:07:53 p34 kernel: [51253.348025] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.348030] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.348037] RSP: 0018:ffff88062773fe98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.348039] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.348042] RDX: 0000000000000000 RSI: ffff8=
8062773ffd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.348045] RBP: ffff88062773fee8 R08: 00000=
000fffffffc R09: 00000000000003b0
Sep 12 09:07:53 p34 kernel: [51253.348047] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:07:53 p34 kernel: [51253.348050] R13: 1242c706c874037c R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348053] FS:  0000000000000000(0000) GS:f=
fff880c3fd20000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348056] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.348059] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.348062] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348064] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.348067] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062773e000, task ffff880627739220)
Sep 12 09:07:53 p34 kernel: [51253.348070] Stack:
Sep 12 09:07:53 p34 kernel: [51253.348071]  ffff88062773fee8 ffffffff814e7d=
92 0000000000000000 00000000000e6c57
Sep 12 09:07:53 p34 kernel: [51253.348077]  0000000000000000 00000015000e6c=
57 ffff880c3fd36170 ffff880c3fd36170
Sep 12 09:07:53 p34 kernel: [51253.348083]  ffff880c3fd362a0 00000000000000=
00 ffff88062773ff08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.348090] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.348098]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.348106]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.348113]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.348121]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.348123] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.348157] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.348163]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.348170]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.348177]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.348184]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.348191] NMI backtrace for cpu 22
Sep 12 09:07:53 p34 kernel: [51253.348197] CPU 22=20
Sep 12 09:07:53 p34 kernel: [51253.348202] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.348212] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.348223] RSP: 0018:ffff880627747e98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.348228] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.348232] RDX: 0000000000000000 RSI: ffff8=
80627747fd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.348237] RBP: ffff880627747ee8 R08: 00000=
000fffffffd R09: 00000000000003af
Sep 12 09:07:53 p34 kernel: [51253.348241] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.348246] R13: 1242c706c8744b31 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348251] FS:  0000000000000000(0000) GS:f=
fff880c3fd40000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348258] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.348263] CR2: 00007fa1ebd0d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.348267] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348272] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.348278] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627746000, task ffff8806277386c0)
Sep 12 09:07:53 p34 kernel: [51253.348282] Stack:
Sep 12 09:07:53 p34 kernel: [51253.348284]  ffff880627747ee8 ffffffff814e7d=
92 0000000000000000 00000000000e25d1
Sep 12 09:07:53 p34 kernel: [51253.348295]  0000000000000000 00000016000e25=
d1 ffff880c3fd56170 ffff880c3fd56170
Sep 12 09:07:53 p34 kernel: [51253.348305]  ffff880c3fd56240 00000000000000=
00 ffff880627747f08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.348315] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.348322]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.348329]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.348336]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.348344]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.348349] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.348405] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.348412]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.348419]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.348425]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.348432]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.348439] NMI backtrace for cpu 23
Sep 12 09:07:53 p34 kernel: [51253.348445] CPU 23=20
Sep 12 09:07:53 p34 kernel: [51253.348450] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:07:53 p34 kernel: [51253.348459] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:07:53 p34 kernel: [51253.348469] RSP: 0018:ffff88062774fe98  EFLA=
GS: 00000046
Sep 12 09:07:53 p34 kernel: [51253.348473] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:07:53 p34 kernel: [51253.348478] RDX: 0000000000000000 RSI: ffff8=
8062774ffd8 RDI: ffffffff81a4d300
Sep 12 09:07:53 p34 kernel: [51253.348483] RBP: ffff88062774fee8 R08: 00000=
000fffffffd R09: 00000000000003b4
Sep 12 09:07:53 p34 kernel: [51253.348488] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:07:53 p34 kernel: [51253.348493] R13: 1242c706c883e8d0 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348497] FS:  0000000000000000(0000) GS:f=
fff880c3fd60000(0000) knlGS:0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348501] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:07:53 p34 kernel: [51253.348503] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:07:53 p34 kernel: [51253.348506] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:07:53 p34 kernel: [51253.348509] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:07:53 p34 kernel: [51253.348512] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062774e000, task ffff88062774d810)
Sep 12 09:07:53 p34 kernel: [51253.348514] Stack:
Sep 12 09:07:53 p34 kernel: [51253.348515]  ffff88062774fee8 ffffffff814e7d=
92 0000000000000000 00000000000dc970
Sep 12 09:07:53 p34 kernel: [51253.348521]  0000000000000000 00000017000dc9=
70 ffff880c3fd76170 ffff880c3fd76170
Sep 12 09:07:53 p34 kernel: [51253.348527]  ffff880c3fd76240 00000000000000=
00 ffff88062774ff08 ffffffff814e6bb6
Sep 12 09:07:53 p34 kernel: [51253.348532] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.348537]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.348544]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.348549]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.348555]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:07:53 p34 kernel: [51253.348559] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:07:53 p34 kernel: [51253.348611] Call Trace:
Sep 12 09:07:53 p34 kernel: [51253.348615]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:07:53 p34 kernel: [51253.348619]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:07:53 p34 kernel: [51253.348622]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:07:53 p34 kernel: [51253.348626]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:08:20 p34 kernel: [51280.468652] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:08:20 p34 kernel: [51280.468657] CPU 18=20
Sep 12 09:08:20 p34 kernel: [51280.468661] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:08:20 p34 kernel: [51280.468667] RIP: 0010:[<ffffffff8107a97b>]  =
[<ffffffff8107a97b>] find_get_pages+0x5b/0x150
Sep 12 09:08:20 p34 kernel: [51280.468676] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000286
Sep 12 09:08:20 p34 kernel: [51280.468678] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:08:20 p34 kernel: [51280.468681] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:08:20 p34 kernel: [51280.468683] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:08:20 p34 kernel: [51280.468686] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:08:20 p34 kernel: [51280.468689] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:08:20 p34 kernel: [51280.468692] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:08:20 p34 kernel: [51280.468695] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:08:20 p34 kernel: [51280.468698] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:08:20 p34 kernel: [51280.468700] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:08:20 p34 kernel: [51280.468703] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:08:20 p34 kernel: [51280.468706] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:08:20 p34 kernel: [51280.468709] Stack:
Sep 12 09:08:20 p34 kernel: [51280.468710]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:08:20 p34 kernel: [51280.468717]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:08:20 p34 kernel: [51280.468722]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:08:20 p34 kernel: [51280.468728] Call Trace:
Sep 12 09:08:20 p34 kernel: [51280.468735]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:08:20 p34 kernel: [51280.468740]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:08:20 p34 kernel: [51280.468747]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:08:20 p34 kernel: [51280.468751]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:08:20 p34 kernel: [51280.468755]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:08:20 p34 kernel: [51280.468759]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:08:20 p34 kernel: [51280.468764]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:08:20 p34 kernel: [51280.468768]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:08:20 p34 kernel: [51280.468772]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:08:20 p34 kernel: [51280.468779]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:08:20 p34 kernel: [51280.468783]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:08:20 p34 kernel: [51280.468787]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:08:20 p34 kernel: [51280.468788] Code: 89 e6 44 89 f1 4c 89 ea e8=
 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b=
 07 48 8b 38 48 85 ff 74 5b=20
Sep 12 09:08:20 p34 kernel: <40>[51280.468810]  f6 c7 01 75 7a 48 63 83 44 =
e0 ff ff a9 00 ff ff 07 0f 85 8d=20
Sep 12 09:08:20 p34 kernel: [51280.468820] Call Trace:
Sep 12 09:08:20 p34 kernel: [51280.468824]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:08:20 p34 kernel: [51280.468829]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:08:20 p34 kernel: [51280.468833]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:08:20 p34 kernel: [51280.468837]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:08:20 p34 kernel: [51280.468841]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:08:20 p34 kernel: [51280.468844]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:08:20 p34 kernel: [51280.468849]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:08:20 p34 kernel: [51280.468854]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:08:20 p34 kernel: [51280.468858]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:08:20 p34 kernel: [51280.468862]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:08:20 p34 kernel: [51280.468865]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:08:20 p34 kernel: [51280.468869]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:08:24 p34 kernel: [51285.080960] INFO: task gpsd:4705 blocked for=
 more than 120 seconds.
Sep 12 09:08:24 p34 kernel: [51285.080964] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
Sep 12 09:08:24 p34 kernel: [51285.080967] gpsd            D ffff8806260378=
50     0  4705      1 0x00000000
Sep 12 09:08:24 p34 kernel: [51285.080973]  ffff880620e397d8 00000000000000=
86 0000000000000001 ffff880620e39fd8
Sep 12 09:08:24 p34 kernel: [51285.080979]  0000000000004000 ffff880620e39f=
d8 ffff8806276713a0 ffff880626037850
Sep 12 09:08:24 p34 kernel: [51285.080985]  ffff880626d2a840 00000000000000=
20 00000000000005f9 00000000000005f9
Sep 12 09:08:24 p34 kernel: [51285.080991] Call Trace:
Sep 12 09:08:24 p34 kernel: [51285.080999]  [<ffffffff81030533>] ? load_bal=
ance+0xa3/0x5c0
Sep 12 09:08:24 p34 kernel: [51285.081006]  [<ffffffff81645985>] schedule_t=
imeout+0x1a5/0x200
Sep 12 09:08:24 p34 kernel: [51285.081010]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:08:24 p34 kernel: [51285.081015]  [<ffffffff816449cd>] wait_for_c=
ommon+0xbd/0x150
Sep 12 09:08:24 p34 kernel: [51285.081019]  [<ffffffff810316a0>] ? try_to_w=
ake_up+0x260/0x260
Sep 12 09:08:24 p34 kernel: [51285.081023]  [<ffffffff81644b38>] wait_for_c=
ompletion+0x18/0x20
Sep 12 09:08:24 p34 kernel: [51285.081028]  [<ffffffff8104b939>] flush_work=
+0x29/0x40
Sep 12 09:08:24 p34 kernel: [51285.081033]  [<ffffffff81049540>] ? do_work_=
for_cpu+0x30/0x30
Sep 12 09:08:24 p34 kernel: [51285.081039]  [<ffffffff813157c0>] tty_flush_=
to_ldisc+0x10/0x20
Sep 12 09:08:24 p34 kernel: [51285.081043]  [<ffffffff8130fc8f>] n_tty_poll=
+0x5f/0x1d0
Sep 12 09:08:24 p34 kernel: [51285.081047]  [<ffffffff8130bb4a>] tty_poll+0=
x8a/0xa0
Sep 12 09:08:24 p34 kernel: [51285.081051]  [<ffffffff810ccd02>] do_select+=
0x3a2/0x6d0
Sep 12 09:08:24 p34 kernel: [51285.081055]  [<ffffffff810cc4f0>] ? poll_sel=
ect_copy_remaining+0x140/0x140
Sep 12 09:08:24 p34 kernel: [51285.081059]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:08:24 p34 kernel: [51285.081062]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:08:24 p34 kernel: [51285.081065]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:08:24 p34 kernel: [51285.081068]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:08:24 p34 kernel: [51285.081072]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:08:24 p34 kernel: [51285.081079]  [<ffffffff812a382e>] ? radix_tr=
ee_lookup_slot+0xe/0x10
Sep 12 09:08:24 p34 kernel: [51285.081083]  [<ffffffff8107a178>] ? find_get=
_page+0x28/0xd0
Sep 12 09:08:24 p34 kernel: [51285.081087]  [<ffffffff8107a417>] ? filemap_=
fault+0x87/0x470
Sep 12 09:08:24 p34 kernel: [51285.081092]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:08:24 p34 kernel: [51285.081096]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:08:24 p34 kernel: [51285.081099]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:08:24 p34 kernel: [51285.081103]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:08:24 p34 kernel: [51285.081107]  [<ffffffff810cd230>] core_sys_s=
elect+0x200/0x2f0
Sep 12 09:08:24 p34 kernel: [51285.081111]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:08:24 p34 kernel: [51285.081115]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:08:24 p34 kernel: [51285.081119]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:08:24 p34 kernel: [51285.081122]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:08:24 p34 kernel: [51285.081126]  [<ffffffff810cd3d6>] sys_select=
+0xb6/0x100
Sep 12 09:08:24 p34 kernel: [51285.081130]  [<ffffffff816478bb>] system_cal=
l_fastpath+0x16/0x1b
Sep 12 09:08:48 p34 kernel: [51308.426398] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:08:48 p34 kernel: [51308.426402] CPU 18=20
Sep 12 09:08:48 p34 kernel: [51308.426407] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:08:48 p34 kernel: [51308.426412] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:08:48 p34 kernel: [51308.426421] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:08:48 p34 kernel: [51308.426424] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:08:48 p34 kernel: [51308.426426] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:08:48 p34 kernel: [51308.426429] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:08:48 p34 kernel: [51308.426432] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:08:48 p34 kernel: [51308.426435] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:08:48 p34 kernel: [51308.426438] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:08:48 p34 kernel: [51308.426441] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:08:48 p34 kernel: [51308.426443] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:08:48 p34 kernel: [51308.426446] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:08:48 p34 kernel: [51308.426449] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:08:48 p34 kernel: [51308.426452] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:08:48 p34 kernel: [51308.426454] Stack:
Sep 12 09:08:48 p34 kernel: [51308.426456]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:08:48 p34 kernel: [51308.426463]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:08:48 p34 kernel: [51308.426468]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:08:48 p34 kernel: [51308.426474] Call Trace:
Sep 12 09:08:48 p34 kernel: [51308.426481]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:08:48 p34 kernel: [51308.426486]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:08:48 p34 kernel: [51308.426492]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:08:48 p34 kernel: [51308.426497]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:08:48 p34 kernel: [51308.426501]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:08:48 p34 kernel: [51308.426505]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:08:48 p34 kernel: [51308.426510]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:08:48 p34 kernel: [51308.426514]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:08:48 p34 kernel: [51308.426518]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:08:48 p34 kernel: [51308.426525]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:08:48 p34 kernel: [51308.426529]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:08:48 p34 kernel: [51308.426533]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:08:48 p34 kernel: [51308.426534] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:08:48 p34 kernel: <44>[51308.426556]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:08:48 p34 kernel: [51308.426566] Call Trace:
Sep 12 09:08:48 p34 kernel: [51308.426570]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:08:48 p34 kernel: [51308.426575]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:08:48 p34 kernel: [51308.426579]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:08:48 p34 kernel: [51308.426583]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:08:48 p34 kernel: [51308.426587]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:08:48 p34 kernel: [51308.426590]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:08:48 p34 kernel: [51308.426595]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:08:48 p34 kernel: [51308.426601]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:08:48 p34 kernel: [51308.426604]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:08:48 p34 kernel: [51308.426608]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:08:48 p34 kernel: [51308.426612]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:08:48 p34 kernel: [51308.426616]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:09:16 p34 kernel: [51336.384144] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:09:16 p34 kernel: [51336.384148] CPU 18=20
Sep 12 09:09:16 p34 kernel: [51336.384153] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:09:16 p34 kernel: [51336.384158] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:09:16 p34 kernel: [51336.384167] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:09:16 p34 kernel: [51336.384170] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:09:16 p34 kernel: [51336.384172] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:09:16 p34 kernel: [51336.384175] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:09:16 p34 kernel: [51336.384178] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:09:16 p34 kernel: [51336.384180] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:09:16 p34 kernel: [51336.384184] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:09:16 p34 kernel: [51336.384187] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:09:16 p34 kernel: [51336.384189] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:09:16 p34 kernel: [51336.384192] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:09:16 p34 kernel: [51336.384195] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:09:16 p34 kernel: [51336.384198] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:09:16 p34 kernel: [51336.384200] Stack:
Sep 12 09:09:16 p34 kernel: [51336.384202]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:09:16 p34 kernel: [51336.384209]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:09:16 p34 kernel: [51336.384214]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:09:16 p34 kernel: [51336.384220] Call Trace:
Sep 12 09:09:16 p34 kernel: [51336.384227]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:09:16 p34 kernel: [51336.384231]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:09:16 p34 kernel: [51336.384238]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:09:16 p34 kernel: [51336.384243]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:09:16 p34 kernel: [51336.384247]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:09:16 p34 kernel: [51336.384251]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:09:16 p34 kernel: [51336.384256]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:09:16 p34 kernel: [51336.384260]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:09:16 p34 kernel: [51336.384264]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:09:16 p34 kernel: [51336.384271]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:09:16 p34 kernel: [51336.384274]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:09:16 p34 kernel: [51336.384278]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:09:16 p34 kernel: [51336.384280] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:09:16 p34 kernel: <44>[51336.384301]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:09:16 p34 kernel: [51336.384312] Call Trace:
Sep 12 09:09:16 p34 kernel: [51336.384316]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:09:16 p34 kernel: [51336.384320]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:09:16 p34 kernel: [51336.384325]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:09:16 p34 kernel: [51336.384329]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:09:16 p34 kernel: [51336.384332]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:09:16 p34 kernel: [51336.384336]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:09:16 p34 kernel: [51336.384341]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:09:16 p34 kernel: [51336.384346]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:09:16 p34 kernel: [51336.384350]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:09:16 p34 kernel: [51336.384354]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:09:16 p34 kernel: [51336.384358]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:09:16 p34 kernel: [51336.384362]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:09:44 p34 kernel: [51364.341889] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:09:44 p34 kernel: [51364.341894] CPU 18=20
Sep 12 09:09:44 p34 kernel: [51364.341898] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:09:44 p34 kernel: [51364.341903] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:09:44 p34 kernel: [51364.341912] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:09:44 p34 kernel: [51364.341915] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:09:44 p34 kernel: [51364.341918] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:09:44 p34 kernel: [51364.341920] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:09:44 p34 kernel: [51364.341923] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:09:44 p34 kernel: [51364.341926] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:09:44 p34 kernel: [51364.341929] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:09:44 p34 kernel: [51364.341932] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:09:44 p34 kernel: [51364.341935] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:09:44 p34 kernel: [51364.341937] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:09:44 p34 kernel: [51364.341940] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:09:44 p34 kernel: [51364.341943] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:09:44 p34 kernel: [51364.341946] Stack:
Sep 12 09:09:44 p34 kernel: [51364.341947]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:09:44 p34 kernel: [51364.341954]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:09:44 p34 kernel: [51364.341960]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:09:44 p34 kernel: [51364.341965] Call Trace:
Sep 12 09:09:44 p34 kernel: [51364.341972]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:09:44 p34 kernel: [51364.341977]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:09:44 p34 kernel: [51364.341984]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:09:44 p34 kernel: [51364.341988]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:09:44 p34 kernel: [51364.341992]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:09:44 p34 kernel: [51364.341996]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:09:44 p34 kernel: [51364.342002]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:09:44 p34 kernel: [51364.342005]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:09:44 p34 kernel: [51364.342009]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:09:44 p34 kernel: [51364.342016]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:09:44 p34 kernel: [51364.342020]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:09:44 p34 kernel: [51364.342024]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:09:44 p34 kernel: [51364.342026] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:09:44 p34 kernel: <44>[51364.342047]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:09:44 p34 kernel: [51364.342058] Call Trace:
Sep 12 09:09:44 p34 kernel: [51364.342062]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:09:44 p34 kernel: [51364.342066]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:09:44 p34 kernel: [51364.342071]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:09:44 p34 kernel: [51364.342075]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:09:44 p34 kernel: [51364.342078]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:09:44 p34 kernel: [51364.342082]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:09:44 p34 kernel: [51364.342087]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:09:44 p34 kernel: [51364.342092]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:09:44 p34 kernel: [51364.342096]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:09:44 p34 kernel: [51364.342100]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:09:44 p34 kernel: [51364.342104]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:09:44 p34 kernel: [51364.342108]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:10:12 p34 kernel: [51392.299636] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:10:12 p34 kernel: [51392.299641] CPU 18=20
Sep 12 09:10:12 p34 kernel: [51392.299645] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:12 p34 kernel: [51392.299650] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:10:12 p34 kernel: [51392.299659] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:10:12 p34 kernel: [51392.299662] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:10:12 p34 kernel: [51392.299664] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:10:12 p34 kernel: [51392.299667] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:10:12 p34 kernel: [51392.299670] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:10:12 p34 kernel: [51392.299673] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:10:12 p34 kernel: [51392.299676] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:10:12 p34 kernel: [51392.299679] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:12 p34 kernel: [51392.299681] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:12 p34 kernel: [51392.299684] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:12 p34 kernel: [51392.299687] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:12 p34 kernel: [51392.299690] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:10:12 p34 kernel: [51392.299692] Stack:
Sep 12 09:10:12 p34 kernel: [51392.299694]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:10:12 p34 kernel: [51392.299701]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:10:12 p34 kernel: [51392.299706]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:10:12 p34 kernel: [51392.299712] Call Trace:
Sep 12 09:10:12 p34 kernel: [51392.299719]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:10:12 p34 kernel: [51392.299724]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:10:12 p34 kernel: [51392.299731]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:10:12 p34 kernel: [51392.299735]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:10:12 p34 kernel: [51392.299739]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:10:12 p34 kernel: [51392.299743]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:10:12 p34 kernel: [51392.299748]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:10:12 p34 kernel: [51392.299752]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:10:12 p34 kernel: [51392.299756]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:10:12 p34 kernel: [51392.299763]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:10:12 p34 kernel: [51392.299767]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:10:12 p34 kernel: [51392.299771]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:10:12 p34 kernel: [51392.299772] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:10:12 p34 kernel: <48>[51392.299794]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:10:12 p34 kernel: [51392.299805] Call Trace:
Sep 12 09:10:12 p34 kernel: [51392.299809]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:10:12 p34 kernel: [51392.299813]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:10:12 p34 kernel: [51392.299817]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:10:12 p34 kernel: [51392.299822]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:10:12 p34 kernel: [51392.299825]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:10:12 p34 kernel: [51392.299829]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:10:12 p34 kernel: [51392.299834]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:10:12 p34 kernel: [51392.299839]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:10:12 p34 kernel: [51392.299843]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:10:12 p34 kernel: [51392.299847]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:10:12 p34 kernel: [51392.299850]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:10:12 p34 kernel: [51392.299854]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:10:24 p34 kernel: [51404.899914] INFO: task gpsd:4705 blocked for=
 more than 120 seconds.
Sep 12 09:10:24 p34 kernel: [51404.899918] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
Sep 12 09:10:24 p34 kernel: [51404.899921] gpsd            D ffff8806260378=
50     0  4705      1 0x00000000
Sep 12 09:10:24 p34 kernel: [51404.899926]  ffff880620e397d8 00000000000000=
86 0000000000000001 ffff880620e39fd8
Sep 12 09:10:24 p34 kernel: [51404.899933]  0000000000004000 ffff880620e39f=
d8 ffff8806276713a0 ffff880626037850
Sep 12 09:10:24 p34 kernel: [51404.899939]  ffff880626d2a840 00000000000000=
20 00000000000005f9 00000000000005f9
Sep 12 09:10:24 p34 kernel: [51404.899945] Call Trace:
Sep 12 09:10:24 p34 kernel: [51404.899953]  [<ffffffff81030533>] ? load_bal=
ance+0xa3/0x5c0
Sep 12 09:10:24 p34 kernel: [51404.899961]  [<ffffffff81645985>] schedule_t=
imeout+0x1a5/0x200
Sep 12 09:10:24 p34 kernel: [51404.899965]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:10:24 p34 kernel: [51404.899969]  [<ffffffff816449cd>] wait_for_c=
ommon+0xbd/0x150
Sep 12 09:10:24 p34 kernel: [51404.899973]  [<ffffffff810316a0>] ? try_to_w=
ake_up+0x260/0x260
Sep 12 09:10:24 p34 kernel: [51404.899978]  [<ffffffff81644b38>] wait_for_c=
ompletion+0x18/0x20
Sep 12 09:10:24 p34 kernel: [51404.899983]  [<ffffffff8104b939>] flush_work=
+0x29/0x40
Sep 12 09:10:24 p34 kernel: [51404.899988]  [<ffffffff81049540>] ? do_work_=
for_cpu+0x30/0x30
Sep 12 09:10:24 p34 kernel: [51404.899993]  [<ffffffff813157c0>] tty_flush_=
to_ldisc+0x10/0x20
Sep 12 09:10:24 p34 kernel: [51404.899998]  [<ffffffff8130fc8f>] n_tty_poll=
+0x5f/0x1d0
Sep 12 09:10:24 p34 kernel: [51404.900001]  [<ffffffff8130bb4a>] tty_poll+0=
x8a/0xa0
Sep 12 09:10:24 p34 kernel: [51404.900006]  [<ffffffff810ccd02>] do_select+=
0x3a2/0x6d0
Sep 12 09:10:24 p34 kernel: [51404.900010]  [<ffffffff810cc4f0>] ? poll_sel=
ect_copy_remaining+0x140/0x140
Sep 12 09:10:24 p34 kernel: [51404.900013]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:10:24 p34 kernel: [51404.900017]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:10:24 p34 kernel: [51404.900020]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:10:24 p34 kernel: [51404.900023]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:10:24 p34 kernel: [51404.900027]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:10:24 p34 kernel: [51404.900033]  [<ffffffff812a382e>] ? radix_tr=
ee_lookup_slot+0xe/0x10
Sep 12 09:10:24 p34 kernel: [51404.900038]  [<ffffffff8107a178>] ? find_get=
_page+0x28/0xd0
Sep 12 09:10:24 p34 kernel: [51404.900041]  [<ffffffff8107a417>] ? filemap_=
fault+0x87/0x470
Sep 12 09:10:24 p34 kernel: [51404.900046]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:10:24 p34 kernel: [51404.900050]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:10:24 p34 kernel: [51404.900054]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:10:24 p34 kernel: [51404.900058]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:10:24 p34 kernel: [51404.900062]  [<ffffffff810cd230>] core_sys_s=
elect+0x200/0x2f0
Sep 12 09:10:24 p34 kernel: [51404.900066]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:10:24 p34 kernel: [51404.900070]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:10:24 p34 kernel: [51404.900074]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:10:24 p34 kernel: [51404.900077]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:10:24 p34 kernel: [51404.900081]  [<ffffffff810cd3d6>] sys_select=
+0xb6/0x100
Sep 12 09:10:24 p34 kernel: [51404.900085]  [<ffffffff816478bb>] system_cal=
l_fastpath+0x16/0x1b
Sep 12 09:10:40 p34 kernel: [51420.257381] BUG: soft lockup - CPU#18 stuck =
for 22s! [kswapd1:1045]
Sep 12 09:10:40 p34 kernel: [51420.257386] CPU 18=20
Sep 12 09:10:40 p34 kernel: [51420.257390] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:40 p34 kernel: [51420.257395] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:10:40 p34 kernel: [51420.257405] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:10:40 p34 kernel: [51420.257407] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:10:40 p34 kernel: [51420.257410] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:10:40 p34 kernel: [51420.257413] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:10:40 p34 kernel: [51420.257415] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:10:40 p34 kernel: [51420.257418] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:10:40 p34 kernel: [51420.257421] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:10:40 p34 kernel: [51420.257424] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:40 p34 kernel: [51420.257427] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:40 p34 kernel: [51420.257430] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:40 p34 kernel: [51420.257432] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:40 p34 kernel: [51420.257435] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:10:40 p34 kernel: [51420.257438] Stack:
Sep 12 09:10:40 p34 kernel: [51420.257440]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:10:40 p34 kernel: [51420.257446]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:10:40 p34 kernel: [51420.257452]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:10:40 p34 kernel: [51420.257457] Call Trace:
Sep 12 09:10:40 p34 kernel: [51420.257464]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:10:40 p34 kernel: [51420.257469]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:10:40 p34 kernel: [51420.257476]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:10:40 p34 kernel: [51420.257481]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:10:40 p34 kernel: [51420.257484]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:10:40 p34 kernel: [51420.257488]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:10:40 p34 kernel: [51420.257494]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:10:40 p34 kernel: [51420.257497]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:10:40 p34 kernel: [51420.257501]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:10:40 p34 kernel: [51420.257508]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:10:40 p34 kernel: [51420.257512]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:10:40 p34 kernel: [51420.257516]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:10:40 p34 kernel: [51420.257518] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:10:40 p34 kernel: <48>[51420.257539]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:10:40 p34 kernel: [51420.257550] Call Trace:
Sep 12 09:10:40 p34 kernel: [51420.257554]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:10:40 p34 kernel: [51420.257558]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:10:40 p34 kernel: [51420.257562]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:10:40 p34 kernel: [51420.257567]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:10:40 p34 kernel: [51420.257570]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:10:40 p34 kernel: [51420.257574]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:10:40 p34 kernel: [51420.257579]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:10:40 p34 kernel: [51420.257584]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:10:40 p34 kernel: [51420.257588]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:10:40 p34 kernel: [51420.257592]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:10:40 p34 kernel: [51420.257595]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:10:40 p34 kernel: [51420.257599]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:10:53 p34 kernel: [51433.101168] INFO: rcu_sched_state detected s=
tall on CPU 18 (t=3D600090 jiffies)
Sep 12 09:10:53 p34 kernel: [51433.101174] sending NMI to all CPUs:
Sep 12 09:10:53 p34 kernel: [51433.101218] NMI backtrace for cpu 0
Sep 12 09:10:53 p34 kernel: [51433.101223] CPU 0=20
Sep 12 09:10:53 p34 kernel: [51433.101228] Pid: 0, comm: swapper Not tainte=
d 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.101234] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.101244] RSP: 0018:ffffffff81a01eb8  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.101247] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.101249] RDX: 0000000000000000 RSI: fffff=
fff81a01fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.101252] RBP: ffffffff81a01f08 R08: 00000=
000fffffffd R09: 00000000000003ad
Sep 12 09:10:53 p34 kernel: [51433.101255] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.101257] R13: 1242c730b2c854f5 R14: fffff=
fffffffffff R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101261] FS:  0000000000000000(0000) GS:f=
fff88063fc00000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101264] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.101266] CR2: 00000000039a39d8 CR3: 00000=
00001a43000 CR4: 00000000000006f0
Sep 12 09:10:53 p34 kernel: [51433.101269] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101272] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.101275] Process swapper (pid: 0, threadi=
nfo ffffffff81a00000, task ffffffff81a4b020)
Sep 12 09:10:53 p34 kernel: [51433.101277] Stack:
Sep 12 09:10:53 p34 kernel: [51433.101279]  ffffffff81a01f08 ffffffff814e7d=
92 0000000000000000 00000000000d9bce
Sep 12 09:10:53 p34 kernel: [51433.101285]  0000000000000000 00000000000d9b=
ce ffff88063fc16170 ffff88063fc16170
Sep 12 09:10:53 p34 kernel: [51433.101291]  ffff88063fc16240 ffff880c3ffdf8=
00 ffffffff81a01f28 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.101297] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.101303]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.101308]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.101313]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.101318]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:10:53 p34 kernel: [51433.101324]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:10:53 p34 kernel: [51433.101329]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:10:53 p34 kernel: [51433.101333]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:10:53 p34 kernel: [51433.101335] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.101366] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.101370]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.101374]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.101378]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.101381]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:10:53 p34 kernel: [51433.101385]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:10:53 p34 kernel: [51433.101390]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:10:53 p34 kernel: [51433.101394]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:10:53 p34 kernel: [51433.101398] NMI backtrace for cpu 1
Sep 12 09:10:53 p34 kernel: [51433.101401] CPU 1=20
Sep 12 09:10:53 p34 kernel: [51433.101405] Pid: 0, comm: kworker/0:0 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.101413] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.101420] RSP: 0018:ffff8806275b1e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.101423] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.101428] RDX: 0000000000000000 RSI: ffff8=
806275b1fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.101433] RBP: ffff8806275b1ee8 R08: 00000=
000fffffffc R09: 000000000000037a
Sep 12 09:10:53 p34 kernel: [51433.101438] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.101443] R13: 1242c730b2d7434a R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101449] FS:  0000000000000000(0000) GS:f=
fff88063fc20000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101455] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.101459] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.101464] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101470] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.101475] Process kworker/0:0 (pid: 0, thr=
eadinfo ffff8806275b0000, task ffff8806275ab1e0)
Sep 12 09:10:53 p34 kernel: [51433.101480] Stack:
Sep 12 09:10:53 p34 kernel: [51433.101483]  ffff8806275b1ee8 ffffffff814e7d=
92 0000000000000000 00000000000df071
Sep 12 09:10:53 p34 kernel: [51433.101493]  0000000000000000 00000001000df0=
71 ffff88063fc36170 ffff88063fc36170
Sep 12 09:10:53 p34 kernel: [51433.101503]  ffff88063fc362a0 00000000000000=
00 ffff8806275b1f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.101513] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.101520]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.101527]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.101533]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.101542]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.101546] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.101597] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.101602]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.101609]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.101615]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.101621]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.101627] NMI backtrace for cpu 2
Sep 12 09:10:53 p34 kernel: [51433.101631] CPU 2=20
Sep 12 09:10:53 p34 kernel: [51433.101635] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.101643] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.101653] RSP: 0018:ffff8806275c3e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.101657] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.101662] RDX: 0000000000000000 RSI: ffff8=
806275c3fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.101667] RBP: ffff8806275c3ee8 R08: 00000=
000fffffffc R09: 0000000000000382
Sep 12 09:10:53 p34 kernel: [51433.101672] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.101677] R13: 1242c730b2d6dd85 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101682] FS:  0000000000000000(0000) GS:f=
fff88063fc40000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101685] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.101688] CR2: 00007f952e86d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.101693] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101698] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.101703] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275c2000, task ffff8806275bb220)
Sep 12 09:10:53 p34 kernel: [51433.101708] Stack:
Sep 12 09:10:53 p34 kernel: [51433.101710]  ffff8806275c3ee8 ffffffff814e7d=
92 0000000000000000 00000000000e52f9
Sep 12 09:10:53 p34 kernel: [51433.101720]  0000000000000000 00000002000e52=
f9 ffff88063fc56170 ffff88063fc56170
Sep 12 09:10:53 p34 kernel: [51433.101730]  ffff88063fc562a0 00000000000000=
00 ffff8806275c3f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.101740] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.101747]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.101753]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.101757]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.101765]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.101769] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.101816] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.101821]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.101827]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.101830]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.101836]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.101842] NMI backtrace for cpu 3
Sep 12 09:10:53 p34 kernel: [51433.101847] CPU 3=20
Sep 12 09:10:53 p34 kernel: [51433.101851] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.101859] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.101869] RSP: 0018:ffff8806275d7e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.101873] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.101877] RDX: 0000000000000000 RSI: ffff8=
806275d7fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.101882] RBP: ffff8806275d7ee8 R08: 00000=
000fffffffc R09: 0000000000000381
Sep 12 09:10:53 p34 kernel: [51433.101887] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.101892] R13: 1242c730b2d6eb03 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101897] FS:  0000000000000000(0000) GS:f=
fff88063fc60000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101903] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.101907] CR2: 0000000004432000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.101912] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.101916] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.101919] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275d6000, task ffff8806275cf260)
Sep 12 09:10:53 p34 kernel: [51433.101922] Stack:
Sep 12 09:10:53 p34 kernel: [51433.101923]  ffff8806275d7ee8 ffffffff814e7d=
92 0000000000000000 00000000000e50b0
Sep 12 09:10:53 p34 kernel: [51433.101929]  0000000000000000 00000003000e50=
b0 ffff88063fc76170 ffff88063fc76170
Sep 12 09:10:53 p34 kernel: [51433.101936]  ffff88063fc762a0 00000000000000=
00 ffff8806275d7f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.101946] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.101951]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.101957]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.101963]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.101970]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.101974] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.102018] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102022]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102026]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102029]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102033]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102038] NMI backtrace for cpu 4
Sep 12 09:10:53 p34 kernel: [51433.102041] CPU 4=20
Sep 12 09:10:53 p34 kernel: [51433.102044] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.102049] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.102056] RSP: 0018:ffff88062760be98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.102059] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.102061] RDX: 0000000000000000 RSI: ffff8=
8062760bfd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.102064] RBP: ffff88062760bee8 R08: 00000=
000fffffffc R09: 0000000000000383
Sep 12 09:10:53 p34 kernel: [51433.102067] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.102069] R13: 1242c730b2d73fb5 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102072] FS:  0000000000000000(0000) GS:f=
fff88063fc80000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102075] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.102078] CR2: 00007fe8e24b0520 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.102081] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102083] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.102088] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062760a000, task ffff8806276052a0)
Sep 12 09:10:53 p34 kernel: [51433.102091] Stack:
Sep 12 09:10:53 p34 kernel: [51433.102092]  ffff88062760bee8 ffffffff814e7d=
92 0000000000000000 00000000000df3cb
Sep 12 09:10:53 p34 kernel: [51433.102098]  0000000000000000 00000004000df3=
cb ffff88063fc96170 ffff88063fc96170
Sep 12 09:10:53 p34 kernel: [51433.102104]  ffff88063fc962a0 00000000000000=
00 ffff88062760bf08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.102110] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102114]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102119]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102123]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102128]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102130] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.102172] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102178]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102184]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102189]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102193]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102197] NMI backtrace for cpu 5
Sep 12 09:10:53 p34 kernel: [51433.102200] CPU 5=20
Sep 12 09:10:53 p34 kernel: [51433.102204] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.102209] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.102216] RSP: 0018:ffff88062761de98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.102218] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.102221] RDX: 0000000000000000 RSI: ffff8=
8062761dfd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.102224] RBP: ffff88062761dee8 R08: 00000=
000fffffffc R09: 0000000000000384
Sep 12 09:10:53 p34 kernel: [51433.102226] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.102229] R13: 1242c730b2d6cfc5 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102234] FS:  0000000000000000(0000) GS:f=
fff88063fca0000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102240] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.102244] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.102248] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102253] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.102259] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062761c000, task ffff8806276192e0)
Sep 12 09:10:53 p34 kernel: [51433.102263] Stack:
Sep 12 09:10:53 p34 kernel: [51433.102265]  ffff88062761dee8 ffffffff814e7d=
92 0000000000000000 00000000000e6037
Sep 12 09:10:53 p34 kernel: [51433.102274]  0000000000000000 00000005000e60=
37 ffff88063fcb6170 ffff88063fcb6170
Sep 12 09:10:53 p34 kernel: [51433.102282]  ffff88063fcb62a0 00000000000000=
00 ffff88062761df08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.102288] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102293]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102297]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102301]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102306]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102308] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.102339] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102343]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102347]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102350]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102356]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102361] NMI backtrace for cpu 6
Sep 12 09:10:53 p34 kernel: [51433.102368] CPU 6=20
Sep 12 09:10:53 p34 kernel: [51433.102376] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.102390] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.102410] RSP: 0018:ffff880627625e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.102417] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.102428] RDX: 0000000000000000 RSI: ffff8=
80627625fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.102439] RBP: ffff880627625ee8 R08: 00000=
000fffffffc R09: 00000000000003e1
Sep 12 09:10:53 p34 kernel: [51433.102447] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.102456] R13: 1242c730b2d60c75 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102467] FS:  0000000000000000(0000) GS:f=
fff880c3fc00000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102477] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.102486] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.102496] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102505] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.102516] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627624000, task ffff880627618780)
Sep 12 09:10:53 p34 kernel: [51433.102527] Stack:
Sep 12 09:10:53 p34 kernel: [51433.102530]  ffff880627625ee8 ffffffff814e7d=
92 0000000000000000 00000000000f23d4
Sep 12 09:10:53 p34 kernel: [51433.102548]  0000000000000000 00000006000f23=
d4 ffff880c3fc16170 ffff880c3fc16170
Sep 12 09:10:53 p34 kernel: [51433.102565]  ffff880c3fc162a0 00000000000000=
00 ffff880627625f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.102581] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102593]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102605]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102618]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102632]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102641] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.102733] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102741]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102752]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102762]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102772]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102783] NMI backtrace for cpu 7
Sep 12 09:10:53 p34 kernel: [51433.102789] CPU 7=20
Sep 12 09:10:53 p34 kernel: [51433.102796] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.102805] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.102817] RSP: 0018:ffff88062762fe98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.102823] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.102829] RDX: 0000000000000000 RSI: ffff8=
8062762ffd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.102834] RBP: ffff88062762fee8 R08: 00000=
000fffffffc R09: 000000000000039e
Sep 12 09:10:53 p34 kernel: [51433.102840] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.102846] R13: 1242c730b2d760d2 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102852] FS:  0000000000000000(0000) GS:f=
fff880c3fc20000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102858] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.102864] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.102869] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.102874] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.102879] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062762e000, task ffff88062762d8d0)
Sep 12 09:10:53 p34 kernel: [51433.102885] Stack:
Sep 12 09:10:53 p34 kernel: [51433.102886]  ffff88062762fee8 ffffffff814e7d=
92 0000000000000000 00000000000dd295
Sep 12 09:10:53 p34 kernel: [51433.102903]  0000000000000000 00000007000dd2=
95 ffff880c3fc36170 ffff880c3fc36170
Sep 12 09:10:53 p34 kernel: [51433.102920]  ffff880c3fc362a0 00000000000000=
00 ffff88062762ff08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.102929] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102934]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.102938]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.102942]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.102947]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.102949] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.102988] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.102995]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103001]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.103008]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.103016]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.103023] NMI backtrace for cpu 8
Sep 12 09:10:53 p34 kernel: [51433.103029] CPU 8=20
Sep 12 09:10:53 p34 kernel: [51433.103036] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.103046] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.103057] RSP: 0018:ffff880627635e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.103063] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.103069] RDX: 0000000000000000 RSI: ffff8=
80627635fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.103075] RBP: ffff880627635ee8 R08: 00000=
000fffffffc R09: 0000000000000399
Sep 12 09:10:53 p34 kernel: [51433.103080] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.103086] R13: 1242c730b2d7661d R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103092] FS:  0000000000000000(0000) GS:f=
fff880c3fc40000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103100] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.103105] CR2: 0000000002426000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.103110] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103114] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.103120] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627634000, task ffff88062762cd70)
Sep 12 09:10:53 p34 kernel: [51433.103125] Stack:
Sep 12 09:10:53 p34 kernel: [51433.103127]  ffff880627635ee8 ffffffff814e7d=
92 0000000000000000 00000000000dce9e
Sep 12 09:10:53 p34 kernel: [51433.103140]  0000000000000000 00000008000dce=
9e ffff880c3fc56170 ffff880c3fc56170
Sep 12 09:10:53 p34 kernel: [51433.103152]  ffff880c3fc562a0 00000000000000=
00 ffff880627635f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.103164] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.103171]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103178]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.103185]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.103193]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.103198] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.103257] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.103264]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103271]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.103278]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.103285]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.103293] NMI backtrace for cpu 9
Sep 12 09:10:53 p34 kernel: [51433.103298] CPU 9=20
Sep 12 09:10:53 p34 kernel: [51433.103304] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.103315] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.103327] RSP: 0018:ffff88062763de98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.103332] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.103338] RDX: 0000000000000000 RSI: ffff8=
8062763dfd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.103343] RBP: ffff88062763dee8 R08: 00000=
000fffffffc R09: 0000000000000397
Sep 12 09:10:53 p34 kernel: [51433.103349] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.103354] R13: 1242c730b2d76796 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103360] FS:  0000000000000000(0000) GS:f=
fff880c3fc60000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103366] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.103371] CR2: 00007f8f297df000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.103377] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103382] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.103388] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062763c000, task ffff88062762c210)
Sep 12 09:10:53 p34 kernel: [51433.103394] Stack:
Sep 12 09:10:53 p34 kernel: [51433.103397]  ffff88062763dee8 ffffffff814e7d=
92 0000000000000000 00000000000dcd24
Sep 12 09:10:53 p34 kernel: [51433.103412]  0000000000000000 00000009000dcd=
24 ffff880c3fc76170 ffff880c3fc76170
Sep 12 09:10:53 p34 kernel: [51433.103423]  ffff880c3fc762a0 00000000000000=
00 ffff88062763df08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.103437] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.103444]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103450]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.103458]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.103466]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.103471] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.103531] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.103537]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103544]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.103551]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.103558]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.103566] NMI backtrace for cpu 10
Sep 12 09:10:53 p34 kernel: [51433.103571] CPU 10=20
Sep 12 09:10:53 p34 kernel: [51433.103577] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.103587] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.103599] RSP: 0018:ffff880627665e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.103605] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.103611] RDX: 0000000000000000 RSI: ffff8=
80627665fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.103617] RBP: ffff880627665ee8 R08: 00000=
000fffffffc R09: 0000000000000396
Sep 12 09:10:53 p34 kernel: [51433.103622] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.103627] R13: 1242c730b2d76a89 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103634] FS:  0000000000000000(0000) GS:f=
fff880c3fc80000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103640] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.103645] CR2: 000016a966002000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.103650] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103655] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.103661] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627664000, task ffff88062763f360)
Sep 12 09:10:53 p34 kernel: [51433.103667] Stack:
Sep 12 09:10:53 p34 kernel: [51433.103669]  ffff880627665ee8 ffffffff814e7d=
92 0000000000000000 00000000000dca2a
Sep 12 09:10:53 p34 kernel: [51433.103680]  0000000000000000 0000000a000dca=
2a ffff880c3fc96170 ffff880c3fc96170
Sep 12 09:10:53 p34 kernel: [51433.103694]  ffff880c3fc962a0 00000000000000=
00 ffff880627665f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.103705] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.103712]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103719]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.103727]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.103736]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.103741] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.103810] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.103816]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103823]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.103829]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.103837]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.103844] NMI backtrace for cpu 11
Sep 12 09:10:53 p34 kernel: [51433.103850] CPU 11=20
Sep 12 09:10:53 p34 kernel: [51433.103856] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.103865] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.103877] RSP: 0018:ffff88062766be98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.103882] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.103887] RDX: 0000000000000000 RSI: ffff8=
8062766bfd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.103893] RBP: ffff88062766bee8 R08: 00000=
000fffffffc R09: 000000000000038b
Sep 12 09:10:53 p34 kernel: [51433.103898] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.103903] R13: 1242c730b2e6659c R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103909] FS:  0000000000000000(0000) GS:f=
fff880c3fca0000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103914] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.103920] CR2: 00007fa1ebd0d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.103925] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.103930] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.103935] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062766a000, task ffff88062763e800)
Sep 12 09:10:53 p34 kernel: [51433.103941] Stack:
Sep 12 09:10:53 p34 kernel: [51433.103942]  ffff88062766bee8 ffffffff814e7d=
92 0000000000000000 00000000000e1037
Sep 12 09:10:53 p34 kernel: [51433.103956]  0000000000000000 0000000b000e10=
37 ffff880c3fcb6170 ffff880c3fcb6170
Sep 12 09:10:53 p34 kernel: [51433.103968]  ffff880c3fcb62a0 00000000000000=
00 ffff88062766bf08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.103980] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.103989]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.103996]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104003]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104011]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104016] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.104079] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104085]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104092]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104099]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104107]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104114] NMI backtrace for cpu 12
Sep 12 09:10:53 p34 kernel: [51433.104118] CPU 12=20
Sep 12 09:10:53 p34 kernel: [51433.104122] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.104129] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.104137] RSP: 0018:ffff88062767fe98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.104141] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.104145] RDX: 0000000000000000 RSI: ffff8=
8062767ffd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.104149] RBP: ffff88062767fee8 R08: 00000=
000fffffffc R09: 00000000000003a8
Sep 12 09:10:53 p34 kernel: [51433.104152] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.104156] R13: 1242c730b2e5569c R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104161] FS:  0000000000000000(0000) GS:f=
fff88063fcc0000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104165] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.104169] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.104172] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104176] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.104181] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062767e000, task ffff880627670840)
Sep 12 09:10:53 p34 kernel: [51433.104184] Stack:
Sep 12 09:10:53 p34 kernel: [51433.104186]  ffff88062767fee8 ffffffff814e7d=
92 0000000000000000 00000000000f1dcf
Sep 12 09:10:53 p34 kernel: [51433.104197]  0000000000000000 0000000c000f1d=
cf ffff88063fcd6170 ffff88063fcd6170
Sep 12 09:10:53 p34 kernel: [51433.104206]  ffff88063fcd62a0 00000000000000=
00 ffff88062767ff08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.104216] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104222]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104228]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104233]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104240]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104243] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.104291] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104297]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104302]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104307]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104313]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104318] NMI backtrace for cpu 13
Sep 12 09:10:53 p34 kernel: [51433.104324] CPU 13=20
Sep 12 09:10:53 p34 kernel: [51433.104329] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.104338] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.104350] RSP: 0018:ffff880627693e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.104355] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.104361] RDX: 0000000000000000 RSI: ffff8=
80627693fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.104367] RBP: ffff880627693ee8 R08: 00000=
000fffffffd R09: 0000000000000391
Sep 12 09:10:53 p34 kernel: [51433.104374] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.104380] R13: 1242c730b2e5577f R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104388] FS:  0000000000000000(0000) GS:f=
fff88063fce0000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104395] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.104400] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.104406] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104411] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.104416] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627692000, task ffff880627684880)
Sep 12 09:10:53 p34 kernel: [51433.104422] Stack:
Sep 12 09:10:53 p34 kernel: [51433.104424]  ffff880627693ee8 ffffffff814e7d=
92 0000000000000000 00000000000f1d61
Sep 12 09:10:53 p34 kernel: [51433.104436]  0000000000000000 0000000d000f1d=
61 ffff88063fcf6170 ffff88063fcf6170
Sep 12 09:10:53 p34 kernel: [51433.104448]  ffff88063fcf6240 00000000000000=
00 ffff880627693f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.104459] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104467]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104474]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104481]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104490]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104495] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.104553] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104559]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104567]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104573]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104582]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104589] NMI backtrace for cpu 14
Sep 12 09:10:53 p34 kernel: [51433.104592] CPU 14=20
Sep 12 09:10:53 p34 kernel: [51433.104596] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.104603] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.104612] RSP: 0018:ffff8806276c5e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.104615] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.104620] RDX: 0000000000000000 RSI: ffff8=
806276c5fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.104624] RBP: ffff8806276c5ee8 R08: 00000=
000fffffffd R09: 00000000000003ad
Sep 12 09:10:53 p34 kernel: [51433.104628] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.104632] R13: 1242c730b2e554b7 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104637] FS:  0000000000000000(0000) GS:f=
fff88063fd00000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104642] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.104645] CR2: 00000000043ec000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.104649] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104654] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.104658] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276c4000, task ffff8806276968c0)
Sep 12 09:10:53 p34 kernel: [51433.104662] Stack:
Sep 12 09:10:53 p34 kernel: [51433.104664]  ffff8806276c5ee8 ffffffff814e7d=
92 0000000000000000 00000000000f1fa5
Sep 12 09:10:53 p34 kernel: [51433.104671]  0000000000000000 0000000e000f1f=
a5 ffff88063fd16170 ffff88063fd16170
Sep 12 09:10:53 p34 kernel: [51433.104679]  ffff88063fd16240 00000000000000=
00 ffff8806276c5f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.104686] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104692]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104698]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104704]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104712]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104717] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.104774] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104782]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104788]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104794]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104800]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104806] NMI backtrace for cpu 15
Sep 12 09:10:53 p34 kernel: [51433.104809] CPU 15=20
Sep 12 09:10:53 p34 kernel: [51433.104813] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.104820] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.104829] RSP: 0018:ffff8806276d9e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.104832] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.104837] RDX: 0000000000000000 RSI: ffff8=
806276d9fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.104841] RBP: ffff8806276d9ee8 R08: 00000=
000fffffffd R09: 00000000000003ac
Sep 12 09:10:53 p34 kernel: [51433.104845] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.104848] R13: 1242c730b2e5ec1f R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104853] FS:  0000000000000000(0000) GS:f=
fff88063fd20000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104858] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.104861] CR2: 00000000039a4000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.104866] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.104869] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.104874] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276d8000, task ffff8806276ca900)
Sep 12 09:10:53 p34 kernel: [51433.104878] Stack:
Sep 12 09:10:53 p34 kernel: [51433.104879]  ffff8806276d9ee8 ffffffff814e7d=
92 0000000000000000 00000000000e8a2e
Sep 12 09:10:53 p34 kernel: [51433.104888]  0000000000000000 0000000f000e8a=
2e ffff88063fd36170 ffff88063fd36170
Sep 12 09:10:53 p34 kernel: [51433.104895]  ffff88063fd36240 00000000000000=
00 ffff8806276d9f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.104902] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104908]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104915]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104920]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104927]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104930] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.104969] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.104973]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.104979]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.104984]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.104991]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.104997] NMI backtrace for cpu 16
Sep 12 09:10:53 p34 kernel: [51433.105001] CPU 16=20
Sep 12 09:10:53 p34 kernel: [51433.105005] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.105012] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.105020] RSP: 0018:ffff8806276ede98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.105023] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.105028] RDX: 0000000000000000 RSI: ffff8=
806276edfd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.105031] RBP: ffff8806276edee8 R08: 00000=
000fffffffd R09: 0000000000000392
Sep 12 09:10:53 p34 kernel: [51433.105035] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.105039] R13: 1242c730b2e55778 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105043] FS:  0000000000000000(0000) GS:f=
fff88063fd40000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105048] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.105051] CR2: 00007ff0a10e8e02 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.105056] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105059] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.105064] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276ec000, task ffff8806276de600)
Sep 12 09:10:53 p34 kernel: [51433.105068] Stack:
Sep 12 09:10:53 p34 kernel: [51433.105069]  ffff8806276edee8 ffffffff814e7d=
92 0000000000000000 00000000000f1cc6
Sep 12 09:10:53 p34 kernel: [51433.105077]  0000000000000000 00000010000f1c=
c6 ffff88063fd56170 ffff88063fd56170
Sep 12 09:10:53 p34 kernel: [51433.105085]  ffff88063fd56240 00000000000000=
00 ffff8806276edf08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.105092] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.105097]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.105103]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.105108]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.105114]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.105118] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.105161] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.105174]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.105180]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.105185]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.105191]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.105196] NMI backtrace for cpu 17
Sep 12 09:10:53 p34 kernel: [51433.105200] CPU 17=20
Sep 12 09:10:53 p34 kernel: [51433.105204] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.105211] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.105220] RSP: 0018:ffff88062771de98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.105224] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.105228] RDX: 0000000000000000 RSI: ffff8=
8062771dfd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.105233] RBP: ffff88062771dee8 R08: 00000=
000fffffffd R09: 00000000000003b0
Sep 12 09:10:53 p34 kernel: [51433.105238] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.105242] R13: 1242c730b2e5579b R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105247] FS:  0000000000000000(0000) GS:f=
fff88063fd60000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105252] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.105256] CR2: 00000000043ed000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.105260] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105265] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.105270] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062771c000, task ffff8806276f0640)
Sep 12 09:10:53 p34 kernel: [51433.105274] Stack:
Sep 12 09:10:53 p34 kernel: [51433.105276]  ffff88062771dee8 ffffffff814e7d=
92 0000000000000000 00000000000f1bae
Sep 12 09:10:53 p34 kernel: [51433.105285]  0000000000000000 00000011000f1b=
ae ffff88063fd76170 ffff88063fd76170
Sep 12 09:10:53 p34 kernel: [51433.105294]  ffff88063fd76240 00000000000000=
00 ffff88062771df08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.105303] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.105309]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.105315]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.105321]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.105328]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.105330] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.105364] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.105368]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.105374]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.105379]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.105385]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.105390] NMI backtrace for cpu 18
Sep 12 09:10:53 p34 kernel: [51433.105395] CPU 18=20
Sep 12 09:10:53 p34 kernel: [51433.105401] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.105412] RIP: 0010:[<ffffffff812a87f2>]  =
[<ffffffff812a87f2>] delay_tsc+0x22/0x60
Sep 12 09:10:53 p34 kernel: [51433.105423] RSP: 0018:ffff880c3fcc3d58  EFLA=
GS: 00000093
Sep 12 09:10:53 p34 kernel: [51433.105429] RAX: 00000000b605807e RBX: 00000=
000000003e9 RCX: 0000000000000023
Sep 12 09:10:53 p34 kernel: [51433.105435] RDX: 0000000000000030 RSI: 00000=
000b605804e RDI: 000000000003a97d
Sep 12 09:10:53 p34 kernel: [51433.105440] RBP: ffff880c3fcc3d58 R08: 00000=
00000000012 R09: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105446] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000001000
Sep 12 09:10:53 p34 kernel: [51433.105452] R13: ffffffff81aa8d50 R14: 00000=
00000000400 R15: 0000000000000092
Sep 12 09:10:53 p34 kernel: [51433.105458] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105464] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.105470] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.105476] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.105482] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.105488] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:10:53 p34 kernel: [51433.105494] Stack:
Sep 12 09:10:53 p34 kernel: [51433.105496]  ffff880c3fcc3d68 ffffffff812a88=
5a ffff880c3fcc3d78 ffffffff812a8887
Sep 12 09:10:53 p34 kernel: [51433.105510]  ffff880c3fcc3d98 ffffffff81019c=
3a 0000000000000002 000000000000c502
Sep 12 09:10:53 p34 kernel: [51433.105524]  ffff880c3fcc3de8 ffffffff8101a8=
e8 7fffffff00000023 0000000000000013
Sep 12 09:10:53 p34 kernel: [51433.105537] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.105540]  <IRQ>=20
Sep 12 09:10:53 p34 kernel: [51433.105547]  [<ffffffff812a885a>] __delay+0x=
a/0x10
Sep 12 09:10:53 p34 kernel: [51433.105553]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:10:53 p34 kernel: [51433.105562]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:10:53 p34 kernel: [51433.105571]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:10:53 p34 kernel: [51433.105582]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:10:53 p34 kernel: [51433.105589]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:10:53 p34 kernel: [51433.105597]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:10:53 p34 kernel: [51433.105606]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:10:53 p34 kernel: [51433.105616]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:10:53 p34 kernel: [51433.105625]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:10:53 p34 kernel: [51433.105635]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:10:53 p34 kernel: [51433.105643]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:10:53 p34 kernel: [51433.105651]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:10:53 p34 kernel: [51433.105660]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:10:53 p34 kernel: [51433.105665]  <EOI>=20
Sep 12 09:10:53 p34 kernel: [51433.105672]  [<ffffffff8107a988>] ? find_get=
_pages+0x68/0x150
Sep 12 09:10:53 p34 kernel: [51433.105681]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:10:53 p34 kernel: [51433.105686]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:10:53 p34 kernel: [51433.105693]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:10:53 p34 kernel: [51433.105698]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:10:53 p34 kernel: [51433.105701]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:10:53 p34 kernel: [51433.105708]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:10:53 p34 kernel: [51433.105715]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:10:53 p34 kernel: [51433.105722]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:10:53 p34 kernel: [51433.105729]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:10:53 p34 kernel: [51433.105738]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:10:53 p34 kernel: [51433.105745]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:10:53 p34 kernel: [51433.105752]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:10:53 p34 kernel: [51433.105757] Code: c8 5d c3 66 0f 1f 44 00 00=
 55 65 44 8b 04 25 f0 c4 00 00 48 89 e5 0f 1f 00 0f ae e8 0f 31 89 c6 eb 16=
 0f 1f 80 00 00 00 00 f3 90=20
Sep 12 09:10:53 p34 kernel: <65>[51433.105805]  8b 0c 25 f0 c4 00 00 41 39 =
c8 75 17 0f 1f 00 0f ae e8 0f 31=20
Sep 12 09:10:53 p34 kernel: [51433.105829] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.105833]  <IRQ>  [<ffffffff812a885a>] __d=
elay+0xa/0x10
Sep 12 09:10:53 p34 kernel: [51433.105842]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:10:53 p34 kernel: [51433.105849]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:10:53 p34 kernel: [51433.105857]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:10:53 p34 kernel: [51433.105866]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:10:53 p34 kernel: [51433.105873]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:10:53 p34 kernel: [51433.105881]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:10:53 p34 kernel: [51433.105888]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:10:53 p34 kernel: [51433.105896]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:10:53 p34 kernel: [51433.105904]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:10:53 p34 kernel: [51433.105911]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:10:53 p34 kernel: [51433.105919]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:10:53 p34 kernel: [51433.105926]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:10:53 p34 kernel: [51433.105934]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:10:53 p34 kernel: [51433.105940]  <EOI>  [<ffffffff8107a988>] ? f=
ind_get_pages+0x68/0x150
Sep 12 09:10:53 p34 kernel: [51433.105952]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:10:53 p34 kernel: [51433.105960]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:10:53 p34 kernel: [51433.105969]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:10:53 p34 kernel: [51433.105976]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:10:53 p34 kernel: [51433.105983]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:10:53 p34 kernel: [51433.105990]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:10:53 p34 kernel: [51433.105996]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:10:53 p34 kernel: [51433.106003]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:10:53 p34 kernel: [51433.106010]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:10:53 p34 kernel: [51433.106017]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:10:53 p34 kernel: [51433.106024]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:10:53 p34 kernel: [51433.106032]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:10:53 p34 kernel: [51433.106102] NMI backtrace for cpu 19
Sep 12 09:10:53 p34 kernel: [51433.106108] CPU 19=20
Sep 12 09:10:53 p34 kernel: [51433.106112] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.106117] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.106124] RSP: 0018:ffff88062772fe98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.106126] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.106129] RDX: 0000000000000000 RSI: ffff8=
8062772ffd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.106136] RBP: ffff88062772fee8 R08: 00000=
000fffffffc R09: 00000000000003b4
Sep 12 09:10:53 p34 kernel: [51433.106142] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.106148] R13: 1242c730b313c864 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106151] FS:  0000000000000000(0000) GS:f=
fff880c3fce0000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106155] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.106158] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.106161] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106165] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.106169] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062772e000, task ffff880627724c30)
Sep 12 09:10:53 p34 kernel: [51433.106171] Stack:
Sep 12 09:10:53 p34 kernel: [51433.106173]  ffff88062772fee8 ffffffff814e7d=
92 0000000000000000 00000000000e733f
Sep 12 09:10:53 p34 kernel: [51433.106179]  0000000000000000 00000013000e73=
3f ffff880c3fcf6170 ffff880c3fcf6170
Sep 12 09:10:53 p34 kernel: [51433.106190]  ffff880c3fcf62a0 00000000000000=
00 ffff88062772ff08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.106204] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.106213]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.106222]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.106228]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.106236]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.106241] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.106300] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.106304]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.106308]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.106312]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.106316]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.106320] NMI backtrace for cpu 20
Sep 12 09:10:53 p34 kernel: [51433.106323] CPU 20=20
Sep 12 09:10:53 p34 kernel: [51433.106327] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.106332] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.106341] RSP: 0018:ffff880627735e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.106347] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.106350] RDX: 0000000000000000 RSI: ffff8=
80627735fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.106353] RBP: ffff880627735ee8 R08: 00000=
000fffffffc R09: 00000000000003b2
Sep 12 09:10:53 p34 kernel: [51433.106355] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.106358] R13: 1242c730b313cfbc R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106361] FS:  0000000000000000(0000) GS:f=
fff880c3fd00000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106364] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.106367] CR2: 00000000043fe000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.106369] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106372] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.106375] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627734000, task ffff8806277240d0)
Sep 12 09:10:53 p34 kernel: [51433.106377] Stack:
Sep 12 09:10:53 p34 kernel: [51433.106379]  ffff880627735ee8 ffffffff814e7d=
92 0000000000000000 00000000000e6ad4
Sep 12 09:10:53 p34 kernel: [51433.106391]  0000000000000000 00000014000e6a=
d4 ffff880c3fd16170 ffff880c3fd16170
Sep 12 09:10:53 p34 kernel: [51433.106406]  ffff880c3fd162a0 00000000000000=
00 ffff880627735f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.106420] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.106429]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.106436]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.106444]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.106452]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.106454] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.106509] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.106516]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.106523]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.106529]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.106537]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.106544] NMI backtrace for cpu 21
Sep 12 09:10:53 p34 kernel: [51433.106550] CPU 21=20
Sep 12 09:10:53 p34 kernel: [51433.106556] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.106567] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.106579] RSP: 0018:ffff88062773fe98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.106584] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.106590] RDX: 0000000000000000 RSI: ffff8=
8062773ffd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.106595] RBP: ffff88062773fee8 R08: 00000=
000fffffffc R09: 00000000000003b4
Sep 12 09:10:53 p34 kernel: [51433.106601] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:10:53 p34 kernel: [51433.106607] R13: 1242c730b3233fbf R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106614] FS:  0000000000000000(0000) GS:f=
fff880c3fd20000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106621] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.106626] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.106632] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106638] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.106645] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062773e000, task ffff880627739220)
Sep 12 09:10:53 p34 kernel: [51433.106651] Stack:
Sep 12 09:10:53 p34 kernel: [51433.106654]  ffff88062773fee8 ffffffff814e7d=
92 0000000000000000 00000000000e3dd7
Sep 12 09:10:53 p34 kernel: [51433.106670]  0000000000000000 00000015000e3d=
d7 ffff880c3fd36170 ffff880c3fd36170
Sep 12 09:10:53 p34 kernel: [51433.106684]  ffff880c3fd362a0 00000000000000=
00 ffff88062773ff08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.106699] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.106709]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.106716]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.106720]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.106725]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.106727] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.106782] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.106789]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.106797]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.106804]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.106811]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.106819] NMI backtrace for cpu 22
Sep 12 09:10:53 p34 kernel: [51433.106824] CPU 22=20
Sep 12 09:10:53 p34 kernel: [51433.106831] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.106841] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.106852] RSP: 0018:ffff880627747e98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.106858] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.106864] RDX: 0000000000000000 RSI: ffff8=
80627747fd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.106871] RBP: ffff880627747ee8 R08: 00000=
000fffffffd R09: 0000000000000399
Sep 12 09:10:53 p34 kernel: [51433.106876] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.106882] R13: 1242c730b3239d5b R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106888] FS:  0000000000000000(0000) GS:f=
fff880c3fd40000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106895] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.106901] CR2: 000016a96601f000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.106906] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.106912] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.106917] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627746000, task ffff8806277386c0)
Sep 12 09:10:53 p34 kernel: [51433.106923] Stack:
Sep 12 09:10:53 p34 kernel: [51433.106925]  ffff880627747ee8 ffffffff814e7d=
92 0000000000000000 00000000000de176
Sep 12 09:10:53 p34 kernel: [51433.106940]  0000000000000000 00000016000de1=
76 ffff880c3fd56170 ffff880c3fd56170
Sep 12 09:10:53 p34 kernel: [51433.106953]  ffff880c3fd56240 00000000000000=
00 ffff880627747f08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.106968] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.106977]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.106984]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.106991]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.107000]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.107005] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.107078] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.107086]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.107094]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.107101]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.107105]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.107109] NMI backtrace for cpu 23
Sep 12 09:10:53 p34 kernel: [51433.107113] CPU 23=20
Sep 12 09:10:53 p34 kernel: [51433.107116] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:10:53 p34 kernel: [51433.107121] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:10:53 p34 kernel: [51433.107128] RSP: 0018:ffff88062774fe98  EFLA=
GS: 00000046
Sep 12 09:10:53 p34 kernel: [51433.107131] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:10:53 p34 kernel: [51433.107138] RDX: 0000000000000000 RSI: ffff8=
8062774ffd8 RDI: ffffffff81a4d300
Sep 12 09:10:53 p34 kernel: [51433.107144] RBP: ffff88062774fee8 R08: 00000=
000fffffffd R09: 000000000000039a
Sep 12 09:10:53 p34 kernel: [51433.107150] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:10:53 p34 kernel: [51433.107156] R13: 1242c730b3233bcd R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.107162] FS:  0000000000000000(0000) GS:f=
fff880c3fd60000(0000) knlGS:0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.107172] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:10:53 p34 kernel: [51433.107178] CR2: 000000000399f000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:10:53 p34 kernel: [51433.107183] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:10:53 p34 kernel: [51433.107189] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:10:53 p34 kernel: [51433.107195] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062774e000, task ffff88062774d810)
Sep 12 09:10:53 p34 kernel: [51433.107202] Stack:
Sep 12 09:10:53 p34 kernel: [51433.107204]  ffff88062774fee8 ffffffff814e7d=
92 0000000000000000 00000000000e4237
Sep 12 09:10:53 p34 kernel: [51433.107219]  0000000000000000 00000017000e42=
37 ffff880c3fd76170 ffff880c3fd76170
Sep 12 09:10:53 p34 kernel: [51433.107232]  ffff880c3fd76240 00000000000000=
00 ffff88062774ff08 ffffffff814e6bb6
Sep 12 09:10:53 p34 kernel: [51433.107249] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.107258]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.107266]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.107270]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.107275]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:10:53 p34 kernel: [51433.107277] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:10:53 p34 kernel: [51433.107324] Call Trace:
Sep 12 09:10:53 p34 kernel: [51433.107330]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:10:53 p34 kernel: [51433.107337]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:10:53 p34 kernel: [51433.107344]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:10:53 p34 kernel: [51433.107351]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:11:20 p34 kernel: [51460.197018] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:11:20 p34 kernel: [51460.197023] CPU 18=20
Sep 12 09:11:20 p34 kernel: [51460.197027] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:11:20 p34 kernel: [51460.197033] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:11:20 p34 kernel: [51460.197042] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:11:20 p34 kernel: [51460.197044] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:11:20 p34 kernel: [51460.197047] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:11:20 p34 kernel: [51460.197050] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:11:20 p34 kernel: [51460.197052] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:11:20 p34 kernel: [51460.197055] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:11:20 p34 kernel: [51460.197058] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:11:20 p34 kernel: [51460.197061] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:11:20 p34 kernel: [51460.197064] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:11:20 p34 kernel: [51460.197067] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:11:20 p34 kernel: [51460.197069] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:11:20 p34 kernel: [51460.197072] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:11:20 p34 kernel: [51460.197075] Stack:
Sep 12 09:11:20 p34 kernel: [51460.197077]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:11:20 p34 kernel: [51460.197083]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:11:20 p34 kernel: [51460.197089]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:11:20 p34 kernel: [51460.197095] Call Trace:
Sep 12 09:11:20 p34 kernel: [51460.197102]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:11:20 p34 kernel: [51460.197106]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:11:20 p34 kernel: [51460.197113]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:11:20 p34 kernel: [51460.197118]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:11:20 p34 kernel: [51460.197122]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:11:20 p34 kernel: [51460.197126]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:11:20 p34 kernel: [51460.197131]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:11:20 p34 kernel: [51460.197135]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:11:20 p34 kernel: [51460.197139]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:11:20 p34 kernel: [51460.197146]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:11:20 p34 kernel: [51460.197149]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:11:20 p34 kernel: [51460.197153]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:11:20 p34 kernel: [51460.197155] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:11:20 p34 kernel: <44>[51460.197177]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:11:20 p34 kernel: [51460.197188] Call Trace:
Sep 12 09:11:20 p34 kernel: [51460.197192]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:11:20 p34 kernel: [51460.197196]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:11:20 p34 kernel: [51460.197200]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:11:20 p34 kernel: [51460.197205]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:11:20 p34 kernel: [51460.197208]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:11:20 p34 kernel: [51460.197212]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:11:20 p34 kernel: [51460.197217]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:11:20 p34 kernel: [51460.197222]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:11:20 p34 kernel: [51460.197225]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:11:20 p34 kernel: [51460.197229]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:11:20 p34 kernel: [51460.197233]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:11:20 p34 kernel: [51460.197237]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:11:48 p34 kernel: [51488.154764] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:11:48 p34 kernel: [51488.154769] CPU 18=20
Sep 12 09:11:48 p34 kernel: [51488.154773] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:11:48 p34 kernel: [51488.154779] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:11:48 p34 kernel: [51488.154788] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:11:48 p34 kernel: [51488.154791] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:11:48 p34 kernel: [51488.154793] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:11:48 p34 kernel: [51488.154796] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:11:48 p34 kernel: [51488.154799] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:11:48 p34 kernel: [51488.154802] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:11:48 p34 kernel: [51488.154805] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:11:48 p34 kernel: [51488.154808] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:11:48 p34 kernel: [51488.154810] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:11:48 p34 kernel: [51488.154813] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:11:48 p34 kernel: [51488.154816] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:11:48 p34 kernel: [51488.154819] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:11:48 p34 kernel: [51488.154821] Stack:
Sep 12 09:11:48 p34 kernel: [51488.154823]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:11:48 p34 kernel: [51488.154830]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:11:48 p34 kernel: [51488.154835]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:11:48 p34 kernel: [51488.154841] Call Trace:
Sep 12 09:11:48 p34 kernel: [51488.154848]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:11:48 p34 kernel: [51488.154853]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:11:48 p34 kernel: [51488.154859]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:11:48 p34 kernel: [51488.154864]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:11:48 p34 kernel: [51488.154868]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:11:48 p34 kernel: [51488.154872]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:11:48 p34 kernel: [51488.154877]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:11:48 p34 kernel: [51488.154881]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:11:48 p34 kernel: [51488.154885]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:11:48 p34 kernel: [51488.154892]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:11:48 p34 kernel: [51488.154896]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:11:48 p34 kernel: [51488.154900]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:11:48 p34 kernel: [51488.154902] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:11:48 p34 kernel: <48>[51488.154923]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:11:48 p34 kernel: [51488.154934] Call Trace:
Sep 12 09:11:48 p34 kernel: [51488.154938]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:11:48 p34 kernel: [51488.154942]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:11:48 p34 kernel: [51488.154946]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:11:48 p34 kernel: [51488.154951]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:11:48 p34 kernel: [51488.154954]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:11:48 p34 kernel: [51488.154958]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:11:48 p34 kernel: [51488.154964]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:11:48 p34 kernel: [51488.154968]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:11:48 p34 kernel: [51488.154972]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:11:48 p34 kernel: [51488.154976]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:11:48 p34 kernel: [51488.154979]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:11:48 p34 kernel: [51488.154983]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:12:16 p34 kernel: [51516.112510] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:12:16 p34 kernel: [51516.112514] CPU 18=20
Sep 12 09:12:16 p34 kernel: [51516.112519] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:12:16 p34 kernel: [51516.112524] RIP: 0010:[<ffffffff8107a981>]  =
[<ffffffff8107a981>] find_get_pages+0x61/0x150
Sep 12 09:12:16 p34 kernel: [51516.112533] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:12:16 p34 kernel: [51516.112536] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:12:16 p34 kernel: [51516.112539] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:12:16 p34 kernel: [51516.112541] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:12:16 p34 kernel: [51516.112544] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:12:16 p34 kernel: [51516.112547] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:12:16 p34 kernel: [51516.112550] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:12:16 p34 kernel: [51516.112553] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:12:16 p34 kernel: [51516.112555] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:12:16 p34 kernel: [51516.112558] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:12:16 p34 kernel: [51516.112561] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:12:16 p34 kernel: [51516.112564] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:12:16 p34 kernel: [51516.112566] Stack:
Sep 12 09:12:16 p34 kernel: [51516.112568]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:12:16 p34 kernel: [51516.112575]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:12:16 p34 kernel: [51516.112580]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:12:16 p34 kernel: [51516.112586] Call Trace:
Sep 12 09:12:16 p34 kernel: [51516.112593]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:12:16 p34 kernel: [51516.112598]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:12:16 p34 kernel: [51516.112605]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:12:16 p34 kernel: [51516.112610]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:12:16 p34 kernel: [51516.112613]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:12:16 p34 kernel: [51516.112617]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:12:16 p34 kernel: [51516.112622]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:12:16 p34 kernel: [51516.112626]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:12:16 p34 kernel: [51516.112630]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:12:16 p34 kernel: [51516.112637]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:12:16 p34 kernel: [51516.112641]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:12:16 p34 kernel: [51516.112645]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:12:16 p34 kernel: [51516.112647] Code: 89 ea e8 33 95 22 00 85 c0=
 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b 07 48 8b 38 48 85=
 ff 74 5b 40 f6 c7 01 75 7a=20
Sep 12 09:12:16 p34 kernel: <48>[51516.112668]  63 83 44 e0 ff ff a9 00 ff =
ff 07 0f 85 8d 00 00 00 44 8b 47=20
Sep 12 09:12:16 p34 kernel: [51516.112679] Call Trace:
Sep 12 09:12:16 p34 kernel: [51516.112682]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:12:16 p34 kernel: [51516.112687]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:12:16 p34 kernel: [51516.112691]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:12:16 p34 kernel: [51516.112695]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:12:16 p34 kernel: [51516.112699]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:12:16 p34 kernel: [51516.112703]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:12:16 p34 kernel: [51516.112707]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:12:16 p34 kernel: [51516.112712]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:12:16 p34 kernel: [51516.112716]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:12:16 p34 kernel: [51516.112720]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:12:16 p34 kernel: [51516.112724]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:12:16 p34 kernel: [51516.112728]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:12:24 p34 kernel: [51524.718806] INFO: task fsnotify_mark:1047 bl=
ocked for more than 120 seconds.
Sep 12 09:12:24 p34 kernel: [51524.718811] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
Sep 12 09:12:24 p34 kernel: [51524.718814] fsnotify_mark   D 00000001030b76=
3d     0  1047      2 0x00000000
Sep 12 09:12:24 p34 kernel: [51524.718819]  ffff8806266f3cb0 00000000000000=
46 0000000000000000 ffff8806266f3fd8
Sep 12 09:12:24 p34 kernel: [51524.718826]  0000000000004000 ffff8806266f3f=
d8 ffff8806276de600 ffff880626d2b3a0
Sep 12 09:12:24 p34 kernel: [51524.718832]  0000000000000000 00000000000000=
00 0000000000000000 0000000000000000
Sep 12 09:12:24 p34 kernel: [51524.718837] Call Trace:
Sep 12 09:12:24 p34 kernel: [51524.718846]  [<ffffffff81030533>] ? load_bal=
ance+0xa3/0x5c0
Sep 12 09:12:24 p34 kernel: [51524.718853]  [<ffffffff81645985>] schedule_t=
imeout+0x1a5/0x200
Sep 12 09:12:24 p34 kernel: [51524.718858]  [<ffffffff816449cd>] wait_for_c=
ommon+0xbd/0x150
Sep 12 09:12:24 p34 kernel: [51524.718862]  [<ffffffff810316a0>] ? try_to_w=
ake_up+0x260/0x260
Sep 12 09:12:24 p34 kernel: [51524.718867]  [<ffffffff8106efb0>] ? rcu_chec=
k_callbacks+0x120/0x120
Sep 12 09:12:24 p34 kernel: [51524.718871]  [<ffffffff81644b38>] wait_for_c=
ompletion+0x18/0x20
Sep 12 09:12:24 p34 kernel: [51524.718875]  [<ffffffff8106f00a>] synchroniz=
e_sched+0x5a/0x60
Sep 12 09:12:24 p34 kernel: [51524.718880]  [<ffffffff8104d0e0>] ? find_ge_=
pid+0x50/0x50
Sep 12 09:12:24 p34 kernel: [51524.718885]  [<ffffffff8105470b>] __synchron=
ize_srcu+0x5b/0xc0
Sep 12 09:12:24 p34 kernel: [51524.718890]  [<ffffffff810548a0>] synchroniz=
e_srcu+0x10/0x20
Sep 12 09:12:24 p34 kernel: [51524.718896]  [<ffffffff810ef839>] fsnotify_m=
ark_destroy+0x89/0x150
Sep 12 09:12:24 p34 kernel: [51524.718900]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:12:24 p34 kernel: [51524.718905]  [<ffffffff810ef7b0>] ? fsnotify=
_put_mark+0x30/0x30
Sep 12 09:12:24 p34 kernel: [51524.718908]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:12:24 p34 kernel: [51524.718914]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:12:24 p34 kernel: [51524.718917]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:12:24 p34 kernel: [51524.718921]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:12:24 p34 kernel: [51524.718938] INFO: task gpsd:4705 blocked for=
 more than 120 seconds.
Sep 12 09:12:24 p34 kernel: [51524.718940] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
Sep 12 09:12:24 p34 kernel: [51524.718943] gpsd            D ffff8806260378=
50     0  4705      1 0x00000000
Sep 12 09:12:24 p34 kernel: [51524.718947]  ffff880620e397d8 00000000000000=
86 0000000000000001 ffff880620e39fd8
Sep 12 09:12:24 p34 kernel: [51524.718953]  0000000000004000 ffff880620e39f=
d8 ffff8806276713a0 ffff880626037850
Sep 12 09:12:24 p34 kernel: [51524.718959]  ffff880626d2a840 00000000000000=
20 00000000000005f9 00000000000005f9
Sep 12 09:12:24 p34 kernel: [51524.718964] Call Trace:
Sep 12 09:12:24 p34 kernel: [51524.718968]  [<ffffffff81030533>] ? load_bal=
ance+0xa3/0x5c0
Sep 12 09:12:24 p34 kernel: [51524.718972]  [<ffffffff81645985>] schedule_t=
imeout+0x1a5/0x200
Sep 12 09:12:24 p34 kernel: [51524.718976]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:12:24 p34 kernel: [51524.718980]  [<ffffffff816449cd>] wait_for_c=
ommon+0xbd/0x150
Sep 12 09:12:24 p34 kernel: [51524.718984]  [<ffffffff810316a0>] ? try_to_w=
ake_up+0x260/0x260
Sep 12 09:12:24 p34 kernel: [51524.718989]  [<ffffffff81644b38>] wait_for_c=
ompletion+0x18/0x20
Sep 12 09:12:24 p34 kernel: [51524.718993]  [<ffffffff8104b939>] flush_work=
+0x29/0x40
Sep 12 09:12:24 p34 kernel: [51524.718997]  [<ffffffff81049540>] ? do_work_=
for_cpu+0x30/0x30
Sep 12 09:12:24 p34 kernel: [51524.719003]  [<ffffffff813157c0>] tty_flush_=
to_ldisc+0x10/0x20
Sep 12 09:12:24 p34 kernel: [51524.719007]  [<ffffffff8130fc8f>] n_tty_poll=
+0x5f/0x1d0
Sep 12 09:12:24 p34 kernel: [51524.719011]  [<ffffffff8130bb4a>] tty_poll+0=
x8a/0xa0
Sep 12 09:12:24 p34 kernel: [51524.719015]  [<ffffffff810ccd02>] do_select+=
0x3a2/0x6d0
Sep 12 09:12:24 p34 kernel: [51524.719019]  [<ffffffff810cc4f0>] ? poll_sel=
ect_copy_remaining+0x140/0x140
Sep 12 09:12:24 p34 kernel: [51524.719023]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:12:24 p34 kernel: [51524.719026]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:12:24 p34 kernel: [51524.719029]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:12:24 p34 kernel: [51524.719032]  [<ffffffff810cc5e0>] ? __pollwa=
it+0xf0/0xf0
Sep 12 09:12:24 p34 kernel: [51524.719036]  [<ffffffff81644eec>] ? schedule=
+0x29c/0x880
Sep 12 09:12:24 p34 kernel: [51524.719043]  [<ffffffff812a382e>] ? radix_tr=
ee_lookup_slot+0xe/0x10
Sep 12 09:12:24 p34 kernel: [51524.719047]  [<ffffffff8107a178>] ? find_get=
_page+0x28/0xd0
Sep 12 09:12:24 p34 kernel: [51524.719050]  [<ffffffff8107a417>] ? filemap_=
fault+0x87/0x470
Sep 12 09:12:24 p34 kernel: [51524.719054]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:12:24 p34 kernel: [51524.719058]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:12:24 p34 kernel: [51524.719062]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:12:24 p34 kernel: [51524.719066]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:12:24 p34 kernel: [51524.719070]  [<ffffffff810cd230>] core_sys_s=
elect+0x200/0x2f0
Sep 12 09:12:24 p34 kernel: [51524.719073]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:12:24 p34 kernel: [51524.719077]  [<ffffffff816481ce>] ? apic_tim=
er_interrupt+0xe/0x20
Sep 12 09:12:24 p34 kernel: [51524.719082]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:12:24 p34 kernel: [51524.719085]  [<ffffffff81057f08>] ? ktime_ge=
t_ts+0xa8/0xe0
Sep 12 09:12:24 p34 kernel: [51524.719089]  [<ffffffff810cd3d6>] sys_select=
+0xb6/0x100
Sep 12 09:12:24 p34 kernel: [51524.719093]  [<ffffffff816478bb>] system_cal=
l_fastpath+0x16/0x1b
Sep 12 09:12:44 p34 kernel: [51544.070256] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:12:44 p34 kernel: [51544.070261] CPU 18=20
Sep 12 09:12:44 p34 kernel: [51544.070265] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:12:44 p34 kernel: [51544.070271] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:12:44 p34 kernel: [51544.070280] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:12:44 p34 kernel: [51544.070282] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:12:44 p34 kernel: [51544.070285] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:12:44 p34 kernel: [51544.070288] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:12:44 p34 kernel: [51544.070290] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:12:44 p34 kernel: [51544.070293] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:12:44 p34 kernel: [51544.070296] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:12:44 p34 kernel: [51544.070299] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:12:44 p34 kernel: [51544.070302] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:12:44 p34 kernel: [51544.070305] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:12:44 p34 kernel: [51544.070307] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:12:44 p34 kernel: [51544.070310] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:12:44 p34 kernel: [51544.070313] Stack:
Sep 12 09:12:44 p34 kernel: [51544.070315]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:12:44 p34 kernel: [51544.070321]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:12:44 p34 kernel: [51544.070327]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:12:44 p34 kernel: [51544.070332] Call Trace:
Sep 12 09:12:44 p34 kernel: [51544.070339]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:12:44 p34 kernel: [51544.070344]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:12:44 p34 kernel: [51544.070351]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:12:44 p34 kernel: [51544.070356]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:12:44 p34 kernel: [51544.070359]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:12:44 p34 kernel: [51544.070363]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:12:44 p34 kernel: [51544.070368]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:12:44 p34 kernel: [51544.070372]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:12:44 p34 kernel: [51544.070376]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:12:44 p34 kernel: [51544.070383]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:12:44 p34 kernel: [51544.070387]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:12:44 p34 kernel: [51544.070391]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:12:44 p34 kernel: [51544.070392] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:12:44 p34 kernel: <48>[51544.070414]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:12:44 p34 kernel: [51544.070424] Call Trace:
Sep 12 09:12:44 p34 kernel: [51544.070428]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:12:44 p34 kernel: [51544.070433]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:12:44 p34 kernel: [51544.070437]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:12:44 p34 kernel: [51544.070441]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:12:44 p34 kernel: [51544.070445]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:12:44 p34 kernel: [51544.070448]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:12:44 p34 kernel: [51544.070453]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:12:44 p34 kernel: [51544.070458]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:12:44 p34 kernel: [51544.070461]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:12:44 p34 kernel: [51544.070465]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:12:44 p34 kernel: [51544.070469]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:12:44 p34 kernel: [51544.070473]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:13:12 p34 kernel: [51572.028001] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:13:12 p34 kernel: [51572.028006] CPU 18=20
Sep 12 09:13:12 p34 kernel: [51572.028010] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:12 p34 kernel: [51572.028016] RIP: 0010:[<ffffffff8107a993>]  =
[<ffffffff8107a993>] find_get_pages+0x73/0x150
Sep 12 09:13:12 p34 kernel: [51572.028024] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:13:12 p34 kernel: [51572.028027] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:13:12 p34 kernel: [51572.028030] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:13:12 p34 kernel: [51572.028032] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:13:12 p34 kernel: [51572.028035] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:13:12 p34 kernel: [51572.028038] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:13:12 p34 kernel: [51572.028041] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:13:12 p34 kernel: [51572.028044] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:12 p34 kernel: [51572.028047] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:12 p34 kernel: [51572.028049] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:12 p34 kernel: [51572.028052] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:12 p34 kernel: [51572.028055] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:13:12 p34 kernel: [51572.028058] Stack:
Sep 12 09:13:12 p34 kernel: [51572.028059]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:13:12 p34 kernel: [51572.028066]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:13:12 p34 kernel: [51572.028072]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:13:12 p34 kernel: [51572.028077] Call Trace:
Sep 12 09:13:12 p34 kernel: [51572.028084]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:13:12 p34 kernel: [51572.028089]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:13:12 p34 kernel: [51572.028096]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:13:12 p34 kernel: [51572.028101]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:13:12 p34 kernel: [51572.028104]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:13:12 p34 kernel: [51572.028108]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:13:12 p34 kernel: [51572.028114]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:13:12 p34 kernel: [51572.028117]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:13:12 p34 kernel: [51572.028121]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:13:12 p34 kernel: [51572.028128]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:13:12 p34 kernel: [51572.028132]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:13:12 p34 kernel: [51572.028136]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:13:12 p34 kernel: [51572.028138] Code: 89 e7 31 c9 31 d2 66 90 49=
 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 48 63 83 44 e0 ff ff a9 00=
 ff ff 07 0f 85 8d 00 00 00=20
Sep 12 09:13:12 p34 kernel: <44>[51572.028159]  8b 47 08 45 85 c0 74 da 45 =
8d 48 01 44 89 c0 4c 8d 57 08 f0=20
Sep 12 09:13:12 p34 kernel: [51572.028170] Call Trace:
Sep 12 09:13:12 p34 kernel: [51572.028174]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:13:12 p34 kernel: [51572.028178]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:13:12 p34 kernel: [51572.028182]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:13:12 p34 kernel: [51572.028186]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:13:12 p34 kernel: [51572.028190]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:13:12 p34 kernel: [51572.028193]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:13:12 p34 kernel: [51572.028198]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:13:12 p34 kernel: [51572.028203]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:13:12 p34 kernel: [51572.028207]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:13:12 p34 kernel: [51572.028211]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:13:12 p34 kernel: [51572.028215]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:13:12 p34 kernel: [51572.028219]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:13:40 p34 kernel: [51599.985748] BUG: soft lockup - CPU#18 stuck =
for 23s! [kswapd1:1045]
Sep 12 09:13:40 p34 kernel: [51599.985752] CPU 18=20
Sep 12 09:13:40 p34 kernel: [51599.985757] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:40 p34 kernel: [51599.985762] RIP: 0010:[<ffffffff8107a976>]  =
[<ffffffff8107a976>] find_get_pages+0x56/0x150
Sep 12 09:13:40 p34 kernel: [51599.985771] RSP: 0018:ffff880626783b50  EFLA=
GS: 00000246
Sep 12 09:13:40 p34 kernel: [51599.985774] RAX: 0000000000000000 RBX: ffff8=
80626783ba0 RCX: 0000000000000000
Sep 12 09:13:40 p34 kernel: [51599.985777] RDX: 0000000000000000 RSI: 00000=
0000000000e RDI: ffffea000113d988
Sep 12 09:13:40 p34 kernel: [51599.985779] RBP: ffff880626783ba0 R08: 00000=
00000000000 R09: 000000000000000a
Sep 12 09:13:40 p34 kernel: [51599.985782] R10: 0000000000000009 R11: ffff8=
805ede87e18 R12: ffffffff816481ce
Sep 12 09:13:40 p34 kernel: [51599.985785] R13: 0000000000000286 R14: ffff8=
80626783b00 R15: ffffffff810e4f5d
Sep 12 09:13:40 p34 kernel: [51599.985788] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:13:40 p34 kernel: [51599.985791] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:40 p34 kernel: [51599.985794] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:40 p34 kernel: [51599.985796] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:40 p34 kernel: [51599.985799] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:40 p34 kernel: [51599.985802] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:13:40 p34 kernel: [51599.985805] Stack:
Sep 12 09:13:40 p34 kernel: [51599.985806]  ffff880c3fccd520 00000000000000=
05 ffff88000558c320 ffff88000558c328
Sep 12 09:13:40 p34 kernel: [51599.985813]  ffff880626783ba0 ffff880626783b=
e0 0000000000000206 ffffffffffffffff
Sep 12 09:13:40 p34 kernel: [51599.985819]  ffff88000558c320 ffffea000245a7=
20 ffff880626783bc0 ffffffff8108597d
Sep 12 09:13:40 p34 kernel: [51599.985824] Call Trace:
Sep 12 09:13:40 p34 kernel: [51599.985831]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:13:40 p34 kernel: [51599.985836]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:13:40 p34 kernel: [51599.985843]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:13:40 p34 kernel: [51599.985848]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:13:40 p34 kernel: [51599.985852]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:13:40 p34 kernel: [51599.985856]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:13:40 p34 kernel: [51599.985861]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:13:40 p34 kernel: [51599.985865]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:13:40 p34 kernel: [51599.985869]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:13:40 p34 kernel: [51599.985876]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:13:40 p34 kernel: [51599.985879]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:13:40 p34 kernel: [51599.985883]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:13:40 p34 kernel: [51599.985885] Code: 48 8b 7d c8 4c 89 e6 44 89=
 f1 4c 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31=
 d2 66 90 49 8b 07 48 8b 38=20
Sep 12 09:13:40 p34 kernel: <48>[51599.985907]  85 ff 74 5b 40 f6 c7 01 75 =
7a 48 63 83 44 e0 ff ff a9 00 ff=20
Sep 12 09:13:40 p34 kernel: [51599.985917] Call Trace:
Sep 12 09:13:40 p34 kernel: [51599.985921]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:13:40 p34 kernel: [51599.985926]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:13:40 p34 kernel: [51599.985930]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:13:40 p34 kernel: [51599.985934]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:13:40 p34 kernel: [51599.985938]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:13:40 p34 kernel: [51599.985942]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:13:40 p34 kernel: [51599.985947]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:13:40 p34 kernel: [51599.985952]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:13:40 p34 kernel: [51599.985955]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:13:40 p34 kernel: [51599.985959]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:13:40 p34 kernel: [51599.985963]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:13:40 p34 kernel: [51599.985967]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:13:53 p34 kernel: [51612.859490] INFO: rcu_sched_state detected s=
tall on CPU 18 (t=3D780120 jiffies)
Sep 12 09:13:53 p34 kernel: [51612.859498] sending NMI to all CPUs:
Sep 12 09:13:53 p34 kernel: [51612.859566] NMI backtrace for cpu 0
Sep 12 09:13:53 p34 kernel: [51612.859571] CPU 0=20
Sep 12 09:13:53 p34 kernel: [51612.859576] Pid: 0, comm: swapper Not tainte=
d 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.859582] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.859591] RSP: 0018:ffffffff81a01eb8  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.859594] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.859597] RDX: 0000000000000000 RSI: fffff=
fff81a01fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.859599] RBP: ffffffff81a01f08 R08: 00000=
000fffffffc R09: 00000000000003a0
Sep 12 09:13:53 p34 kernel: [51612.859602] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.859605] R13: 1242c75a9d675d70 R14: fffff=
fffffffffff R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.859608] FS:  0000000000000000(0000) GS:f=
fff88063fc00000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.859611] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.859613] CR2: 00007f607f3c8000 CR3: 00000=
00001a43000 CR4: 00000000000006f0
Sep 12 09:13:53 p34 kernel: [51612.859616] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.859619] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.859622] Process swapper (pid: 0, threadi=
nfo ffffffff81a00000, task ffffffff81a4b020)
Sep 12 09:13:53 p34 kernel: [51612.859624] Stack:
Sep 12 09:13:53 p34 kernel: [51612.859626]  ffffffff81a01f08 ffffffff814e7d=
92 0000000000000000 00000000000e5e53
Sep 12 09:13:53 p34 kernel: [51612.859633]  0000000000000000 00000000000e5e=
53 ffff88063fc16170 ffff88063fc16170
Sep 12 09:13:53 p34 kernel: [51612.859638]  ffff88063fc162a0 ffff880c3ffdf8=
00 ffffffff81a01f28 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.859644] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.859651]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.859656]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.859660]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.859666]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:13:53 p34 kernel: [51612.859671]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:13:53 p34 kernel: [51612.859676]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:13:53 p34 kernel: [51612.859680]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:13:53 p34 kernel: [51612.859682] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.859713] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.859717]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.859721]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.859725]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.859728]  [<ffffffff8162f309>] rest_init+=
0x6d/0x74
Sep 12 09:13:53 p34 kernel: [51612.859733]  [<ffffffff81ac4a6c>] start_kern=
el+0x2a4/0x2af
Sep 12 09:13:53 p34 kernel: [51612.859737]  [<ffffffff81ac42ee>] x86_64_sta=
rt_reservations+0xfe/0x102
Sep 12 09:13:53 p34 kernel: [51612.859741]  [<ffffffff81ac43e2>] x86_64_sta=
rt_kernel+0xf0/0xf7
Sep 12 09:13:53 p34 kernel: [51612.859745] NMI backtrace for cpu 1
Sep 12 09:13:53 p34 kernel: [51612.859748] CPU 1=20
Sep 12 09:13:53 p34 kernel: [51612.859752] Pid: 0, comm: kworker/0:0 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.859758] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.859766] RSP: 0018:ffff8806275b1e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.859768] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.859774] RDX: 0000000000000000 RSI: ffff8=
806275b1fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.859779] RBP: ffff8806275b1ee8 R08: 00000=
000fffffffc R09: 00000000000003ad
Sep 12 09:13:53 p34 kernel: [51612.859784] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.859789] R13: 1242c75a9d76849d R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.859794] FS:  0000000000000000(0000) GS:f=
fff88063fc20000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.859800] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.859805] CR2: 00007f952e86e000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.859810] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.859815] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.859820] Process kworker/0:0 (pid: 0, thr=
eadinfo ffff8806275b0000, task ffff8806275ab1e0)
Sep 12 09:13:53 p34 kernel: [51612.859826] Stack:
Sep 12 09:13:53 p34 kernel: [51612.859828]  ffff8806275b1ee8 ffffffff814e7d=
92 0000000000000000 00000000000e7913
Sep 12 09:13:53 p34 kernel: [51612.859838]  0000000000000000 00000001000e79=
13 ffff88063fc36170 ffff88063fc36170
Sep 12 09:13:53 p34 kernel: [51612.859848]  ffff88063fc362a0 00000000000000=
00 ffff8806275b1f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.859859] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.859865]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.859872]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.859879]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.859888]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.859892] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.859943] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.859948]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.859954]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.859960]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.859966]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.859973] NMI backtrace for cpu 2
Sep 12 09:13:53 p34 kernel: [51612.859977] CPU 2=20
Sep 12 09:13:53 p34 kernel: [51612.859982] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.859990] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.860000] RSP: 0018:ffff8806275c3e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.860004] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.860009] RDX: 0000000000000000 RSI: ffff8=
806275c3fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.860014] RBP: ffff8806275c3ee8 R08: 00000=
000fffffffd R09: 00000000000003ae
Sep 12 09:13:53 p34 kernel: [51612.860018] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:13:53 p34 kernel: [51612.860024] R13: 1242c75a9d7688a0 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860027] FS:  0000000000000000(0000) GS:f=
fff88063fc40000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860030] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.860033] CR2: 00007f952e86d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.860035] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860038] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.860041] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275c2000, task ffff8806275bb220)
Sep 12 09:13:53 p34 kernel: [51612.860044] Stack:
Sep 12 09:13:53 p34 kernel: [51612.860045]  ffff8806275c3ee8 ffffffff814e7d=
92 0000000000000000 00000000000e73cb
Sep 12 09:13:53 p34 kernel: [51612.860051]  0000000000000000 00000002000e73=
cb ffff88063fc56170 ffff88063fc56170
Sep 12 09:13:53 p34 kernel: [51612.860057]  ffff88063fc56240 00000000000000=
00 ffff8806275c3f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.860062] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860067]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860074]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860078]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860085]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860087] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.860126] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860131]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860137]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860142]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860148]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860154] NMI backtrace for cpu 3
Sep 12 09:13:53 p34 kernel: [51612.860158] CPU 3=20
Sep 12 09:13:53 p34 kernel: [51612.860163] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.860171] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.860180] RSP: 0018:ffff8806275d7e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.860184] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.860190] RDX: 0000000000000000 RSI: ffff8=
806275d7fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.860194] RBP: ffff8806275d7ee8 R08: 00000=
000fffffffc R09: 0000000000000398
Sep 12 09:13:53 p34 kernel: [51612.860199] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.860204] R13: 1242c75a9d771bcc R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860209] FS:  0000000000000000(0000) GS:f=
fff88063fc60000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860214] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.860217] CR2: 0000000004151e04 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.860219] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860222] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.860225] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806275d6000, task ffff8806275cf260)
Sep 12 09:13:53 p34 kernel: [51612.860227] Stack:
Sep 12 09:13:53 p34 kernel: [51612.860229]  ffff8806275d7ee8 ffffffff814e7d=
92 0000000000000000 00000000000de282
Sep 12 09:13:53 p34 kernel: [51612.860235]  0000000000000000 00000003000de2=
82 ffff88063fc76170 ffff88063fc76170
Sep 12 09:13:53 p34 kernel: [51612.860241]  ffff88063fc762a0 00000000000000=
00 ffff8806275d7f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.860246] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860251]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860256]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860260]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860266]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860270] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.860313] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860317]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860321]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860324]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860328]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860333] NMI backtrace for cpu 4
Sep 12 09:13:53 p34 kernel: [51612.860336] CPU 4=20
Sep 12 09:13:53 p34 kernel: [51612.860339] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.860344] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.860351] RSP: 0018:ffff88062760be98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.860354] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.860356] RDX: 0000000000000000 RSI: ffff8=
8062760bfd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.860359] RBP: ffff88062760bee8 R08: 00000=
000fffffffc R09: 00000000000003ac
Sep 12 09:13:53 p34 kernel: [51612.860362] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.860367] R13: 1242c75a9d76feb5 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860372] FS:  0000000000000000(0000) GS:f=
fff88063fc80000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860377] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.860381] CR2: 00007fa1ebd0d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.860386] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860390] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.860395] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062760a000, task ffff8806276052a0)
Sep 12 09:13:53 p34 kernel: [51612.860399] Stack:
Sep 12 09:13:53 p34 kernel: [51612.860401]  ffff88062760bee8 ffffffff814e7d=
92 0000000000000000 00000000000e05ed
Sep 12 09:13:53 p34 kernel: [51612.860408]  0000000000000000 00000004000e05=
ed ffff88063fc96170 ffff88063fc96170
Sep 12 09:13:53 p34 kernel: [51612.860414]  ffff88063fc962a0 00000000000000=
00 ffff88062760bf08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.860419] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860425]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860429]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860433]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860438]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860440] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.860479] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860484]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860490]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860494]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860499]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860503] NMI backtrace for cpu 5
Sep 12 09:13:53 p34 kernel: [51612.860506] CPU 5=20
Sep 12 09:13:53 p34 kernel: [51612.860509] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.860514] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.860521] RSP: 0018:ffff88062761de98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.860524] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.860526] RDX: 0000000000000000 RSI: ffff8=
8062761dfd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.860531] RBP: ffff88062761dee8 R08: 00000=
000fffffffc R09: 00000000000003a9
Sep 12 09:13:53 p34 kernel: [51612.860536] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.860539] R13: 1242c75a9d76ec11 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860542] FS:  0000000000000000(0000) GS:f=
fff88063fca0000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860545] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.860548] CR2: 00007f223aab89b8 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.860552] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860557] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.860562] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062761c000, task ffff8806276192e0)
Sep 12 09:13:53 p34 kernel: [51612.860566] Stack:
Sep 12 09:13:53 p34 kernel: [51612.860568]  ffff88062761dee8 ffffffff814e7d=
92 0000000000000000 00000000000e1139
Sep 12 09:13:53 p34 kernel: [51612.860578]  0000000000000000 00000005000e11=
39 ffff88063fcb6170 ffff88063fcb6170
Sep 12 09:13:53 p34 kernel: [51612.860588]  ffff88063fcb62a0 00000000000000=
00 ffff88062761df08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.860598] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860604]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860610]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860614]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860619]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860621] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.860652] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860656]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860660]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860663]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860667]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860671] NMI backtrace for cpu 6
Sep 12 09:13:53 p34 kernel: [51612.860676] CPU 6=20
Sep 12 09:13:53 p34 kernel: [51612.860684] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.860699] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.860718] RSP: 0018:ffff880627625e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.860727] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.860735] RDX: 0000000000000000 RSI: ffff8=
80627625fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.860745] RBP: ffff880627625ee8 R08: 00000=
000fffffffc R09: 00000000000003df
Sep 12 09:13:53 p34 kernel: [51612.860755] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.860765] R13: 1242c75a9d75d559 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860775] FS:  0000000000000000(0000) GS:f=
fff880c3fc00000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860786] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.860795] CR2: 0000000004ddb000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.860804] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.860815] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.860824] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627624000, task ffff880627618780)
Sep 12 09:13:53 p34 kernel: [51612.860835] Stack:
Sep 12 09:13:53 p34 kernel: [51612.860838]  ffff880627625ee8 ffffffff814e7d=
92 0000000000000000 00000000000f2618
Sep 12 09:13:53 p34 kernel: [51612.860858]  0000000000000000 00000006000f26=
18 ffff880c3fc16170 ffff880c3fc16170
Sep 12 09:13:53 p34 kernel: [51612.860877]  ffff880c3fc162a0 00000000000000=
00 ffff880627625f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.860893] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.860905]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.860918]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.860930]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.860944]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.860953] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.861039] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.861047]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.861057]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.861068]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.861078]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.861088] NMI backtrace for cpu 7
Sep 12 09:13:53 p34 kernel: [51612.861094] CPU 7=20
Sep 12 09:13:53 p34 kernel: [51612.861101] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.861113] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.861125] RSP: 0018:ffff88062762fe98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.861128] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.861135] RDX: 0000000000000000 RSI: ffff8=
8062762ffd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.861141] RBP: ffff88062762fee8 R08: 00000=
000fffffffc R09: 0000000000000388
Sep 12 09:13:53 p34 kernel: [51612.861146] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.861151] R13: 1242c75a9d76aadd R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861157] FS:  0000000000000000(0000) GS:f=
fff880c3fc20000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861164] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.861169] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.861175] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861180] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.861186] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062762e000, task ffff88062762d8d0)
Sep 12 09:13:53 p34 kernel: [51612.861193] Stack:
Sep 12 09:13:53 p34 kernel: [51612.861194]  ffff88062762fee8 ffffffff814e7d=
92 0000000000000000 00000000000e51df
Sep 12 09:13:53 p34 kernel: [51612.861206]  0000000000000000 00000007000e51=
df ffff880c3fc36170 ffff880c3fc36170
Sep 12 09:13:53 p34 kernel: [51612.861222]  ffff880c3fc362a0 00000000000000=
00 ffff88062762ff08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.861238] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.861247]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.861255]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.861261]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.861270]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.861275] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.861339] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.861345]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.861352]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.861359]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.861367]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.861374] NMI backtrace for cpu 8
Sep 12 09:13:53 p34 kernel: [51612.861379] CPU 8=20
Sep 12 09:13:53 p34 kernel: [51612.861387] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.861396] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.861408] RSP: 0018:ffff880627635e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.861414] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.861420] RDX: 0000000000000000 RSI: ffff8=
80627635fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.861426] RBP: ffff880627635ee8 R08: 00000=
000fffffffc R09: 0000000000000385
Sep 12 09:13:53 p34 kernel: [51612.861431] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.861437] R13: 1242c75a9d769771 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861443] FS:  0000000000000000(0000) GS:f=
fff880c3fc40000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861449] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.861455] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.861461] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861466] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.861471] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627634000, task ffff88062762cd70)
Sep 12 09:13:53 p34 kernel: [51612.861477] Stack:
Sep 12 09:13:53 p34 kernel: [51612.861479]  ffff880627635ee8 ffffffff814e7d=
92 0000000000000000 00000000000e64ab
Sep 12 09:13:53 p34 kernel: [51612.861493]  0000000000000000 00000008000e64=
ab ffff880c3fc56170 ffff880c3fc56170
Sep 12 09:13:53 p34 kernel: [51612.861506]  ffff880c3fc562a0 00000000000000=
00 ffff880627635f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.861519] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.861527]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.861537]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.861545]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.861554]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.861559] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.861621] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.861627]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.861634]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.861641]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.861648]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.861656] NMI backtrace for cpu 9
Sep 12 09:13:53 p34 kernel: [51612.861661] CPU 9=20
Sep 12 09:13:53 p34 kernel: [51612.861668] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.861677] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.861690] RSP: 0018:ffff88062763de98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.861695] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.861701] RDX: 0000000000000000 RSI: ffff8=
8062763dfd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.861706] RBP: ffff88062763dee8 R08: 00000=
000fffffffc R09: 0000000000000387
Sep 12 09:13:53 p34 kernel: [51612.861711] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.861717] R13: 1242c75a9d76a137 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861723] FS:  0000000000000000(0000) GS:f=
fff880c3fc60000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861729] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.861734] CR2: 00007f8f297df000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.861739] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861744] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.861748] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062763c000, task ffff88062762c210)
Sep 12 09:13:53 p34 kernel: [51612.861754] Stack:
Sep 12 09:13:53 p34 kernel: [51612.861755]  ffff88062763dee8 ffffffff814e7d=
92 0000000000000000 00000000000e5a80
Sep 12 09:13:53 p34 kernel: [51612.861766]  0000000000000000 00000009000e5a=
80 ffff880c3fc76170 ffff880c3fc76170
Sep 12 09:13:53 p34 kernel: [51612.861778]  ffff880c3fc762a0 00000000000000=
00 ffff88062763df08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.861790] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.861799]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.861806]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.861814]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.861824]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.861829] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.861894] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.861901]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.861908]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.861915]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.861923]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.861929] NMI backtrace for cpu 10
Sep 12 09:13:53 p34 kernel: [51612.861935] CPU 10=20
Sep 12 09:13:53 p34 kernel: [51612.861941] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.861950] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.861961] RSP: 0018:ffff880627665e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.861967] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.861974] RDX: 0000000000000000 RSI: ffff8=
80627665fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.861979] RBP: ffff880627665ee8 R08: 00000=
000fffffffc R09: 0000000000000386
Sep 12 09:13:53 p34 kernel: [51612.861984] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.861988] R13: 1242c75a9d76a04c R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.861995] FS:  0000000000000000(0000) GS:f=
fff880c3fc80000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862002] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.862007] CR2: 00007fbaef0fc000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.862013] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862018] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.862021] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627664000, task ffff88062763f360)
Sep 12 09:13:53 p34 kernel: [51612.862027] Stack:
Sep 12 09:13:53 p34 kernel: [51612.862028]  ffff880627665ee8 ffffffff814e7d=
92 0000000000000000 00000000000e5b70
Sep 12 09:13:53 p34 kernel: [51612.862041]  0000000000000000 0000000a000e5b=
70 ffff880c3fc96170 ffff880c3fc96170
Sep 12 09:13:53 p34 kernel: [51612.862055]  ffff880c3fc962a0 00000000000000=
00 ffff880627665f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.862068] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862075]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862083]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862090]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862099]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862104] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.862167] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862174]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862183]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862189]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862197]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862204] NMI backtrace for cpu 11
Sep 12 09:13:53 p34 kernel: [51612.862209] CPU 11=20
Sep 12 09:13:53 p34 kernel: [51612.862216] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.862225] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.862237] RSP: 0018:ffff88062766be98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.862242] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.862248] RDX: 0000000000000000 RSI: ffff8=
8062766bfd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.862253] RBP: ffff88062766bee8 R08: 00000=
000fffffffc R09: 000000000000039d
Sep 12 09:13:53 p34 kernel: [51612.862257] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.862263] R13: 1242c75a9d862d1b R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862268] FS:  0000000000000000(0000) GS:f=
fff880c3fca0000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862275] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.862280] CR2: 0000000002319148 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.862285] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862290] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.862295] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062766a000, task ffff88062763e800)
Sep 12 09:13:53 p34 kernel: [51612.862300] Stack:
Sep 12 09:13:53 p34 kernel: [51612.862302]  ffff88062766bee8 ffffffff814e7d=
92 0000000000000000 00000000000e1523
Sep 12 09:13:53 p34 kernel: [51612.862314]  0000000000000000 0000000b000e15=
23 ffff880c3fcb6170 ffff880c3fcb6170
Sep 12 09:13:53 p34 kernel: [51612.862326]  ffff880c3fcb62a0 00000000000000=
00 ffff88062766bf08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.862338] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862346]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862354]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862360]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862368]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862373] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.862439] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862444]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862451]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862458]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862466]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862473] NMI backtrace for cpu 12
Sep 12 09:13:53 p34 kernel: [51612.862477] CPU 12=20
Sep 12 09:13:53 p34 kernel: [51612.862481] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.862487] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.862495] RSP: 0018:ffff88062767fe98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.862499] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.862502] RDX: 0000000000000000 RSI: ffff8=
8062767ffd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.862506] RBP: ffff88062767fee8 R08: 00000=
000fffffffc R09: 0000000000000392
Sep 12 09:13:53 p34 kernel: [51612.862510] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.862514] R13: 1242c75a9d851d55 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862518] FS:  0000000000000000(0000) GS:f=
fff88063fcc0000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862523] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.862526] CR2: 00007f4341f16000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.862530] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862534] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.862538] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062767e000, task ffff880627670840)
Sep 12 09:13:53 p34 kernel: [51612.862542] Stack:
Sep 12 09:13:53 p34 kernel: [51612.862544]  ffff88062767fee8 ffffffff814e7d=
92 0000000000000000 00000000000f2291
Sep 12 09:13:53 p34 kernel: [51612.862554]  0000000000000000 0000000c000f22=
91 ffff88063fcd6170 ffff88063fcd6170
Sep 12 09:13:53 p34 kernel: [51612.862564]  ffff88063fcd62a0 00000000000000=
00 ffff88062767ff08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.862572] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862578]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862584]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862589]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862596]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862599] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.862647] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862652]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862658]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862663]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862669]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862674] NMI backtrace for cpu 13
Sep 12 09:13:53 p34 kernel: [51612.862680] CPU 13=20
Sep 12 09:13:53 p34 kernel: [51612.862683] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.862694] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.862705] RSP: 0018:ffff880627693e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.862711] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.862717] RDX: 0000000000000000 RSI: ffff8=
80627693fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.862723] RBP: ffff880627693ee8 R08: 00000=
000fffffffd R09: 00000000000003b4
Sep 12 09:13:53 p34 kernel: [51612.862729] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:13:53 p34 kernel: [51612.862736] R13: 1242c75a9d85aa66 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862743] FS:  0000000000000000(0000) GS:f=
fff88063fce0000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862750] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.862755] CR2: 0000000004e4c000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.862762] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.862768] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.862775] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627692000, task ffff880627684880)
Sep 12 09:13:53 p34 kernel: [51612.862781] Stack:
Sep 12 09:13:53 p34 kernel: [51612.862783]  ffff880627693ee8 ffffffff814e7d=
92 0000000000000000 00000000000e9585
Sep 12 09:13:53 p34 kernel: [51612.862796]  0000000000000000 0000000d000e95=
85 ffff88063fcf6170 ffff88063fcf6170
Sep 12 09:13:53 p34 kernel: [51612.862808]  ffff88063fcf6240 00000000000000=
00 ffff880627693f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.862822] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862830]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862838]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862846]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862855]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862860] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.862923] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.862930]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.862938]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.862945]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.862953]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.862960] NMI backtrace for cpu 14
Sep 12 09:13:53 p34 kernel: [51612.862964] CPU 14=20
Sep 12 09:13:53 p34 kernel: [51612.862968] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.862976] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.862985] RSP: 0018:ffff8806276c5e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.862989] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.862994] RDX: 0000000000000000 RSI: ffff8=
806276c5fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.862999] RBP: ffff8806276c5ee8 R08: 00000=
000fffffffc R09: 00000000000003b3
Sep 12 09:13:53 p34 kernel: [51612.863004] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.863008] R13: 1242c75a9d85b916 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863014] FS:  0000000000000000(0000) GS:f=
fff88063fd00000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863020] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.863024] CR2: 0000000004e5e001 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.863028] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863033] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.863040] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276c4000, task ffff8806276968c0)
Sep 12 09:13:53 p34 kernel: [51612.863046] Stack:
Sep 12 09:13:53 p34 kernel: [51612.863049]  ffff8806276c5ee8 ffffffff814e7d=
92 0000000000000000 00000000000e87c0
Sep 12 09:13:53 p34 kernel: [51612.863061]  0000000000000000 0000000e000e87=
c0 ffff88063fd16170 ffff88063fd16170
Sep 12 09:13:53 p34 kernel: [51612.863074]  ffff88063fd162a0 00000000000000=
00 ffff8806276c5f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.863087] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863096]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863102]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863108]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863115]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863119] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.863164] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863169]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863175]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863180]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863186]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863192] NMI backtrace for cpu 15
Sep 12 09:13:53 p34 kernel: [51612.863195] CPU 15=20
Sep 12 09:13:53 p34 kernel: [51612.863200] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.863207] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.863216] RSP: 0018:ffff8806276d9e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.863220] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.863225] RDX: 0000000000000000 RSI: ffff8=
806276d9fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.863230] RBP: ffff8806276d9ee8 R08: 00000=
000fffffffc R09: 0000000000000391
Sep 12 09:13:53 p34 kernel: [51612.863235] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.863240] R13: 1242c75a9d85b3a1 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863245] FS:  0000000000000000(0000) GS:f=
fff88063fd20000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863251] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.863255] CR2: 0000000004db8000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.863260] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863265] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.863270] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276d8000, task ffff8806276ca900)
Sep 12 09:13:53 p34 kernel: [51612.863275] Stack:
Sep 12 09:13:53 p34 kernel: [51612.863276]  ffff8806276d9ee8 ffffffff814e7d=
92 0000000000000000 00000000000e8cbb
Sep 12 09:13:53 p34 kernel: [51612.863287]  0000000000000000 0000000f000e8c=
bb ffff88063fd36170 ffff88063fd36170
Sep 12 09:13:53 p34 kernel: [51612.863297]  ffff88063fd362a0 00000000000000=
00 ffff8806276d9f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.863304] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863308]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863313]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863316]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863321]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863323] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.863364] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863368]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863374]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863380]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863385]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863391] NMI backtrace for cpu 16
Sep 12 09:13:53 p34 kernel: [51612.863394] CPU 16=20
Sep 12 09:13:53 p34 kernel: [51612.863399] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.863405] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.863414] RSP: 0018:ffff8806276ede98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.863418] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.863422] RDX: 0000000000000000 RSI: ffff8=
806276edfd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.863426] RBP: ffff8806276edee8 R08: 00000=
000fffffffd R09: 0000000000000399
Sep 12 09:13:53 p34 kernel: [51612.863431] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:13:53 p34 kernel: [51612.863435] R13: 1242c75a9d851e36 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863440] FS:  0000000000000000(0000) GS:f=
fff88063fd40000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863446] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.863449] CR2: 0000000004c92000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.863454] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863459] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.863464] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff8806276ec000, task ffff8806276de600)
Sep 12 09:13:53 p34 kernel: [51612.863468] Stack:
Sep 12 09:13:53 p34 kernel: [51612.863470]  ffff8806276edee8 ffffffff814e7d=
92 0000000000000000 00000000000f21a6
Sep 12 09:13:53 p34 kernel: [51612.863478]  0000000000000000 00000010000f21=
a6 ffff88063fd56170 ffff88063fd56170
Sep 12 09:13:53 p34 kernel: [51612.863487]  ffff88063fd56240 00000000000000=
00 ffff8806276edf08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.863495] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863500]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863506]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863511]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863518]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863522] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.863566] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863571]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863577]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863582]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863588]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863593] NMI backtrace for cpu 17
Sep 12 09:13:53 p34 kernel: [51612.863597] CPU 17=20
Sep 12 09:13:53 p34 kernel: [51612.863601] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.863609] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.863618] RSP: 0018:ffff88062771de98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.863622] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.863627] RDX: 0000000000000000 RSI: ffff8=
8062771dfd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.863629] RBP: ffff88062771dee8 R08: 00000=
000fffffffd R09: 000000000000039a
Sep 12 09:13:53 p34 kernel: [51612.863632] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:13:53 p34 kernel: [51612.863635] R13: 1242c75a9d851f12 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863638] FS:  0000000000000000(0000) GS:f=
fff88063fd60000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863641] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.863643] CR2: 0000000004ca2000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.863646] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863649] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.863654] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062771c000, task ffff8806276f0640)
Sep 12 09:13:53 p34 kernel: [51612.863658] Stack:
Sep 12 09:13:53 p34 kernel: [51612.863660]  ffff88062771dee8 ffffffff814e7d=
92 0000000000000000 00000000000f1fad
Sep 12 09:13:53 p34 kernel: [51612.863669]  0000000000000000 00000011000f1f=
ad ffff88063fd76170 ffff88063fd76170
Sep 12 09:13:53 p34 kernel: [51612.863678]  ffff88063fd76240 00000000000000=
00 ffff88062771df08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.863686] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863691]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863698]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863703]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863710]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863714] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.863757] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863762]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.863768]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.863773]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863779]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.863784] NMI backtrace for cpu 18
Sep 12 09:13:53 p34 kernel: [51612.863789] CPU 18=20
Sep 12 09:13:53 p34 kernel: [51612.863795] Pid: 1045, comm: kswapd1 Not tai=
nted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.863804] RIP: 0010:[<ffffffff812a87f2>]  =
[<ffffffff812a87f2>] delay_tsc+0x22/0x60
Sep 12 09:13:53 p34 kernel: [51612.863815] RSP: 0018:ffff880c3fcc3d58  EFLA=
GS: 00000093
Sep 12 09:13:53 p34 kernel: [51612.863821] RAX: 0000000050e5dee8 RBX: 00000=
000000003e9 RCX: 0000000000000023
Sep 12 09:13:53 p34 kernel: [51612.863827] RDX: 0000000000000030 RSI: 00000=
00050e5deb8 RDI: 000000000003a97d
Sep 12 09:13:53 p34 kernel: [51612.863833] RBP: ffff880c3fcc3d58 R08: 00000=
00000000012 R09: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863836] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000001000
Sep 12 09:13:53 p34 kernel: [51612.863838] R13: ffffffff81aa8d50 R14: 00000=
00000000400 R15: 0000000000000092
Sep 12 09:13:53 p34 kernel: [51612.863842] FS:  0000000000000000(0000) GS:f=
fff880c3fcc0000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863845] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.863847] CR2: 00007f15dc551000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.863850] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.863852] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.863855] Process kswapd1 (pid: 1045, thre=
adinfo ffff880626782000, task ffff880626d2a840)
Sep 12 09:13:53 p34 kernel: [51612.863858] Stack:
Sep 12 09:13:53 p34 kernel: [51612.863859]  ffff880c3fcc3d68 ffffffff812a88=
5a ffff880c3fcc3d78 ffffffff812a8887
Sep 12 09:13:53 p34 kernel: [51612.863866]  ffff880c3fcc3d98 ffffffff81019c=
3a 0000000000000002 000000000000c502
Sep 12 09:13:53 p34 kernel: [51612.863871]  ffff880c3fcc3de8 ffffffff8101a8=
e8 7fffffff00000023 0000000000000013
Sep 12 09:13:53 p34 kernel: [51612.863884] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.863888]  <IRQ>=20
Sep 12 09:13:53 p34 kernel: [51612.863894]  [<ffffffff812a885a>] __delay+0x=
a/0x10
Sep 12 09:13:53 p34 kernel: [51612.863901]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:13:53 p34 kernel: [51612.863911]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:13:53 p34 kernel: [51612.863920]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:13:53 p34 kernel: [51612.863930]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:13:53 p34 kernel: [51612.863938]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:13:53 p34 kernel: [51612.863946]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:13:53 p34 kernel: [51612.863954]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:13:53 p34 kernel: [51612.863965]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:13:53 p34 kernel: [51612.863976]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:13:53 p34 kernel: [51612.863985]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:13:53 p34 kernel: [51612.863993]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:13:53 p34 kernel: [51612.864000]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:13:53 p34 kernel: [51612.864009]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:13:53 p34 kernel: [51612.864015]  <EOI>=20
Sep 12 09:13:53 p34 kernel: [51612.864021]  [<ffffffff8107a981>] ? find_get=
_pages+0x61/0x150
Sep 12 09:13:53 p34 kernel: [51612.864032]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:13:53 p34 kernel: [51612.864040]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:13:53 p34 kernel: [51612.864051]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:13:53 p34 kernel: [51612.864059]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:13:53 p34 kernel: [51612.864066]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:13:53 p34 kernel: [51612.864074]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:13:53 p34 kernel: [51612.864082]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:13:53 p34 kernel: [51612.864089]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:13:53 p34 kernel: [51612.864096]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:13:53 p34 kernel: [51612.864105]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:13:53 p34 kernel: [51612.864111]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:13:53 p34 kernel: [51612.864118]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:13:53 p34 kernel: [51612.864123] Code: c8 5d c3 66 0f 1f 44 00 00=
 55 65 44 8b 04 25 f0 c4 00 00 48 89 e5 0f 1f 00 0f ae e8 0f 31 89 c6 eb 16=
 0f 1f 80 00 00 00 00 f3 90=20
Sep 12 09:13:53 p34 kernel: <65>[51612.864171]  8b 0c 25 f0 c4 00 00 41 39 =
c8 75 17 0f 1f 00 0f ae e8 0f 31=20
Sep 12 09:13:53 p34 kernel: [51612.864197] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.864200]  <IRQ>  [<ffffffff812a885a>] __d=
elay+0xa/0x10
Sep 12 09:13:53 p34 kernel: [51612.864210]  [<ffffffff812a8887>] __const_ud=
elay+0x27/0x30
Sep 12 09:13:53 p34 kernel: [51612.864218]  [<ffffffff81019c3a>] native_saf=
e_apic_wait_icr_idle+0x1a/0x50
Sep 12 09:13:53 p34 kernel: [51612.864226]  [<ffffffff8101a8e8>] default_se=
nd_IPI_mask_sequence_phys+0xb8/0xd0
Sep 12 09:13:53 p34 kernel: [51612.864234]  [<ffffffff8101d462>] physflat_s=
end_IPI_all+0x12/0x20
Sep 12 09:13:53 p34 kernel: [51612.864241]  [<ffffffff8101aae5>] arch_trigg=
er_all_cpu_backtrace+0x55/0x90
Sep 12 09:13:53 p34 kernel: [51612.864249]  [<ffffffff8106e189>] __rcu_pend=
ing+0x169/0x3a0
Sep 12 09:13:53 p34 kernel: [51612.864257]  [<ffffffff8106eef7>] rcu_check_=
callbacks+0x67/0x120
Sep 12 09:13:53 p34 kernel: [51612.864264]  [<ffffffff81041f93>] update_pro=
cess_times+0x43/0x80
Sep 12 09:13:53 p34 kernel: [51612.864272]  [<ffffffff8105ef7f>] tick_sched=
_timer+0x5f/0xb0
Sep 12 09:13:53 p34 kernel: [51612.864279]  [<ffffffff8105315d>] __run_hrti=
mer.isra.34+0x4d/0x100
Sep 12 09:13:53 p34 kernel: [51612.864287]  [<ffffffff81053bbf>] hrtimer_in=
terrupt+0xdf/0x200
Sep 12 09:13:53 p34 kernel: [51612.864294]  [<ffffffff81019ee4>] smp_apic_t=
imer_interrupt+0x64/0xa0
Sep 12 09:13:53 p34 kernel: [51612.864302]  [<ffffffff816481d3>] apic_timer=
_interrupt+0x13/0x20
Sep 12 09:13:53 p34 kernel: [51612.864307]  <EOI>  [<ffffffff8107a981>] ? f=
ind_get_pages+0x61/0x150
Sep 12 09:13:53 p34 kernel: [51612.864321]  [<ffffffff8108597d>] pagevec_lo=
okup+0x1d/0x30
Sep 12 09:13:53 p34 kernel: [51612.864329]  [<ffffffff8108607f>] invalidate=
_mapping_pages+0x5f/0x170
Sep 12 09:13:53 p34 kernel: [51612.864337]  [<ffffffff810d37b5>] shrink_ica=
che_memory+0x2d5/0x320
Sep 12 09:13:53 p34 kernel: [51612.864342]  [<ffffffff81086f5d>] shrink_sla=
b+0x11d/0x190
Sep 12 09:13:53 p34 kernel: [51612.864345]  [<ffffffff81089d6a>] balance_pg=
dat+0x4fa/0x6a0
Sep 12 09:13:53 p34 kernel: [51612.864349]  [<ffffffff81089fc3>] kswapd+0xb=
3/0x250
Sep 12 09:13:53 p34 kernel: [51612.864352]  [<ffffffff8104fea0>] ? abort_ex=
clusive_wait+0xb0/0xb0
Sep 12 09:13:53 p34 kernel: [51612.864356]  [<ffffffff81089f10>] ? balance_=
pgdat+0x6a0/0x6a0
Sep 12 09:13:53 p34 kernel: [51612.864359]  [<ffffffff8104f457>] kthread+0x=
87/0x90
Sep 12 09:13:53 p34 kernel: [51612.864363]  [<ffffffff81648814>] kernel_thr=
ead_helper+0x4/0x10
Sep 12 09:13:53 p34 kernel: [51612.864367]  [<ffffffff8104f3d0>] ? kthread_=
flush_work_fn+0x10/0x10
Sep 12 09:13:53 p34 kernel: [51612.864374]  [<ffffffff81648810>] ? gs_chang=
e+0xb/0xb
Sep 12 09:13:53 p34 kernel: [51612.864419] NMI backtrace for cpu 19
Sep 12 09:13:53 p34 kernel: [51612.864424] CPU 19=20
Sep 12 09:13:53 p34 kernel: [51612.864431] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.864441] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.864452] RSP: 0018:ffff88062772fe98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.864457] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.864463] RDX: 0000000000000000 RSI: ffff8=
8062772ffd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.864469] RBP: ffff88062772fee8 R08: 00000=
000fffffffd R09: 00000000000003b4
Sep 12 09:13:53 p34 kernel: [51612.864475] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:13:53 p34 kernel: [51612.864484] R13: 1242c75a9db38f70 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864489] FS:  0000000000000000(0000) GS:f=
fff880c3fce0000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864494] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.864499] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.864502] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864505] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.864508] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062772e000, task ffff880627724c30)
Sep 12 09:13:53 p34 kernel: [51612.864510] Stack:
Sep 12 09:13:53 p34 kernel: [51612.864512]  ffff88062772fee8 ffffffff814e7d=
92 0000000000000000 00000000000e7763
Sep 12 09:13:53 p34 kernel: [51612.864523]  0000000000000000 00000013000e77=
63 ffff880c3fcf6170 ffff880c3fcf6170
Sep 12 09:13:53 p34 kernel: [51612.864538]  ffff880c3fcf6240 00000000000000=
00 ffff88062772ff08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.864552] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.864560]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.864568]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.864574]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.864581]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.864587] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.864653] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.864656]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.864661]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.864664]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.864668]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.864672] NMI backtrace for cpu 20
Sep 12 09:13:53 p34 kernel: [51612.864675] CPU 20=20
Sep 12 09:13:53 p34 kernel: [51612.864679] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.864691] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.864698] RSP: 0018:ffff880627735e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.864700] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.864703] RDX: 0000000000000000 RSI: ffff8=
80627735fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.864706] RBP: ffff880627735ee8 R08: 00000=
000fffffffd R09: 000000000000039d
Sep 12 09:13:53 p34 kernel: [51612.864708] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:13:53 p34 kernel: [51612.864711] R13: 1242c75a9db397fe R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864714] FS:  0000000000000000(0000) GS:f=
fff880c3fd00000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864717] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.864720] CR2: 0000000004e42000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.864722] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864725] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.864728] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627734000, task ffff8806277240d0)
Sep 12 09:13:53 p34 kernel: [51612.864731] Stack:
Sep 12 09:13:53 p34 kernel: [51612.864732]  ffff880627735ee8 ffffffff814e7d=
92 0000000000000000 00000000000e6de3
Sep 12 09:13:53 p34 kernel: [51612.864738]  0000000000000000 00000014000e6d=
e3 ffff880c3fd16170 ffff880c3fd16170
Sep 12 09:13:53 p34 kernel: [51612.864748]  ffff880c3fd16240 00000000000000=
00 ffff880627735f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.864762] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.864771]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.864779]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.864786]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.864794]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.864799] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.864872] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.864878]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.864887]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.864893]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.864901]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.864908] NMI backtrace for cpu 21
Sep 12 09:13:53 p34 kernel: [51612.864914] CPU 21=20
Sep 12 09:13:53 p34 kernel: [51612.864920] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.864930] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.864943] RSP: 0018:ffff88062773fe98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.864948] RAX: 0000000000000010 RBX: 00000=
00000000004 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.864954] RDX: 0000000000000000 RSI: ffff8=
8062773ffd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.864961] RBP: ffff88062773fee8 R08: 00000=
000fffffffd R09: 00000000000003b5
Sep 12 09:13:53 p34 kernel: [51612.864967] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000010
Sep 12 09:13:53 p34 kernel: [51612.864973] R13: 1242c75a9dc333ca R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864979] FS:  0000000000000000(0000) GS:f=
fff880c3fd20000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.864986] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.864992] CR2: 00007f0546a71de0 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.864998] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.865004] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.865010] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062773e000, task ffff880627739220)
Sep 12 09:13:53 p34 kernel: [51612.865016] Stack:
Sep 12 09:13:53 p34 kernel: [51612.865018]  ffff88062773fee8 ffffffff814e7d=
92 0000000000000000 00000000000e1682
Sep 12 09:13:53 p34 kernel: [51612.865034]  0000000000000000 00000015000e16=
82 ffff880c3fd36170 ffff880c3fd36170
Sep 12 09:13:53 p34 kernel: [51612.865049]  ffff880c3fd36240 00000000000000=
00 ffff88062773ff08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.865054] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.865059]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.865064]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.865068]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.865073]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.865075] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.865146] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.865153]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.865161]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.865168]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.865175]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.865183] NMI backtrace for cpu 22
Sep 12 09:13:53 p34 kernel: [51612.865188] CPU 22=20
Sep 12 09:13:53 p34 kernel: [51612.865195] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.865205] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.865218] RSP: 0018:ffff880627747e98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.865224] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.865230] RDX: 0000000000000000 RSI: ffff8=
80627747fd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.865235] RBP: ffff880627747ee8 R08: 00000=
000fffffffc R09: 0000000000000399
Sep 12 09:13:53 p34 kernel: [51612.865242] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.865247] R13: 1242c75a9dc330f8 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.865254] FS:  0000000000000000(0000) GS:f=
fff880c3fd40000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.865260] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.865266] CR2: 00007f95ee884000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.865271] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.865277] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.865283] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff880627746000, task ffff8806277386c0)
Sep 12 09:13:53 p34 kernel: [51612.865289] Stack:
Sep 12 09:13:53 p34 kernel: [51612.865292]  ffff880627747ee8 ffffffff814e7d=
92 0000000000000000 00000000000e1a6a
Sep 12 09:13:53 p34 kernel: [51612.865306]  0000000000000000 00000016000e1a=
6a ffff880c3fd56170 ffff880c3fd56170
Sep 12 09:13:53 p34 kernel: [51612.865319]  ffff880c3fd562a0 00000000000000=
00 ffff880627747f08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.865334] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.865341]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.865349]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.865356]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.865364]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.865369] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.865439] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.865444]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.865448]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.865451]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.865455]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.865459] NMI backtrace for cpu 23
Sep 12 09:13:53 p34 kernel: [51612.865462] CPU 23=20
Sep 12 09:13:53 p34 kernel: [51612.865470] Pid: 0, comm: kworker/0:1 Not ta=
inted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
Sep 12 09:13:53 p34 kernel: [51612.865480] RIP: 0010:[<ffffffff812d64f2>]  =
[<ffffffff812d64f2>] intel_idle+0x92/0x110
Sep 12 09:13:53 p34 kernel: [51612.865494] RSP: 0018:ffff88062774fe98  EFLA=
GS: 00000046
Sep 12 09:13:53 p34 kernel: [51612.865503] RAX: 0000000000000020 RBX: 00000=
00000000008 RCX: 0000000000000001
Sep 12 09:13:53 p34 kernel: [51612.865513] RDX: 0000000000000000 RSI: ffff8=
8062774ffd8 RDI: ffffffff81a4d300
Sep 12 09:13:53 p34 kernel: [51612.865524] RBP: ffff88062774fee8 R08: 00000=
000fffffffc R09: 00000000000003e2
Sep 12 09:13:53 p34 kernel: [51612.865534] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000020
Sep 12 09:13:53 p34 kernel: [51612.865543] R13: 1242c75a9dc21ba9 R14: 00000=
00000000000 R15: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.865554] FS:  0000000000000000(0000) GS:f=
fff880c3fd60000(0000) knlGS:0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.865565] CS:  0010 DS: 0000 ES: 0000 CR0:=
 000000008005003b
Sep 12 09:13:53 p34 kernel: [51612.865574] CR2: 0000000004c9d000 CR3: 00000=
00001a43000 CR4: 00000000000006e0
Sep 12 09:13:53 p34 kernel: [51612.865584] DR0: 0000000000000000 DR1: 00000=
00000000000 DR2: 0000000000000000
Sep 12 09:13:53 p34 kernel: [51612.865595] DR3: 0000000000000000 DR6: 00000=
000ffff0ff0 DR7: 0000000000000400
Sep 12 09:13:53 p34 kernel: [51612.865606] Process kworker/0:1 (pid: 0, thr=
eadinfo ffff88062774e000, task ffff88062774d810)
Sep 12 09:13:53 p34 kernel: [51612.865617] Stack:
Sep 12 09:13:53 p34 kernel: [51612.865621]  ffff88062774fee8 ffffffff814e7d=
92 0000000000000000 00000000000f2b3d
Sep 12 09:13:53 p34 kernel: [51612.865643]  0000000000000000 00000017000f2b=
3d ffff880c3fd76170 ffff880c3fd76170
Sep 12 09:13:53 p34 kernel: [51612.865654]  ffff880c3fd762a0 00000000000000=
00 ffff88062774ff08 ffffffff814e6bb6
Sep 12 09:13:53 p34 kernel: [51612.865662] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.865667]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.865672]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.865678]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.865690]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 09:13:53 p34 kernel: [51612.865699] Code: 28 e0 ff ff 83 e2 08 75 22=
 31 d2 48 83 c0 10 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75=
 08 b1 01 4c 89 e0 0f 01 c9 <e8> b9 1c d8 ff 4c 29 e8 48 89 c7 e8 fe 3f d6 =
ff 4c 69 e0 40 42=20
Sep 12 09:13:53 p34 kernel: [51612.865790] Call Trace:
Sep 12 09:13:53 p34 kernel: [51612.865799]  [<ffffffff814e7d92>] ? menu_sel=
ect+0xe2/0x360
Sep 12 09:13:53 p34 kernel: [51612.865811]  [<ffffffff814e6bb6>] cpuidle_id=
le_call+0x76/0xe0
Sep 12 09:13:53 p34 kernel: [51612.865823]  [<ffffffff810006ad>] cpu_idle+0=
x5d/0xb0
Sep 12 09:13:53 p34 kernel: [51612.865835]  [<ffffffff81af79dd>] start_seco=
ndary+0x19a/0x19e
Sep 12 10:55:34 p34 kernel: [57704.867087] nfs: server atomw not responding=
, still trying
Sep 12 10:55:46 p34 kernel: [57717.232427] nfs: server atomw not responding=
, still trying
Sep 12 10:55:46 p34 kernel: [57717.352217] nfs: server atomw not responding=
, still trying
Sep 12 10:55:47 p34 kernel: [57717.689714] nfs: server atomw not responding=
, still trying
Sep 12 11:09:09 p34 kernel: [58519.196311] nfs: server atomw OK
Sep 12 11:09:09 p34 kernel: [58519.197588] nfs: server atomw OK
Sep 12 11:09:09 p34 kernel: [58519.197831] nfs: server atomw OK
Sep 12 11:09:11 p34 kernel: [58521.059101] nfs: server atomw OK

Justin.

--655872-1209471688-1315840531=:16088--
