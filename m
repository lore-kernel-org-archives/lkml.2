Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2FEUDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:03:31 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:48437 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2FEUD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:03:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Jun 2012 23:03:20 +0300
From: Denys Fedoryshchenko <denys@visp.net.lb>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: BUG: =?UTF-8?Q?tty=5Finsert=5Fflip=5Fstring=5Ffixed=5Fflag=2C=20u?=
 =?UTF-8?Q?nable=20to=20handle=20kernel=20NULL=20pointer=20dereference=20a?=
 =?UTF-8?Q?t=20=30=30=30=30=30=30=30=34?=
Message-ID: <43517e56ecce834d141078f1918eba15@visp.net.lb>
User-Agent: VISP Webmail/0.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 (32bit), occured on multiple kernels, 3.1.1-rc1 and 3.4.1 at least.

Workload - PPPoE NAS server with few thousands of ppp interfaces.

[ 5350.555285] BUG: unable to handle kernel NULL pointer dereference at 
00000004
[ 5350.555543] IP: [<c027a1cd>] 
tty_insert_flip_string_fixed_flag+0x46/0x7f
[ 5350.555781] *pdpt = 0000000034372001 *pde = 0000000000000000
[ 5350.556008] Oops: 0000 [#1] SMP
[ 5350.556089] Modules linked in: sch_prio act_skbedit sch_ingress 
sch_sfq nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre 
nf_nat_proto_gre netconsole configfs l2tp_eth l2tp_netlink l2tp_core 
xt_connmark cls_flow cls_u32 e
[ 5350.556089]
[ 5350.556089] Pid: 1581, comm: telnetd Not tainted 3.4.1-build-0061 
#18 Intel S5000VSA/S5000VSA
[ 5350.556089] EIP: 0060:[<c027a1cd>] EFLAGS: 00010202 CPU: 0
[ 5350.556089] EIP is at tty_insert_flip_string_fixed_flag+0x46/0x7f
[ 5350.556089] EAX: f00d8000 EBX: 00000000 ECX: 00000046 EDX: 00000002
[ 5350.556089] ESI: f247b400 EDI: 00000073 EBP: f4e87ed8 ESP: f4e87ebc
[ 5350.556089]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 5350.556089] CR0: 8005003b CR2: 00000004 CR3: 340a9000 CR4: 000007f0
[ 5350.556089] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 5350.556089] DR6: ffff0ff0 DR7: 00000400
[ 5350.556089] Process telnetd (pid: 1581, ti=f4e86000 task=f4101110 
task.ti=f4e86000)
[ 5350.556089] Stack:
[ 5350.556089]  00b6a194 f00d8000 00000000 00000073 f3b6a000 f00d8000 
00000073 f4e87ef0
[ 5350.556089]  c027adc4 00000073 c037112c f3b6a000 f247b400 f4e87f34 
c0277a44 f4e87f14
[ 5350.556089]  f3b6a194 f3b6a4fc f247b400 e8d90000 f4101110 00000000 
f4101110 c0144a2b
[ 5350.556089] Call Trace:
[ 5350.556089]  [<c027adc4>] pty_write+0x2c/0x4c
[ 5350.556089]  [<c0277a44>] n_tty_write+0x24e/0x2d6
[ 5350.556089]  [<c0144a2b>] ? try_to_wake_up+0x18c/0x18c
[ 5350.556089]  [<c0274112>] tty_write+0x166/0x1d7
[ 5350.556089]  [<c02777f6>] ? n_tty_receive_buf+0xbce/0xbce
[ 5350.556089]  [<c0273fac>] ? tty_write_lock+0x3c/0x3c
[ 5350.556089]  [<c01a2e8c>] vfs_write+0x7e/0xab
[ 5350.556089]  [<c01a3eba>] ? fget_light+0x2b/0x7c
[ 5350.556089]  [<c01a2ffc>] sys_write+0x3d/0x5e
[ 5350.556089]  [<c034e191>] syscall_call+0x7/0xb
[ 5350.556089]  [<c0340000>] ? workqueue_cpu_callback+0x18b/0x1bb
[ 5350.556089] Code: b8 00 07 00 00 2b 55 ec 81 fa 00 07 00 00 0f 47 d0 
8b 45 e8 e8 b9 fd ff ff 89 45 f0 8b 45 e8 83 7d f0 00 8b 98 84 01 00 00 
74 2e <8b> 43 04 03 43 0c 8b 4d f0 89 c7 f3 a4 8b 53 08 03 53 0c 8a 45
[ 5350.556089] EIP: [<c027a1cd>] 
tty_insert_flip_string_fixed_flag+0x46/0x7f SS:ESP 0068:f4e87ebc
[ 5350.556089] CR2: 0000000000000004
[ 5350.574878] ---[ end trace 6beb0edac4247567 ]---


  [198492.978179] BUG: unable to handle kernel NULL pointer dereference 
at 00000004
  [198492.978641] IP: [<c026dd94>] 
