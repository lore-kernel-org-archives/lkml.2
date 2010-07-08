Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab0GHOHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:07:53 -0400
Received: from hermes.mejor.pl ([193.238.12.139]:35159 "EHLO hermes.mejor.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab0GHOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:07:51 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 10:07:51 EDT
Message-ID: <4C35D9BB.6070108@mejor.pl>
Date: Thu, 08 Jul 2010 15:59:23 +0200
From: =?UTF-8?B?TWFyY2luIE1pcm9zxYJhdw==?= <marcin@mejor.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Lightning/1.0b2pre Mnenhy/0.8.3 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Oops while umounting nfs shared partition, 2.6.32-2.6.34
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
I have repetitious (in  Oops using kernel from 2.6.32 to 2.6.34.
On host called "wzor" i start up nfs server, nfs is serving data from 
separate partition. When a few clients connect to this server using udp, 
start copying filef from and to this server, i run:
umount /data/nfs ; /etc/init.d/nfs stop
(sometimes better works this: umount /data/nfs ; /etc/init.d/nfs stop ; 
umount /data/nfs )

In 3 times per 10 it triggers Oops.
I couldn't trigger Oops using kernel 2.6.35_rc3-r8.
Clients are connecting using this parameters:
mount.nfs  192.168.138.79:/data/nfs /mnt/test/ -v -o 
rw,proto=udp,rsize=8192,wsize=8192,intr,nfsvers=3,nolock,bg,soft

I don't know which commit fixes this in most recent kernel, is it 
possible to fix problem in earlier kernels?
Regards,
Marcin

./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux wzor 2.6.34-gentoo-r1 #7 SMP Thu Jul 8 14:46:09 CEST 2010 x86_64 
Intel(R) Xeon(R) CPU E5420 @ 2.50GHz GenuineIntel GNU/Linux

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.1.20100303
util-linux             2.17.2
mount                  support
module-init-tools      3.5
e2fsprogs              1.41.11
reiserfsprogs          3.6.21
xfsprogs               3.0.3
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               8.4
Modules Loaded         nfsd lockd sunrpc exportfs bnx2 iTCO_wdt

 From console:
Message from syslogd@wzor at Thu Jul  8 15:20:31 2010 ...
wzor kernel: Oops: 0000 [#1] SMP

Message from syslogd@wzor at Thu Jul  8 15:20:31 2010 ...
wzor kernel: last sysfs file: /sys/devices/virtual/block/md0/dev

Message from syslogd@wzor at Thu Jul  8 15:20:31 2010 ...
wzor kernel: Stack:

Message from syslogd@wzor at Thu Jul  8 15:20:31 2010 ...
wzor kernel: Call Trace:

Message from syslogd@wzor at Thu Jul  8 15:20:31 2010 ...
wzor kernel: Code: 41 5f c9 c3 49 8b bd 00 01 00 00 41 bf c3 ff ff ff e8 
81 06 00 00 4d 8b b5 00 01 00 00 49 8b 86 80 02 00 00 48 8b 80 70 04 00 
00 <48> 8b 50 10 48 85 d2 0f 84 43 04 00 00 48 8d ba b0 00 00 00 48

Message from syslogd@wzor at Thu Jul  8 15:20:31 2010 ...
wzor kernel: CR2: 0000000000000010
Killed


 From dmesg:
Jul  8 15:20:30 wzor mountd[4890]: Caught signal 15, un-registering and 
exiting.
Jul  8 15:20:30 wzor kernel: nfsd: last server has exited, flushing 
export cache
Jul  8 15:20:30 wzor kernel: nfsd: last server has exited, flushing 
export cache
Jul  8 15:20:31 wzor kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000000000000010
Jul  8 15:20:31 wzor kernel: IP: [<ffffffff81129fb4>] 
reiserfs_for_each_xattr+0x94/0x560
Jul  8 15:20:31 wzor kernel: PGD 679885067 PUD 679522067 PMD 0
Jul  8 15:20:31 wzor kernel: Oops: 0000 [#1] SMP
Jul  8 15:20:31 wzor kernel: last sysfs file: 
/sys/devices/virtual/block/md0/dev
Jul  8 15:20:31 wzor kernel: CPU 7
Jul  8 15:20:31 wzor kernel: Modules linked in: nfsd lockd sunrpc 
exportfs bnx2 iTCO_wdt
Jul  8 15:20:31 wzor kernel:
Jul  8 15:20:31 wzor kernel: Pid: 4950, comm: umount Not tainted 
2.6.34-gentoo-r1 #7 0TT740/PowerEdge 1950
Jul  8 15:20:31 wzor kernel: RIP: 0010:[<ffffffff81129fb4>] 
[<ffffffff81129fb4>] reiserfs_for_each_xattr+0x94/0x560
Jul  8 15:20:31 wzor kernel: RSP: 0018:ffff88067ebb5bf8  EFLAGS: 00010202
Jul  8 15:20:31 wzor kernel: RAX: 0000000000000000 RBX: ffffffff81129da0 
RCX: 0000000000000000
Jul  8 15:20:31 wzor kernel: RDX: 0000000000000000 RSI: ffffffff81129da0 
RDI: ffff88067e9ef828
Jul  8 15:20:31 wzor kernel: RBP: ffff88067ebb5ce8 R08: 000000000006bdc4 
R09: dead000000200200
Jul  8 15:20:31 wzor kernel: R10: dead000000100100 R11: dead000000200200 
R12: 0000000000000000
Jul  8 15:20:31 wzor kernel: R13: ffff88065ba3fcc8 R14: ffff880678cb7c00 
R15: 00000000ffffffc3
Jul  8 15:20:31 wzor kernel: FS:  00007f4fe7313740(0000) 
GS:ffff8800019c0000(0000) knlGS:0000000000000000
Jul  8 15:20:31 wzor kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Jul  8 15:20:31 wzor kernel: CR2: 0000000000000010 CR3: 000000067b139000 
CR4: 00000000000006e0
Jul  8 15:20:31 wzor kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Jul  8 15:20:31 wzor kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Jul  8 15:20:31 wzor kernel: Process umount (pid: 4950, threadinfo 
ffff88067ebb4000, task ffff88067e8c3380)
Jul  8 15:20:31 wzor kernel: Stack:
Jul  8 15:20:31 wzor kernel:  ffff88067ebb5c58 ffff88067ebb5c28 
ffff88067ebb5cf8 ffff88067e92e006
Jul  8 15:20:31 wzor kernel: <0> 0000000f00000000 000000000000000f 
0000000000000000 0000000000000000
Jul  8 15:20:31 wzor kernel: <0> 0000000000000000 0000000000000000 
0000000000000000 0000000000000000
Jul  8 15:20:31 wzor kernel: Call Trace:
Jul  8 15:20:31 wzor kernel:  [<ffffffff8102a29b>] ? 
__dequeue_entity+0x2b/0x50
Jul  8 15:20:31 wzor kernel:  [<ffffffff8112a502>] 
reiserfs_delete_xattrs+0x22/0x60
Jul  8 15:20:31 wzor kernel:  [<ffffffff8110fb04>] 
reiserfs_delete_inode+0x94/0x110
Jul  8 15:20:31 wzor kernel:  [<ffffffff810bfcd0>] 
generic_delete_inode+0x80/0x120
Jul  8 15:20:31 wzor kernel:  [<ffffffff810bfdbd>] 
generic_drop_inode+0x4d/0x70
Jul  8 15:20:31 wzor kernel:  [<ffffffff810beb6d>] iput+0x5d/0x70
Jul  8 15:20:31 wzor kernel:  [<ffffffff810bd101>] 
shrink_dcache_for_umount_subtree+0x1d1/0x270
Jul  8 15:20:31 wzor kernel:  [<ffffffff810bd1e6>] 
shrink_dcache_for_umount+0x46/0x50
Jul  8 15:20:31 wzor kernel:  [<ffffffff810accca>] 
generic_shutdown_super+0x1a/0x100
Jul  8 15:20:31 wzor kernel:  [<ffffffff810acddc>] 
kill_block_super+0x2c/0x50
Jul  8 15:20:31 wzor kernel:  [<ffffffff811148f3>] 
reiserfs_kill_sb+0x93/0xa0
Jul  8 15:20:31 wzor kernel:  [<ffffffff810ad320>] 
deactivate_super+0x50/0x70
Jul  8 15:20:31 wzor kernel:  [<ffffffff810c349e>] 
mntput_no_expire+0x9e/0xe0
Jul  8 15:20:31 wzor kernel:  [<ffffffff810c3846>] sys_umount+0x76/0x370
Jul  8 15:20:31 wzor kernel:  [<ffffffff810023ab>] 
system_call_fastpath+0x16/0x1b
Jul  8 15:20:31 wzor kernel: Code: 41 5f c9 c3 49 8b bd 00 01 00 00 41 
bf c3 ff ff ff e8 81 06 00 00 4d 8b b5 00 01 00 00 49 8b 86 80 02 00 00 
48 8b 80 70 04 00 00 <48> 8b 50 10 48 85 d2 0f 84 43 04 00 00 48 8d ba 
b0 00 00 00 48
Jul  8 15:20:31 wzor kernel: RIP  [<ffffffff81129fb4>] 
reiserfs_for_each_xattr+0x94/0x560
Jul  8 15:20:31 wzor kernel:  RSP <ffff88067ebb5bf8>
Jul  8 15:20:31 wzor kernel: CR2: 0000000000000010
Jul  8 15:20:31 wzor kernel: ---[ end trace 8142c08791238025 ]---

./decodecode:

Jul 8 15:20:31 wzor kernel: Code: 41 5f c9 c3 49 8b bd 00 01 00 00 41 bf 
c3 ff ff ff e8 81 06 00 00 4d 8b b5 00 01 00 00 49 8b 86 80 02 00 00 48 
8b 80 70 04 00 00 <48> 8b 50 10 48 85 d2 0f 84 43 04 00 00 48 8d ba b0 
00 00 00 48
All code
========
    0:   41 5f                   pop    %r15
    2:   c9                      leaveq
    3:   c3                      retq
    4:   49 8b bd 00 01 00 00    mov    0x100(%r13),%rdi
    b:   41 bf c3 ff ff ff       mov    $0xffffffc3,%r15d
   11:   e8 81 06 00 00          callq  0x697
   16:   4d 8b b5 00 01 00 00    mov    0x100(%r13),%r14
   1d:   49 8b 86 80 02 00 00    mov    0x280(%r14),%rax
   24:   48 8b 80 70 04 00 00    mov    0x470(%rax),%rax
   2b:*  48 8b 50 10             mov    0x10(%rax),%rdx     <-- trapping 
instruction
   2f:   48 85 d2                test   %rdx,%rdx
   32:   0f 84 43 04 00 00       je     0x47b
   38:   48 8d ba b0 00 00 00    lea    0xb0(%rdx),%rdi
   3f:   48                      rex.W

Code starting with the faulting instruction
===========================================
    0:   48 8b 50 10             mov    0x10(%rax),%rdx
    4:   48 85 d2                test   %rdx,%rdx
    7:   0f 84 43 04 00 00       je     0x450
    d:   48 8d ba b0 00 00 00    lea    0xb0(%rdx),%rdi
   14:   48                      rex.W


