Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1LADCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:02:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33514 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1LADCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:02:09 -0500
Date: Wed, 30 Nov 2011 19:01:47 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: George Spelvin <linux@horizon.com>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: v3.2-rc2: kernel BUG at mm/migrate.c:578
In-Reply-To: <20111130140754.6662.qmail@science.horizon.com>
Message-ID: <alpine.LSU.2.00.1111301803330.23181@sister.anvils>
References: <20111130140754.6662.qmail@science.horizon.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, George Spelvin wrote:

> I just noticed the last one, but the preceding warnings were close enough I figured they might be relevant.
> 
> Kernel is stock 3.2.0-rc2.
> 
> Prcessor is 1st gen Core i3, 4G RAM, 64-bit kernel.  Userspace is 32-bit Debian/unstable.
> lspci -nn gives:
> 
> 00:00.0 Host bridge [0600]: Intel Corporation Core Processor DRAM Controller [8086:0040] (rev 12)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Core Processor Integrated Graphics Controller [8086:0042] (rev 12)
> 00:16.0 Communication controller [0780]: Intel Corporation 5 Series/3400 Series Chipset HECI Controller [8086:3b64] (rev 06)
> 00:1a.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB Universal Host Controller [8086:3b3b] (rev 06)
> 00:1a.1 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB Universal Host Controller [8086:3b3e] (rev 06)
> 00:1a.2 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB Universal Host Controller [8086:3b3f] (rev 06)
> 00:1a.7 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 06)
> 00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56] (rev 06)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 [8086:3b42] (rev 06)
> 00:1c.4 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 [8086:3b4a] (rev 06)
> 00:1c.5 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 [8086:3b4c] (rev 06)
> 00:1d.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB Universal Host Controller [8086:3b36] (rev 06)
> 00:1d.1 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB Universal Host Controller [8086:3b37] (rev 06)
> 00:1d.2 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB Universal Host Controller [8086:3b38] (rev 06)
> 00:1d.7 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 06)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev a6)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 5 Series Chipset LPC Interface Controller [8086:3b06] (rev 06)
> 00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller [8086:3b22] (rev 06)
> 00:1f.3 SMBus [0c05]: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller [8086:3b30] (rev 06)
> 01:00.0 Ethernet controller [0200]: Intel Corporation 82574L Gigabit Network Connection [8086:10d3]
> 02:00.0 IDE interface [0101]: JMicron Technology Corp. JMB368 IDE controller [197b:2368]
> 03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 06)
> 04:02.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev 80)
> 04:02.1 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev 80)
> 04:07.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) [104c:8024]
> 3f:00.0 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers [8086:2c61] (rev 02)
> 3f:00.1 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture System Address Decoder [8086:2d01] (rev 02)
> 3f:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI Link 0 [8086:2d10] (rev 02)
> 3f:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI Physical 0 [8086:2d11] (rev 02)
> 3f:02.2 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d12] (rev 02)
> 3f:02.3 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d13] (rev 02)
> 
> The only kernel log messages since boot were about a task
> (/usr/lib/apt/methods/rred) stuck in the kernel:
> 
> [1029342.255554] INFO: task rred:18093 blocked for more than 120 seconds.
> [1029342.255557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [1029342.255558] rred            D ffff880117c10700     0 18093  18073 0x00020000
> [1029342.255562]  ffff880112f4b8d0 0000000000000082 ffffffff814ab020 0000000000000000
> [1029342.255565]  0000000000010700 ffff880021e1dfd8 ffff880021e1dfd8 ffff880112f4b8d0
> [1029342.255568]  ffffffff81021027 0000000100000010 0000000000000202 ffff8800730c2310
> [1029342.255571] Call Trace:
> [1029342.255579]  [<ffffffff81021027>] ? pick_next_pushable_task+0x5b/0x5b
> [1029342.255584]  [<ffffffff81332fcc>] ? __mutex_lock_common.isra.6+0xfe/0x161
> [1029342.255586]  [<ffffffff81332ebb>] ? mutex_lock+0x1a/0x2d
> [1029342.255590]  [<ffffffff810769ef>] ? get_pageblock_flags_group+0x2c/0x60
> [1029342.255594]  [<ffffffff810ac2ca>] ? lock_rename+0x22/0x93
> [1029342.255596]  [<ffffffff810aed2a>] ? sys_renameat+0xbb/0x1ef
> [1029342.255601]  [<ffffffff8108b1f5>] ? unmap_region+0xd6/0xe8
> [1029342.255604]  [<ffffffff810a4cd8>] ? fput+0x18f/0x1b6
> [1029342.255608]  [<ffffffff810b8816>] ? mntput_no_expire+0x1e/0xc1
> [1029342.255613]  [<ffffffff81335545>] ? sysenter_dispatch+0x7/0x2b

I don't have an opinion on this trace, Cc'ed Al Viro in case it's of
interest to him.  A first guess would be that this one is not related
to the rest, but thanks for including it, it could be useful info.

Intriguing how sys_renameat() is in every trace (except the last);
but I've not been able to get anything out of that.

It looks (from the "? " stacktrace entries throughout) as if you don't
have CONFIG_FRAME_POINTER=y configured on this machine.  I think in
these traces it's pretty easy to work out which addresses are relevant
and which are stale, but in future they might be easier to decipher if
you can switch frame pointers on.

> 
> It's still stuck, and then much later I got the bad messages:
> 
> [1118744.699989] ------------[ cut here ]------------
> [1118744.699998] WARNING: at mm/truncate.c:286 truncate_inode_pages_range+0x228/0x271()
> [1118744.700000] Hardware name: H55M-UD2H
> [1118744.700002] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118744.700014] Pid: 18073, comm: apt-get Tainted: G        W    3.2.0-rc2 #40

