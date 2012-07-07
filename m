Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab2GGPbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 11:31:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:42482 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab2GGPbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 11:31:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="174504805"
Date: Sat, 7 Jul 2012 23:31:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: general protection fault on ttm_init()
Message-ID: <20120707153142.GA24787@localhost>
References: <20120706144622.GA13387@localhost>
 <20120706144846.GA13505@localhost>
 <CAPM=9txA0OAm=8ROHXBpXZ+-onqJx41yK4_-v1go8e8W6ROVzw@mail.gmail.com>
 <CAPM=9tzUkUOkA8-RNA4rztUXuKREKYGJVR3=0oYM7ufR9kRacA@mail.gmail.com>
 <20120707020847.GA28771@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120707020847.GA28771@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 10:08:47AM +0800, Fengguang Wu wrote:
> On Fri, Jul 06, 2012 at 06:09:20PM +0100, Dave Airlie wrote:
> > On Fri, Jul 6, 2012 at 5:49 PM, Dave Airlie <airlied@gmail.com> wrote:
> > > On Fri, Jul 6, 2012 at 3:48 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > >> ... The missed kconfig.
> > >>
> > >> On Fri, Jul 06, 2012 at 10:46:22PM +0800, Fengguang Wu wrote:
> > >>> Hi Thomas,
> > >
> > > Wierd, I'm sorta tempted to just depend drm on CONFIG_PROC_FS, but it
> > > looks like the error path is failing to dtrt.
> > 
> > I've attached a patch that should fix it, let me know if it works.
> 
> It does not work.. The dmesg (attached) remains the same.

I got more interesting back traces in a clean kernel:

device class 'drm': registering
kobject: 'drm' (ffff88000f07f050): kobject_add_internal: parent: 'class', set: 'class'
kobject: 'drm' (ffff88000f07f050): kobject_uevent_env
kobject: 'drm' (ffff88000f07f050): fill_kobj_path: path = '/class/drm'
[drm:drm_core_init] *ERROR* Cannot create /proc/dri
device class 'drm': unregistering
kobject: 'drm' (ffff88000f07f050): kobject_cleanup
kobject: 'drm' (ffff88000f07f050): auto cleanup 'remove' event
kobject: 'drm' (ffff88000f07f050): kobject_uevent_env
kobject: 'drm' (ffff88000f07f050): fill_kobj_path: path = '/class/drm'
kobject: 'drm' (ffff88000f07f050): auto cleanup kobject_del
kobject: 'drm' (ffff88000f07f050): calling ktype release
class 'drm': release.
class_create_release called for drm
kobject: 'drm': free name
kobject: 'drm' (ffff88000f080070): kobject_cleanup
kobject: 'drm' (ffff88000f080070): calling ktype release
kobject: 'drm': free name
device: 'ttm': device_add
kobject: '(null)' (ffff88000f080230): kobject_add_internal: parent: 'virtual', set: '(null)'
kobject: 'ttm' (ffffffff824709b0): kobject_add_internal: parent: '(null)', set: 'devices'
general protection fault: 0000 [#1] SMP
CPU 1
Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc5-bisect #207
RIP: 0010:[<ffffffff8115eb59>]  [<ffffffff8115eb59>] sysfs_do_create_link+0x59/0x1c0
RSP: 0018:ffff880000107db0  EFLAGS: 00010206
RAX: ffff880000100000 RBX: 00cccccccccccccc RCX: 000000000000dad9
RDX: 000000000000d9d9 RSI: 0000000000000000 RDI: ffffffff8243b320
RBP: ffff880000107e00 R08: ffff880000100580 R09: fffffffffe000080
R10: ffff880000100000 R11: 0000000002000000 R12: ffffffff821622db
R13: ffff88000f080150 R14: 0000000000000001 R15: ffff88000f080308
FS:  0000000000000000(0000) GS:ffff88000df00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000002411000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff880000106000, task ffff880000100000)
Stack:
 ffff88000f080308 0000000000000000 ffffffff824709b0 00000000000002ec
 0000000000000000 0000000000000000 ffffffff824709b0 00000000000002ec
 0000000000000000 ffffffff824709a0 ffff880000107e10 ffffffff8115ecce
