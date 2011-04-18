Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1DRUEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:04:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51171 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1DRUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EQI+0vWox6bDXZb3Aqe1ezYt2qawRwnA+MHOR5/V1t910Yd5sbbX52auNIQxzLPqkg
         u+hGqd20T2Mg/LKuMoSep9+ue0JQ5cwEjqnWfCuo8toBYv6/w8IjRa9dNx7PK0oYNcO0
         c3Y/NkUx+sd2BHDkb5YlPZb70sN+iPVz5D7Bg=
Date: Mon, 18 Apr 2011 22:02:04 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Kyle Spaans <kspaans@uwaterloo.ca>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: 2.6.39-rc1 nouveau(?) regression (bisected) 
Message-ID: <20110418200204.GA2522@joi.lan>
References: <20110407151129.GA24977@comet.dominikbrodowski.net>
 <20110414170559.GA10768@comet.dominikbrodowski.net>
 <20110414190117.GA3493@joi.lan>
 <20110415061136.GA21979@isilmar-3.linta.de>
 <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
 <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
 <20110417154557.GA2871@joi.lan>
 <20110417162427.GB25242@taurine.csclub.uwaterloo.ca>
 <20110417164920.GA2626@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110417164920.GA2626@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 06:49:20PM +0200, Marcin Slusarz wrote:
