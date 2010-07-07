Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0GGBiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:38:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:52354 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751649Ab0GGBix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:38:53 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/ChWMfxlbC4cCOFT0JpGMWF1m6torA0aaajJwE54
	1NToHuBiWGK0G5
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: devel@driverdev.osuosl.org
Subject: Re: Oops after unloading staging/panel/panel.ko
Date: Wed, 7 Jul 2010 03:38:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: kernel-testers@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <201007070313.38814.PeterHuewe@gmx.de>
In-Reply-To: <201007070313.38814.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007070338.50023.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another oops trace caused by the same problem.
This time I inserted the module using

# insmod panel.ko parport=0 lcd_height=2 lcd_width=20 lcd_charset=1 lcd_type=5 
lcd_e_pin=1 lcd_rs_pin=14 lcd_rw_pin=0

parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
ppdev: user-space parallel port driver
Panel driver version 0.9.5 registered on parport0 (io=0x378).
parport0: panel tried to release parport when not owner
BUG: unable to handle kernel NULL pointer dereference at 0000000000000081
IP: [<ffffffffa024f6cf>] parport_register_device+0x25/0x26b [parport]
PGD 13446d067 PUD 134652067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/platform/w83627ehf.656/in8_input
CPU 0 
Modules linked in: panel(+) ppdev parport_pc parport netconsole w83627ehf 
vboxnetflt vboxnetadp vboxdrv i2c_piix4 fglrx(P) [last unloaded: panel]

