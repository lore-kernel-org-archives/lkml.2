Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab1HDCWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 22:22:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56737 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab1HDCWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 22:22:00 -0400
X-Nat-Received: from [202.181.97.72]:58532 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1312424506.18772
Message-Id: <201108040221.p742Lk3R069631@www262.sakura.ne.jp>
Subject: Re: [3.0-git16] Oops at driver_uevent_store().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: lacombar@gmail.com, greg@kroah.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Aug 2011 11:21:45 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 04082011 #5783366, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 005bdad7 "eisa/pci_eisa.c: fix section mismatch" triggers oops.
Reverting it solved the oops. Is this rather a sysfs bug?

[    7.460292] dracut: Mounted root filesystem /dev/sda1
[    7.603017] dracut: Loading SELinux policy
[    7.976804] dracut: /sbin/load_policy: Can't load policy: No such device
[    8.095959] dracut: Switching root
[    9.452334] udev: starting version 147
[    9.456695] BUG: unable to handle kernel paging request at c15dd684
[    9.457860] IP: [<c12408a0>] driver_uevent_store+0x20/0x40
[    9.457860] *pde = 01d60067 *pte = 015dd162 
[    9.457860] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[    9.457860] Modules linked in:
[    9.457860] 
[    9.457860] Pid: 2914, comm: udevadm Tainted: G        W   3.0.0-03636-g005bdad #12 VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform
[    9.457860] EIP: 0060:[<c12408a0>] EFLAGS: 00010246 CPU: 1
[    9.457861] EIP is at driver_uevent_store+0x20/0x40
[    9.457861] EAX: 00000000 EBX: 00000003 ECX: ffffffff EDX: f4422000
[    9.457861] ESI: c15dd650 EDI: 00000003 EBP: f4b63f30 ESP: f4b63f24
[    9.457861]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    9.459164] Process udevadm (pid: 2914, ti=f4b62000 task=f49f87e0 task.ti=f4b62000)
[    9.463514] Stack:
[    9.464278]  00000000 c1240880 f4d61f70 f4b63f40 c12405e7 c13e0240 f5c1bea8 f4b63f64
[    9.465858]  c111cf6c 00000003 c13e0240 f4f82f84 f4d61f70 f18cdf20 00000003 bfe20f1e
[    9.465858]  f4b63f8c c10c6bba f4b63f98 f18cdf28 00000020 c111ced0 f4b63fa0 f18cdf20
[    9.467123] Call Trace:
[    9.468030]  [<c1240880>] ? bus_uevent_store+0x40/0x40
[    9.469764]  [<c12405e7>] drv_attr_store+0x27/0x40
[    9.469856]  [<c111cf6c>] sysfs_write_file+0x9c/0xf0
[    9.469856]  [<c10c6bba>] vfs_write+0x9a/0x140
[    9.469857]  [<c111ced0>] ? sysfs_open_file+0x1e0/0x1e0
[    9.469857]  [<c10c6d2d>] sys_write+0x3d/0x70
[    9.469857]  [<c13be60c>] sysenter_do_call+0x12/0x32
[    9.469857] Code: f8 89 ec 5d c3 8d b6 00 00 00 00 55 89 e5 83 ec 0c 89 5d f8 89 cb 89 75 fc 8d 4d f4 89 c6 89 d0 89 da e8 34 b5 f7 ff 85 c0 75 0b <8b> 46 34 8b 55 f4 e8 b5 b9 f7 ff 89 d8 8b 75 fc 8b 5d f8 89 ec 
[    9.469964] EIP: [<c12408a0>] driver_uevent_store+0x20/0x40 SS:ESP 0068:f4b63f24
[    9.471828] CR2: 00000000c15dd684
[    9.472987] ---[ end trace 93d72a36b9146f25 ]---
[    9.959305] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    9.961686] pcnet32 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    9.963766] pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:6c:1a:76 assigned IRQ 19

Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.0-git16 .

Regards.
