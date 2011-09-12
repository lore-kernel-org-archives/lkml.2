Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1ILJUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 05:20:20 -0400
Received: from outbound3.exchangedefender.com ([65.99.255.234]:40977 "EHLO
	outbound3.exchangedefender.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab1ILJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:20:18 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Sep 2011 05:20:18 EDT
X-ExchangeDefender-MagicKey: 1317028399.84163@Ew1R4QFjNQPyXMzQVt+nxg
Message-ID: <4E6DCD36.6020104@kelvatek.com>
Date: Mon, 12 Sep 2011 11:13:26 +0200
From: Krzysztof Kanas <k.kanas@kelvatek.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel  2.6.27.15  oops in PPP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2011 09:13:13.0313 (UTC) FILETIME=[32E2DD10:01CC712C]
X-ExchangeDefender-Info: Please contact the ISP for more information
X-MailScanner-ID: p8C9DCOe001974
X-ExchangeDefender-VirusScan: Found to be clean
X-ExchangeDefender-From: k.kanas@kelvatek.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi I am tracing kernel oops in 2.6.27.15 on ARM(CONFIG_CPU_ARM926T=y).

I tried to search list/Changelog for bugs in ppp at newer version but I 
didn't succeed (or maybe I searched poorly).

The oops is occurring when I kill pppd in user space.

More important this started to show when I changed kernel config
to CONFIG_PREEMPT=y (and other major changes were done at the same time 
but I think this contributes the most). Before the changes in config 
kernel didn't oopsed.

I can post changes to the .config that caused the oops to occur.

The kenel oops

# ./ppp.up
Serial connection established.
using channel 1
Using interface ppp0
Connect: ppp0 <--> /dev/ttyS1
sent [LCP ConfReq id=0x1 <asyncmap 0x0> <magic 0x660f510e> <pcomp> <accomp>]
rcvd [LCP ConfRej id=0x1 <pcomp> <accomp>]
sent [LCP ConfReq id=0x2 <asyncmap 0x0> <magic 0x660f510e>]
rcvd [LCP ConfReq id=0x1 <asyncmap 0x0> <auth pap> <magic 0x54d50000>]
sent [LCP ConfAck id=0x1 <asyncmap 0x0> <auth pap> <magic 0x54d50000>]
rcvd [LCP ConfAck id=0x2 <asyncmap 0x0> <magic 0x660f510e>]
sent [LCP EchoReq id=0x0 magic=0x660f510e]
sent [PAP AuthReq id=0x1 user="heyah" password=<hidden>]
rcvd [LCP EchoRep id=0x0 magic=0x82d50000]
rcvd [PAP AuthAck id=0x1 "Welcome!"]
Remote message: Welcome!
PAP authentication succeeded
sent [IPCP ConfReq id=0x1 <compress VJ 0f 01> <addr 0.0.0.0> <ms-dns1 
0.0.0.0> <ms-dns3 0.0.0.0>]
rcvd [IPCP ConfReq id=0x1 <addr 192.168.202.0>]
sent [IPCP ConfAck id=0x1 <addr 192.168.202.0>]
Terminating on signal 2
sent [LCP TermReq id=0x3 "User request"]
rcvd [LCP TermAck id=0x3 "User request"]
Connection terminated.
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7cd8000
[00000000] *pgd=27c5c031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.27.15 #1)
PC is at tty_ldisc_put+0x40/0x80
LR is at tty_ldisc_put+0x30/0x80
pc : [<c01bfdb4>]    lr : [<c01bfda4>]    psr: 60000093
sp : c7d13e60  ip : c7d13e60  fp : c7d13e74
r10: 00000000  r9 : c7d13ec8  r8 : c7d13ebc
r7 : 00000000  r6 : 00000000  r5 : 00000003  r4 : 80000013
r3 : 00000000  r2 : c03a4fe0  r1 : c7d12000  r0 : 00000001
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 27cd8000  DAC: 00000015
Process pppd (pid: 1359, stack limit = 0xc7d12260)
Stack: (0xc7d13e60 to 0xc7d14000)
3e60: 20000013 c7c88800 c7d13f08 c7d13e78 c01c07f4 c01bfd84 00000000 
c0081bdc
3e80: c78967c4 c7d13ea8 c7d13ea8 c7d13e98 c02f0b7c c0080fb0 c7d12000 
c7d13ecc
3ea0: c7d13eac c01ce748 c02f0b44 7fffffff 000497c8 c7c88800 c7c88800 
00000000
3ec0: c7c91940 c009b3f0 c7d13ec8 c7d13ec8 c03a1290 00000000 c03a4fe0 
00000000
3ee0: 00000000 000497c8 c7c88800 c7c88800 c782a2a0 c7d12000 00000001 
c7d13f38
3f00: c7d13f0c c01bc168 c01c03c8 00000000 c782a0a0 be97bad4 c782a2a0 
000497c8
3f20: 00005423 c782a2a0 c0076e04 c7d13f54 c7d13f3c c00d9ac8 c01bb9f4 
c782a2a0
3f40: c7453988 000497c8 c7d13f80 c7d13f58 c00d9de8 c00d9aa4 c0399bf4 
00000000
3f60: 00000008 000497c8 00005423 c782a2a0 c0076e04 c7d13fa4 c7d13f84 
c00d9e44
3f80: c00d9b38 00000000 00000008 00047681 0008b508 00000036 00000000 
c7d13fa8
3fa0: c0076c60 c00d9e14 00000008 00047681 00000008 00005423 000497c8 
be97bad4
3fc0: 00000008 00047681 0008b508 0008b504 00000003 0004b4f8 00000001 
0000c021
3fe0: 000420e8 be97bac0 00026208 40040e94 60000010 00000008 00000000 
00000000
Backtrace:
[<c01bfd74>] (tty_ldisc_put+0x0/0x80) from [<c01c07f4>] 
(tty_set_ldisc+0x43c/0x490)
  r5:c7c88800 r4:20000013
[<c01c03b8>] (tty_set_ldisc+0x0/0x490) from [<c01bc168>] 
(tty_ioctl+0x784/0x99c)
[<c01bb9e4>] (tty_ioctl+0x0/0x99c) from [<c00d9ac8>] (vfs_ioctl+0x34/0x94)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:c782a2a0
[<c00d9a94>] (vfs_ioctl+0x0/0x94) from [<c00d9de8>] 
(do_vfs_ioctl+0x2c0/0x2dc)
  r6:000497c8 r5:c7453988 r4:c782a2a0
[<c00d9b28>] (do_vfs_ioctl+0x0/0x2dc) from [<c00d9e44>] 
(sys_ioctl+0x40/0x60)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:00000008
[<c00d9e04>] (sys_ioctl+0x0/0x60) from [<c0076c60>] 
(ret_fast_syscall+0x0/0x2c)
  r7:00000036 r6:0008b508 r5:00047681 r4:00000008
Code: e59f3044 e7932105 e5923048 e3530000 (05833000)
---[ end trace 3af99e223e004a2a ]---
note: pppd[1359] exited with preempt_count 2
BUG: scheduling while atomic: pppd/1359/0x40000002
Modules linked in:
[<c007aab0>] (dump_stack+0x0/0x14) from [<c0081390>] 
(__schedule_bug+0x50/0x5c)
[<c0081340>] (__schedule_bug+0x0/0x5c) from [<c02ef1fc>] 
(schedule+0x80/0x338)
  r4:c7d12000
[<c02ef17c>] (schedule+0x0/0x338) from [<c0081468>] 
(__cond_resched+0x2c/0x4c)
[<c008143c>] (__cond_resched+0x0/0x4c) from [<c02efa84>] 
(_cond_resched+0x40/0x54)
  r4:00000001
[<c02efa44>] (_cond_resched+0x0/0x54) from [<c00bf438>] 
(unmap_vmas+0x51c/0x608)
  r4:c78804e0
[<c00bef1c>] (unmap_vmas+0x0/0x608) from [<c00c18d0>] (exit_mmap+0x94/0x170)
[<c00c183c>] (exit_mmap+0x0/0x170) from [<c0083a98>] (mmput+0x50/0xf0)
  r7:c7c91940 r6:c7880514 r5:00000000 r4:c78804e0
[<c0083a48>] (mmput+0x0/0xf0) from [<c0087904>] (exit_mm+0x11c/0x124)
  r5:c78804e0 r4:00000000
[<c00877e8>] (exit_mm+0x0/0x124) from [<c0088fc4>] (do_exit+0x198/0x770)
  r7:00000817 r6:0000000b r5:c7c91940 r4:c7d12000
[<c0088e2c>] (do_exit+0x0/0x770) from [<c007a9b8>] (die+0x1d4/0x220)
[<c007a7e4>] (die+0x0/0x220) from [<c007c374>] (__do_kernel_fault+0x6c/0x7c)
[<c007c308>] (__do_kernel_fault+0x0/0x7c) from [<c007c5a4>] 
(do_page_fault+0x220/0x23c)
  r7:c7d13e18 r6:c7c91940 r5:c0395d5c r4:ffffffff
[<c007c384>] (do_page_fault+0x0/0x23c) from [<c0076230>] 
(do_DataAbort+0x3c/0xa0)
[<c00761f4>] (do_DataAbort+0x0/0xa0) from [<c0076820>] 
(__dabt_svc+0x40/0x60)
Exception stack(0xc7d13e18 to 0xc7d13e60)
3e00:                                                       00000001 
c7d12000
3e20: c03a4fe0 00000000 80000013 00000003 00000000 00000000 c7d13ebc 
c7d13ec8
3e40: 00000000 c7d13e74 c7d13e60 c7d13e60 c01bfda4 c01bfdb4 60000093 
ffffffff
  r8:c7d13ebc r7:00000000 r6:00000000 r5:c7d13e4c r4:ffffffff
[<c01bfd74>] (tty_ldisc_put+0x0/0x80) from [<c01c07f4>] 
(tty_set_ldisc+0x43c/0x490)
  r5:c7c88800 r4:20000013
[<c01c03b8>] (tty_set_ldisc+0x0/0x490) from [<c01bc168>] 
(tty_ioctl+0x784/0x99c)
[<c01bb9e4>] (tty_ioctl+0x0/0x99c) from [<c00d9ac8>] (vfs_ioctl+0x34/0x94)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:c782a2a0
[<c00d9a94>] (vfs_ioctl+0x0/0x94) from [<c00d9de8>] 
(do_vfs_ioctl+0x2c0/0x2dc)
  r6:000497c8 r5:c7453988 r4:c782a2a0
[<c00d9b28>] (do_vfs_ioctl+0x0/0x2dc) from [<c00d9e44>] 
(sys_ioctl+0x40/0x60)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:00000008
[<c00d9e04>] (sys_ioctl+0x0/0x60) from [<c0076c60>] 
(ret_fast_syscall+0x0/0x2c)
  r7:00000036 r6:0008b508 r5:00047681 r4:00000008
BUG: scheduling while atomic: pppd/1359/0x00000002
Modules linked in:
[<c007aab0>] (dump_stack+0x0/0x14) from [<c0081390>] 
(__schedule_bug+0x50/0x5c)
[<c0081340>] (__schedule_bug+0x0/0x5c) from [<c02ef1fc>] 
(schedule+0x80/0x338)
  r4:c7d13b68
[<c02ef17c>] (schedule+0x0/0x338) from [<c02efae0>] 
(schedule_timeout+0x20/0xc4)
[<c02efac0>] (schedule_timeout+0x0/0xc4) from [<c02ef890>] 
(wait_for_common+0x114/0x1e0)
  r7:7fffffff r6:c7d12000 r5:c7c91940 r4:c7d13b68
[<c02ef77c>] (wait_for_common+0x0/0x1e0) from [<c02ef9ec>] 
(wait_for_completion+0x18/0x1c)
[<c02ef9d4>] (wait_for_completion+0x0/0x1c) from [<c00989f4>] 
(synchronize_rcu+0x38/0x44)
[<c00989bc>] (synchronize_rcu+0x0/0x44) from [<c0254544>] 
(synchronize_net+0x1c/0x28)
  r4:c7bd6c00
[<c0254528>] (synchronize_net+0x0/0x28) from [<c0255cb4>] 
(rollback_registered+0x98/0x128)
[<c0255c1c>] (rollback_registered+0x0/0x128) from [<c0255d7c>] 
(unregister_netdevice+0x38/0x68)
  r4:c7bd6c00
[<c0255d44>] (unregister_netdevice+0x0/0x68) from [<c0255dc8>] 
(unregister_netdev+0x1c/0x24)
  r4:c7bd6c00
[<c0255dac>] (unregister_netdev+0x0/0x24) from [<c01e4ae4>] 
(ppp_shutdown_interface+0x64/0xc0)
  r4:00000001
[<c01e4a80>] (ppp_shutdown_interface+0x0/0xc0) from [<c01e4ed8>] 
(ppp_release+0x40/0x98)
  r5:c782ada0 r4:c798f220
[<c01e4e98>] (ppp_release+0x0/0x98) from [<c00cdecc>] (__fput+0xc4/0x1a8)
  r4:00000008
[<c00cde08>] (__fput+0x0/0x1a8) from [<c00ce388>] (fput+0x34/0x38)
[<c00ce354>] (fput+0x0/0x38) from [<c00caf6c>] (filp_close+0x74/0x80)
[<c00caef8>] (filp_close+0x0/0x80) from [<c0087af0>] 
(put_files_struct+0x80/0xd4)
  r6:00000028 r5:00000001 r4:c7816e00
[<c0087a70>] (put_files_struct+0x0/0xd4) from [<c0087b98>] 
(exit_files+0x54/0x58)
[<c0087b44>] (exit_files+0x0/0x58) from [<c0088fd4>] (do_exit+0x1a8/0x770)
  r5:c7c91940 r4:c7d12000
[<c0088e2c>] (do_exit+0x0/0x770) from [<c007a9b8>] (die+0x1d4/0x220)
[<c007a7e4>] (die+0x0/0x220) from [<c007c374>] (__do_kernel_fault+0x6c/0x7c)
[<c007c308>] (__do_kernel_fault+0x0/0x7c) from [<c007c5a4>] 
(do_page_fault+0x220/0x23c)
  r7:c7d13e18 r6:c7c91940 r5:c0395d5c r4:ffffffff
[<c007c384>] (do_page_fault+0x0/0x23c) from [<c0076230>] 
(do_DataAbort+0x3c/0xa0)
[<c00761f4>] (do_DataAbort+0x0/0xa0) from [<c0076820>] 
(__dabt_svc+0x40/0x60)
Exception stack(0xc7d13e18 to 0xc7d13e60)
3e00:                                                       00000001 
c7d12000
3e20: c03a4fe0 00000000 80000013 00000003 00000000 00000000 c7d13ebc 
c7d13ec8
3e40: 00000000 c7d13e74 c7d13e60 c7d13e60 c01bfda4 c01bfdb4 60000093 
ffffffff
  r8:c7d13ebc r7:00000000 r6:00000000 r5:c7d13e4c r4:ffffffff
[<c01bfd74>] (tty_ldisc_put+0x0/0x80) from [<c01c07f4>] 
(tty_set_ldisc+0x43c/0x490)
  r5:c7c88800 r4:20000013
[<c01c03b8>] (tty_set_ldisc+0x0/0x490) from [<c01bc168>] 
(tty_ioctl+0x784/0x99c)
[<c01bb9e4>] (tty_ioctl+0x0/0x99c) from [<c00d9ac8>] (vfs_ioctl+0x34/0x94)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:c782a2a0
[<c00d9a94>] (vfs_ioctl+0x0/0x94) from [<c00d9de8>] 
(do_vfs_ioctl+0x2c0/0x2dc)
  r6:000497c8 r5:c7453988 r4:c782a2a0
[<c00d9b28>] (do_vfs_ioctl+0x0/0x2dc) from [<c00d9e44>] 
(sys_ioctl+0x40/0x60)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:00000008
[<c00d9e04>] (sys_ioctl+0x0/0x60) from [<c0076c60>] 
(ret_fast_syscall+0x0/0x2c)
  r7:00000036 r6:0008b508 r5:00047681 r4:00000008
BUG: scheduling while atomic: pppd/1359/0x00000002
Modules linked in:
[<c007aab0>] (dump_stack+0x0/0x14) from [<c0081390>] 
(__schedule_bug+0x50/0x5c)
[<c0081340>] (__schedule_bug+0x0/0x5c) from [<c02ef1fc>] 
(schedule+0x80/0x338)
  r4:c7d13aec
[<c02ef17c>] (schedule+0x0/0x338) from [<c02efae0>] 
(schedule_timeout+0x20/0xc4)
[<c02efac0>] (schedule_timeout+0x0/0xc4) from [<c02ef890>] 
(wait_for_common+0x114/0x1e0)
  r7:7fffffff r6:c7d12000 r5:c7c91940 r4:c7d13aec
[<c02ef77c>] (wait_for_common+0x0/0x1e0) from [<c02ef9ec>] 
(wait_for_completion+0x18/0x1c)
[<c02ef9d4>] (wait_for_completion+0x0/0x1c) from [<c0096cec>] 
(call_usermodehelper_exec+0x7c/0x98)
[<c0096c70>] (call_usermodehelper_exec+0x0/0x98) from [<c019ad58>] 
(kobject_uevent_env+0x330/0x3a0)
  r7:c7bfc000 r6:c7bd7700 r5:00000000 r4:00000006
[<c019aa28>] (kobject_uevent_env+0x0/0x3a0) from [<c019addc>] 
(kobject_uevent+0x14/0x18)
[<c019adc8>] (kobject_uevent+0x0/0x18) from [<c01d5ff0>] 
(device_del+0x148/0x170)
[<c01d5ea8>] (device_del+0x0/0x170) from [<c0263210>] 
(netdev_unregister_kobject+0x20/0x24)
  r6:c744b30c r5:c798f220 r4:c7bd6c00
[<c02631f0>] (netdev_unregister_kobject+0x0/0x24) from [<c0255d04>] 
(rollback_registered+0xe8/0x128)
  r4:c7bd6c00
[<c0255c1c>] (rollback_registered+0x0/0x128) from [<c0255d7c>] 
(unregister_netdevice+0x38/0x68)
  r4:c7bd6c00
[<c0255d44>] (unregister_netdevice+0x0/0x68) from [<c0255dc8>] 
(unregister_netdev+0x1c/0x24)
  r4:c7bd6c00
[<c0255dac>] (unregister_netdev+0x0/0x24) from [<c01e4ae4>] 
(ppp_shutdown_interface+0x64/0xc0)
  r4:00000001
[<c01e4a80>] (ppp_shutdown_interface+0x0/0xc0) from [<c01e4ed8>] 
(ppp_release+0x40/0x98)
  r5:c782ada0 r4:c798f220
[<c01e4e98>] (ppp_release+0x0/0x98) from [<c00cdecc>] (__fput+0xc4/0x1a8)
  r4:00000008
[<c00cde08>] (__fput+0x0/0x1a8) from [<c00ce388>] (fput+0x34/0x38)
[<c00ce354>] (fput+0x0/0x38) from [<c00caf6c>] (filp_close+0x74/0x80)
[<c00caef8>] (filp_close+0x0/0x80) from [<c0087af0>] 
(put_files_struct+0x80/0xd4)
  r6:00000028 r5:00000001 r4:c7816e00
[<c0087a70>] (put_files_struct+0x0/0xd4) from [<c0087b98>] 
(exit_files+0x54/0x58)
[<c0087b44>] (exit_files+0x0/0x58) from [<c0088fd4>] (do_exit+0x1a8/0x770)
  r5:c7c91940 r4:c7d12000
[<c0088e2c>] (do_exit+0x0/0x770) from [<c007a9b8>] (die+0x1d4/0x220)
[<c007a7e4>] (die+0x0/0x220) from [<c007c374>] (__do_kernel_fault+0x6c/0x7c)
[<c007c308>] (__do_kernel_fault+0x0/0x7c) from [<c007c5a4>] 
(do_page_fault+0x220/0x23c)
  r7:c7d13e18 r6:c7c91940 r5:c0395d5c r4:ffffffff
[<c007c384>] (do_page_fault+0x0/0x23c) from [<c0076230>] 
(do_DataAbort+0x3c/0xa0)
[<c00761f4>] (do_DataAbort+0x0/0xa0) from [<c0076820>] 
(__dabt_svc+0x40/0x60)
Exception stack(0xc7d13e18 to 0xc7d13e60)
3e00:                                                       00000001 
c7d12000
3e20: c03a4fe0 00000000 80000013 00000003 00000000 00000000 c7d13ebc 
c7d13ec8
3e40: 00000000 c7d13e74 c7d13e60 c7d13e60 c01bfda4 c01bfdb4 60000093 
ffffffff
  r8:c7d13ebc r7:00000000 r6:00000000 r5:c7d13e4c r4:ffffffff
[<c01bfd74>] (tty_ldisc_put+0x0/0x80) from [<c01c07f4>] 
(tty_set_ldisc+0x43c/0x490)
  r5:c7c88800 r4:20000013
[<c01c03b8>] (tty_set_ldisc+0x0/0x490) from [<c01bc168>] 
(tty_ioctl+0x784/0x99c)
[<c01bb9e4>] (tty_ioctl+0x0/0x99c) from [<c00d9ac8>] (vfs_ioctl+0x34/0x94)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:c782a2a0
[<c00d9a94>] (vfs_ioctl+0x0/0x94) from [<c00d9de8>] 
(do_vfs_ioctl+0x2c0/0x2dc)
  r6:000497c8 r5:c7453988 r4:c782a2a0
[<c00d9b28>] (do_vfs_ioctl+0x0/0x2dc) from [<c00d9e44>] 
(sys_ioctl+0x40/0x60)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:00000008
[<c00d9e04>] (sys_ioctl+0x0/0x60) from [<c0076c60>] 
(ret_fast_syscall+0x0/0x2c)
  r7:00000036 r6:0008b508 r5:00047681 r4:00000008
BUG: scheduling while atomic: pppd/1359/0x00000002
Modules linked in:
[<c007aab0>] (dump_stack+0x0/0x14) from [<c0081390>] 
(__schedule_bug+0x50/0x5c)
[<c0081340>] (__schedule_bug+0x0/0x5c) from [<c02ef1fc>] 
(schedule+0x80/0x338)
  r4:c7d13b68
[<c02ef17c>] (schedule+0x0/0x338) from [<c02efae0>] 
(schedule_timeout+0x20/0xc4)
[<c02efac0>] (schedule_timeout+0x0/0xc4) from [<c02ef890>] 
(wait_for_common+0x114/0x1e0)
  r7:7fffffff r6:c7d12000 r5:c7c91940 r4:c7d13b68
[<c02ef77c>] (wait_for_common+0x0/0x1e0) from [<c02ef9ec>] 
(wait_for_completion+0x18/0x1c)
[<c02ef9d4>] (wait_for_completion+0x0/0x1c) from [<c00989f4>] 
(synchronize_rcu+0x38/0x44)
[<c00989bc>] (synchronize_rcu+0x0/0x44) from [<c0254544>] 
(synchronize_net+0x1c/0x28)
  r4:c7bd6c00
[<c0254528>] (synchronize_net+0x0/0x28) from [<c0255d08>] 
(rollback_registered+0xec/0x128)
[<c0255c1c>] (rollback_registered+0x0/0x128) from [<c0255d7c>] 
(unregister_netdevice+0x38/0x68)
  r4:c7bd6c00
[<c0255d44>] (unregister_netdevice+0x0/0x68) from [<c0255dc8>] 
(unregister_netdev+0x1c/0x24)
  r4:c7bd6c00
[<c0255dac>] (unregister_netdev+0x0/0x24) from [<c01e4ae4>] 
(ppp_shutdown_interface+0x64/0xc0)
  r4:00000001
[<c01e4a80>] (ppp_shutdown_interface+0x0/0xc0) from [<c01e4ed8>] 
(ppp_release+0x40/0x98)
  r5:c782ada0 r4:c798f220
[<c01e4e98>] (ppp_release+0x0/0x98) from [<c00cdecc>] (__fput+0xc4/0x1a8)
  r4:00000008
[<c00cde08>] (__fput+0x0/0x1a8) from [<c00ce388>] (fput+0x34/0x38)
[<c00ce354>] (fput+0x0/0x38) from [<c00caf6c>] (filp_close+0x74/0x80)
[<c00caef8>] (filp_close+0x0/0x80) from [<c0087af0>] 
(put_files_struct+0x80/0xd4)
  r6:00000028 r5:00000001 r4:c7816e00
[<c0087a70>] (put_files_struct+0x0/0xd4) from [<c0087b98>] 
(exit_files+0x54/0x58)
[<c0087b44>] (exit_files+0x0/0x58) from [<c0088fd4>] (do_exit+0x1a8/0x770)
  r5:c7c91940 r4:c7d12000
[<c0088e2c>] (do_exit+0x0/0x770) from [<c007a9b8>] (die+0x1d4/0x220)
[<c007a7e4>] (die+0x0/0x220) from [<c007c374>] (__do_kernel_fault+0x6c/0x7c)
[<c007c308>] (__do_kernel_fault+0x0/0x7c) from [<c007c5a4>] 
(do_page_fault+0x220/0x23c)
  r7:c7d13e18 r6:c7c91940 r5:c0395d5c r4:ffffffff
[<c007c384>] (do_page_fault+0x0/0x23c) from [<c0076230>] 
(do_DataAbort+0x3c/0xa0)
[<c00761f4>] (do_DataAbort+0x0/0xa0) from [<c0076820>] 
(__dabt_svc+0x40/0x60)
Exception stack(0xc7d13e18 to 0xc7d13e60)
3e00:                                                       00000001 
c7d12000
3e20: c03a4fe0 00000000 80000013 00000003 00000000 00000000 c7d13ebc 
c7d13ec8
3e40: 00000000 c7d13e74 c7d13e60 c7d13e60 c01bfda4 c01bfdb4 60000093 
ffffffff
  r8:c7d13ebc r7:00000000 r6:00000000 r5:c7d13e4c r4:ffffffff
[<c01bfd74>] (tty_ldisc_put+0x0/0x80) from [<c01c07f4>] 
(tty_set_ldisc+0x43c/0x490)
  r5:c7c88800 r4:20000013
[<c01c03b8>] (tty_set_ldisc+0x0/0x490) from [<c01bc168>] 
(tty_ioctl+0x784/0x99c)
[<c01bb9e4>] (tty_ioctl+0x0/0x99c) from [<c00d9ac8>] (vfs_ioctl+0x34/0x94)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:c782a2a0
[<c00d9a94>] (vfs_ioctl+0x0/0x94) from [<c00d9de8>] 
(do_vfs_ioctl+0x2c0/0x2dc)
  r6:000497c8 r5:c7453988 r4:c782a2a0
[<c00d9b28>] (do_vfs_ioctl+0x0/0x2dc) from [<c00d9e44>] 
(sys_ioctl+0x40/0x60)
  r8:c0076e04 r7:c782a2a0 r6:00005423 r5:000497c8 r4:00000008
[<c00d9e04>] (sys_ioctl+0x0/0x60) from [<c0076c60>] 
(ret_fast_syscall+0x0/0x2c)
  r7:00000036 r6:0008b508 r5:00047681 r4:00000008
Segmentation fault

Maybe this is known issue but I couldn't find fix for it.

 
 
 
                      # Processor Type
 
 
 

CONFIG_CPU_ARM926T=y 
 
 

CONFIG_CPU_32=y
CONFIG_CPU_32v5=y 
 
 

CONFIG_CPU_ABRT_EV5TJ=y 
 
 

CONFIG_CPU_PABRT_NOIFAR=y 
 
 

CONFIG_CPU_CACHE_VIVT=y 
 
 

CONFIG_CPU_COPY_V4WB=y 
 
 

CONFIG_CPU_TLB_V4WBI=y 
 
 

CONFIG_CPU_CP15=y 
 
 

CONFIG_CPU_CP15_MMU=y 
 
 




-- 
Best regards,
Krzysztof Kanas



--
Asylia ExchangeDefender Message Security: Click below to verify authenticity
http://www.exchangedefender.com/verify.asp?id=p8C9DCOe001974&from=k.kanas@kelvatek.com