> On Sun, Apr 17, 2011 at 12:24:27PM -0400, Kyle Spaans wrote:
> > On Sun, Apr 17, 2011 at 05:45:57PM +0200, Marcin Slusarz wrote:
> > > On Sun, Apr 17, 2011 at 11:12:04AM -0400, Kyle Spaans wrote:
> > > > On Sat, Apr 16, 2011 at 07:50:28PM -0400, Kyle Spaans wrote:
> > > > > On Sun, Apr 17, 2011 at 08:12:35AM +1000, Nigel Cunningham wrote:
> > > > > > On 15/04/11 16:11, Dominik Brodowski wrote:
> > > > > > > On Thu, Apr 14, 2011 at 09:02:01PM +0200, Marcin Slusarz wrote:
> > > > > > >> On Thu, Apr 14, 2011 at 07:05:59PM +0200, Dominik Brodowski wrote:
> > > > > > >>> Thought about CCing Linus to show him that 2.6.39-rcX isn't as "calm"
> > > > > > >>> to everyone, but then chose to CC Maciej instead: Would you be so kind and
> > > > > > >>> add this to your regression list? Thanks!
> > > > > > >>>
> > > > > > >>> Since commit 38f1cff
> > > > > > >>>
> > > > > > >>>     From: Dave Airlie <airlied@redhat.com>
> > > > > > >>>     Date: Wed, 16 Mar 2011 11:34:41 +1000
> > > > > > >>>     Subject: [PATCH] Merge commit '5359533801e3dd3abca5b7d3d985b0b33fd9fe8b' into dr
> > > > > > >>>
> > > > > > >>>     This commit changed an internal radeon structure, that meant a new driver
> > > > > > >>>     in -next had to be fixed up, merge in the commit and fix up the driver.
> > > > > > >>>
> > > > > > >>>     Also fixes a trivial nouveau merge.
> > > > > > >>>
> > > > > > >>>     Conflicts:
> > > > > > >>>         drivers/gpu/drm/nouveau/nouveau_mem.c
> > > > > > >>>
> > > > > > >>> booting my atom/NM10/ION2 system crashes hard during boot, right after
> > > > > > >>> blanking the screen, and before the initramfs gets loaded. I just
> > > > > > >>> re-checked: both parent commits ( 5359533 and 4819d2e ) do indeed work
> > > > > > >>> just fine, but the merge commit ( 38f1cff ) fails, same as tip ( 85f2e68 ).
> > > > > > >> Can you activate netconsole and check whether kernel spits anything interesting?
> > > > > > >> You might try to load nouveau module after boot - maybe something will be saved
> > > > > > >> to /var/log or you could even ssh into the box and check dmesg...
> > > > > > > Compiling it as a module seems to work fine. When I do so, no regression is
> > > > > > > obvious from what gets reported in "dmesg". However, somehow I now do get
> > > > > > > some output: The last message I see is
> > > > > > >
> > > > > > > [drm] nouveau 0000:01:00.0: allocated 1680x1050, fb 0x40.... b0 <some pointer value>
> > > > > > >
> > > > > > > Then, nothing more. However, it really is quite strange why this error only
> > > > > > > appears in the CONFIG_NOUVEAU=y case, not in the =m case...
> > > > > > Try disabling CONFIG_BOOT_LOGO. I reported on freedesktop.org that it is
> > > > > > causing me an oops at boot, but my bug has been ignored there so far -
> > > > > > perhaps I should have posted it here instead.
> > > > > 
> > > > > I'm getting the exact same symptoms on my Atom + ION hardware. Crashes before it
> > > > > can write any logs if it's compiled in and the logo is selected, but boots fine
> > > > > if compiled as a module or the logo is removed.
> > > > > 
> > > > > In my case I bisected and found 8969960 by Nick Piggin (change to mm/vmalloc.c)
> > > > > to be the first bad one in 2.6.38+. This makes me think that it's not a bug in
> > > > > nouveau, but maybe a bug in the order that things are initialized?
> > > > 
> > > > FWIW, reverting commit 89699605fe7cfd8611900346f61cb6cbf179b10a on 2.6.39-rc3+
> > > > makes my system boot just fine with the nouveau drivers compiled into the
> > > > kernel. I've seen some similar looking bugs on LKML that this regression may or
> > > > may not be related to? It works fine on 2.6.38.
> > > > 
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=33272
> > > > http://lkml.org/lkml/2011/4/15/194
> > > > 
> > > > I'm still trying to figure out exactly where the kernel is crashing after
> > > > printing
> > > > [drm] nouveau 0000:03:00.0: allocated 1280x1024 fb: 0x40000000, b0 f4cf7600
> > > > 
> > > > Any thoughts on what else I should look for?
> > > 
> > > I reproduced this bug today, and reverting 89699605fe7cfd8611900346f61cb6cbf179b10a
> > > does not fix it for me. Here's the backtrace:
> > > 
> > > Entering kdb (current=0xffff8801becb0000, pid 1) on processor 6 Oops: (null)
> > > due to oops @ 0xffffffff81255081
> > > CPU 6 <d>Modules linked in:
> > > <c>
> > > <d>Pid: 1, comm: swapper Not tainted 2.6.39-rc2-nv+ #640<c> System manufacturer System Product Name<c>/P6T SE<c>
> > > <d>RIP: 0010:[<ffffffff81255081>]  [<ffffffff81255081>] iowrite32+0x12/0x34
> > > <d>RSP: 0000:ffff8801becab4b0  EFLAGS: 00010296
> > > <d>RAX: 00000000ffffffff RBX: ffff8801bd334800 RCX: 00000000000016fc
> > > <d>RDX: 00000000ffffffff RSI: ffffc900100bbf4c RDI: ffffc900100bbf4c
> > > <d>RBP: ffff8801becab4b0 R08: 0000000000000002 R09: 0000000000000001
> > > <d>R10: 00000000000000bb R11: ffff8801becab540 R12: ffff8801bd336000
> > > <d>R13: ffff8801bd334818 R14: ffff8801bd600000 R15: 0000000000000020
> > > <d>FS:  0000000000000000(0000) GS:ffff8801bfd80000(0000) knlGS:0000000000000000
> > > <d>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > <d>CR2: ffffc900100bbf4c CR3: 0000000001a2b000 CR4: 00000000000006e0
> > > <d>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > <d>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Process swapper (pid: 1, threadinfo ffff8801becaa000, task ffff8801becb0000)
> > > <0>Stack:
> > > <c> ffff8801becab4c0<c> ffffffff812f5bd5<c> ffff8801becab4f0<c> ffffffff8130f1f8<c>
> > > <c> ffff8801bd336000<c> ffffc90012a00000<c> ffff8801becab620<c> 0000000000000000<c>
> > > <c> ffff8801becab590<c> ffffffff8127b4c8<c> ffff8801becb0000<c> ffffffff814c8c44<c>
> > > <0>Call Trace:
> > > <0> [<ffffffff812f5bd5>] nouveau_bo_wr32+0x21/0x27
> > > <0> [<ffffffff8130f1f8>] nouveau_fbcon_sync+0x19b/0x26e
> > > <0> [<ffffffff8127b4c8>] cfb_imageblit+0x80/0x450
> > > <0> [<ffffffff814c8c44>] ? __mutex_unlock_slowpath+0x100/0x124
> > > <0> [<ffffffff8109e999>] ? trace_hardirqs_on_caller+0x118/0x13c
> > > <0> [<ffffffff8130f32d>] ? nouveau_fbcon_imageblit+0x62/0xd8
> > > <0> [<ffffffff8130f398>] nouveau_fbcon_imageblit+0xcd/0xd8
> > > <0> [<ffffffff8126ed90>] fb_show_logo+0x5ea/0x73a
> > > <0> [<ffffffff8130f529>] ? nouveau_fbcon_fillrect+0xae/0xd8
> > > <0> [<ffffffff8127900d>] ? bit_clear_margins+0x141/0x14e
> > > <0> [<ffffffff81275f19>] fbcon_switch+0x3fd/0x475
> > > <0> [<ffffffff812c1039>] redraw_screen+0x125/0x1fd
> > > <0> [<ffffffff812c16bb>] bind_con_driver+0x5aa/0x637
> > > <0> [<ffffffff812c1780>] take_over_console+0x38/0x45
> > > <0> [<ffffffff812780e7>] fbcon_takeover+0x57/0x91
> > > <0> [<ffffffff812788c5>] fbcon_event_notify+0x32d/0x65a
> > > <0> [<ffffffff814cdd38>] notifier_call_chain+0x74/0xa1
> > > <0> [<ffffffff81092f9d>] __blocking_notifier_call_chain+0x71/0x8e
> > > <0> [<ffffffff81092fc9>] blocking_notifier_call_chain+0xf/0x11
> > > <0> [<ffffffff8126c74a>] fb_notifier_call_chain+0x16/0x18
> > > <0> [<ffffffff8126d8ca>] register_framebuffer+0x25a/0x271
> > > <0> [<ffffffff812cc770>] drm_fb_helper_single_fb_probe+0x1bd/0x26f
> > > <0> [<ffffffff812ccdc5>] drm_fb_helper_initial_config+0x4a8/0x4bf
> > > <0> [<ffffffff8109e734>] ? mark_held_locks+0x52/0x70
> > > <0> [<ffffffff8130fa88>] nouveau_fbcon_init+0xd4/0xe0
> > > <0> [<ffffffff812ef1eb>] nouveau_card_init+0x109e/0x11b9
> > > <0> [<ffffffff812ef833>] nouveau_load+0x52d/0x56c
> > > <0> [<ffffffff812d9a1e>] drm_get_pci_dev+0x16a/0x26f
> > > <0> [<ffffffff814babf4>] nouveau_pci_probe+0x10/0x12
> > > <0> [<ffffffff812621f7>] local_pci_probe+0x12/0x16
> > > <0> [<ffffffff812629f8>] pci_device_probe+0x60/0x8f
> > > <0> [<ffffffff81367fc4>] ? driver_sysfs_add+0x6b/0x90
> > > <0> [<ffffffff8136810c>] driver_probe_device+0xa7/0x136
> > > <0> [<ffffffff813681f7>] __driver_attach+0x5c/0x80
> > > <0> [<ffffffff8136819b>] ? driver_probe_device+0x136/0x136
> > > <0> [<ffffffff81367914>] bus_for_each_dev+0x54/0x89
> > > <0> [<ffffffff81367f57>] driver_attach+0x19/0x1b
> > > <0> [<ffffffff8136724a>] bus_add_driver+0xcd/0x219
> > > <0> [<ffffffff81368768>] driver_register+0x99/0x10a
> > > <0> [<ffffffff81262c68>] __pci_register_driver+0x63/0xd3
> > > <0> [<ffffffff812d9ba6>] drm_pci_init+0x83/0xe8
> > > <0> [<ffffffff81ad1ab9>] ? ttm_init+0x62/0x62
> > > 
> > > It crashes on:
> > > nouveau_bo_wr32(chan->notifier_bo, chan->m2mf_ntfy + 3, 0xffffffff);
> > > in nouveau_fbcon_sync.
> > 
> > Looks like your kernel is getting farther along than mine. I get a hard freeze
> > with no oops though. From what I can tell mine is also following the same path
> > through the fb_notifier stuff just before crashing. Can you "fix" your kernel by
> > changing nouveau to be a module or turning off the tux boot logo?
> 
> Well, to get this trace I had to enable netconsole, patch nouveau[1] to load after
> netconsole initialisation and enable kgdb.
> 
> Yes, changing nouveau to module and disabling logo "fixes" it too.
> 
> 
> [1]
> ---
> diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
> index 0842d88..66bf8cb 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_drv.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
> @@ -473,7 +473,7 @@ static void __exit nouveau_exit(void)
>  	nouveau_unregister_dsm_handler();
>  }
>  
> -module_init(nouveau_init);
> +late_initcall(nouveau_init);
>  module_exit(nouveau_exit);
>  
>  MODULE_AUTHOR(DRIVER_AUTHOR);

