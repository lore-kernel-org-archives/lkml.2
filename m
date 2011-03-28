Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1C1VBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:01:01 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:60568 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604Ab1C1VBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:01:00 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: Greg KH <gregkh@suse.de>
Subject: Re: 2.6.38.2: regression from 2.6.38: kernel BUG at fs/nfsd/nfs4state.c:380!
Date: Mon, 28 Mar 2011 23:00:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38.2-ei+6.3; KDE/4.4.5; x86_64; ; )
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        Rick Koshi <nfs-bug-report@more-right-rudder.com>,
        Ivo =?utf-8?q?P=C5=99ikryl?= <prikryl@eurosat.cz>
References: <201103282223.06191.wolfgang.walter@stwm.de> <20110328203207.GA17493@suse.de>
In-Reply-To: <20110328203207.GA17493@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201103282300.57903.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 March 2011, Greg KH wrote:
> On Mon, Mar 28, 2011 at 10:23:05PM +0200, Wolfgang Walter wrote:
> > Upgraded from 2.6.38 to 2.6.38.2: Got immediately:
> > 
> > Mar 28 21:35:08 au kernel: [  312.778443] ------------[ cut here ]------------
> > Mar 28 21:35:08 au kernel: [  312.778629] kernel BUG at fs/nfsd/nfs4state.c:380!
> > Mar 28 21:35:08 au kernel: [  312.778746] invalid opcode: 0000 [#1] SMP 
> > Mar 28 21:35:08 au kernel: [  312.778949] last sysfs file: /sys/devices/virtual/vc/vcsa6/uevent
> > Mar 28 21:35:08 au kernel: [  312.779068] CPU 3 
> > Mar 28 21:35:08 au kernel: [  312.779115] Modules linked in: i2c_i801 i5k_amb
> > Mar 28 21:35:08 au kernel: [  312.779469] 
> > Mar 28 21:35:08 au kernel: [  312.779581] Pid: 12850, comm: nfsd Not tainted 2.6.38.2-bigintel64a+1.17 #1 Supermicro X7DB8/X7DB8
> > Mar 28 21:35:08 au kernel: [  312.779970] RIP: 0010:[<ffffffff81281c8a>]  [<ffffffff81281c8a>] free_generic_stateid+0x3a/0xf0
> > Mar 28 21:35:08 au kernel: [  312.779970] RSP: 0018:ffff8803bd563b50  EFLAGS: 00010297
> > Mar 28 21:35:08 au kernel: [  312.779970] RAX: 00000000ffffffff RBX: ffff88040e726d58 RCX: ffff88040e726d78
> > Mar 28 21:35:08 au kernel: [  312.779970] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff8803bd563b5c
> > Mar 28 21:35:08 au kernel: [  312.779970] RBP: ffff8803bd563b70 R08: dead000000200200 R09: dead000000100100
> > Mar 28 21:35:08 au kernel: [  312.779970] R10: dead000000200200 R11: dead000000100100 R12: ffff88040e726d58
> > Mar 28 21:35:08 au kernel: [  312.779970] R13: ffff88040b588dd0 R14: ffff88040b588d98 R15: ffff8803bd4421a0
> > Mar 28 21:35:08 au kernel: [  312.779970] FS:  0000000000000000(0000) GS:ffff8800cfd80000(0000) knlGS:0000000000000000
> > Mar 28 21:35:08 au kernel: [  312.779970] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > Mar 28 21:35:08 au kernel: [  312.779970] CR2: 00007ffe6063a530 CR3: 000000040dae3000 CR4: 00000000000006e0
> > Mar 28 21:35:08 au kernel: [  312.779970] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > Mar 28 21:35:08 au kernel: [  312.779970] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Mar 28 21:35:08 au kernel: [  312.779970] Process nfsd (pid: 12850, threadinfo ffff8803bd562000, task ffff8803bd447290)
> > Mar 28 21:35:08 au kernel: [  312.779970] Stack:
> > Mar 28 21:35:08 au kernel: [  312.779970]  00000000000000d0 0000000000000202 ffff88040e726d58 ffff88040b588d98
> > Mar 28 21:35:08 au kernel: [  312.779970]  ffff8803bd563ba0 ffffffff81281df9 0000000000000011 0000000000000011
> > Mar 28 21:35:08 au kernel: [  312.779970]  0000000000000001 000000001d270000 ffff8803bd563dc0 ffffffff81286b4c
> > Mar 28 21:35:08 au kernel: [  312.779970] Call Trace:
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81281df9>] release_lockowner+0xb9/0x1a0
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81286b4c>] nfsd4_lock+0x50c/0x8d0
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff8126fd07>] ? nfsd_setuser+0x137/0x300
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81268522>] ? nfsd_setuser_and_check_port+0x72/0x80
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff812686a5>] ? fh_verify+0x175/0x6d0
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff8174cb51>] ? unix_gid_lookup+0x61/0x70
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff8127737d>] nfsd4_proc_compound+0x33d/0x4a0
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81264bfb>] nfsd_dispatch+0xbb/0x260
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff817489a2>] svc_process+0x4b2/0x840
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff812652a0>] ? nfsd+0x0/0x160
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81265375>] nfsd+0xd5/0x160
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81093b96>] kthread+0x96/0xb0
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81032a54>] kernel_thread_helper+0x4/0x10
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81093b00>] ? kthread+0x0/0xb0
> > Mar 28 21:35:08 au kernel: [  312.779970]  [<ffffffff81032a50>] ? kernel_thread_helper+0x0/0x10
> > Mar 28 21:35:08 au kernel: [  312.779970] Code: 8b 77 60 48 8d 7d ec e8 d5 fc ff ff 8b 45 ec 83 e0 03 83 f8 02 0f 84 b6 00 00 00 83 f8 03 0f 84 9d 00 00 00 ff c8 0f 1f 00 74 
0e 
> > <0f> 0b 0f 1f 40 00 eb fa 66 0f 1f 44 00 00 31 f6 49 8b 7c 24 48 
> > Mar 28 21:35:08 au kernel: [  312.779970] RIP  [<ffffffff81281c8a>] free_generic_stateid+0x3a/0xf0
> > Mar 28 21:35:08 au kernel: [  312.779970]  RSP <ffff8803bd563b50>
> > Mar 28 21:35:08 au kernel: [  312.788300] ---[ end trace 0eb789063a9e575d ]---
> > 
> > 
> > Reverting
> > 
> > 	nfsd4: fix struct file leak
> > 
> > seems to "fix" it.
> 
> Ick.
> 
> Bruce, should I revert this, or is something else needed to be able to
> have this patch applied?
> 
> thanks,
> 
> greg k-h
> 
> 


I just searched linux-nfs and found this:

http://marc.info/?l=linux-nfs&m=130129644016061&w=4

He even seems to have a real fix though I don't want to test it
without blessing.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
