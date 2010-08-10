Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0HJOWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab0HJOWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:22:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: cfq: oops in __call_for_each_cic
References: <20100810064045.6996f3b7@tlielax.poochiereds.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Aug 2010 10:22:41 -0400
In-Reply-To: <20100810064045.6996f3b7@tlielax.poochiereds.net> (Jeff Layton's
	message of "Tue, 10 Aug 2010 06:40:45 -0400")
Message-ID: <x49zkwu8s3y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> Saw this oops on my test machine this morning. I rebooted the machine
> last night and hadn't done anything on it other than log in this
> morning. The kernel here is based on Steve French's git tree, which is
> based on Linus' as of Sunday Aug 8th. Last non-cifs commit is:

This looks a lot like this bug:
  https://bugzilla.redhat.com/show_bug.cgi?id=577968

See also:
  http://kerneloops.org/guilty.php?guilty=cfq_free_io_context&version=2.6.34-rc&start=2228224&end=2260991&class=oops

It's been around since 2.6.30.8 according to kerneloops.org.  If you
find that you have a reliable way of reproducing the issue, that would
be great.

Cheers,
Jeff


> commit 45d7f32c7a43cbb9592886d38190e379e2eb2226
> Merge: 53bcef6 ab11b48
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Aug 8 10:10:11 2010 -0700
>
>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
>
> I also have some cifs patches in this kernel, but the cifs module
> wasn't even plugged in at the time, and the patches don't affect
> anything else. The host is a KVM guest. Let me know if you need other
> info:
>
> general protection fault: 0000 [#1] SMP 
> last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> CPU 0 
> Modules linked in: nfsd lockd nfs_acl exportfs rpcsec_gss_krb5 auth_rpcgss des_generic sunrpc ipv6 i2c_piix4 virtio_net i2c_core virtio_balloon floppy joydev pcspkr microcode virtio_blk virtio_pci virtio_ring virtio [last unloaded: mperf]
>
> Pid: 2708, comm: gzip Not tainted 2.6.35+ #1 /
> RIP: 0010:[<ffffffff81223830>]  [<ffffffff81223830>] __call_for_each_cic+0x21/0x3f
> RSP: 0018:ffff88003cea1e38  EFLAGS: 00010202
> RAX: 00000001012070a8 RBX: 6b6b6b6b6b6b6b6b RCX: ffff88003ab1ce80
> RDX: 00000001012070ab RSI: ffff8800047d1260 RDI: 0000000000000286
> RBP: ffff88003cea1e58 R08: 0000000000000286 R09: ffff88003cea1da8
> R10: ffff88003a75a9e8 R11: ffff88003cea1e08 R12: ffff88003a75a9c0
> R13: ffffffff8122387c R14: ffff88003e678000 R15: 0000000000000001
> FS:  00007f6f4dc8b720(0000) GS:ffff880004600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000032c80a92c0 CR3: 0000000001a43000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process gzip (pid: 2708, threadinfo ffff88003cea0000, task ffff88003cf5a440)
> Stack:
>  ffff88003e678000 ffff88003a75a9c0 ffff88003cf5a440 ffff88003cf5aac0
> <0> ffff88003cea1e68 ffffffff81223863 ffff88003cea1e88 ffffffff8121aa65
> <0> ffff88003cea1e88 ffff88003a75a9c0 ffff88003cea1eb8 ffffffff8121ab25
> Call Trace:
>  [<ffffffff81223863>] cfq_free_io_context+0x15/0x17
>  [<ffffffff8121aa65>] put_io_context+0x41/0x5e
>  [<ffffffff8121ab25>] exit_io_context+0x6c/0x74
>  [<ffffffff81054f11>] do_exit+0x75f/0x786
>  [<ffffffff81487c61>] ? lockdep_sys_exit_thunk+0x35/0x67
>  [<ffffffff810551ce>] do_group_exit+0x88/0xb6
>  [<ffffffff81055213>] sys_exit_group+0x17/0x1b
>  [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
> Code: f1 00 00 41 59 48 98 5b c9 c3 55 48 89 e5 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 48 8b 5f 78 49 89 fc 49 89 f5 48 85 db 74 15 <48> 8b 03 48 8d 73 b0 4c 89 e7 0f 18 08 41 ff d5 48 8b 1b eb e6 
> RIP  [<ffffffff81223830>] __call_for_each_cic+0x21/0x3f
>  RSP <ffff88003cea1e38>
> ---[ end trace 48227764f4e7dc77 ]---
> Fixing recursive fault but reboot is needed!