That "W" in the Tainted string implies that you got some warning
before these messages (but I think the hung task trace above would
not have added it).  Perhaps you were getting so many of these
truncate_inode_pages_range() stack traces, that you're only showing
the last few here?  Or perhaps you got some other warning that
you're sure is irrelevant?

I'm responsible for that WARN_ON(page->index != index) in
truncate_inode_pages_range(); but I think what it's saying here
is that you've got a corrupt entry in one of the radix_tree nodes
(quite possibly off beyond the end of file).

The corrupt entry is a good kernel pointer (no oops), and quite
possibly a struct page pointer (as one would expect), but not
necessarily.  If it is a struct page pointer, its page->index
no longer matches its location in the radix_tree: I think the
page has by now been reused for another purpose, yet its pointer
somehow left behind in the tree.

But I've spent a while in lib/radix-tree.c, and don't see any
way that can happen.

This looks to me like another manifestation of the hang in
find_get_pages() on 3.0, which two or three people reported a
few months ago.  (Not to be confused with the hang in find_get_pages()
on 3.1, which was due to a bug of mine.)  In that case it was behaving
as if there were a stray page pointer left in the radix_tree, whose
count had gone down to 0 (free); in your case, the page (if page it
be) has got reused.

But beware, I might be making connections where there are none.

> [1118744.700015] Call Trace:
> [1118744.700022]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
> [1118744.700025]  [<ffffffff8107b8fb>] ? truncate_inode_pages_range+0x228/0x271
> [1118744.700029]  [<ffffffff810f2521>] ? ext3_evict_inode+0x8e/0x168
> [1118744.700033]  [<ffffffff810b5629>] ? evict+0x95/0x140
> [1118744.700036]  [<ffffffff810b2bab>] ? dentry_kill+0x101/0x11c
> [1118744.700038]  [<ffffffff810b2f42>] ? dput+0xdf/0xeb
> [1118744.700040]  [<ffffffff810aedf9>] ? sys_renameat+0x18a/0x1ef
> [1118744.700044]  [<ffffffff810a4cd8>] ? fput+0x18f/0x1b6
> [1118744.700048]  [<ffffffff810b8816>] ? mntput_no_expire+0x1e/0xc1
> [1118744.700053]  [<ffffffff81335545>] ? sysenter_dispatch+0x7/0x2b
> [1118744.700054] ---[ end trace ceac60930a99a4c8 ]---

