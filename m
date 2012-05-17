Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab2EQVb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab2EQVbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:31:24 -0400
Date: Thu, 17 May 2012 17:31:20 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.4-rc7 numa_policy slab poison.
Message-ID: <20120517213120.GA12329@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just found this while fuzzing.

	Dave

[ 7613.229315] =============================================================================
[ 7613.229955] BUG numa_policy (Not tainted): Poison overwritten
[ 7613.230560] -----------------------------------------------------------------------------
[ 7613.230560] 
[ 7613.231834] INFO: 0xffff880146498250-0xffff880146498250. First byte 0x6a instead of 0x6b
[ 7613.232518] INFO: Allocated in mpol_new+0xa3/0x140 age=46310 cpu=6 pid=32154
[ 7613.233188] 	__slab_alloc+0x3d3/0x445
[ 7613.233877] 	kmem_cache_alloc+0x29d/0x2b0
[ 7613.234564] 	mpol_new+0xa3/0x140
[ 7613.235236] 	sys_mbind+0x142/0x620
[ 7613.235929] 	system_call_fastpath+0x16/0x1b
[ 7613.236640] INFO: Freed in __mpol_put+0x27/0x30 age=46268 cpu=6 pid=32154
[ 7613.237354] 	__slab_free+0x2e/0x1de
[ 7613.238080] 	kmem_cache_free+0x25a/0x260
[ 7613.238799] 	__mpol_put+0x27/0x30
[ 7613.239515] 	remove_vma+0x68/0x90
[ 7613.240223] 	exit_mmap+0x118/0x140
[ 7613.240939] 	mmput+0x73/0x110
[ 7613.241651] 	exit_mm+0x108/0x130
[ 7613.242367] 	do_exit+0x162/0xb90
[ 7613.243074] 	do_group_exit+0x4f/0xc0
[ 7613.243790] 	sys_exit_group+0x17/0x20
[ 7613.244507] 	system_call_fastpath+0x16/0x1b
[ 7613.245212] INFO: Slab 0xffffea0005192600 objects=27 used=27 fp=0x          (null) flags=0x20000000004080
[ 7613.246000] INFO: Object 0xffff880146498250 @offset=592 fp=0xffff88014649b9d0
[ 7613.246001] 
[ 7613.247537] Bytes b4 ffff880146498240: 4d c4 6f 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  M.o.....ZZZZZZZZ
[ 7613.248356] Object ffff880146498250: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
[ 7613.249182] Object ffff880146498260: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.250014] Object ffff880146498270: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.250832] Object ffff880146498280: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.251630] Object ffff880146498290: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.252411] Object ffff8801464982a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.253191] Object ffff8801464982b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.253959] Object ffff8801464982c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.254718] Object ffff8801464982d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.255458] Object ffff8801464982e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.256176] Object ffff8801464982f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.256878] Object ffff880146498300: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.257563] Object ffff880146498310: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.258211] Object ffff880146498320: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.258858] Object ffff880146498330: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.259495] Object ffff880146498340: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 7613.260097] Object ffff880146498350: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
[ 7613.260698] Redzone ffff880146498358: bb bb bb bb bb bb bb bb                          ........
[ 7613.261277] Padding ffff880146498498: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[ 7613.261880] Pid: 2679, comm: trinity Not tainted 3.4.0-rc7+ #9
[ 7613.262474] Call Trace:
[ 7613.263039]  [<ffffffff8118cc2d>] ? print_section+0x3d/0x40
[ 7613.263633]  [<ffffffff8118cfd8>] print_trailer+0xe8/0x160
[ 7613.264197]  [<ffffffff8118d180>] check_bytes_and_report+0xe0/0x120
[ 7613.264772]  [<ffffffff8118df6a>] check_object+0x22a/0x270
[ 7613.265344]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[ 7613.265876]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[ 7613.266420]  [<ffffffff8162ff92>] alloc_debug_processing+0x65/0xef
[ 7613.266942]  [<ffffffff81630862>] __slab_alloc+0x3d3/0x445
[ 7613.267482]  [<ffffffff8116b0f7>] ? __split_vma+0x77/0x270
[ 7613.268007]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[ 7613.268561]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[ 7613.269071]  [<ffffffff81190cad>] kmem_cache_alloc+0x29d/0x2b0
[ 7613.269601]  [<ffffffff8116b0f7>] ? __split_vma+0x77/0x270
[ 7613.270105]  [<ffffffff81184fc9>] __mpol_dup+0x29/0x1f0
[ 7613.270629]  [<ffffffff81190bc3>] ? kmem_cache_alloc+0x1b3/0x2b0
[ 7613.271140]  [<ffffffff810856a1>] ? get_parent_ip+0x11/0x50
[ 7613.271679]  [<ffffffff8116b0f7>] ? __split_vma+0x77/0x270
[ 7613.272198]  [<ffffffff8116b159>] __split_vma+0xd9/0x270
[ 7613.272739]  [<ffffffff8116b7fa>] do_munmap+0x10a/0x3a0
[ 7613.273258]  [<ffffffff81636ee5>] ? down_write+0x95/0xb0
[ 7613.273796]  [<ffffffff8116bf23>] ? sys_brk+0x43/0x130
[ 7613.274344]  [<ffffffff8116c001>] sys_brk+0x121/0x130
[ 7613.274863]  [<ffffffff816416d2>] system_call_fastpath+0x16/0x1b
[ 7613.275401] FIX numa_policy: Restoring 0xffff880146498250-0xffff880146498250=0x6b
[ 7613.275402] 
[ 7613.276416] FIX numa_policy: Marking all objects used
[ 8736.474054] DCCP: Activated CCID 2 (TCP-like)
[ 8736.475627] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[10900.079149] =============================================================================
[10900.079701] BUG numa_policy (Not tainted): Poison overwritten
[10900.080387] -----------------------------------------------------------------------------
[10900.080389] 
[10900.081772] INFO: 0xffff880136e14000-0xffff880136e14000. First byte 0x6a instead of 0x6b
[10900.082426] INFO: Allocated in mpol_new+0xa3/0x140 age=1816176 cpu=0 pid=25145
[10900.083233] 	__slab_alloc+0x3d3/0x445
[10900.084064] 	kmem_cache_alloc+0x29d/0x2b0
[10900.084883] 	mpol_new+0xa3/0x140
[10900.085713] 	sys_mbind+0x142/0x620
[10900.086562] 	system_call_fastpath+0x16/0x1b
[10900.087418] INFO: Freed in __mpol_put+0x27/0x30 age=1816181 cpu=0 pid=25145
[10900.088295] 	__slab_free+0x2e/0x1de
[10900.089181] 	kmem_cache_free+0x25a/0x260
[10900.090004] 	__mpol_put+0x27/0x30
[10900.090757] 	sys_mbind+0x3ed/0x620
[10900.091575] 	system_call_fastpath+0x16/0x1b
[10900.092290] INFO: Slab 0xffffea0004db8500 objects=27 used=27 fp=0x          (null) flags=0x20000000004080
[10900.093026] INFO: Object 0xffff880136e14000 @offset=0 fp=0xffff880136e179d0
[10900.093027] 
[10900.094732] Object ffff880136e14000: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
[10900.095667] Object ffff880136e14010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.096602] Object ffff880136e14020: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.097568] Object ffff880136e14030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.098447] Object ffff880136e14040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.099306] Object ffff880136e14050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.100150] Object ffff880136e14060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.101051] Object ffff880136e14070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.101980] Object ffff880136e14080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.102847] Object ffff880136e14090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.103745] Object ffff880136e140a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.104622] Object ffff880136e140b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.105479] Object ffff880136e140c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.106247] Object ffff880136e140d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.107011] Object ffff880136e140e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.107781] Object ffff880136e140f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[10900.108524] Object ffff880136e14100: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
[10900.109253] Redzone ffff880136e14108: bb bb bb bb bb bb bb bb                          ........
[10900.110010] Padding ffff880136e14248: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[10900.110779] Pid: 31192, comm: trinity Not tainted 3.4.0-rc7+ #9
[10900.111541] Call Trace:
[10900.112265]  [<ffffffff8118cc2d>] ? print_section+0x3d/0x40
[10900.113031]  [<ffffffff8118cfd8>] print_trailer+0xe8/0x160
[10900.113776]  [<ffffffff8118d180>] check_bytes_and_report+0xe0/0x120
[10900.114510]  [<ffffffff8118df6a>] check_object+0x22a/0x270
[10900.115233]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[10900.115958]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[10900.116682]  [<ffffffff8162ff92>] alloc_debug_processing+0x65/0xef
[10900.117368]  [<ffffffff81630862>] __slab_alloc+0x3d3/0x445
[10900.118073]  [<ffffffff8116b0f7>] ? __split_vma+0x77/0x270
[10900.118761]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[10900.119403]  [<ffffffff81184fc9>] ? __mpol_dup+0x29/0x1f0
[10900.120040]  [<ffffffff81190cad>] kmem_cache_alloc+0x29d/0x2b0
[10900.120668]  [<ffffffff8116b0f7>] ? __split_vma+0x77/0x270
[10900.121268]  [<ffffffff81184fc9>] __mpol_dup+0x29/0x1f0
[10900.121886]  [<ffffffff81190bc3>] ? kmem_cache_alloc+0x1b3/0x2b0
[10900.122502]  [<ffffffff8116b0f7>] ? __split_vma+0x77/0x270
[10900.123125]  [<ffffffff8116b159>] __split_vma+0xd9/0x270
[10900.123748]  [<ffffffff8116cf20>] split_vma+0x20/0x30
[10900.124339]  [<ffffffff811699b9>] mlock_fixup+0x159/0x1a0
[10900.124941]  [<ffffffff81169b5f>] do_mlock+0xbf/0x100
[10900.125550]  [<ffffffff81169bf4>] ? sys_mlock+0x54/0x130
[10900.126135]  [<ffffffff81169c87>] sys_mlock+0xe7/0x130
[10900.126751]  [<ffffffff816416d2>] system_call_fastpath+0x16/0x1b
[10900.127340] FIX numa_policy: Restoring 0xffff880136e14000-0xffff880136e14000=0x6b
[10900.127341] 
[10900.128569] FIX numa_policy: Marking all objects used