Pid: 6744, comm: insmod Tainted: P           2.6.34 #1 939A785GMH/128M/To Be 
Filled By O.E.M.
RIP: 0010:[<ffffffffa024f6cf>]  [<ffffffffa024f6cf>] 
parport_register_device+0x25/0x26b [parport]
RSP: 0018:ffff8801342efe88  EFLAGS: 00010296
RAX: 0000000000000001 RBX: ffff88013d58cc00 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffffa027c83d RDI: ffff88013d58cc00
RBP: ffff88013d58cc00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: ffff88013427e5d0 R12: ffffffffa027c83d
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f63473a8700(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000081 CR3: 000000013446c000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process insmod (pid: 6744, threadinfo ffff8801342ee000, task ffff880133a30cf0)
Stack:
 0000000000000000 ffff88013d58cc00 ffffffffa027cf70 0000000000000000
<0> 00007fffcc7ff8cd 0000000001222010 0000000001222080 ffffffffa027bb21
<0> ffffffffa027d3b0 0000000000000000 00000000ffffffff ffff88013d58cc00
Call Trace:
 [<ffffffffa027bb21>] ? panel_attach+0x66/0x2a0 [panel]
 [<ffffffffa024f9c2>] ? parport_register_driver+0x44/0x93 [parport]
 [<ffffffffa0281000>] ? panel_init_module+0x0/0xa [panel]
 [<ffffffffa027b460>] ? panel_init+0x1e1/0x29c [panel]
 [<ffffffff810001e1>] ? do_one_initcall+0x50/0x13d
 [<ffffffff81059688>] ? sys_init_module+0xc5/0x21a
 [<ffffffff81001eeb>] ? system_call_fastpath+0x16/0x1b
Code: 5d e9 fd fd ff ff 41 57 49 89 cf 41 56 49 89 d6 41 55 45 89 cd 41 54 49 
89 f4 55 48 89 fd 53 48 83 ec 08 4c 89 04 24 48 8b 47 40 <f6> 80 80 00 00 00 
02 74 17 48 8b 77 18 31 c0 48 c7 c7 62 17 25 
RIP  [<ffffffffa024f6cf>] parport_register_device+0x25/0x26b [parport]
 RSP <ffff8801342efe88>
CR2: 0000000000000081
---[ end trace be11e64dc4171169 ]---
general protection fault: 0000 [#2] SMP 
last sysfs file: /sys/devices/platform/w83627ehf.656/in8_input
CPU 1 
Modules linked in: panel(+) ppdev parport_pc parport netconsole w83627ehf 
vboxnetflt vboxnetadp vboxdrv i2c_piix4 fglrx(P) [last unloaded: panel]

Pid: 6746, comm: notification-da Tainted: P      D    2.6.34 #1 
939A785GMH/128M/To Be Filled By O.E.M.
RIP: 0010:[<ffffffff8115cb4a>]  [<ffffffff8115cb4a>] shm_fault+0x16/0x19
RSP: 0000:ffff8801343a1d30  EFLAGS: 00010292
RAX: ffffffff810da2b1 RBX: 0000000000000000 RCX: ffff880133fccfd0
RDX: 00007f783f43f000 RSI: ffff8801343a1d78 RDI: ffff880133af3090
RBP: 0000000000000001 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 30247c8d4850ec83 R12: ffff8801340911f8
R13: 0000000000000006 R14: ffff880133af3090 R15: ffff880133af3090
FS:  00007f784a874760(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f783f43f000 CR3: 0000000134652000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process notification-da (pid: 6746, threadinfo ffff8801343a0000, task 
ffff880135ad26a0)
Stack:
 ffffffff8107ec09 0000000000000000 ffff880133fccfd0 00007f783f43f000
<0> ffff880133a70200 ffff880007182780 ffff8801343a1f50 ffffffff81304993
<0> ffffffff81097caa 0000100000000001 0000000000000002 00007f783f43f000
Call Trace:
 [<ffffffff8107ec09>] ? __do_fault+0x56/0x432
 [<ffffffff81304993>] ? sock_aio_write+0x0/0x10b
 [<ffffffff81097caa>] ? do_sync_readv_writev+0x9a/0xde
 [<ffffffff81080fca>] ? handle_mm_fault+0x45f/0x856
 [<ffffffff813b6eee>] ? do_page_fault+0x338/0x35c
 [<ffffffff8109838f>] ? do_readv_writev+0x183/0x198
 [<ffffffff813b44df>] ? page_fault+0x1f/0x30
Code: 00 c7 87 f0 00 00 00 00 00 00 00 48 83 c7 08 e9 2e d9 ff ff 90 48 8b 87 
90 00 00 00 48 8b 80 98 00 00 00 48 8b 40 18 4c 8b 58 10 <41> ff e3 48 8b 87 
98 00 00 00 48 8b 78 10 48 8b 47 20 48 8b 40 
RIP  [<ffffffff8115cb4a>] shm_fault+0x16/0x19
 RSP <ffff8801343a1d30>
---[ end trace be11e64dc417116a ]---
BUG: unable to handle kernel paging request at 00000002dead00a0
IP: [<ffffffff813b3636>] down_write+0x16/0x27
PGD 0 
Oops: 0002 [#3] SMP 
last sysfs file: /sys/devices/platform/w83627ehf.656/in8_input
CPU 1 
Modules linked in: panel(+) ppdev parport_pc parport netconsole w83627ehf 
vboxnetflt vboxnetadp vboxdrv i2c_piix4 fglrx(P) [last unloaded: panel]

Pid: 6746, comm: notification-da Tainted: P      D    2.6.34 #1 
939A785GMH/128M/To Be Filled By O.E.M.
RIP: 0010:[<ffffffff813b3636>]  [<ffffffff813b3636>] down_write+0x16/0x27
RSP: 0018:ffff8801343a1b18  EFLAGS: 00010246
RAX: 00000002dead00a0 RBX: 00000002dead00a0 RCX: ffff880133a70260
RDX: ffffffff00000001 RSI: ffff880133df71e0 RDI: 00000002dead00a0
RBP: 00000002dead0000 R08: ffff880133df71e0 R09: ffff880133df71e0
R10: ffff88000190d3d0 R11: ffff88000190e3a8 R12: 00000002dead00a0
R13: ffff880133a70260 R14: ffff8801339e8840 R15: 000000000000000b
FS:  00007f784a874760(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000002dead00a0 CR3: 00000000015a9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process notification-da (pid: 6746, threadinfo ffff8801343a0000, task 
ffff880135ad26a0)
Stack:
 ffff880133b1fe00 ffffffff8115ce1f ffff880133af3090 ffff880133ebf330
<0> ffff880133a70200 ffffffff8108480e ffff880133a70260 ffff88000190d3d0
<0> ffff880133af3090 ffffffff8108494f 00000000000003de ffff88000190d3d0
Call Trace:
 [<ffffffff8115ce1f>] ? shm_close+0x25/0x9f
 [<ffffffff8108480e>] ? remove_vma+0x2c/0x61
 [<ffffffff8108494f>] ? exit_mmap+0x10c/0x12a
 [<ffffffff81031ddf>] ? mmput+0x2b/0xcd
 [<ffffffff810356e1>] ? exit_mm+0x111/0x11c
 [<ffffffff813b3650>] ? down_read+0x9/0x19
 [<ffffffff8103703b>] ? do_exit+0x1f9/0x66a
 [<ffffffff810349e4>] ? kmsg_dump+0x99/0x12a
 [<ffffffff813b4f6f>] ? oops_end+0x86/0x8b
 [<ffffffff813b44af>] ? general_protection+0x1f/0x30
 [<ffffffff810da2b1>] ? loadavg_proc_show+0x0/0xc0
 [<ffffffff8115cb4a>] ? shm_fault+0x16/0x19
 [<ffffffff8107ec09>] ? __do_fault+0x56/0x432
 [<ffffffff81304993>] ? sock_aio_write+0x0/0x10b
 [<ffffffff81097caa>] ? do_sync_readv_writev+0x9a/0xde
 [<ffffffff81080fca>] ? handle_mm_fault+0x45f/0x856
 [<ffffffff813b6eee>] ? do_page_fault+0x338/0x35c
 [<ffffffff8109838f>] ? do_readv_writev+0x183/0x198
 [<ffffffff813b44df>] ? page_fault+0x1f/0x30
Code: 85 c0 89 c2 7e 05 ba fc fd ff ff 48 83 c4 78 48 63 c2 5b 5d c3 53 48 89 
fb e8 5d f2 ff ff 48 ba 01 00 00 00 ff ff ff ff 48 89 d8 <f0> 48 0f c1 10 48 
85 d2 74 05 e8 8b e9 dc ff 5b c3 53 48 89 fb 
RIP  [<ffffffff813b3636>] down_write+0x16/0x27
 RSP <ffff8801343a1b18>
CR2: 00000002dead00a0
---[ end trace be11e64dc417116b ]---
Fixing recursive fault but reboot is needed!