And we don't see the BUG_ON(inode->i_data.nrpages) in end_writeback():
so we have successfully deleted all the radix tree entries that were
supposed to be there, and just got this spurious entry left over.

Which we cannot get rid of, even when the radix_tree node is freed
back to kmem_cache.  So even though this inode is evicted, other
inodes pick it up and hit the same problem (because the kmem_cache
constructor only zeroes the node when first allocating the slab page).

> [1118748.118322] ------------[ cut here ]------------
> [1118748.118334] WARNING: at mm/truncate.c:286 truncate_inode_pages_range+0x228/0x271()
> [1118748.118336] Hardware name: H55M-UD2H
> [1118748.118338] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118748.118351] Pid: 18073, comm: apt-get Tainted: G        W    3.2.0-rc2 #40
> [1118748.118352] Call Trace:
> [1118748.118360]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
> [1118748.118363]  [<ffffffff8107b8fb>] ? truncate_inode_pages_range+0x228/0x271
> [1118748.118367]  [<ffffffff810f2521>] ? ext3_evict_inode+0x8e/0x168
> [1118748.118370]  [<ffffffff810b5629>] ? evict+0x95/0x140
> [1118748.118373]  [<ffffffff810b2bab>] ? dentry_kill+0x101/0x11c
> [1118748.118376]  [<ffffffff810b2f42>] ? dput+0xdf/0xeb
> [1118748.118378]  [<ffffffff810aedf9>] ? sys_renameat+0x18a/0x1ef
> [1118748.118382]  [<ffffffff810a4cd8>] ? fput+0x18f/0x1b6
> [1118748.118386]  [<ffffffff810b8816>] ? mntput_no_expire+0x1e/0xc1
> [1118748.118390]  [<ffffffff81335545>] ? sysenter_dispatch+0x7/0x2b
> [1118748.118392] ---[ end trace ceac60930a99a4c9 ]---
> [1118763.397583] ------------[ cut here ]------------
> [1118763.397595] WARNING: at mm/truncate.c:286 truncate_inode_pages_range+0x228/0x271()
> [1118763.397597] Hardware name: H55M-UD2H
> [1118763.397598] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118763.397612] Pid: 18073, comm: apt-get Tainted: G        W    3.2.0-rc2 #40
> [1118763.397613] Call Trace:
> [1118763.397621]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
> [1118763.397623]  [<ffffffff8107b8fb>] ? truncate_inode_pages_range+0x228/0x271
> [1118763.397628]  [<ffffffff810f2521>] ? ext3_evict_inode+0x8e/0x168
> [1118763.397631]  [<ffffffff810b5629>] ? evict+0x95/0x140
> [1118763.397635]  [<ffffffff810b2bab>] ? dentry_kill+0x101/0x11c
> [1118763.397637]  [<ffffffff810b2f42>] ? dput+0xdf/0xeb
> [1118763.397640]  [<ffffffff810aedf9>] ? sys_renameat+0x18a/0x1ef
> [1118763.397644]  [<ffffffff810a4cd8>] ? fput+0x18f/0x1b6
> [1118763.397647]  [<ffffffff810b8816>] ? mntput_no_expire+0x1e/0xc1
> [1118763.397652]  [<ffffffff81335545>] ? sysenter_dispatch+0x7/0x2b
> [1118763.397654] ---[ end trace ceac60930a99a4ca ]---
> [1118778.745672] ------------[ cut here ]------------
> [1118778.745683] WARNING: at mm/truncate.c:286 truncate_inode_pages_range+0x228/0x271()
> [1118778.745686] Hardware name: H55M-UD2H
> [1118778.745688] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118778.745700] Pid: 18073, comm: apt-get Tainted: G        W    3.2.0-rc2 #40
> [1118778.745701] Call Trace:
> [1118778.745709]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
> [1118778.745711]  [<ffffffff8107b8fb>] ? truncate_inode_pages_range+0x228/0x271
> [1118778.745717]  [<ffffffff810f2521>] ? ext3_evict_inode+0x8e/0x168
> [1118778.745720]  [<ffffffff810b5629>] ? evict+0x95/0x140
> [1118778.745723]  [<ffffffff810b2bab>] ? dentry_kill+0x101/0x11c
> [1118778.745725]  [<ffffffff810b2f42>] ? dput+0xdf/0xeb
> [1118778.745728]  [<ffffffff810aedf9>] ? sys_renameat+0x18a/0x1ef
> [1118778.745732]  [<ffffffff810a4cd8>] ? fput+0x18f/0x1b6
> [1118778.745736]  [<ffffffff810b8816>] ? mntput_no_expire+0x1e/0xc1
> [1118778.745741]  [<ffffffff81335545>] ? sysenter_dispatch+0x7/0x2b
> [1118778.745742] ---[ end trace ceac60930a99a4cb ]---
> [1118849.078259] ------------[ cut here ]------------
> [1118849.078270] WARNING: at mm/truncate.c:286 truncate_inode_pages_range+0x228/0x271()
> [1118849.078272] Hardware name: H55M-UD2H
> [1118849.078273] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118849.078284] Pid: 18073, comm: apt-get Tainted: G        W    3.2.0-rc2 #40
> [1118849.078286] Call Trace:
> [1118849.078293]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
> [1118849.078296]  [<ffffffff8107b8fb>] ? truncate_inode_pages_range+0x228/0x271
> [1118849.078300]  [<ffffffff810f2521>] ? ext3_evict_inode+0x8e/0x168
> [1118849.078303]  [<ffffffff810b5629>] ? evict+0x95/0x140
> [1118849.078306]  [<ffffffff810b2bab>] ? dentry_kill+0x101/0x11c
> [1118849.078309]  [<ffffffff810b2f42>] ? dput+0xdf/0xeb
> [1118849.078311]  [<ffffffff810aedf9>] ? sys_renameat+0x18a/0x1ef
> [1118849.078315]  [<ffffffff810a4cd8>] ? fput+0x18f/0x1b6
> [1118849.078319]  [<ffffffff810b8816>] ? mntput_no_expire+0x1e/0xc1
> [1118849.078323]  [<ffffffff81335545>] ? sysenter_dispatch+0x7/0x2b
> [1118849.078325] ---[ end trace ceac60930a99a4cc ]---
> [1118854.697592] ------------[ cut here ]------------
> [1118854.697604] WARNING: at mm/truncate.c:286 truncate_inode_pages_range+0x228/0x271()
> [1118854.697606] Hardware name: H55M-UD2H
> [1118854.697607] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118854.697620] Pid: 18073, comm: apt-get Tainted: G        W    3.2.0-rc2 #40
> [1118854.697621] Call Trace:
> [1118854.697629]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
> [1118854.697631]  [<ffffffff8107b8fb>] ? truncate_inode_pages_range+0x228/0x271
> [1118854.697636]  [<ffffffff810f2521>] ? ext3_evict_inode+0x8e/0x168
> [1118854.697639]  [<ffffffff810b5629>] ? evict+0x95/0x140
> [1118854.697642]  [<ffffffff810b2bab>] ? dentry_kill+0x101/0x11c
> [1118854.697644]  [<ffffffff810b2f42>] ? dput+0xdf/0xeb
> [1118854.697647]  [<ffffffff810aedf9>] ? sys_renameat+0x18a/0x1ef
> [1118854.697651]  [<ffffffff810a4cd8>] ? fput+0x18f/0x1b6
> [1118854.697655]  [<ffffffff810b8816>] ? mntput_no_expire+0x1e/0xc1
> [1118854.697659]  [<ffffffff81335545>] ? sysenter_dispatch+0x7/0x2b
> [1118854.697661] ---[ end trace ceac60930a99a4cd ]---
> [1118868.292556] ------------[ cut here ]------------
> [1118868.292589] kernel BUG at mm/migrate.c:578!
> [1118868.292612] invalid opcode: 0000 [#1] SMP 
> [1118868.292640] CPU 2 
> [1118868.292652] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118868.292746] 
> [1118868.292758] Pid: 3387, comm: firefox-bin Tainted: G        W    3.2.0-rc2 #40 Gigabyte Technology Co., Ltd. H55M-UD2H/H55M-UD2H
> [1118868.292818] RIP: 0010:[<ffffffff8109ece2>]  [<ffffffff8109ece2>] move_to_new_page+0x21/0x1b8
> [1118868.292868] RSP: 0000:ffff880105c25a38  EFLAGS: 00010246
> [1118868.292895] RAX: 0000000000000000 RBX: ffffea00000dd940 RCX: 0000000000000001
> [1118868.292929] RDX: 0000000000000001 RSI: ffffea00000dd940 RDI: ffffea0001c763c0
> [1118868.292964] RBP: ffffea0001c763c0 R08: ffffea00000de280 R09: 000000000000000a
> [1118868.292999] R10: ffffea0001a08100 R11: ffffea0001a08100 R12: 0000000000000000
> [1118868.293033] R13: 0000000000000001 R14: 0000000000000001 R15: ffff880105c25be8
> [1118868.293068] FS:  0000000000000000(0000) GS:ffff880117d00000(0063) knlGS:00000000f742f6e0
> [1118868.293106] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [1118868.293134] CR2: 000000006c000000 CR3: 00000001116a4000 CR4: 00000000000006e0
> [1118868.293169] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [1118868.293203] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [1118868.293237] Process firefox-bin (pid: 3387, threadinfo ffff880105c24000, task ffff880110bb0ca0)
> [1118868.293278] Stack:
> [1118868.293291]  ffff880117d0d870 ffffea00000dd940 0000000000000003 0000000000000000
> [1118868.293334]  0000000000000001 0000000000000001 ffffea00000dd940 0000000000000003
> [1118868.293377]  0000000000000000 0000000000000001 0000000000000001 ffffffff8109f145
> [1118868.293420] Call Trace:
> [1118868.293436]  [<ffffffff8109f145>] ? migrate_pages+0x1e3/0x335
> [1118868.293466]  [<ffffffff81099ef3>] ? pfn_valid.part.3+0x32/0x32
> [1118868.293496]  [<ffffffff8109a5b7>] ? compact_zone+0x3f1/0x5bf
> [1118868.293526]  [<ffffffff8100738f>] ? read_tsc+0x5/0x14
> [1118868.293552]  [<ffffffff8109a8a6>] ? try_to_compact_pages+0x121/0x17e
> [1118868.293585]  [<ffffffff81077f6b>] ? __alloc_pages_direct_compact+0xaa/0x161
> [1118868.293619]  [<ffffffff8107868f>] ? __alloc_pages_nodemask+0x66d/0x6cc
> [1118868.293653]  [<ffffffff8108ff77>] ? anon_vma_prepare+0x1e/0x126
> [1118868.293683]  [<ffffffff810a1b5a>] ? do_huge_pmd_anonymous_page+0xa4/0x227
> [1118868.293718]  [<ffffffff8101b13e>] ? do_page_fault+0x288/0x2ce
> [1118868.293749]  [<ffffffff8108cef4>] ? mmap_region+0x353/0x44a
> [1118868.293780]  [<ffffffff81333def>] ? page_fault+0x1f/0x30
> [1118868.293806] Code: 44 24 08 48 83 c4 18 5b 5d c3 41 56 41 88 ce 41 55 41 89 d5 41 54 55 48 89 fd 53 48 89 f3 48 83 ec 30 e8 03 f8 ff ff 85 c0 75 02 <0f> 0b 48 8b 43 10 48 89 45 10 48 8b 43 08 48 89 45 08 48 8b 03 
> [1118868.294066] RIP  [<ffffffff8109ece2>] move_to_new_page+0x21/0x1b8
> [1118868.294099]  RSP <ffff880105c25a38>
> [1118868.358440] ---[ end trace ceac60930a99a4ce ]---

And I would like to believe that it was indeed a struct page pointer
left in the radix_tree, because we know that inode eviction does lock
it.  But if it now gets allocated to page migration, that rightly
believes it should have sole access to the page, and asserts
	if (!trylock_page(newpage))
		BUG();

So, I don't think this is a page migration bug; but I just cannot
find what is wrong at the radix_tree end.

Summary: thank you for reporting, sorry I don't understand it,
please keep us informed of any further bugs you see, and hope
that one will enlighten us.

Hugh
