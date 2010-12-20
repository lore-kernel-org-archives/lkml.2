Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab0LTT0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:26:20 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:37308 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab0LTT0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:26:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cOL4UKxjZSH092YINfBQui4rgl0GFaPXdQhK3cFmpzwqpMsjB6sGmGoncLTQgxmfey
         5rhpqaN3yOFJ/vHhgZ9TWsN+wjMYuol5pNMyg5IRpXFWy7lbwx6YrMhKWXmePPddf579
         7FUP2DiIDx+LEDbbq9/teT97o/YcZHD18ppvw=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=mSTLTi29Da5WRzeuG5xyryj-FW7bb8HEW3mGn@mail.gmail.com>
References: <AANLkTi=mSTLTi29Da5WRzeuG5xyryj-FW7bb8HEW3mGn@mail.gmail.com>
Date: Mon, 20 Dec 2010 14:26:17 -0500
X-Google-Sender-Auth: KuDgtoCFsGL5MWo5LUBIF4pcPcc
Message-ID: <AANLkTikPNMC3Pxr9m55ayeyee4Er4F-aqAZ_Yqc-gDwZ@mail.gmail.com>
Subject: Re: BUG after md/raid10:md0: not enough operational mirrors.
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[-dm-devel, +linux-raid]

It has been pointed out to me that I picked the wrong mailing list.
Didn't go down far enough in MAINTAINERS =/