Call Trace:
 [<ffffffff8115ecce>] sysfs_create_link+0xe/0x10
 [<ffffffff81580309>] device_add+0x289/0x610
 [<ffffffff8255aae2>] ? drm_core_init+0xca/0xca
 [<ffffffff81589d09>] ? device_pm_init+0x69/0x90
 [<ffffffff8255aae2>] ? drm_core_init+0xca/0xca
 [<ffffffff815806a9>] device_register+0x19/0x20
 [<ffffffff8147d507>] drm_class_device_register+0x17/0x20
 [<ffffffff8255ab19>] ttm_init+0x37/0x62
 [<ffffffff8252ed56>] do_one_initcall+0x7a/0x139
 [<ffffffff8252ef18>] kernel_init+0x103/0x187
 [<ffffffff8252e614>] ? do_early_param+0x8c/0x8c
 [<ffffffff81ccf334>] kernel_thread_helper+0x4/0x10
 [<ffffffff81ccd8b0>] ? retint_restore_args+0x13/0x13
 [<ffffffff8252ee15>] ? do_one_initcall+0x139/0x139
 [<ffffffff81ccf330>] ? gs_change+0x13/0x13
Code: 4c 8b 7f 30 bb f2 ff ff ff 4d 85 ff 0f 84 a2 00 00 00 48 c7 c7 20 b3 43 82 e8 c4 e2 b6 00 49 8b 5d 30 48 85 db 0f 84 27 01 00 00 <8b> 03 f0 ff 03 48 c7 c7 20 b3 43 82 e8 d6 e3 b6 00 4c 89 e7 ba
RIP  [<ffffffff8115eb59>] sysfs_do_create_link+0x59/0x1c0
 RSP <ffff880000107db0>


and:


kobject: 'drm': free name
device: 'ttm': device_add
BUG: unable to handle kernel paging request at 0000000100000001
IP: [<ffffffff8137b7ad>] strnlen+0xd/0x40
PGD 0
Oops: 0000 [#1] SMP
CPU 1
Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc5-bisect #207
RIP: 0010:[<ffffffff8137b7ad>]  [<ffffffff8137b7ad>] strnlen+0xd/0x40
RSP: 0018:ffff880000107c30  EFLAGS: 00010286
RAX: ffffffff8210a8fc RBX: 0000000000000000 RCX: fffffffffffffffe
RDX: 0000000100000001 RSI: ffffffffffffffff RDI: 0000000100000001
RBP: ffff880000107c30 R08: 000000000000ffff R09: 000000000000ffff
R10: ffff88000f0750f0 R11: ffffffff824384e0 R12: 0000000100000001
R13: 0000000000000000 R14: 000000000000ffff R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88000df00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000100000001 CR3: 0000000002411000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff880000106000, task ffff880000100000)
Stack:
 ffff880000107c70 ffffffff8137cc3e ffffffff82ff88a0 0000000000000000
 0000000000000000 ffff880000107d08 ffffffff8222f3dc ffffffff8222f3dc
 ffff880000107cf0 ffffffff8137d719 0000000000000007 0000000000000006
Call Trace:
 [<ffffffff8137cc3e>] string.isra.4+0x3e/0xd0
 [<ffffffff8137d719>] vsnprintf+0x219/0x5e0
 [<ffffffff81381468>] kvasprintf+0x48/0x90
 [<ffffffff81374fa1>] kobject_set_name_vargs+0x21/0x60
 [<ffffffff81375394>] kobject_add+0x54/0xc0
 [<ffffffff81cb9093>] get_device_parent.isra.11+0x142/0x18f
 [<ffffffff815801b8>] device_add+0x138/0x610
 [<ffffffff8255aae2>] ? drm_core_init+0xca/0xca
 [<ffffffff81589d09>] ? device_pm_init+0x69/0x90
 [<ffffffff8255aae2>] ? drm_core_init+0xca/0xca
 [<ffffffff815806a9>] device_register+0x19/0x20
 [<ffffffff8147d507>] drm_class_device_register+0x17/0x20
 [<ffffffff8255ab19>] ttm_init+0x37/0x62
 [<ffffffff8252ed56>] do_one_initcall+0x7a/0x139
 [<ffffffff8252ef18>] kernel_init+0x103/0x187
 [<ffffffff8252e614>] ? do_early_param+0x8c/0x8c
 [<ffffffff81ccf334>] kernel_thread_helper+0x4/0x10
 [<ffffffff81ccd8b0>] ? retint_restore_args+0x13/0x13
 [<ffffffff8252ee15>] ? do_one_initcall+0x139/0x139
 [<ffffffff81ccf330>] ? gs_change+0x13/0x13
Code: c0 01 80 38 00 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83
RIP  [<ffffffff8137b7ad>] strnlen+0xd/0x40
 RSP <ffff880000107c30>
CR2: 0000000100000001


Thanks,
Fengguang
