Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2GPO4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2GPO4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:56:46 -0400
Message-ID: <50042BAA.2040809@redhat.com>
Date: Mon, 16 Jul 2012 17:56:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: nicolas prochazka <prochazka.nicolas@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Oops in proc_fd_instantiate (was: Re: [ kernel 3.5 ] Kernel bug when
 using kvm)
References: <CADdae-i23f_1tL6xRm3-j8g6LMSE7RP4bC68+cUCv-hPbX+B0g@mail.gmail.com> <5003FA12.7010907@redhat.com> <CADdae-jrhsuRvG-+rTWGActWtaLiQUzzothdcfq3hHp5OOKYUQ@mail.gmail.com> <500427F5.80709@redhat.com> <CADdae-hFGXWDm7H=vktoAr=EfX1powWtfMJ0dMraBtmWMZcK0w@mail.gmail.com>
In-Reply-To: <CADdae-hFGXWDm7H=vktoAr=EfX1powWtfMJ0dMraBtmWMZcK0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 05:46 PM, nicolas prochazka wrote:
> sorry,
> i recompile kernel with some option, and crash again :
> ( it seems i need to run a lot of qemu process to bug )
> 
> 
> [ 3117.379546] BUG: unable to handle kernel paging request at 000000010000003b
> [ 3117.379783] IP: [<ffffffff811a3654>] tid_fd_revalidate+0x84/0x1a0
> [ 3117.379978] PGD 6ea4e0067 PUD 0
> [ 3117.380012] Oops: 0000 [#1] SMP
> [ 3117.380012] CPU 4
> [ 3117.380012] Modules linked in: kvm_intel kvm [last unloaded: kvm]
> [ 3117.380012]
> [ 3117.380012] Pid: 9816, comm: netstat Not tainted 3.5.0-rc7 #2 Dell
> Inc. PowerEdge M600/0MY736
> [ 3117.380012] RIP: 0010:[<ffffffff811a3654>]  [<ffffffff811a3654>]
> tid_fd_revalidate+0x84/0x1a0
> [ 3117.380012] RSP: 0018:ffff8806ff6c1d78  EFLAGS: 00010206
> [ 3117.380012] RAX: ffff8806fc5042c0 RBX: ffff8806fa161380 RCX: 000000000000007e
> [ 3117.380012] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff8806fc5042c0
> [ 3117.411799] RBP: ffff8806ff6c1d98 R08: ffff88083fd16b30 R09: ffffffff8119fef0
> [ 3117.411799] R10: 0000000000000000 R11: 0000000000000206 R12: ffff8807e3d20180
> [ 3117.411799] R13: ffff880759832000 R14: ffff8807f2980838 R15: ffff8806ff6c1e08
> [ 3117.411799] FS:  00007fcb7124b700(0000) GS:ffff88083fd00000(0000)
> knlGS:0000000000000000
> [ 3117.438973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3117.438973] CR2: 000000010000003b CR3: 000000075e06c000 CR4: 00000000000027e0
> [ 3117.438973] DR0: 0000000000000003 DR1: 00000000000000b0 DR2: 0000000000000001
> [ 3117.438973] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 3117.438973] Process netstat (pid: 9816, threadinfo
> ffff8806ff6c0000, task ffff8807cefb3000)
> [ 3117.438973] Stack:
> [ 3117.438973]  ffff8807e3d20180 0000000000000007 ffff8806fa161380
> ffff8807e3ef5c00
> [ 3117.490924]  ffff8806ff6c1dc8 ffffffff811a3880 ffffffffff0a0210
> 0000000000000001
> [ 3117.490924]  ffff8806ff6c1e98 ffff8807f22a8d00 ffff8806ff6c1e48
> ffffffff811a4cd6
> [ 3117.490924] Call Trace:
> [ 3117.490924]  [<ffffffff811a3880>] proc_fd_instantiate+0x80/0xa0
> [ 3117.490924]  [<ffffffff811a4cd6>] proc_fill_cache+0x126/0x150
> [ 3117.490924]  [<ffffffff811a3800>] ? proc_fdinfo_instantiate+0x90/0x90
> [ 3117.490924]  [<ffffffff811505a0>] ? filldir64+0xe0/0xe0
> [ 3117.490924]  [<ffffffff811a5006>] proc_readfd_common+0xf6/0x1c0
> [ 3117.490924]  [<ffffffff811a3800>] ? proc_fdinfo_instantiate+0x90/0x90
> [ 3117.490924]  [<ffffffff811505a0>] ? filldir64+0xe0/0xe0
> [ 3117.490924]  [<ffffffff811a5105>] proc_readfd+0x15/0x20
> [ 3117.490924]  [<ffffffff811507c0>] vfs_readdir+0xa0/0xc0
> [ 3117.490924]  [<ffffffff811505a0>] ? filldir64+0xe0/0xe0
> [ 3117.490924]  [<ffffffff8115096d>] sys_getdents+0x8d/0x100
> [ 3117.490924]  [<ffffffff81ae9c29>] system_call_fastpath+0x16/0x1b
> [ 3117.609269] alloc_fd: slot 7 not NULL!
> [ 3117.490924] Code: b8 00 00 00 48 8b 50 08 44 3b 32 0f 83 9e 00 00
> 00 45 89 f6 49 c1 e6 03 4c 03 72 08 49 8b 16 48 85 d2 0f 84 87 00 00
> 00 48 89 c7 <44> 8b 62 3c e8 13 29 ea ff 4c 89 ef e8 4b df ff ff 85 c0
> 0f 84


Seems to be in the outside kvm.  Copying lkml.


-- 
error compiling committee.c: too many arguments to function


