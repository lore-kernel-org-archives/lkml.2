Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0GWNeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:34:01 -0400
Received: from smtp-out-041.synserver.de ([212.40.180.41]:1117 "HELO
	smtp-out-041.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753460Ab0GWNd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:33:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 31560
Date: Fri, 23 Jul 2010 15:33:55 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, npiggin@suse.de
Subject: Re: [Bug #16393] kernel BUG at fs/block_dev.c:765!
Message-ID: <20100723133355.GA1806@arch.tripp.de>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
 <tneGvaw1wLL.A.EH.k2XSMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tneGvaw1wLL.A.EH.k2XSMB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 01:47:36PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).

It happend again today:

...
Jul 23 09:22:00 arch kernel: r8169 0000:02:05.0: eth0: link up
Jul 23 09:22:00 arch kernel: r8169: WARNING! Changing of MTU on this NIC may lead to frame reception errors!
Jul 23 13:41:43 arch kernel: ------------[ cut here ]------------
Jul 23 13:41:43 arch kernel: kernel BUG at fs/block_dev.c:765!
Jul 23 13:41:43 arch kernel: invalid opcode: 0000 [#1] SMP
Jul 23 13:41:43 arch kernel: last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
Jul 23 13:41:43 arch kernel: CPU 1
Jul 23 13:41:43 arch kernel: Pid: 2616, comm: mount Not tainted 2.6.35-rc6-00012-g7e5a57e #32 M4A78T-E/System Product Name
Jul 23 13:41:43 arch kernel: RIP: 0010:[<ffffffff810f66c7>]  [<ffffffff810f66c7>] __bd_abort_claiming+0x17/0x40
Jul 23 13:41:43 arch kernel: RSP: 0018:ffff880035d07d18  EFLAGS: 00010207
Jul 23 13:41:43 arch kernel: RAX: 0000000000009292 RBX: ffff88011f8249c0 RCX: 0000000000000002
Jul 23 13:41:43 arch kernel: RDX: 0000000000000003 RSI: ffffffff8182f0a0 RDI: ffff88011f8249c0
Jul 23 13:41:43 arch kernel: RBP: ffff880035d07d28 R08: ffff880035d07b68 R09: ffffffff81877ea8
Jul 23 13:41:43 arch kernel: R10: ffff880035d07cb8 R11: 0000000000000010 R12: ffff88011f8249c0
Jul 23 13:41:43 arch kernel: R13: 0000000000000001 R14: ffffffff8182f0a0 R15: 00000000ffffff85
Jul 23 13:41:43 arch kernel: FS:  00007f727e6a8740(0000) GS:ffff880001a80000(0000) knlGS:0000000000000000
Jul 23 13:41:43 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul 23 13:41:43 arch kernel: CR2: 00007f99480f2000 CR3: 000000003c34d000 CR4: 00000000000006e0
Jul 23 13:41:43 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 23 13:41:43 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 23 13:41:43 arch kernel: Process mount (pid: 2616, threadinfo ffff880035d06000, task ffff88011afe0000)
Jul 23 13:41:43 arch kernel: Stack:
Jul 23 13:41:43 arch kernel: ffff880035d07d28 ffffffffffffff85 ffff880035d07d68 ffffffff810f7b6c
Jul 23 13:41:43 arch kernel: <0> ffff880035d07d98 0000000000000001 ffffffff8182f0a0 0000000000000001
Jul 23 13:41:43 arch kernel: <0> ffff88003c3c5000 ffffffff8182f0a0 ffff880035d07de8 ffffffff810d3daa
Jul 23 13:41:43 arch kernel: Call Trace:
Jul 23 13:41:43 arch kernel: [<ffffffff810f7b6c>] open_bdev_exclusive+0xb3/0xc3
Jul 23 13:41:43 arch kernel: [<ffffffff810d3daa>] get_sb_bdev+0x47/0x178
Jul 23 13:41:43 arch kernel: [<ffffffff8113121c>] ? ext4_fill_super+0x0/0x208d
Jul 23 13:41:43 arch kernel: [<ffffffff8112e6ba>] ext4_get_sb+0x18/0x1a
Jul 23 13:41:43 arch kernel: [<ffffffff810d40af>] vfs_kern_mount+0x62/0xff
Jul 23 13:41:43 arch kernel: [<ffffffff810d431b>] do_kern_mount+0x4d/0xef
Jul 23 13:41:43 arch kernel: [<ffffffff810e86ad>] do_mount+0x6cb/0x744
Jul 23 13:41:43 arch kernel: [<ffffffff810e87fb>] sys_mount+0x8c/0xcd
Jul 23 13:41:43 arch kernel: [<ffffffff8102b93b>] system_call_fastpath+0x16/0x1b
Jul 23 13:41:43 arch kernel: Code: c7 c3 f4 ff ff ff 5Jul 23 13:42:38 arch kernel: Linux version 2.6.35-rc6-00012-g7e5a57e (markus@arch.tripp.de) (gcc version 4.5.0 20100610 (prerelease) (GCC) ) #32 SMP Fri Jul 23 09:21:31 CEST 2010
Jul 23 13:42:38 arch kernel: Command line: BOOT_IMAGE=/usr/src/linux/arch/x86/boot/bzImage root=/dev/sdb2 fbcon=rotate:3 drm.edid_force_checksum=1 quiet
Jul 23 13:42:38 arch kernel: BIOS-provided physical RAM map:
-- 
Markus