It's some nasty corruption:

[    6.523867] =============================================================================
[    6.523916] BUG sysfs_dir_cache: Poison overwritten
[    6.523949] -----------------------------------------------------------------------------
[    6.523950]
[    6.524016] INFO: 0xffff8801bb47df4c-0xffff8801bb47df4f. First byte 0xff instead of 0x6b
[    6.524061] INFO: Slab 0xffffea00060f7b58 objects=22 used=21 fp=0xffff8801bb47df18 flags=0x80000000000000c1
[    6.524110] INFO: Object 0xffff8801bb47df18 @offset=3864 fp=0x          (null)
[    6.524111]
[    6.524170] Bytes b4 0xffff8801bb47df08:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[    6.524516]   Object 0xffff8801bb47df18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    6.524862]   Object 0xffff8801bb47df28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    6.525208]   Object 0xffff8801bb47df38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    6.525556]   Object 0xffff8801bb47df48:  6b 6b 6b 6b ff ff ff ff 6b 6b 6b 6b 6b 6b 6b 6b kkkk<FF><FF><FF><FF>kkkkkkkk
[    6.525904]   Object 0xffff8801bb47df58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    6.526250]   Object 0xffff8801bb47df68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    6.526594]   Object 0xffff8801bb47df78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk<A5>
[    6.526939]  Redzone 0xffff8801bb47df88:  bb bb bb bb bb bb bb bb                         <BB><BB><BB><BB><BB><BB><BB><BB>
[    6.527298]  Padding 0xffff8801bb47dfc8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
[    6.527648] Pid: 393, comm: khubd Not tainted 2.6.39-rc3+ #653
[    6.527684] Call Trace:
[    6.527713]  [<ffffffff81116e64>] print_trailer+0x12e/0x137
[    6.529183]  [<ffffffff8111738a>] check_bytes_and_report+0xb9/0xfd
[    6.530651]  [<ffffffff811735bb>] ? sysfs_new_dirent+0x9d/0xff
[    6.532123]  [<ffffffff81117483>] check_object+0xb5/0x1e8
[    6.533591]  [<ffffffff8117356c>] ? sysfs_new_dirent+0x4e/0xff
[    6.535052]  [<ffffffff81117cb2>] alloc_debug_processing+0xc9/0x159
[    6.536515]  [<ffffffff811193b0>] T.977+0x3ad/0x3f9
[    6.537985]  [<ffffffff8117356c>] ? sysfs_new_dirent+0x4e/0xff
[    6.539437]  [<ffffffff8117356c>] ? sysfs_new_dirent+0x4e/0xff
[    6.540886]  [<ffffffff810a2f0c>] ? mark_held_locks+0x52/0x70
[    6.542327]  [<ffffffff8117356c>] ? sysfs_new_dirent+0x4e/0xff
[    6.543760]  [<ffffffff81119465>] kmem_cache_alloc+0x69/0x19e
[    6.545180]  [<ffffffff8117356c>] sysfs_new_dirent+0x4e/0xff
[    6.546581]  [<ffffffff810a2f0c>] ? mark_held_locks+0x52/0x70
[    6.547982]  [<ffffffff814ade58>] ? __mutex_unlock_slowpath+0x100/0x124
[    6.549341]  [<ffffffff81172c8d>] sysfs_add_file_mode+0x2f/0xa8
[    6.550692]  [<ffffffff81175161>] internal_create_group+0xe6/0x170
[    6.552035]  [<ffffffff8117520c>] sysfs_create_group+0xe/0x12
[    6.553363]  [<ffffffff8136ca21>] device_add_groups+0x25/0x64
[    6.554681]  [<ffffffff8136d1b0>] device_add+0x310/0x58f
[    6.555951]  [<ffffffff813b9a29>] ? usb_cache_string+0x8f/0x9b
[    6.557211]  [<ffffffff813b398d>] usb_new_device+0x13f/0x181
[    6.558488]  [<ffffffff813b4e3f>] hub_thread+0x94a/0xe53
[    6.559760]  [<ffffffff81068ab6>] ? sub_preempt_count+0x9e/0xb1
[    6.561027]  [<ffffffff814ad37f>] ? schedule+0xce1/0xd6c
[    6.562296]  [<ffffffff81091f79>] ? wake_up_bit+0x25/0x25
[    6.563576]  [<ffffffff814affbc>] ? _raw_spin_unlock_irqrestore+0x46/0x64
[    6.564851]  [<ffffffff813b44f5>] ? hub_probe+0x807/0x807
[    6.566111]  [<ffffffff81091a38>] kthread+0x7d/0x85
[    6.567367]  [<ffffffff814b18d4>] kernel_thread_helper+0x4/0x10
[    6.568621]  [<ffffffff814aff59>] ? _raw_spin_unlock_irq+0x36/0x53
[    6.569866]  [<ffffffff814b0384>] ? retint_restore_args+0xe/0xe
[    6.571101]  [<ffffffff810919bb>] ? __init_kthread_worker+0x56/0x56
[    6.572319]  [<ffffffff814b18d0>] ? gs_change+0xb/0xb
[    6.573537] FIX sysfs_dir_cache: Restoring 0xffff8801bb47df4c-0xffff8801bb47df4f=0x6b
[    6.573537]
[    6.575970] FIX sysfs_dir_cache: Marking all objects used




