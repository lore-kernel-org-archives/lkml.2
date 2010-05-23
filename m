Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0EWQ3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 12:29:35 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:32940 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0EWQ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 12:29:33 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel paging request
Date: Sun, 23 May 2010 18:29:32 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-gentoo-r1-ck1; KDE/4.4.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231829.32106.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1+4JXKFYa3in8s9ptZMtw2HMsy4waWkmg48gR3S
	3wQfg0KMRXyUhEpMCIoQ5kznpKYE5sUT2TqdbTWBi9q6uEwIMV
	hDXH5L58g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have a system running, now its running a 2.6.34 but it also happend 
with 2.6.33.x and 2.6.32.x.
I hit a BUG and the whole system hang. I had to reboot and the console 
was to small to show the full BUG.
But now I got the framebuffer setup and could write the following dump 
down (by hand, so there might be some typos or so, I have a "screenshot" 
if you have a specific question)

The system is a amd64 phenom X4 with 2 x 4GB non-ECC RAM and a raid6 for 
/ and a data-partition as well as a raid1 for swap.
I ran memtest86+ 4.0 and it showed no errors for two passes.

An hour before that BUG I saw a lot of async-processes.
It happens round about once a day, will check if its the same or similar 
the next time.

But any hints are greatly appreciated! (How to solve or how to get 
needed informations.)

Thanks,
Markus

PS: Please CC me.


[64112.493940] BUG: unable to handle kernel paging request at 
0000000001912178
[64112.499847] IP: [<ffffffff810303fe>] pick_next_task_fair+0x4e/0x130
[64112.502507] PGD 0
[64112.502507] Oops: 0000 [#1] SMP
[64112.502507] last sysfs file: 
/sys/devices/platform/w83627ehf.656/cpu0_vid
[64112.502507] CPU 2
[64112.502507] Modules linked in: xt_time ftdi_sio usbserial 
tcp_highspeed cpufreq_userspace af_packet bonding w83627ehf hwmon_vid 
ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
iptables_filter ipt_addrtype xt_dscp xt_string xt_owner xt_multiport 
xt_mark xt_iprange xt_hashlimit xt_connmark xt_NFQUEUE xt_MARK 
xt_CONNMARK nf_conntrack ip_tables x_tables fuse cpufreq_ondemand 
powernow_k8 freq_table usbhid hid ide_pci_generic edac_core 8250_pnp 
k10temp r8169 hwmon rtc_cmos rtc_core rtc_lib 8250 sg mii serial_core 
unix
[64112.502507] 
[64112.502507] Pid: 0, comm: swapper Not tainted 2.6.34 #3 
M3A790GXH/128M/To Be Filled By O.E.M.
[64112.502507] RIP: 0010:[<ffffffff810303fe>]  [<ffffffff810303fe>] 
pick_next_task_fair+0x4e/0x130
[64112.502507] RSP: 0018:ffff88010060b308  EFLAGS: 00010046
[64112.502507] RAX: ffff88010060b308 RBX: ffff88010060b2f8 RCX: 
0000000000000000
[64112.502507] RDX: ffff88010060b2f8 RSI: ffff88021fc64140 RDI: 
0000000000000000
[64112.502507] RBP: ffff88010060b2f8 R08: 0000000000000000 R09: 
00000000ffffffff
[64112.502507] R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000000000
[64112.502507] R13: 00000000019129c0 R14: 0000000000000000 R15: 
0000000000000002
[64112.502507] FS:  00007ffb68af7910(0000) GS:ffff880001900000(0000) 
knlGS:0000000000000000
[64112.502507] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[64112.502507] CR2: 0000000001912178 CR3: 000000018d37b000 CR4: 
00000000000006e0
[64112.502507] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[64112.502507] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[64112.502507] Process swapper (pid: 0, threadinfo ffff88021fc92000, 
task ffff88021fc64140)
[64112.502507] Stack:
[64112.502507]  00000000000120c0 ffff8800019120c0 0000000000000002 
0000000000000000
[64112.502507] <0> ffff88021fc644c8 ffffffff8132dca0 0000000000000000 
0000000000004000
[64112.502507] <0> ffff88021fc93fd8 ffff88021fc93fd8 ffff88021fc64140 
00000000000120c0
[64112.502507] Call Trace:
[64112.502507]  [<ffffffff8132dca0>] ? schedule+0x630/0x890
[64112.502507]  [<ffffffff810015ae>] ? cpu_idle+0x2e/0x90
[64112.502507] Code: 8b bf b0 00 00 00 31 ed 48 8d 50 f0 48 85 c0 48 0f 
45 ea 48 85 ff 74 10 48 89 ee e8 8d d3 ff ff 85 c0 0f 8e c5 00 00 00 48 
89 eb <49> 8b bd b8 00 00 00 48 85 ff 74 10 48 89 ee e8 6e d3 ff ff 85
[64112.502507] RIP  [<ffffffff810303fe>] pick_next_task_fair+0x4e/0x130
[64112.502507]  RSP <ffff88021fc93e58>
[64112.502507] CR2: 0000000001912178
[64112.502507] ---[ end trace 21311dbab0670ec5 ]---
[64112.502507] Kernel panic - not syncing: Attempted to kill the idle 
task!
[64112.502507] Pid: 0, comm: swapper Tainted: G      D    2.6.34 #3
[64112.502507] Call Trace:
[64112.502507]  [<ffffffff8132d15f>] ? panic+0x85/0xff
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? printk+0x4e/0x57
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? do_exit+0x60a/0x7a0
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? bit_cursor+0x0/0x620
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? up+0x16/0x50
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? kmsg_dump+0x7d/0x140
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? oops_end+0x95/0xa0
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? no_context+0xf8/0x260
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? 
__bad_area_nosemaphore+0x14d/0x220
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? enqueue_task_fair+0x184/0x2c0
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? enqueue_task+0x56/0x60
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? activate_task+0x56/0x30
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? cpumask_next_and+0x23/0x40
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? do_page_fault+0x28e/0x390
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? page_fault+0x1f/0x30
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? pick_next_task_fair+0x4e/0x130
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? finish_task_switch+0x34/0xc0
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? schedule+0x630/0x890
[64112.502507]  [<xxxxxxxxxxxxxxxx>] ? cpu_idle+0x2e/0x90
