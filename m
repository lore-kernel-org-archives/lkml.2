Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2AXWcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:32:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48797 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2AXWcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:32:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at kernel/workqueue.c:3659
Date: Tue, 24 Jan 2012 23:36:22 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
References: <4F1EC8D5.5040102@suse.cz> <4F1ED9C4.9020503@linux.vnet.ibm.com> <4F1EDB41.2070303@suse.cz>
In-Reply-To: <4F1EDB41.2070303@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201242336.22482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 24, 2012, Jiri Slaby wrote:
> On 01/24/2012 05:18 PM, Srivatsa S. Bhat wrote:
> > Hi Jiri,
> > 
> > On 01/24/2012 08:35 PM, Jiri Slaby wrote:
> > 
> >> Hi,
> >>
> >> this is a freshly booted system. When I do s2dsk, I see:
> >> ...
> >> Freezing remaining freezable tasks ... BUG: 'workqueue_freezing' is true!
> >> ------------[ cut here ]------------
> >> kernel BUG at /l/latest/linux/kernel/workqueue.c:3659!
> >> invalid opcode: 0000 [#1] SMP
> >> CPU 0
> >> Modules linked in:
> >>
> >> Pid: 2669, comm: s2disk Not tainted 3.3.0-rc1-next-20120124_64+ #1627
> >> Bochs Bochs
> >> RIP: 0010:[<ffffffff8107e365>]  [<ffffffff8107e365>]
> >> freeze_workqueues_begin+0x195/0x1a0
> >> RSP: 0018:ffff880046f01d68  EFLAGS: 00010292
> >> RAX: 0000000000000023 RBX: 0000000000000001 RCX: 00000000000000c9
> >> RDX: 0000000000000077 RSI: 0000000000000046 RDI: ffffffff81b51f7c
> >> RBP: ffff880046f01d98 R08: ffffffff81a9d760 R09: 0000000000000000
> >> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> >> R13: 00007fff579464dc R14: ffffffffffffffff R15: 0000000000000004
> >> FS:  00007f3c65d54700(0000) GS:ffff880049600000(0000) knlGS:0000000000000000
> >> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> CR2: 00007f3c64f58c20 CR3: 0000000045b64000 CR4: 00000000000006f0
> >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >> Process s2disk (pid: 2669, threadinfo ffff880046f00000, task
> >> ffff880047251980)
> >> Stack:
> >>  ffff880046f01d98 0000000000000001 0000000000000000 00007fff579464dc
> >>  ffffffffffffffff 0000000000000004 ffff880046f01e18 ffffffff81096cb9
> >>  00000000ffff0124 0000000000000004 ffff880046f01e18 000000004f1ec7d1
> >> Call Trace:
> >>  [<ffffffff81096cb9>] try_to_freeze_tasks+0x1b9/0x2d0
> >>  [<ffffffff81096ed5>] freeze_kernel_threads+0x25/0x90
> >>  [<ffffffff81097b55>] hibernation_snapshot+0x75/0x2e0
> >>  [<ffffffff8109d724>] snapshot_ioctl+0x314/0x4e0
> >>  [<ffffffff81130856>] do_vfs_ioctl+0x96/0x550
> >>  [<ffffffff8111ff7b>] ? vfs_write+0x10b/0x180
> >>  [<ffffffff81130d5a>] sys_ioctl+0x4a/0x80
> >>  [<ffffffff81630e22>] system_call_fastpath+0x16/0x1b
> >> Code: c7 c6 0a a4 92 81 48 c7 c7 16 65 92 81 31 c0 e8 19 94 5a 00 0f 0b
> >> 48 c7 c6 27 a4 92 81 48 c7 c7 16 65 92 81 31 c0 e8 02 94 5a 00 <0f> 0b
> >> 66 0f 1f 84 00 00 00 00 00 55 48 c7 c7 82 4b b9 81 48 89
> >> RIP  [<ffffffff8107e365>] freeze_workqueues_begin+0x195/0x1a0
> >>  RSP <ffff880046f01d68>
> >> ---[ end trace 632574abdc098963 ]---
> >>
> > 
> > 
> > I couldn't find any obvious root-cause from a quick check. Is this completely
> > reproducible upon a fresh boot?
> 
> True.
> 
> The cause is that the function is called twice:

Which function?

Rafael


> # s2disk
> PM: Marking nosave pages: 000000000009f000 - 0000000000100000
> PM: Basic memory bitmaps created
> Syncing filesystems ... done.
> Freezing user space processes ... (elapsed 0.01 seconds) done.
> PM: Preallocating image memory... done (allocated 264170 pages)
> PM: Allocated 1056680 kbytes in 0.45 seconds (2348.17 MB/s)
> Freezing remaining freezable tasks ... Pid: 2650, comm: s2disk Not
> tainted 3.3.0-rc1-next-20120124_64+ #1628
> Call Trace:
>  [<ffffffff8109edd2>] ? getnstimeofday+0x52/0xf0
>  [<ffffffff8107e206>] freeze_workqueues_begin+0x36/0x1b0
>  [<ffffffff81096cc9>] try_to_freeze_tasks+0x1b9/0x2d0
>  [<ffffffff81096ee5>] freeze_kernel_threads+0x25/0x90
>  [<ffffffff81097b65>] hibernation_snapshot+0x75/0x2e0
>  [<ffffffff8109d734>] snapshot_ioctl+0x314/0x4e0
>  [<ffffffff81130866>] do_vfs_ioctl+0x96/0x550
>  [<ffffffff8111ff8b>] ? vfs_write+0x10b/0x180
>  [<ffffffff81130d6a>] sys_ioctl+0x4a/0x80
>  [<ffffffff81630e22>] system_call_fastpath+0x16/0x1b
> (elapsed 0.03 seconds) done.
> PM: freeze of devices complete after 57.216 msecs
> PM: late freeze of devices complete after 0.720 msecs
> ACPI: Preparing to enter system sleep state S4
> PM: Saving platform NVS memory
> Disabling non-boot CPUs ...
> CPU 1 is now offline
> PM: Creating hibernation image:
> PM: Need to copy 24112 pages
> PM: Normal pages needed: 24112 + 1024, available pages: 277076
> PM: Hibernation image created (24112 pages copied)
> Enabling non-boot CPUs ...
> Booting Node 0 Processor 1 APIC 0x1
> smpboot cpu 1: start_ip = 9a000
> Calibrating delay loop (skipped) already calibrated this CPU
> NMI watchdog disabled (cpu1): hardware events not enabled
> CPU1 is up
> ACPI: Waking up from system sleep state S4
> PM: early thaw of devices complete after 0.093 msecs
> ata_piix 0000:00:01.1: setting latency timer to 64
> e1000 0000:00:03.0: setting latency timer to 64
> e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> ata2.01: NODEV after polling detection
> ata1.00: configured for MWDMA2
> ata2.00: configured for MWDMA2
> ata1.01: configured for MWDMA2
> sd 0:0:1:0: [sdb] Starting disk
> sd 0:0:0:0: [sda] Starting disk
> PM: thaw of devices complete after 192.317 msecs
> PM: Preallocating image memory... done (allocated 264295 pages)
> PM: Allocated 1057180 kbytes in 0.12 seconds (8809.83 MB/s)
> Freezing remaining freezable tasks ... BUG: 'workqueue_freezing' is true!
> ------------[ cut here ]------------
> kernel BUG at /l/latest/linux/kernel/workqueue.c:3659!
> invalid opcode: 0000 [#1] SMP
> CPU 1
> Modules linked in:
> 
> Pid: 2650, comm: s2disk Not tainted 3.3.0-rc1-next-20120124_64+ #1628
> Bochs Bochs
> RIP: 0010:[<ffffffff8107e371>]  [<ffffffff8107e371>]
> freeze_workqueues_begin+0x1a1/0x1b0
> RSP: 0018:ffff8800456d7d68  EFLAGS: 00010292
> RAX: 0000000000000023 RBX: 0000000000000001 RCX: 0000000000000073
> RDX: 00000000000000ea RSI: 0000000000000046 RDI: ffffffff81b51f7c
> RBP: ffff8800456d7d98 R08: ffffffff81a9d760 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 00007fff11d8709c R14: ffffffffffffffff R15: 0000000000000004
> FS:  00007f4744397700(0000) GS:ffff880049700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000001f46bc0 CR3: 000000004483b000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process s2disk (pid: 2650, threadinfo ffff8800456d6000, task
> ffff880046c93300)
> Stack:
>  ffff8800456d7d98 0000000000000001 0000000000000000 00007fff11d8709c
>  ffffffffffffffff 0000000000000004 ffff8800456d7e18 ffffffff81096cc9
>  00000000ffff008f 0000000000000004 ffff8800456d7e18 000000004f1edaaf
> Call Trace:
>  [<ffffffff81096cc9>] try_to_freeze_tasks+0x1b9/0x2d0
>  [<ffffffff81096ee5>] freeze_kernel_threads+0x25/0x90
>  [<ffffffff81097b65>] hibernation_snapshot+0x75/0x2e0
>  [<ffffffff8109d734>] snapshot_ioctl+0x314/0x4e0
>  [<ffffffff81130866>] do_vfs_ioctl+0x96/0x550
>  [<ffffffff8111ff8b>] ? vfs_write+0x10b/0x180
>  [<ffffffff81130d6a>] sys_ioctl+0x4a/0x80
>  [<ffffffff81630e22>] system_call_fastpath+0x16/0x1b
> Code: c7 c6 0a a4 92 81 48 c7 c7 16 65 92 81 31 c0 e8 1d 94 5a 00 0f 0b
> 48 c7 c6 27 a4 92 81 48 c7 c7 16 65 92 81 31 c0 e8 06 94 5a 00 <0f> 0b
> 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 c7 c7 82 4b
> RIP  [<ffffffff8107e371>] freeze_workqueues_begin+0x1a1/0x1b0
>  RSP <ffff8800456d7d68>
> ---[ end trace 696a23a038efce41 ]---
> 
> 
> 
> >  
> > Regards,
> > Srivatsa S. Bhat
> > IBM Linux Technology Center
> > 
> 
> 
> 

