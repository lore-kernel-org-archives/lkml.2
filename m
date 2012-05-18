Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab2ERHYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:24:54 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:39290 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442Ab2ERHYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:24:52 -0400
Message-ID: <4FB5F940.80500@msgid.tls.msk.ru>
Date: Fri, 18 May 2012 11:24:48 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: rcu_bh_state detected stall on CPU 1?
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this info in kern.log today:

May 15 00:58:53 gate vmunix: [189490.569376] INFO: rcu_bh_state detected stall on CPU 1 (t=0 jiffies)
May 15 00:58:53 gate vmunix: [189490.569404] sending NMI to all CPUs:
May 15 00:58:53 gate vmunix: [189490.569430] NMI backtrace for cpu 0
May 15 00:58:53 gate vmunix: [189490.569453] Modules linked in: ipv6 iptable_nat nf_nat xt_recent ipt_REJECT ipt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_comment iptable_filter ip_tables x_tables coretemp w83627ehf hwmon_vid hwmon tun ppp_async ppp_generic slhc crc_ccitt 8021q garp stp llc e1000e ext4 mbcache jbd2 crc16 sd_mod crc_t10dif usb_storage scsi_mod uhci_hcd ehci_hcd usbcore
May 15 00:58:53 gate vmunix: [189490.569620]
May 15 00:58:53 gate vmunix: [189490.569637] Pid: 0, comm: swapper Not tainted 3.0.0-i686pae #3.0.31                  /D2500CC
May 15 00:58:53 gate vmunix: [189490.569676] EIP: 0060:[<c1009eb4>] EFLAGS: 00000246 CPU: 0
May 15 00:58:53 gate vmunix: [189490.569701] EIP is at mwait_idle+0x64/0xf0
May 15 00:58:53 gate vmunix: [189490.569720] EAX: 00000000 EBX: c13f8920 ECX: 00000000 EDX: 00000000
May 15 00:58:53 gate vmunix: [189490.569742] ESI: 00000000 EDI: 00000000 EBP: 01905003 ESP: c13bbfcc
May 15 00:58:53 gate vmunix: [189490.569764]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
May 15 00:58:53 gate vmunix: [189490.569785] Process swapper (pid: 0, ti=c13ba000 task=c13d0fa0 task.ti=c13ba000)
May 15 00:58:53 gate vmunix: [189490.569816] Stack:
May 15 00:58:53 gate vmunix: [189490.569831]  c13f8920 00000000 c13be000 c1001d32 c142df20 00020000 c13fb7c3 00000047
May 15 00:58:53 gate vmunix: [189490.569876]  c13fb307 00020800 c142df20 00020800 00000000
May 15 00:58:53 gate vmunix: [189490.569903] Call Trace:
May 15 00:58:53 gate vmunix: [189490.569924]  [<c1001d32>] ? cpu_idle+0x42/0x70
May 15 00:58:53 gate vmunix: [189490.569947]  [<c13fb7c3>] ? start_kernel+0x2fa/0x2ff
May 15 00:58:53 gate vmunix: [189490.569968]  [<c13fb307>] ? kernel_init+0x13b/0x13b
May 15 00:58:53 gate vmunix: [189490.569987] Code: 08 89 e0 25 00 e0 ff ff 31 d2 83 c0 08 89 d1 0f 01 c8 0f ae f0 89 f6 89 e0 25 00 e0 ff ff 8b 40 08 a8 08 75 4b 31 c0 fb 0f 01 c9 <a1> 78 73 3f c1 64 8b 3d c0 90 45 c1 85 c0 75 0c 5b 5e 5f c3 fb
May 15 00:58:53 gate vmunix: [189490.570143] Call Trace:
May 15 00:58:53 gate vmunix: [189490.570160]  [<c1001d32>] ? cpu_idle+0x42/0x70
May 15 00:58:53 gate vmunix: [189490.570181]  [<c13fb7c3>] ? start_kernel+0x2fa/0x2ff
May 15 00:58:53 gate vmunix: [189490.570203]  [<c13fb307>] ? kernel_init+0x13b/0x13b
May 15 00:58:53 gate vmunix: [189490.570223] NMI backtrace for cpu 1
May 15 00:58:53 gate vmunix: [189490.570240] Modules linked in: ipv6 iptable_nat nf_nat xt_recent ipt_REJECT ipt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_comment iptable_filter ip_tables x_tables coretemp w83627ehf hwmon_vid hwmon tun ppp_async ppp_generic slhc crc_ccitt 8021q garp stp llc e1000e ext4 mbcache jbd2 crc16 sd_mod crc_t10dif usb_storage scsi_mod uhci_hcd ehci_hcd usbcore
May 15 00:58:53 gate vmunix: [189490.570408]
May 15 00:58:53 gate vmunix: [189490.570425] Pid: 1312, comm: tincd Not tainted 3.0.0-i686pae #3.0.31                  /D2500CC
May 15 00:58:53 gate vmunix: [189490.570464] EIP: 0060:[<c101d78d>] EFLAGS: 00000006 CPU: 1
May 15 00:58:53 gate vmunix: [189490.570491] EIP is at arch_trigger_all_cpu_backtrace+0x4d/0x70
May 15 00:58:53 gate vmunix: [189490.570512] EAX: 00418958 EBX: 00000000 ECX: c13d5260 EDX: fffff000
May 15 00:58:53 gate vmunix: [189490.570534] ESI: c13db200 EDI: c13db200 EBP: f7082ac0 ESP: f672fe24
May 15 00:58:53 gate vmunix: [189490.570556]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
May 15 00:58:53 gate vmunix: [189490.570578] Process tincd (pid: 1312, ti=f672e000 task=f65ac520 task.ti=f672e000)
May 15 00:58:53 gate vmunix: [189490.570609] Stack:
May 15 00:58:53 gate vmunix: [189490.570624]  c1359f77 f7082ce0 c10999ad c136a4cc c1366177 00000001 00000000 00000d05
May 15 00:58:53 gate vmunix: [189490.570669]  c145cb40 00000001 00000000 00000001 f7082ac0 c1099c7e f65ac520 c1050305
May 15 00:58:53 gate vmunix: [189490.570713]  f672ff24 dfef694f 0000ac83 c1070359 f70829ec c1063145 f7082ac0 7fffffff
May 15 00:58:53 gate vmunix: [189490.570757] Call Trace:
May 15 00:58:53 gate vmunix: [189490.570779]  [<c10999ad>] ? __rcu_pending+0x12d/0x310
May 15 00:58:53 gate vmunix: [189490.570801]  [<c1099c7e>] ? rcu_check_callbacks+0xee/0x100
May 15 00:58:53 gate vmunix: [189490.570824]  [<c1050305>] ? update_process_times+0x35/0x70
May 15 00:58:53 gate vmunix: [189490.570847]  [<c1070359>] ? tick_sched_timer+0x59/0xd0
May 15 00:58:53 gate vmunix: [189490.570870]  [<c1063145>] ? __remove_hrtimer+0x45/0xa0
May 15 00:58:53 gate vmunix: [189490.570891]  [<c1063355>] ? __run_hrtimer+0x75/0x190
May 15 00:58:53 gate vmunix: [189490.570914]  [<c1069700>] ? ktime_get+0x60/0x100
May 15 00:58:53 gate vmunix: [189490.570935]  [<c1070300>] ? tick_nohz_handler+0x100/0x100
May 15 00:58:53 gate vmunix: [189490.570957]  [<c10636f1>] ? hrtimer_interrupt+0x101/0x2b0
May 15 00:58:53 gate vmunix: [189490.570980]  [<c101cd6c>] ? smp_apic_timer_interrupt+0x4c/0x90
May 15 00:58:53 gate vmunix: [189490.571004]  [<c12ee6de>] ? apic_timer_interrupt+0x2a/0x30
May 15 00:58:53 gate vmunix: [189490.571027]  [<c11a392b>] ? _copy_from_user+0x4b/0x130
May 15 00:58:53 gate vmunix: [189490.571051]  [<c124ae30>] ? sys_socketcall+0x50/0x2e0
May 15 00:58:53 gate vmunix: [189490.571073]  [<c1048141>] ? irq_exit+0x31/0xa0
May 15 00:58:53 gate vmunix: [189490.571094]  [<c1004136>] ? do_IRQ+0x46/0xc0
May 15 00:58:53 gate vmunix: [189490.571116]  [<c10fe301>] ? sys_read+0x41/0x80
May 15 00:58:53 gate vmunix: [189490.571137]  [<c12eeb58>] ? sysenter_do_call+0x12/0x28
May 15 00:58:53 gate vmunix: [189490.571160]  [<c12e0000>] ? msi_ht_cap_enabled+0x70/0x8d
May 15 00:58:53 gate vmunix: [189490.571179] Code: 04 24 77 9f 35 c1 a3 8c 87 3f c1 e8 9f e3 2c 00 8b 15 44 52 3d c1 b8 02 00 00 00 ff 52 7c eb 1b 8d b6 00 00 00 00 b8 58 89 41 00
May 15 00:58:53 gate vmunix: [189490.571340] Call Trace:
May 15 00:58:53 gate vmunix: [189490.571358]  [<c10999ad>] ? __rcu_pending+0x12d/0x310
May 15 00:58:53 gate vmunix: [189490.571380]  [<c1099c7e>] ? rcu_check_callbacks+0xee/0x100
May 15 00:58:53 gate vmunix: [189490.571402]  [<c1050305>] ? update_process_times+0x35/0x70
May 15 00:58:53 gate vmunix: [189490.571424]  [<c1070359>] ? tick_sched_timer+0x59/0xd0
May 15 00:58:53 gate vmunix: [189490.571446]  [<c1063145>] ? __remove_hrtimer+0x45/0xa0
May 15 00:58:53 gate vmunix: [189490.571467]  [<c1063355>] ? __run_hrtimer+0x75/0x190
May 15 00:58:53 gate vmunix: [189490.571489]  [<c1069700>] ? ktime_get+0x60/0x100
May 15 00:58:53 gate vmunix: [189490.571510]  [<c1070300>] ? tick_nohz_handler+0x100/0x100
May 15 00:58:53 gate vmunix: [189490.571532]  [<c10636f1>] ? hrtimer_interrupt+0x101/0x2b0
May 15 00:58:53 gate vmunix: [189490.571555]  [<c101cd6c>] ? smp_apic_timer_interrupt+0x4c/0x90
May 15 00:58:53 gate vmunix: [189490.571577]  [<c12ee6de>] ? apic_timer_interrupt+0x2a/0x30
May 15 00:58:53 gate vmunix: [189490.571600]  [<c11a392b>] ? _copy_from_user+0x4b/0x130
May 15 00:58:53 gate vmunix: [189490.571622]  [<c124ae30>] ? sys_socketcall+0x50/0x2e0
May 15 00:58:53 gate vmunix: [189490.571644]  [<c1048141>] ? irq_exit+0x31/0xa0
May 15 00:58:53 gate vmunix: [189490.571664]  [<c1004136>] ? do_IRQ+0x46/0xc0
May 15 00:58:53 gate vmunix: [189490.571685]  [<c10fe301>] ? sys_read+0x41/0x80
May 15 00:58:53 gate vmunix: [189490.571706]  [<c12eeb58>] ? sysenter_do_call+0x12/0x28
May 15 00:58:53 gate vmunix: [189490.571728]  [<c12e0000>] ? msi_ht_cap_enabled+0x70/0x8d

There was no other indication of (high) activity at that time in any other
logs.  Should I be concerned?

This is a new machine, with CedarTrail Atom D2500 CPU (D2500CC motherboard from
Intel), used as a router.  I haven't seen this message before, and this is the
only "problem report" on this machine.

Thanks,

/mjt