tty_insert_flip_string_fixed_flag+0x47/0x80
  [198492.978904] *pdpt = 000000003486f001 *pde = 0000000000000000
  [198492.979001] Oops: 0000 [#1] SMP
  [198492.979001] Modules linked in: sch_prio rtc_cmos act_skbedit 
sch_ingress sch_sfq nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre 
nf_nat_proto_gre netconsole configfs l2tp_eth l2tp_netlink l2tp_core 
xt_connmark cls_flow
  [198492.981010]
  [198492.981010] Pid: 1604, comm: telnetd Tainted: G        W   
3.1.1-rc1-build-0060 #16 Intel S5000VSA/S5000VSA
  [198492.981010] EIP: 0060:[<c026dd94>] EFLAGS: 00010206 CPU: 2
  [198492.981010] EIP is at tty_insert_flip_string_fixed_flag+0x47/0x80
  [198492.981010] EAX: e2f73400 EBX: 00000000 ECX: 00000000 EDX: 
00000282
  [198492.981010] ESI: ec1ec800 EDI: 00000044 EBP: f48fded8 ESP: 
f48fdebc
  [198492.981010]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
  [198492.981010] Process telnetd (pid: 1604, ti=f48fc000 task=f4ea4470 
task.ti=f48fc000)
  [198492.981010] Stack:
  [198492.981010]  00000000 e2f73400 00000000 00000044 e2f77000 e2f73400 
00000044 f48fdef0
  [198492.981010]  c026e888 00000044 c035a174 e2f77000 ec1ec800 f48fdf34 
c026b72d 00000286
  [198492.981010]  e2f770e4 e2f7739c ec1ec800 ec66e500 f4ea4470 00000000 
f4ea4470 c0127ee3
  [198492.981010] Call Trace:
  [198492.981010]  [<c026e888>] pty_write+0x2c/0x4c
  [198492.981010]  [<c026b72d>] n_tty_write+0x240/0x2ca
  [198492.981010]  [<c0127ee3>] ? try_to_wake_up+0x15a/0x15a
  [198492.981010]  [<c026800c>] tty_write+0x163/0x1d4
  [198492.981010]  [<c026b4ed>] ? n_tty_receive_buf+0xb96/0xb96
  [198492.981010]  [<c0267ea9>] ? tty_write_lock+0x3c/0x3c
  [198492.981010]  [<c019d206>] vfs_write+0x7e/0xab
  [198492.981010]  [<c019d376>] sys_write+0x3d/0x5e
  [198492.981010]  [<c0336785>] syscall_call+0x7/0xb
  [198492.981010]  [<c0330000>] ? ppro_with_ram_bug+0xa/0x38
  [198492.981010] Code: b8 00 07 00 00 2b 55 ec 81 fa 00 07 00 00 0f 47 
d0 8b 45 e8 e8 b6 fd ff ff 89 45 f0 8b 45 e8 83 7d f0 00 8b 98 d4 00 00 
00 74 2e <8b> 43 04 03 43 0c 8b 4d f0 89 c7 f3 a4 8b 53 08 03 53 0c 8a 
45
  [198492.981010] EIP: [<c026dd94>] 
tty_insert_flip_string_fixed_flag+0x47/0x80 SS:ESP 0068:f48fdebc
  [198492.981010] CR2: 0000000000000004
  [198493.001671] ---[ end trace ece639f56fc2d4a3 ]---
  [198493.002281] Kernel panic - not syncing: Fatal exception
  [198493.002690] Pid: 1604, comm: telnetd Tainted: G      D W   
3.1.1-rc1-build-0060 #16
  [198493.003610] Call Trace:
  [198493.004497]  [<c0334e80>] ? printk+0x18/0x20
  [198493.004897]  [<c0334d64>] panic+0x57/0x15b
  [198493.005416]  [<c0104d86>] oops_end+0x92/0x9f
  [198493.005956]  [<c011b821>] no_context+0x151/0x159
  [198493.006596]  [<c011b935>] __bad_area_nosemaphore+0x10c/0x114
  [198493.007128]  [<c01a920b>] ? __pollwait+0xa5/0xa5
  [198493.007663]  [<c011b988>] bad_area+0x37/0x3d
  [198493.008253]  [<c011bc98>] do_page_fault+0x178/0x2f4
  [198493.009119]  [<c03374a9>] ? common_interrupt+0x29/0x30
  [198493.009717]  [<c011bb20>] ? vmalloc_sync_all+0x5/0x5
  [198493.010051]  [<c0336d52>] error_code+0x5a/0x60
  [198493.010428]  [<c011bb20>] ? vmalloc_sync_all+0x5/0x5
  [198493.010816]  [<c026dd94>] ? 
tty_insert_flip_string_fixed_flag+0x47/0x80
  [198493.011243]  [<c026e888>] pty_write+0x2c/0x4c
  [198493.011645]  [<c026b72d>] n_tty_write+0x240/0x2ca
  [198493.011970]  [<c0127ee3>] ? try_to_wake_up+0x15a/0x15a
  [198493.012400]  [<c026800c>] tty_write+0x163/0x1d4
  [198493.012791]  [<c026b4ed>] ? n_tty_receive_buf+0xb96/0xb96
  [198493.013145]  [<c0267ea9>] ? tty_write_lock+0x3c/0x3c
  [198493.013493]  [<c019d206>] vfs_write+0x7e/0xab
  [198493.013987]  [<c019d376>] sys_write+0x3d/0x5e
  [198493.014535]  [<c0336785>] syscall_call+0x7/0xb

---
Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.
