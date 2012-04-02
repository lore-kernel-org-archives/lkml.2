Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2DBNWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 09:22:41 -0400
Received: from sam.nabble.com ([216.139.236.26]:46263 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab2DBNWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 09:22:40 -0400
Message-ID: <33544993.post@talk.nabble.com>
Date: Mon, 2 Apr 2012 06:22:39 -0700 (PDT)
From: Akifumi Chikazawa <chikazawa.akifu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: kernel crash on P4080DS
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: chikazawa.akifu@jp.fujitsu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A kernel panic has occurred when the driver do ioremap over and over on
P4080DS.  
There are two cases where the kernel panic occurs.
Could you give me some advice or information, please?
I can give more informations if you need it.

One is as follows
System could cause kernel panic in the map_page() function
(arch/powerpc/mm/ptgtable_32.c).
This was due to BUG_ON. so I checked the condition.
But it is not true (it means pte_val(*pt) is 0).
and It does'nt depend on the paticular adderss. 


kernel version: 2.6.36.2
architecture: powerpc/e500mc
processor: P4080
board: P4080DS


  [   60.190019] ------------[ cut here ]------------
  [   60.194630] kernel BUG at arch/powerpc/mm/pgtable_32.c:288!
  [   60.200195] Oops: Exception in kernel mode, sig: 5 [#1]
  [   60.205411] SMP NR_CPUS=8 P4080 DS
  [   60.208808] last sysfs file:
  
/sys/devices/pci0001:02/0001:02:00.0/0001:03:00.0/host0/target0:0:0/0:0:0:0/block/sda/size
  [   60.219580] Modules linked in: cthermo binfmt_misc dm_mod [last
unloaded:
   scsi_wait_scan]
  [   60.227773] NIP: c00154b4 LR: c0015464 CTR: 00000000
  [   60.232730] REGS: ea52fd30 TRAP: 0700   Not tainted  (2.6.36.2)
  [   60.238639] MSR: 00029002 <EE,ME,CE>  CR: 42000488  XER: 00000000
  [   60.244752] TASK = ebf1b380[3289] 'cthermo_tp' THREAD: ea52e000 CPU: 1
  [   60.251101] GPR00: 00000001 ea52fde0 ebf1b380 fffffff4 00029002
0000000c
  000e0000 00541215
  [   60.259479] GPR08: 000000d0 00000000 c07c0000 00000001 0fffffff
10018c2c
  00000077 00000000 
  [   60.267858] GPR16: 1001453c 00000000 bfc36454 00000020 00000000
00000000
  100dab00 00000000
  [   60.276238] GPR24: 00000000 0000000c 000e0000 c0782000 c059e5b8
00541215
  fceae000 eaa83570
  [   60.284800] NIP [c00154b4] map_page+0xd8/0x138
  [   60.289236] LR [c0015464] map_page+0x88/0x138
  [   60.293583] Call Trace:
  [   60.296022] [ea52fde0] [c0015464] map_page+0x88/0x138 (unreliable)
  [   60.302203] [ea52fe10] [c001573c] __ioremap_caller+0x19c/0x214
  [   60.308039] [ea52fe50] [f953be24] Setup_ioremap+0x4c/0x158 [cthermo]
  [   60.314391] [ea52fe70] [f953bfd8] lock_ioctl+0xa8/0x31c [cthermo]
  [   60.320485] [ea52feb0] [c010e0bc] do_vfs_ioctl+0x6a4/0x74c
  [   60.325968] [ea52ff10] [c010e1cc] sys_ioctl+0x68/0xa8
  [   60.331019] [ea52ff40] [c000ebc0] ret_from_syscall+0x0/0x3c
  [   60.336588] --- Exception: c01 at 0xff5f3c4
  [   60.336590]     LR = 0xffecb40
  [   60.343805] Instruction dump:
  [   60.346767] 4856f081 2f9f0000 3860fff4 419e0058 813f0004 38000000
712b0001
  41820014
  [   60.354537] 7fa9fe70 7d20ea78 7c004850 54000ffe <0f000000> 5739a016
  5747a33e 7f273b78
  [   60.362482] ---[ end trace 2241f4aa422ec8d9 ]---


The Other is as follows
I have no idea what is caused karnel panic.

kernel version: 2.6.36.2
architecture: powerpc/e500mc
processor: P4080
board: P4080DS
 
[   90.732024] Unable to handle kernel paging request for data at address
0x00000000
[   90.739509] Faulting instruction address: 0xc006ed50
[   90.744469] Oops: Kernel access of bad area, sig: 11 [#1]
[   90.749858] SMP NR_CPUS=8 P4080 DS
[   90.753255] last sysfs file:
/sys/devices/pci0001:02/0001:02:00.0/0001:03:00.0/host0/target0:0:0/0:0:0:0/block/sda/size
[   90.764028] Modules linked in: cthermo binfmt_misc dm_mod [last unloaded:
scsi_wait_scan]
[   90.772220] NIP: c006ed50 LR: c006ed48 CTR: c022d708
[   90.777175] REGS: effa3e90 TRAP: 0300   Not tainted  (2.6.36.2)
[   90.783085] MSR: 00029002 <EE,ME,CE>  CR: 24000028  XER: 20000000
[   90.789197] DEAR: 00000000, ESR: 00000000
[   90.793198] TASK = ebc85a20[0] 'swapper' THREAD: ebca2000 CPU: 6
[   90.799025] GPR00: c006ed48 effa3f40 ebc85a20 00000000 c1579180 ebd8c500
c006edc8 e551070c
[   90.807406] GPR08: 00000100 ebf06020 c3071cc0 00000060 44000088 00000000
c07b2cf0 00000000
[   90.815786] GPR16: c069966e c0787420 00000006 c077f480 c07bc080 c07bc080
c077c1c0 c07be578
[   90.824165] GPR24: 00000024 00000009 00000000 00000003 eaae7b40 c0789b80
c307174c eb178e00
[   90.832729] NIP [c006ed50] put_cred_rcu+0x54/0xe0
[   90.836675] [cthermo]----- [CTHERMO] drv_open(): START
[   90.836679] [cthermo]----- [CTHERMO] drv_open(): END
[   90.836690] [cthermo]----- [CTHERMO] drv_ioctl(): START
[   90.836694] [cthermo]Setup_ioremap(): before ioremap_nocache
[   90.836746] [cthermo]Setup_ioremap(): ioremap_nocache
(0xc000e0000)->[0xf9a42000]
[   90.836751] [cthermo]Setup_ioremap(): ioremap_nocache
(0xc000f0000)->[0xf9a46000]
[   90.836755] [cthermo][CTHERMO] drv_ioctl(): no=0 kind=0
[   90.836761] [cthermo][CTHERMO] Free_ioremap(): iounmap
[   90.836765] [cthermo][CTHERMO] Free_ioremap(): iounmap
[   90.836768] [cthermo][CTHERMO] drv_ioctl(): up(&gDrv_ioctl_sem) call
[   90.836772] [cthermo]----- [CTHERMO] drv_ioctl(): END
[   90.836818] [cthermo]----- [CTHERMO] drv_release(): START
[   90.836822] [cthermo]----- [CTHERMO] drv_release(): END
[   90.910824] LR [c006ed48] put_cred_rcu+0x4c/0xe0
[   90.915431] Call Trace:
[   90.917870] [effa3f40] [c006ed48] put_cred_rcu+0x4c/0xe0 (unreliable)
[   90.924317] [effa3f50] [c0098c90] __rcu_process_callbacks+0x1e8/0x31c
[   90.930755] [effa3f70] [c0098e20] rcu_process_callbacks+0x5c/0x98
[   90.936847] [effa3f90] [c004b0cc] __do_softirq+0x16c/0x284
[   90.942331] [effa3ff0] [c000e4dc] call_do_softirq+0x14/0x24
[   90.947902] [ebca3e70] [c00051d0] do_softirq+0x84/0xb0
[   90.953036] [ebca3e90] [c004ae9c] irq_exit+0x54/0xa0
[   90.958000] [ebca3ea0] [c000bb8c] timer_interrupt+0x1a0/0x228
[   90.963743] [ebca3ec0] [c000f204] ret_from_except+0x0/0x18
[   90.969228] --- Exception: 901 at ppc_wait+0x4/0x8
[   90.969230]     LR = cpu_idle_simple+0x4c/0xb0
[   90.978444] [ebca3f80] [c0008ce8] cpu_idle_simple+0x3c/0xb0 (unreliable)
[   90.985146] [ebca3fa0] [c0008d94] cpu_idle+0x38/0x164
[   90.990199] [ebca3fc0] [c058a398] start_secondary+0x310/0x34c
[   90.995942] [ebca3ff0] [c00019c8] __secondary_start+0x30/0x84
[   91.001682] Instruction dump:
[   91.004644] 3c60c06a 7fe4fb78 3863c23c 485155f5 7fe3fb78 481b34b9
807f004c 481ab845
[   91.012412] 807f0050 481ab83d 807f0054 7c2004ac <7c001828> 3000ffff
7c00192d 40a2fff4
[   91.020360] Kernel panic - not syncing: Fatal exception in interrupt
[   91.026707] Call Trace:
[   91.029151] [effa3dc0] [c0007c38] show_stack+0x78/0x18c (unreliable)
[   91.035512] [effa3e00] [c05843d8] panic+0xb8/0x1e4
[   91.040304] [effa3e50] [c000cc44] die+0x1e4/0x1f0
[   91.045009] [effa3e70] [c0014544] bad_page_fault+0xbc/0xd4
[   91.050496] [effa3e80] [c000f070] handle_page_fault+0x7c/0x80
[   91.056245] --- Exception: 300 at put_cred_rcu+0x54/0xe0
[   91.056247]     LR = put_cred_rcu+0x4c/0xe0
[   91.065726] [effa3f50] [c0098c90] __rcu_process_callbacks+0x1e8/0x31c
[   91.072171] [effa3f70] [c0098e20] rcu_process_callbacks+0x5c/0x98
[   91.078265] [effa3f90] [c004b0cc] __do_softirq+0x16c/0x284
[   91.083752] [effa3ff0] [c000e4dc] call_do_softirq+0x14/0x24
[   91.089324] [ebca3e70] [c00051d0] do_softirq+0x84/0xb0
[   91.094462] [ebca3e90] [c004ae9c] irq_exit+0x54/0xa0
[   91.099426] [ebca3ea0] [c000bb8c] timer_interrupt+0x1a0/0x228
[   91.105171] [ebca3ec0] [c000f204] ret_from_except+0x0/0x18
[   91.110658] --- Exception: 901 at ppc_wait+0x4/0x8
[   91.110660]     LR = cpu_idle_simple+0x4c/0xb0
[   91.119877] [ebca3f80] [c0008ce8] cpu_idle_simple+0x3c/0xb0 (unreliable)
[   91.126583] [ebca3fa0] [c0008d94] cpu_idle+0x38/0x164
[   91.131634] [ebca3fc0] [c058a398] start_secondary+0x310/0x34c
[   91.137379] [ebca3ff0] [c00019c8] __secondary_start+0x30/0x84
[   91.143126] Rebooting in 180 seconds..

-- 
View this message in context: http://old.nabble.com/kernel-crash-on-P4080DS-tp33544993p33544993.html
Sent from the linux-kernel mailing list archive at Nabble.com.

