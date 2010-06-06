Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0FFI6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 04:58:10 -0400
Received: from smtp-out-194.synserver.de ([212.40.180.194]:1213 "HELO
	smtp-out-192.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754007Ab0FFI6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 04:58:07 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 15815
Date: Sun, 6 Jun 2010 10:57:58 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Subject: Re: ext4 2.6.35-rc2 regression (ext4: Make sure the MOVE_EXT ioctl
 can't overwrite append-only files)
Message-ID: <20100606085758.GA1822@arch.tripp.de>
References: <20100606081601.GA1807@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100606081601.GA1807@arch.tripp.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 06, 2010 at 10:16:01AM +0200, Markus Trippelsdorf wrote:
> Commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72
> "ext4: Make sure the MOVE_EXT ioctl can't overwrite append-only files"
> causes the following kernel BUG on my machine (x86_64):

I'm also seeing these general protection faults since rc2. This happens
even with the two recent ext4 commits reverted:

Jun  6 09:53:16 arch kernel: EXT4-fs (sdb2): re-mounted. Opts: discard
Jun  6 09:53:16 arch kernel: EXT4-fs (sdb2): re-mounted. Opts: discard
Jun  6 09:53:16 arch kernel: EXT4-fs (sdb2): re-mounted. Opts: discard
Jun  6 09:53:16 arch kernel: EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Jun  6 09:53:16 arch kernel: EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
Jun  6 09:53:16 arch kernel: Adding 200808k swap on /dev/sda3.  Priority:-1 extents:1 across:200808k
Jun  6 09:53:16 arch kernel: r8169 0000:02:05.0: eth0: link up
Jun  6 09:53:16 arch kernel: r8169: WARNING! Changing of MTU on this NIC may lead to frame reception errors!
Jun  6 09:53:16 arch kernel: general protection fault: 0000 [#1] SMP
Jun  6 09:53:16 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sdb/size
Jun  6 09:53:16 arch kernel: CPU 2
Jun  6 09:53:16 arch kernel: Pid: 1683, comm: iptables-restor Not tainted 2.6.35-rc2-00033-gcc1f375 #46 M4A78T-E/System Product Name
Jun  6 09:53:16 arch kernel: RIP: 0010:[<ffffffff810cc6e6>]  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:16 arch kernel: RSP: 0018:ffff88011c993d78  EFLAGS: 00010002
Jun  6 09:53:16 arch kernel: RAX: 0000000000000000 RBX: 0720072007200720 RCX: ffffffff810bd4c9
Jun  6 09:53:16 arch kernel: RDX: 00007f076cee3000 RSI: 00000000000000d0 RDI: ffff88011fc01800
Jun  6 09:53:16 arch kernel: RBP: ffff88011c993db8 R08: ffff880001b13f48 R09: 0000000000000000
Jun  6 09:53:16 arch kernel: R10: ffff88011d387c00 R11: ffff88011c983930 R12: ffff88011fc01800
Jun  6 09:53:16 arch kernel: R13: 0000000000000202 R14: 00000000000000d0 R15: 00000000000000d0
Jun  6 09:53:16 arch kernel: FS:  00007f076dc43700(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun  6 09:53:16 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  6 09:53:16 arch kernel: CR2: 00007f8595d364f8 CR3: 000000011b8b0000 CR4: 00000000000006e0
Jun  6 09:53:16 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 09:53:16 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  6 09:53:16 arch kernel: Process iptables-restor (pid: 1683, threadinfo ffff88011c992000, task ffff88011ec09610)
Jun  6 09:53:16 arch kernel: Stack:
Jun  6 09:53:16 arch kernel: ffff88011d387c10 ffff88011c983930 ffff88011c993d98 000000000000fffa
Jun  6 09:53:16 arch kernel: <0> ffff88011d387bd0 00007f076cee3000 ffff88011f77ea40 0000000000000000
Jun  6 09:53:16 arch kernel: <0> ffff88011c993e08 ffffffff810bd4c9 ffff88011b8f5cc0 ffffffff810bd639
Jun  6 09:53:16 arch kernel: Call Trace:
Jun  6 09:53:16 arch kernel: [<ffffffff810bd4c9>] __split_vma+0x33/0x18d
Jun  6 09:53:16 arch kernel: [<ffffffff810bd639>] ? vma_merge+0x16/0x1fc
Jun  6 09:53:16 arch kernel: [<ffffffff810bdc01>] split_vma+0x23/0x28
Jun  6 09:53:16 arch kernel: [<ffffffff810bf572>] mprotect_fixup+0x146/0x54c
Jun  6 09:53:16 arch kernel: [<ffffffff810befff>] ? do_mmap_pgoff+0x2a4/0x2fe
Jun  6 09:53:16 arch kernel: [<ffffffff810bfaf0>] sys_mprotect+0x178/0x1f4
Jun  6 09:53:16 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jun  6 09:53:16 arch kernel: Code: 65 4c 8b 04 25 88 d4 00 00 48 8b 07 49 01 c0 49 8b 18 48 85 db 75 10 83 ca ff 44 89 f6 e8 58 fa ff ff 48 89 c3 eb 0b 48 63 47 18 <48> 8b 04 03 49 89 00 41 55 9d 48 85 db 74 15 41 81 e6 00 80 00
Jun  6 09:53:16 arch kernel: RIP  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:16 arch kernel: RSP <ffff88011c993d78>
Jun  6 09:53:16 arch kernel: ---[ end trace e2fb1ccd3cb9dd77 ]---
Jun  6 09:53:16 arch kernel: general protection fault: 0000 [#2] SMP
Jun  6 09:53:16 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sdb/size
Jun  6 09:53:16 arch kernel: CPU 2
Jun  6 09:53:16 arch kernel: Pid: 1693, comm: mpd Tainted: G      D     2.6.35-rc2-00033-gcc1f375 #46 M4A78T-E/System Product Name
Jun  6 09:53:16 arch kernel: RIP: 0010:[<ffffffff810cc6e6>]  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:16 arch kernel: RSP: 0018:ffff88011c969da8  EFLAGS: 00010002
Jun  6 09:53:16 arch kernel: RAX: 0000000000000000 RBX: 0720072007200720 RCX: ffffffff810beabc
Jun  6 09:53:16 arch kernel: RDX: 0000000000000000 RSI: 00000000000080d0 RDI: ffff88011fc01800
Jun  6 09:53:16 arch kernel: RBP: ffff88011c969de8 R08: ffff880001b13f48 R09: 0000000000000000
Jun  6 09:53:16 arch kernel: R10: 0000000000000227 R11: ffff88011cb492a0 R12: ffff88011fc01800
Jun  6 09:53:16 arch kernel: R13: 0000000000000202 R14: 00000000000080d0 R15: 00000000000080d0
Jun  6 09:53:16 arch kernel: FS:  00007f076dc43700(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun  6 09:53:16 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  6 09:53:16 arch kernel: CR2: 00007f16b1954028 CR3: 000000011db32000 CR4: 00000000000006e0
Jun  6 09:53:16 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 09:53:16 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  6 09:53:16 arch kernel: Process mpd (pid: 1693, threadinfo ffff88011c968000, task ffff88011c960000)
Jun  6 09:53:16 arch kernel: Stack:
Jun  6 09:53:16 arch kernel: 800000011abcc067 ffff88011d3cf540 ffff88011c969e48 ffff88011b8df6c0
Jun  6 09:53:16 arch kernel: <0> 0000000000000000 00007f16b0a3b000 0000000000000075 0000000000000075
Jun  6 09:53:16 arch kernel: <0> ffff88011c969ea8 ffffffff810beabc ffff88011b8df6c0 0000000000000000
Jun  6 09:53:16 arch kernel: Call Trace:
Jun  6 09:53:16 arch kernel: [<ffffffff810beabc>] mmap_region+0x1af/0x44e
Jun  6 09:53:16 arch kernel: [<ffffffff810befff>] do_mmap_pgoff+0x2a4/0x2fe
Jun  6 09:53:16 arch kernel: [<ffffffff810bf112>] sys_mmap_pgoff+0xb9/0xf2
Jun  6 09:53:16 arch kernel: [<ffffffff8102fcca>] sys_mmap+0x22/0x24
Jun  6 09:53:16 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jun  6 09:53:16 arch kernel: Code: 65 4c 8b 04 25 88 d4 00 00 48 8b 07 49 01 c0 49 8b 18 48 85 db 75 10 83 ca ff 44 89 f6 e8 58 fa ff ff 48 89 c3 eb 0b 48 63 47 18 <48> 8b 04 03 49 89 00 41 55 9d 48 85 db 74 15 41 81 e6 00 80 00
Jun  6 09:53:16 arch kernel: RIP  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:16 arch kernel: RSP <ffff88011c969da8>
Jun  6 09:53:16 arch kernel: ---[ end trace e2fb1ccd3cb9dd78 ]---
Jun  6 09:53:16 arch kernel: general protection fault: 0000 [#3] SMP
Jun  6 09:53:16 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sdb/size
Jun  6 09:53:16 arch kernel: CPU 2
Jun  6 09:53:16 arch kernel: Pid: 1677, comm: login Tainted: G      D     2.6.35-rc2-00033-gcc1f375 #46 M4A78T-E/System Product Name
Jun  6 09:53:16 arch kernel: RIP: 0010:[<ffffffff810cc6e6>]  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:16 arch kernel: RSP: 0018:ffff88011d05fda8  EFLAGS: 00010002
Jun  6 09:53:16 arch kernel: RAX: 0000000000000000 RBX: 0720072007200720 RCX: ffffffff810beabc
Jun  6 09:53:16 arch kernel: RDX: 0000000000000000 RSI: 00000000000080d0 RDI: ffff88011fc01800
Jun  6 09:53:16 arch kernel: RBP: ffff88011d05fde8 R08: ffff880001b13f48 R09: 0000000000000000
Jun  6 09:53:16 arch kernel: R10: 0000000000000203 R11: ffff88011d30ebd0 R12: ffff88011fc01800
Jun  6 09:53:16 arch kernel: R13: 0000000000000202 R14: 00000000000080d0 R15: 00000000000080d0
Jun  6 09:53:16 arch kernel: FS:  00007f04d3382700(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun  6 09:53:16 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  6 09:53:16 arch kernel: CR2: 00007f16b1954028 CR3: 000000011b8b1000 CR4: 00000000000006e0
Jun  6 09:53:16 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 09:53:16 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  6 09:53:16 arch kernel: Process login (pid: 1677, threadinfo ffff88011d05e000, task ffff88011f6cac20)
Jun  6 09:53:16 arch kernel: Stack:
Jun  6 09:53:16 arch kernel: 0000000000000000 0000000000000000 ffff88011d05ff18 ffff88011dab10c0
Jun  6 09:53:16 arch kernel: <0> 0000000000000000 00007f04d17af000 0000000000000075 0000000000000075
Jun  6 09:53:16 arch kernel: <0> ffff88011d05fea8 ffffffff810beabc ffff88011dab10c0 0000000000000000
Jun  6 09:53:16 arch kernel: Call Trace:
Jun  6 09:53:16 arch kernel: [<ffffffff810beabc>] mmap_region+0x1af/0x44e
Jun  6 09:53:16 arch kernel: [<ffffffff810befff>] do_mmap_pgoff+0x2a4/0x2fe
Jun  6 09:53:16 arch kernel: [<ffffffff810bf112>] sys_mmap_pgoff+0xb9/0xf2
Jun  6 09:53:16 arch kernel: [<ffffffff8102fcca>] sys_mmap+0x22/0x24
Jun  6 09:53:16 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jun  6 09:53:16 arch kernel: Code: 65 4c 8b 04 25 88 d4 00 00 48 8b 07 49 01 c0 49 8b 18 48 85 db 75 10 83 ca ff 44 89 f6 e8 58 fa ff ff 48 89 c3 eb 0b 48 63 47 18 <48> 8b 04 03 49 89 00 41 55 9d 48 85 db 74 15 41 81 e6 00 80 00
Jun  6 09:53:16 arch kernel: RIP  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:16 arch kernel: RSP <ffff88011d05fda8>
Jun  6 09:53:16 arch kernel: ---[ end trace e2fb1ccd3cb9dd79 ]---
Jun  6 09:53:16 arch kernel: general protection fault: 0000 [#4] SMP
Jun  6 09:53:16 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sdb/size
Jun  6 09:53:16 arch kernel: CPU 2
Jun  6 09:53:16 arch kernel: Pid: 1696, comm: cupsd Tainted: G      D     2.6.35-rc2-00033-gcc1f375 #46 M4A78T-E/System Product Name
Jun  6 09:53:16 arch kernel: RIP: 0010:[<ffffffff810cc6e6>]  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:17 arch kernel: RSP: 0018:ffff88011d929da8  EFLAGS: 00010002
Jun  6 09:53:17 arch kernel: RAX: 0000000000000000 RBX: 0720072007200720 RCX: ffffffff810beabc
Jun  6 09:53:17 arch kernel: RDX: 0000000000000000 RSI: 00000000000080d0 RDI: ffff88011fc01800
Jun  6 09:53:17 arch kernel: RBP: ffff88011d929de8 R08: ffff880001b13f48 R09: 0000000000000000
Jun  6 09:53:17 arch kernel: R10: 000000000000029a R11: 0000000000000000 R12: ffff88011fc01800
Jun  6 09:53:17 arch kernel: R13: 0000000000000202 R14: 00000000000080d0 R15: 00000000000080d0
Jun  6 09:53:17 arch kernel: FS:  00007f04d3382700(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun  6 09:53:17 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  6 09:53:17 arch kernel: CR2: 00007f16b1954028 CR3: 000000011c830000 CR4: 00000000000006e0
Jun  6 09:53:17 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 09:53:17 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  6 09:53:17 arch kernel: Process cupsd (pid: 1696, threadinfo ffff88011d928000, task ffff88011f4cac20)
Jun  6 09:53:17 arch kernel: Stack:
Jun  6 09:53:17 arch kernel: 0000000000000000 0000000000000000 ffff88011d929f18 ffff88011cbdf300
Jun  6 09:53:17 arch kernel: <0> 0000000000000000 00007ff74755a000 0000000000000075 0000000000000075
Jun  6 09:53:17 arch kernel: <0> ffff88011d929ea8 ffffffff810beabc ffff88011cbdf300 0000000000000000
Jun  6 09:53:17 arch kernel: Call Trace:
Jun  6 09:53:17 arch kernel: [<ffffffff810beabc>] mmap_region+0x1af/0x44e
Jun  6 09:53:17 arch kernel: [<ffffffff810befff>] do_mmap_pgoff+0x2a4/0x2fe
Jun  6 09:53:17 arch kernel: [<ffffffff810bf112>] sys_mmap_pgoff+0xb9/0xf2
Jun  6 09:53:17 arch kernel: [<ffffffff8102fcca>] sys_mmap+0x22/0x24
Jun  6 09:53:17 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jun  6 09:53:17 arch kernel: Code: 65 4c 8b 04 25 88 d4 00 00 48 8b 07 49 01 c0 49 8b 18 48 85 db 75 10 83 ca ff 44 89 f6 e8 58 fa ff ff 48 89 c3 eb 0b 48 63 47 18 <48> 8b 04 03 49 89 00 41 55 9d 48 85 db 74 15 41 81 e6 00 80 00
Jun  6 09:53:17 arch kernel: RIP  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:17 arch kernel: RSP <ffff88011d929da8>
Jun  6 09:53:17 arch kernel: ---[ end trace e2fb1ccd3cb9dd7a ]---
Jun  6 09:53:17 arch kernel: general protection fault: 0000 [#5] SMP
Jun  6 09:53:17 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sdb/size
Jun  6 09:53:17 arch kernel: CPU 2
Jun  6 09:53:17 arch kernel: Pid: 1701, comm: ntpd Tainted: G      D     2.6.35-rc2-00033-gcc1f375 #46 M4A78T-E/System Product Name
Jun  6 09:53:17 arch kernel: RIP: 0010:[<ffffffff810cc6e6>]  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:17 arch kernel: RSP: 0018:ffff88011cb59e48  EFLAGS: 00010002
Jun  6 09:53:17 arch kernel: RAX: 0000000000000000 RBX: 0720072007200720 RCX: ffffffff810bd4c9
Jun  6 09:53:17 arch kernel: RDX: 00007f85969a2000 RSI: 00000000000000d0 RDI: ffff88011fc01800
Jun  6 09:53:17 arch kernel: RBP: ffff88011cb59e88 R08: ffff880001b13f48 R09: 00000000ffffffff
Jun  6 09:53:17 arch kernel: R10: 0000000000000022 R11: 0000000000000206 R12: ffff88011fc01800
Jun  6 09:53:17 arch kernel: R13: 0000000000000202 R14: 00000000000000d0 R15: 00000000000000d0
Jun  6 09:53:17 arch kernel: FS:  00007f8596969700(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun  6 09:53:17 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun  6 09:53:17 arch kernel: CR2: 00007f85969a1000 CR3: 000000011da71000 CR4: 00000000000006e0
Jun  6 09:53:17 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 09:53:17 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  6 09:53:17 arch kernel: Process ntpd (pid: 1701, threadinfo ffff88011cb58000, task ffff88011f4c9610)
Jun  6 09:53:17 arch kernel: Stack:
Jun  6 09:53:17 arch kernel: 0000000000000000 0000000000000093 ffff88011cb59e88 ffff88011c8ced80
Jun  6 09:53:17 arch kernel: <0> ffff88011ea26bd0 00007f85969a2000 ffff88011c8ced80 0000000000000001
Jun  6 09:53:17 arch kernel: <0> ffff88011cb59ed8 ffffffff810bd4c9 ffff88011cb59eb8 ffffffff8118c5e9
Jun  6 09:53:17 arch kernel: Call Trace:
Jun  6 09:53:17 arch kernel: [<ffffffff810bd4c9>] __split_vma+0x33/0x18d
Jun  6 09:53:17 arch kernel: [<ffffffff8118c5e9>] ? _atomic_dec_and_lock+0x2d/0x4c
Jun  6 09:53:17 arch kernel: [<ffffffff810bdd81>] do_munmap+0x17b/0x2e1
Jun  6 09:53:17 arch kernel: [<ffffffff810bdf28>] sys_munmap+0x41/0x58
Jun  6 09:53:17 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jun  6 09:53:17 arch kernel: Code: 65 4c 8b 04 25 88 d4 00 00 48 8b 07 49 01 c0 49 8b 18 48 85 db 75 10 83 ca ff 44 89 f6 e8 58 fa ff ff 48 89 c3 eb 0b 48 63 47 18 <48> 8b 04 03 49 89 00 41 55 9d 48 85 db 74 15 41 81 e6 00 80 00
Jun  6 09:53:17 arch kernel: RIP  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:17 arch kernel: RSP <ffff88011cb59e48>
Jun  6 09:53:17 arch kernel: ---[ end trace e2fb1ccd3cb9dd7b ]---
Jun  6 09:53:17 arch kernel: general protection fault: 0000 [#6] SMP
Jun  6 09:53:17 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sdb/size
Jun  6 09:53:17 arch kernel: CPU 2
Jun  6 09:53:17 arch kernel: Pid: 1684, comm: agetty Tainted: G      D     2.6.35-rc2-00033-gcc1f375 #46 M4A78T-E/System Product Name
Jun  6 09:53:17 arch kernel: RIP: 0010:[<ffffffff810cc6e6>]  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:17 arch kernel: RSP: 0018:ffff88011b8c9e48  EFLAGS: 00010002
Jun  6 09:53:17 arch kernel: RAX: 0000000000000000 RBX: 0720072007200720 RCX: ffffffff810bd4c9
Jun  6 09:53:17 arch kernel: RDX: 00007fbda8056000 RSI: 00000000000000d0 RDI: ffff88011fc01800
Jun  6 09:53:17 arch kernel: RBP: ffff88011b8c9e88 R08: ffff880001b13f48 R09: 00000000ffffffff
Jun  6 09:53:17 arch kernel: R10: 00007fff22feceb0 R11: 0000000000000206 R12: ffff88011fc01800
Jun  6 09:53:17 arch kernel: R13: 0000000000000202 R14: 00000000000000d0 R15: 00000000000000d0
Jun  6 09:53:17 arch kernel: FS:  00007fbda8020700(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun  6 09:53:17 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  6 09:53:17 arch kernel: CR2: 00007fbda7b4e2c0 CR3: 000000011cbbe000 CR4: 00000000000006e0
Jun  6 09:53:17 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 09:53:17 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  6 09:53:17 arch kernel: Process agetty (pid: 1684, threadinfo ffff88011b8c8000, task ffff88011b8c4230)
Jun  6 09:53:17 arch kernel: Stack:
Jun  6 09:53:17 arch kernel: ffff88011b8c9f48 ffffffff81103e64 ffff88011c8cda68 ffff88011c8cda00
Jun  6 09:53:17 arch kernel: <0> ffff88011ca6c1f8 00007fbda8056000 ffff88011c8cda00 0000000000000000
Jun  6 09:53:17 arch kernel: <0> ffff88011b8c9ed8 ffffffff810bd4c9 ffff88011b8df540 0000000000000010
Jun  6 09:53:17 arch kernel: Call Trace:
Jun  6 09:53:17 arch kernel: [<ffffffff81103e64>] ? locks_remove_posix+0x11/0xb2
Jun  6 09:53:17 arch kernel: [<ffffffff810bd4c9>] __split_vma+0x33/0x18d
Jun  6 09:53:17 arch kernel: [<ffffffff810bdd4c>] do_munmap+0x146/0x2e1
Jun  6 09:53:17 arch kernel: [<ffffffff810bdf28>] sys_munmap+0x41/0x58
Jun  6 09:53:17 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jun  6 09:53:17 arch kernel: Code: 65 4c 8b 04 25 88 d4 00 00 48 8b 07 49 01 c0 49 8b 18 48 85 db 75 10 83 ca ff 44 89 f6 e8 58 fa ff ff 48 89 c3 eb 0b 48 63 47 18 <48> 8b 04 03 49 89 00 41 55 9d 48 85 db 74 15 41 81 e6 00 80 00
Jun  6 09:53:17 arch kernel: RIP  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:17 arch kernel: RSP <ffff88011b8c9e48>
Jun  6 09:53:17 arch kernel: ---[ end trace e2fb1ccd3cb9dd7c ]---
Jun  6 09:53:29 arch kernel: general protection fault: 0000 [#7] SMP
Jun  6 09:53:29 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/host2/target2:0:0/2:0:0:0/block/sdb/size
Jun  6 09:53:29 arch kernel: CPU 2
Jun  6 09:53:29 arch kernel: Pid: 1706, comm: shutdown Tainted: G      D     2.6.35-rc2-00033-gcc1f375 #46 M4A78T-E/System Product Name
Jun  6 09:53:29 arch kernel: RIP: 0010:[<ffffffff810cc6e6>]  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:29 arch kernel: RSP: 0018:ffff88011eb5fe08  EFLAGS: 00010002
Jun  6 09:53:29 arch kernel: RAX: 0000000000000000 RBX: 0720072007200720 RCX: ffffffff810d55e5
Jun  6 09:53:29 arch kernel: RDX: ffffffff818f23e4 RSI: 00000000000080d0 RDI: ffff88011fc01800
Jun  6 09:53:29 arch kernel: RBP: ffff88011eb5fe48 R08: ffff880001b13f48 R09: 0000000000000002
Jun  6 09:53:29 arch kernel: R10: dead000000200200 R11: dead000000100100 R12: ffff88011fc01800
Jun  6 09:53:29 arch kernel: R13: 0000000000000202 R14: 00000000000080d0 R15: 00000000000080d0
Jun  6 09:53:29 arch kernel: FS:  00007fcca59ce700(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun  6 09:53:29 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  6 09:53:29 arch kernel: CR2: 00007fbda7b4e2c0 CR3: 000000011d910000 CR4: 00000000000006e0
Jun  6 09:53:29 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 09:53:29 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  6 09:53:29 arch kernel: Process shutdown (pid: 1706, threadinfo ffff88011eb5e000, task ffff88011fe58000)
Jun  6 09:53:29 arch kernel: Stack:
Jun  6 09:53:29 arch kernel: ffff88011eb5fe48 ffffffff8102ef08 ffff88011eb5fe38 ffff88011c97ba00
Jun  6 09:53:29 arch kernel: <0> ffff88011c8cd6c0 ffff88011c97ba00 ffff88011c8cd6c0 00007fffb7270460
Jun  6 09:53:29 arch kernel: <0> ffff88011eb5fe98 ffffffff810d55e5 ffff88011eb5fe98 ffff88011fe58000
Jun  6 09:53:29 arch kernel: Call Trace:
Jun  6 09:53:29 arch kernel: [<ffffffff8102ef08>] ? init_new_context+0x2f/0xd2
Jun  6 09:53:29 arch kernel: [<ffffffff810d55e5>] bprm_mm_init+0x6e/0x18e
Jun  6 09:53:29 arch kernel: [<ffffffff810d68bb>] do_execve+0x112/0x2b6
Jun  6 09:53:29 arch kernel: [<ffffffff81194136>] ? strncpy_from_user+0x39/0x3c
Jun  6 09:53:29 arch kernel: [<ffffffff81032ede>] sys_execve+0x43/0x61
Jun  6 09:53:29 arch kernel: [<ffffffff8102bcda>] stub_execve+0x6a/0xc0
Jun  6 09:53:29 arch kernel: Code: 65 4c 8b 04 25 88 d4 00 00 48 8b 07 49 01 c0 49 8b 18 48 85 db 75 10 83 ca ff 44 89 f6 e8 58 fa ff ff 48 89 c3 eb 0b 48 63 47 18 <48> 8b 04 03 49 89 00 41 55 9d 48 85 db 74 15 41 81 e6 00 80 00
Jun  6 09:53:29 arch kernel: RIP  [<ffffffff810cc6e6>] kmem_cache_alloc+0x59/0xda
Jun  6 09:53:29 arch kernel: RSP <ffff88011eb5fe08>
Jun  6 09:53:29 arch kernel: ---[ end trace e2fb1ccd3cb9dd7d ]---

-- 
Markus
