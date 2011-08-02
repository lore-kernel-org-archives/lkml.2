Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1HBC0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 22:26:06 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53775 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab1HBCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 22:25:56 -0400
X-Nat-Received: from [202.181.97.72]:49262 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1312251955.22686
Message-Id: <201108020225.p722PtG5093431@www262.sakura.ne.jp>
Subject: [3.0-git16] Oops at driver_uevent_store().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Aug 2011 11:25:55 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 02082011 #5769817, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting below oops on CentOS 6.0 (x86_32) since at least 3.0-git11.
3.0 works OK.

Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.0-git16 .

[    5.434284] NET: Registered protocol family 17
[    5.439180] Using IPI No-Shortcut mode
[    5.441357] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input2
[    5.451427] debug: unmapping init memory c1583000..c173d000
[    5.453428] Write protecting the kernel text: 3848k
[    5.454413] Testing CPA: Reverting c1000000-c13c2000
[    5.456225] Testing CPA: write protecting again
[    5.457817] Write protecting the kernel read-only data: 1488k
[    5.459136] Testing CPA: undo c13c2000-c1536000
[    5.460662] Testing CPA: write protecting again
[    5.474749] dracut: dracut-004-33.2.el6_0
[    5.484396] udev: starting version 147
[    5.486118] ------------[ cut here ]------------
[    5.487813] WARNING: at fs/proc/base.c:1123 oom_adjust_write+0x266/0x280()
[    5.490401] Hardware name: VMware Virtual Platform
[    5.491594] udevd (1193): /proc/1193/oom_adj is deprecated, please use /proc/1193/oom_score_adj instead.
[    5.494400] Modules linked in:
[    5.495771] Pid: 1193, comm: udevd Tainted: G        W   3.0.0-git16 #1
[    5.497469] Call Trace:
[    5.498398]  [<c103a2bd>] warn_slowpath_common+0x6d/0xa0
[    5.499915]  [<c1113046>] ? oom_adjust_write+0x266/0x280
[    5.502065]  [<c1113046>] ? oom_adjust_write+0x266/0x280
[    5.503676]  [<c103a36e>] warn_slowpath_fmt+0x2e/0x30
[    5.504858]  [<c1113046>] oom_adjust_write+0x266/0x280
[    5.507912]  [<c10c6b7a>] vfs_write+0x9a/0x140
[    5.509834]  [<c1112de0>] ? oom_score_adj_write+0x250/0x250
[    5.511514]  [<c10c6ced>] sys_write+0x3d/0x70
[    5.512328]  [<c13c0d0c>] sysenter_do_call+0x12/0x32
[    5.515909] ---[ end trace 93d72a36b9146f24 ]---
[    5.819969] dracut: Starting plymouth daemon
[    5.887203] ata_id used greatest stack depth: 5840 bytes left
[    6.224024] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    6.280249] dracut: Mounted root filesystem /dev/sda1
[    6.355938] dracut: Loading SELinux policy
[    6.626868] load_policy used greatest stack depth: 5696 bytes left
[    6.629000] dracut: /sbin/load_policy: Can't load policy: No such device
[    6.692244] dracut: Switching root
[    7.657652] udev: starting version 147
[    7.669087] BUG: unable to handle kernel paging request at c15e2744
[    7.669648] IP: [<c1242f20>] driver_uevent_store+0x20/0x40
[    7.669648] *pde = 01d65067 *pte = 015e2162 
[    7.671783] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    7.673560] Modules linked in:
[    7.673647] 
[    7.673647] Pid: 2874, comm: udevadm Tainted: G        W   3.0.0-git16 #1 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[    7.673648] EIP: 0060:[<c1242f20>] EFLAGS: 00010246 CPU: 1
[    7.675163] EIP is at driver_uevent_store+0x20/0x40
[    7.676075] EAX: 00000000 EBX: 00000003 ECX: ffffffff EDX: f67ce000
[    7.677645] ESI: c15e2710 EDI: 00000003 EBP: f1b13f30 ESP: f1b13f24
[    7.677646]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    7.677646] Process udevadm (pid: 2874, ti=f1b12000 task=f138c3a0 task.ti=f1b12000)
[    7.679454] Stack:
[    7.680206]  00000000 c1242f00 f4a7df70 f1b13f40 c1242c67 c13e24a0 f6662d28 f1b13f64
[    7.682162]  c111ce8c 00000003 c13e24a0 f106bf84 f4a7df70 f411ef20 00000003 bfe2df1e
[    7.686981]  f1b13f8c c10c6b7a f1b13f98 f411ef28 00000020 c111cdf0 f1b13fa0 f411ef20
[    7.689530] Call Trace:
[    7.689816]  [<c1242f00>] ? bus_uevent_store+0x40/0x40
[    7.691158]  [<c1242c67>] drv_attr_store+0x27/0x40
[    7.692418]  [<c111ce8c>] sysfs_write_file+0x9c/0xf0
[    7.695157]  [<c10c6b7a>] vfs_write+0x9a/0x140
[    7.696104]  [<c111cdf0>] ? sysfs_open_file+0x1e0/0x1e0
[    7.697762]  [<c10c6ced>] sys_write+0x3d/0x70
[    7.699155]  [<c13c0d0c>] sysenter_do_call+0x12/0x32
[    7.700128] Code: f8 89 ec 5d c3 8d b6 00 00 00 00 55 89 e5 83 ec 0c 89 5d f8 89 cb 89 75 fc 8d 4d f4 89 c6 89 d0 89 da e8 34 ae f7 ff 85 c0 75 0b <8b> 46 34 8b 55 f4 e8 b5 b2 f7 ff 89 d8 8b 75 fc 8b 5d f8 89 ec 
[    7.711151] EIP: [<c1242f20>] driver_uevent_store+0x20/0x40 SS:ESP 0068:f1b13f24
[    7.713324] CR2: 00000000c15e2744
[    7.714362] ---[ end trace 93d72a36b9146f25 ]---
[    8.165941] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    8.168320] pcnet32 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    8.170581] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:6c:1a:76 assigned IRQ 19
[    8.175791] pcnet32: eth0: registered as PCnet/PCI II 79C970A
[    8.177491] pcnet32: 1 cards_found
[    8.281700] ip used greatest stack depth: 5588 bytes left
[    9.131734] EXT4-fs (sda1): re-mounted. Opts: (null)
[    9.687123] NET: Registered protocol family 10
