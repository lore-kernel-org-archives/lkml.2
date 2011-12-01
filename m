Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1LAD5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:57:14 -0500
Received: from science.horizon.com ([71.41.210.146]:48556 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753451Ab1LAD5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:57:13 -0500
Date: 30 Nov 2011 22:57:11 -0500
Message-ID: <20111201035711.31686.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hughd@google.com, linux@horizon.com
Subject: Re: v3.2-rc2: kernel BUG at mm/migrate.c:578
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
In-Reply-To: <alpine.LSU.2.00.1111301803330.23181@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks (from the "? " stacktrace entries throughout) as if you don't
> have CONFIG_FRAME_POINTER=y configured on this machine.  I think in
> these traces it's pretty easy to work out which addresses are relevant
> and which are stale, but in future they might be easier to decipher if
> you can switch frame pointers on.

Okay, will do when I next reboot.

> 
> It's still stuck, and then much later I got the bad messages:
> 
> [1118744.699989] ------------[ cut here ]------------
> [1118744.699998] WARNING: at mm/truncate.c:286 truncate_inode_pages_range+0x228/0x271()
> [1118744.700000] Hardware name: H55M-UD2H
> [1118744.700002] Modules linked in: battery nfsd exportfs nfs lockd auth_rpcgss nfs_acl sunrpc fuse loop ftdi_sio usbserial r8169
> [1118744.700014] Pid: 18073, comm: apt-get Tainted: G        W    3.2.0-rc2 #40

> That "W" in the Tainted string implies that you got some warning
> before these messages (but I think the hung task trace above would
> not have added it).  Perhaps you were getting so many of these
> truncate_inode_pages_range() stack traces, that you're only showing
> the last few here?  Or perhaps you got some other warning that
> you're sure is irrelevant?

Oops, sorry, it's during the boot messages, a complaint about floppy drives:

[    4.679959] floppy0: no floppy controllers found
[    4.680070] ------------[ cut here ]------------
[    4.680101] WARNING: at drivers/block/floppy.c:2929 blk_drain_queue+0x25/0x54()
[    4.680137] Hardware name: H55M-UD2H
[    4.680158] VFS: do_fd_request called on non-open device
[    4.680186] Modules linked in:
[    4.680210] Pid: 1, comm: swapper Not tainted 3.2.0-rc2 #40
[    4.680239] Call Trace:
[    4.680255]  [<ffffffff8111b7b7>] ? blk_drain_queue+0x25/0x54
[    4.680289]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
[    4.680322]  [<ffffffff8102e772>] ? warn_slowpath_fmt+0x45/0x4a
[    4.680353]  [<ffffffff8111b7b7>] ? blk_drain_queue+0x25/0x54
[    4.682311]  [<ffffffff8111b871>] ? blk_cleanup_queue+0x8b/0xaf
[    4.684275]  [<ffffffff81529787>] ? floppy_init+0xd2e/0xd51
[    4.686223]  [<ffffffff81528a59>] ? set_cmos+0x5f/0x5f
[    4.688146]  [<ffffffff81000205>] ? do_one_initcall+0x75/0x124
[    4.690062]  [<ffffffff8150ba5e>] ? kernel_init+0x9a/0x114
[    4.691962]  [<ffffffff813353b4>] ? kernel_thread_helper+0x4/0x10
[    4.693840]  [<ffffffff8150b9c4>] ? start_kernel+0x2c0/0x2c0
[    4.695703]  [<ffffffff813353b0>] ? gs_change+0xb/0xb
[    4.697559] ---[ end trace ceac60930a99a4bf ]---
[    4.699416] ------------[ cut here ]------------
[    4.701237] WARNING: at drivers/block/floppy.c:2929 blk_drain_queue+0x25/0x54()
[    4.703072] Hardware name: H55M-UD2H
[    4.704897] VFS: do_fd_request called on non-open device
[    4.706728] Modules linked in:
[    4.708551] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc2 #40
[    4.710382] Call Trace:
[    4.712197]  [<ffffffff8111b7b7>] ? blk_drain_queue+0x25/0x54
[    4.714026]  [<ffffffff8102e6c6>] ? warn_slowpath_common+0x78/0x8c
[    4.715844]  [<ffffffff8102e772>] ? warn_slowpath_fmt+0x45/0x4a
[    4.717644]  [<ffffffff8111b7b7>] ? blk_drain_queue+0x25/0x54
[    4.719443]  [<ffffffff8111b871>] ? blk_cleanup_queue+0x8b/0xaf
[    4.721255]  [<ffffffff81529787>] ? floppy_init+0xd2e/0xd51
[    4.723072]  [<ffffffff81528a59>] ? set_cmos+0x5f/0x5f
[    4.724883]  [<ffffffff81000205>] ? do_one_initcall+0x75/0x124
[    4.726688]  [<ffffffff8150ba5e>] ? kernel_init+0x9a/0x114
[    4.728486]  [<ffffffff813353b4>] ? kernel_thread_helper+0x4/0x10
[    4.730281]  [<ffffffff8150b9c4>] ? start_kernel+0x2c0/0x2c0
[    4.732066]  [<ffffffff813353b0>] ? gs_change+0xb/0xb
[    4.733828] ---[ end trace ceac60930a99a4c0 ]---
(A total of 8 warnings.)

Looks pretty irrelevant to me.

> So, I don't think this is a page migration bug; but I just cannot
> find what is wrong at the radix_tree end.
> 
> Summary: thank you for reporting, sorry I don't understand it,
> please keep us informed of any further bugs you see, and hope
> that one will enlighten us.

I'm running mprime as a memory stability test, and it's been passing for
the last few hours, but there was several days of uptime.

Thank you very much for your time looking at things!
-- 
	-Colin