On Mon, Dec 20, 2010 at 2:57 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> Hello,
>
> I've just upgraded to linux-2.6.36.2 on this machine. Right after the
> upgrade, I got an oops on boot which I was unable to capture. I'm
> guessing that it left md state in a somewhat undefined place, although
> I don't know what caused the initial oops. Anyways, on second boot:
>
> [   17.336794] md: Scanned 11 and added 11 devices.
> [   17.337050] md: autorun ...
> [   17.337298] md: considering sdj1 ...
> [   17.337552] md:  adding sdj1 ...
> [   17.337800] md:  adding sdg1 ...
> [   17.338047] md:  adding sdi1 ...
> [   17.338295] md:  adding sdh1 ...
> [   17.338548] md:  adding sdf1 ...
> [   17.338797] md:  adding sde1 ...
> [   17.339046] md:  adding sdk1 ...
> [   17.339295] md:  adding sdd1 ...
> [   17.339556] md:  adding sda1 ...
> [   17.339808] md:  adding sdb1 ...
> [   17.340058] md:  adding sdc1 ...
> [   17.340305] md: created md0
> [   17.340547] md: bind<sdc1>
> [   17.340793] md: bind<sdb1>
> [   17.341037] md: bind<sda1>
> [   17.341287] md: bind<sdd1>
> [   17.341543] md: bind<sdk1>
> [   17.341790] md: bind<sde1>
> [   17.342036] md: bind<sdf1>
> [   17.342284] md: bind<sdh1>
> [   17.342534] md: bind<sdi1>
> [   17.342783] md: bind<sdg1>
> [   17.343031] md: bind<sdj1>
> [   17.343281] md: running:
> <sdj1><sdg1><sdi1><sdh1><sdf1><sde1><sdk1><sdd1><sda1><sdb1><sdc1>
> [   17.344151] md: kicking non-fresh sdj1 from array!
> [   17.344406] md: unbind<sdj1>
> [   17.348365] md: export_rdev(sdj1)
> [   17.348613] md: kicking non-fresh sdg1 from array!
> [   17.348852] md: unbind<sdg1>
> [   17.356343] md: export_rdev(sdg1)
> [   17.356589] md: kicking non-fresh sdi1 from array!
> [   17.356827] md: unbind<sdi1>
> [   17.364325] md: export_rdev(sdi1)
> [   17.364582] md: kicking non-fresh sdh1 from array!
> [   17.364831] md: unbind<sdh1>
> [   17.372308] md: export_rdev(sdh1)
> [   17.372563] md: kicking non-fresh sdf1 from array!
> [   17.372812] md: unbind<sdf1>
> [   17.380291] md: export_rdev(sdf1)
> [   17.380551] md: kicking non-fresh sde1 from array!
> [   17.380801] md: unbind<sde1>
> [   17.388274] md: export_rdev(sde1)
> [   17.388522] md: kicking non-fresh sdk1 from array!
> [   17.388763] md: unbind<sdk1>
> [   17.396256] md: export_rdev(sdk1)
> [   17.397013] md/raid10:md0: not enough operational mirrors.
> [   17.397364] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000014
> [   17.397882] IP: [<ffffffff814ccc1f>] _raw_spin_lock_irq+0xa/0x1b
> [   17.398162] PGD 0
> [   17.398450] Oops: 0002 [#1] SMP
> [   17.398749] last sysfs file:
> [   17.398986] CPU 13
> [   17.399022] Modules linked in:
> [   17.399538]
> [   17.399771] Pid: 1519, comm: md0_raid10 Not tainted 2.6.36.2 #2 X8DT3/X8DT3
> [   17.400013] RIP: 0010:[<ffffffff814ccc1f>]  [<ffffffff814ccc1f>]
> _raw_spin_lock_irq+0xa/0x1b
> [   17.400510] RSP: 0018:ffff88033d151cc0  EFLAGS: 00010082
> [   17.400750] RAX: 0000000000000100 RBX: 0000000000000000 RCX: 0000000000000000
> [   17.400995] RDX: ffff88033e381650 RSI: 0000000000000000 RDI: 0000000000000014
> [   17.401288] RBP: ffff88033d151cc0 R08: ffff88033d150000 R09: 0000000000000000
> [   17.401531] R10: ffffffff81a7d7f0 R11: ffff88033e355dc8 R12: ffff88033d700d80
> [   17.401774] R13: 0000000000000014 R14: 0000000000000000 R15: ffff88033d151e80
> [   17.402018] FS:  0000000000000000(0000) GS:ffff88034e340000(0000)
> knlGS:0000000000000000
> [   17.402478] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   17.402718] CR2: 0000000000000014 CR3: 0000000001a05000 CR4: 00000000000006e0
> [   17.402961] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   17.403252] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   17.403496] Process md0_raid10 (pid: 1519, threadinfo
> ffff88033d150000, task ffff88033e381650)
> [   17.403940] Stack:
> [   17.404195]  ffff88033d151cf0 ffffffff81380efb ffff88033d151d10
> 0000000000000014
> [   17.404536] <0> ffff88033d700d80 ffff88033e381650 ffff88033d151e50
> ffffffff81381900
> [   17.405141] <0> ffffffff81a1cd80 ffff88033e381650 ffff88033e381650
> ffffffff814cb876
> [   17.406019] Call Trace:
> [   17.406279]  [<ffffffff81380efb>] flush_pending_writes+0x1c/0x8a
> [   17.406524]  [<ffffffff81381900>] raid10d+0x69/0xe06
> [   17.406765]  [<ffffffff814cb876>] ? schedule+0x61e/0x66b
> [   17.407008]  [<ffffffff814cbc42>] ? schedule_timeout+0x22/0xbf
> [   17.407299]  [<ffffffff81032a25>] ? finish_task_switch+0x3d/0xb0
> [   17.407547]  [<ffffffff813936bd>] md_thread+0xf8/0x116
> [   17.407791]  [<ffffffff81051e93>] ? autoremove_wake_function+0x0/0x38
> [   17.408033]  [<ffffffff813935c5>] ? md_thread+0x0/0x116
> [   17.408291]  [<ffffffff810519fb>] kthread+0x81/0x89
> [   17.408534]  [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
> [   17.408777]  [<ffffffff8105197a>] ? kthread+0x0/0x89
> [   17.409017]  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
> [   17.409301] Code: eb f6 c9 c3 55 48 89 e5 9c 58 fa ba 00 01 00 00
> f0 66 0f c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c9 c3 55 48 89 e5 fa b8
> 00 01 00 00 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 55 48
> 89 e5
> [   17.412131] RIP  [<ffffffff814ccc1f>] _raw_spin_lock_irq+0xa/0x1b
> [   17.417553]  RSP <ffff88033d151cc0>
> [   17.417789] CR2: 0000000000000014
> [   17.418026] ---[ end trace 1dc7eeca43b701f8 ]---
> [   17.418302] md0_raid10 used greatest stack depth: 4632 bytes left
> [   17.418338] md: pers->run() failed ...
> [   17.418342] md: do_md_run() returned -5
> [   17.418344] md: md0 still in use.
> [   17.418346] md: ... autorun DONE.
>
> Shortly followed by:
>
> [   18.572342] udev: starting version 149
> [   18.572396] udevd (1612): /proc/1612/oom_adj is deprecated, please
> use /proc/1612/oom_score_adj instead.
> [   18.615329] BUG: unable to handle kernel paging request at 00000000000ffeb6
> [   18.615645] IP: [<ffffffff8102a0c7>] __wake_up_common+0x29/0x76
> [   18.615923] PGD 73cd4a067 PUD 73cd4b067 PMD 0
> [   18.616264] Oops: 0000 [#2] SMP
> [   18.616570] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input2/name
> [   18.617020] CPU 2
> [   18.617057] Modules linked in:
> [   18.617558]
> [   18.617796] Pid: 1635, comm: udevd Tainted: G      D     2.6.36.2
> #2 X8DT3/X8DT3
> [   18.618242] RIP: 0010:[<ffffffff8102a0c7>]  [<ffffffff8102a0c7>]
> __wake_up_common+0x29/0x76
> [   18.618719] RSP: 0018:ffff88073cd69de8  EFLAGS: 00010096
> [   18.618958] RAX: 00000000000ffeb6 RBX: ffff88033d700d90 RCX: 0000000000000000
> [   18.619202] RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff88033d700d90
> [   18.619447] RBP: ffff88073cd69e18 R08: 00000000000ffe9e R09: 000000000000000a
> [   18.619691] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> [   18.619934] R13: 0000000000000001 R14: ffff88033d700d98 R15: 0000000000000000
> [   18.620177] FS:  00007fcae5aba6f0(0000) GS:ffff880001c80000(0000)
> knlGS:0000000000000000
> [   18.620625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   18.620886] CR2: 00000000000ffeb6 CR3: 000000073cd49000 CR4: 00000000000006e0
> [   18.621146] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   18.621410] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   18.621761] Process udevd (pid: 1635, threadinfo ffff88073cd68000,
> task ffff88073cd30770)
> [   18.622238] Stack:
> [   18.622487]  0000000300000000 ffff88033d700d90 0000000000000000
> 0000000000000001
> [   18.622928] <0> 0000000000000296 0000000000000003 ffff88073cd69e58
> ffffffff8102d080
> [   18.623596] <0> ffff88073cd69ee8 ffff88033d10b400 0000000000000000
> ffffffff81a44410
> [   18.624514] Call Trace:
> [   18.624816]  [<ffffffff8102d080>] __wake_up+0x38/0x50
> [   18.625075]  [<ffffffff8138e297>] md_wakeup_thread+0x27/0x29
> [   18.625319]  [<ffffffff8138f301>] mddev_unlock+0xa6/0xab
> [   18.625605]  [<ffffffff8138f533>] md_attr_show+0x4c/0x58
> [   18.625867]  [<ffffffff8112a83b>] sysfs_read_file+0xb2/0x131
> [   18.626121]  [<ffffffff810dbd8e>] vfs_read+0xa8/0x100
> [   18.626371]  [<ffffffff810dbeaa>] sys_read+0x47/0x70
> [   18.626666]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
> [   18.626928] Code: c9 c3 55 48 89 e5 41 57 4d 89 c7 41 56 4c 8d 77
> 08 41 55 41 54 41 89 d4 53 48 83 ec 08 89 75 d4 89 4d d0 48 8b 47 08
> 4c 8d 40 e8 <49> 8b 40 18 48 8d 58 e8 eb 2d 45 8b 28 4c 89 f9 8b 55 d0
> 8b 75
> [   18.629848] RIP  [<ffffffff8102a0c7>] __wake_up_common+0x29/0x76
> [   18.630139]  RSP <ffff88073cd69de8>
> [   18.630386] CR2: 00000000000ffeb6
> [   18.630680] ---[ end trace 1dc7eeca43b701f9 ]---
>
> And then a watchdog:
>
> [  230.799819] ------------[ cut here ]------------
> [  230.800081] WARNING: at kernel/watchdog.c:240
> watchdog_overflow_callback+0xa9/0xbb()
> [  230.805856] Hardware name: X8DT3
> [  230.806106] Watchdog detected hard LOCKUP on cpu 1
> [  230.806147] Modules linked in: cifs kvm_intel kvm iTCO_wdt
> iTCO_vendor_support i2c_i801
> [  230.807114] Pid: 2594, comm: udevd Tainted: G      D     2.6.36.2 #2
> [  230.807358] Call Trace:
> [  230.807636]  <NMI>  [<ffffffff8107f1d2>] ?
> watchdog_overflow_callback+0xa9/0xbb
> [  230.808134]  [<ffffffff81038abf>] warn_slowpath_common+0x80/0x99
> [  230.808382]  [<ffffffff81038bbb>] warn_slowpath_fmt+0x69/0x6b
> [  230.808679]  [<ffffffff8107f1d2>] watchdog_overflow_callback+0xa9/0xbb
> [  230.808938]  [<ffffffff8109ebeb>] __perf_event_overflow+0x189/0x1fc
> [  230.809195]  [<ffffffff8109efcd>] perf_event_overflow+0x14/0x16
> [  230.809448]  [<ffffffff81011b52>] intel_pmu_handle_irq+0x385/0x3ee
> [  230.809744]  [<ffffffff814ce2c0>] perf_event_nmi_handler+0x6f/0xcf
> [  230.810001]  [<ffffffff814cfdf2>] notifier_call_chain+0x33/0x5b
> [  230.810249]  [<ffffffff814cfe3c>] atomic_notifier_call_chain+0x13/0x15
> [  230.810499]  [<ffffffff814cfe6c>] notify_die+0x2e/0x30
> [  230.810789]  [<ffffffff814cda31>] do_nmi+0x91/0x261
> [  230.811042]  [<ffffffff814cd4fa>] nmi+0x1a/0x20
> [  230.811290]  [<ffffffff814ccc0f>] ? _raw_spin_lock_irqsave+0x17/0x1d
> [  230.811576]  <<EOE>>  [<ffffffff8102d06a>] __wake_up+0x22/0x50
> [  230.811875]  [<ffffffff8138e297>] md_wakeup_thread+0x27/0x29
> [  230.812125]  [<ffffffff8138f301>] mddev_unlock+0xa6/0xab
> [  230.812373]  [<ffffffff8138f533>] md_attr_show+0x4c/0x58
> [  230.812663]  [<ffffffff8112a83b>] sysfs_read_file+0xb2/0x131
> [  230.812919]  [<ffffffff810dbd8e>] vfs_read+0xa8/0x100
> [  230.813168]  [<ffffffff810dbeaa>] sys_read+0x47/0x70
> [  230.813415]  [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b
> [  230.813706] ---[ end trace 1dc7eeca43b701fa ]---
>
> I will be throwing out/rebuilding this raid shortly (it's used for
> swap, no real data on it anyways), but thought it would be good to
> report this. Let me know if I can provide any further details about
> this system.

And to add some real content to this e-mail rather than just changing list CC's:

The above happened consistently on boots until I rebuilt the md. (Took
me a few tries to realize I had to do raid=noautodetect.) Also,
looking over things more carefully, there were errors on the md
shortly before reboot (online disk controller firmware upgrade,
probably temporarily took out some of the drives, as resetting the
controller is part of the upgrade procedure) of the form:

[2519101.140755] end_request: I/O error, dev sdk, sector 16787775
[2519101.140761] md: super_written gets error=-5, uptodate=0
[2519101.140765] raid10: Disk failure on sdk1, disabling device.
[2519101.140766] raid10: Operation continuing on 10 devices.

repeated for a bunch of the drives (with kernel 2.6.33). Then, after
rebooting again (into 2.6.33, but fresh boot with the new controller
firmware all there from the start), I got the same errors as in
2.6.36.2, wrt the array not being able to start:

[   17.703472] raid10: not enough operational mirrors for md0
[   17.703743] md: pers->run() failed ...
[   17.704018] md: do_md_run() returned -5
[   17.704268] md: md0 still in use.
[   17.704519] md: ... autorun DONE.

But no oopses. Right after that, I upgraded to 2.6.36.2, with the
results from above.

-- 
Ilia Mirkin
imirkin@alum.mit.edu