and in another boot:




[    6.704786] BUG: unable to handle kernel paging request at ffffffffbc70b058
[    6.704862] IP: [<ffffffff81171d89>] sysfs_refresh_inode+0x71/0x8e
[    6.704920] PGD 1a2d067 PUD 1a31063 PMD 0
[    6.705004] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    6.705110] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3:1.0/host10/target10:0:0/10:0:0:3/block/sde/dev
Entering kdb (current=0xffff8801be6e3ea0, pid 1552) on processor 7 Oops: (null)
due to oops @ 0xffffffff81171d89
CPU 7 <d>Modules linked in:
<c>
<d>Pid: 1552, comm: busybox Not tainted 2.6.39-rc3+ #653<c> System manufacturer System Product Name<c>/P6T SE<c>
<d>RIP: 0010:[<ffffffff81171d89>]  [<ffffffff81171d89>] sysfs_refresh_inode+0x71/0x8e
<d>RSP: 0018:ffff8801bbb41bf8  EFLAGS: 00010246
<d>RAX: ffffffffbc70b000 RBX: ffff8801bae11680 RCX: 0000000000000000
<d>RDX: 0000000000000001 RSI: ffff8801bae11680 RDI: ffff8801bbe775c0
<d>RBP: ffff8801bbb41bf8 R08: 0000000000003ce6 R09: 0000000000000000
<d>R10: ffff880100000008 R11: 0000000000003ce6 R12: ffff8801bbe775c0
<d>R13: ffff8801bbe775c0 R14: fffffffffffffff4 R15: ffff8801bae09b80
<d>FS:  0000000000963880(0063) GS:ffff8801bfdc0000(0000) knlGS:0000000000000000
<d>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<d>CR2: ffffffffbc70b058 CR3: 00000001bc272000 CR4: 00000000000006e0
<d>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<d>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process busybox (pid: 1552, threadinfo ffff8801bbb40000, task ffff8801be6e3ea0)
<0>Stack:
<c> ffff8801bbb41c18<c> ffffffff81171f8c<c> ffff8801bae09cc0<c> ffff8801bae11200<c>
<c> ffff8801bbb41c48<c> ffffffff8117310b<c> ffff8801bae09cc0<c> ffff8801bae11200<c>
<c> 0000000000000001<c> ffff8801bbb41d38<c> ffff8801bbb41c78<c> ffffffff811280bb<c>
<0>Call Trace:
<0> [<ffffffff81171f8c>] sysfs_get_inode+0xc4/0x14c
<0> [<ffffffff8117310b>] sysfs_lookup+0x70/0xfc
<0> [<ffffffff811280bb>] d_alloc_and_lookup+0x49/0x67
<0> [<ffffffff811285a2>] do_lookup+0x14e/0x246
<0> [<ffffffff8112997f>] path_lookupat+0x42b/0x66f
<0> [<ffffffff81129bf6>] do_path_lookup+0x33/0x54
<0> [<ffffffff8112aed6>] user_path_at+0x53/0x97
<0> [<ffffffff81068ab6>] ? sub_preempt_count+0x9e/0xb1
<0> [<ffffffff81139228>] ? vfsmount_lock_local_unlock+0x43/0x60
<0> [<ffffffff81122545>] vfs_fstatat+0x47/0x72
<0> [<ffffffff81139398>] ? mntput+0x21/0x23
<0> [<ffffffff81120149>] ? fput+0x1b8/0x1c7
<0> [<ffffffff811225a1>] vfs_stat+0x16/0x18
<0> [<ffffffff81122735>] sys_newstat+0x1a/0x38
<0> [<ffffffff810a3171>] ? trace_hardirqs_on_caller+0x118/0x13c
<0> [<ffffffff81255e7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
<0> [<ffffffff814b0afb>] system_call_fastpath+0x16/0x1b
<0>Code: 96 88 01 00 00 48 8b 50 38 48 89 96 90 01 00 00 48 8b 40 40 48 89 86 98 01 00 00 80 7f 58 01 75 25 48 8b 47 50 31 d2 eb 0f 31 c9 <80> 78 58 01 48 8b 40 30 0f 94 c1 01 ca 48 85 c0 75 ec 83 c2 02

