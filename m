Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965807Ab2KAWDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:03:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39112 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762410Ab2KAWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAMBWrQ=Xrp-_opV0ej4rn20p3yTUP0TmYQHr5nG79szC0=WUDA@mail.gmail.com>
References: <CAMBWrQ=Xrp-_opV0ej4rn20p3yTUP0TmYQHr5nG79szC0=WUDA@mail.gmail.com>
From: Stan Hu <stanhu@gmail.com>
Date: Thu, 1 Nov 2012 15:02:45 -0700
Message-ID: <CAMBWrQm6CacSoUxZdNA9XPhDMqyAt2R15ZXxpCLEZcRvEeRiCg@mail.gmail.com>
Subject: Re: help with diagnosing kernel oops in __mutex_lock_slowpath
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm getting this kernel oops sporadically with a custom Cortex-A8 ARM
board with a Linux 3.2.28 kernel.  The system is booting off an SD
card; interestingly this failure doesn't seem to happen when I boot
from NAND flash.   I would say 1 out 10 times it fails with a similar
backtrace.  Does anyone have any clue why this might be happening?

[    6.249053] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[    6.257629] pgd = c6c24000
[    6.260498] [00000000] *pgd=86c2b831, *pte=00000000, *ppte=00000000
[    6.267059] Internal error: Oops: 817 [#1]
[    6.271331] Modules linked in: ipv6
[    6.274993] CPU: 0    Not tainted  (3.2.23 #223)
[    6.279846] PC is at __mutex_lock_slowpath+0x1e/0x70
[    6.285064] LR is at tty_open+0x1bb/0x320
[    6.289245] pc : [<c02e0a40>]    lr : [<c0181ee3>]    psr: 80000033
[    6.289276] sp : c6c1fda0  ip : c6c1e040  fp : c6ccac18
[    6.301269] r10: c6ccac00  r9 : c052e6a0  r8 : c790ee18
[    6.306732] r7 : c6c06040  r6 : 00500001  r5 : c6ccac1c  r4 : c6ccac18
[    6.313568] r3 : 00000000  r2 : c6c1fda4  r1 : 00000001  r0 : c6ccac18
[    6.320373] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb
Segment user
[    6.328033] Control: 50c5387d  Table: 86c24019  DAC: 00000015
[    6.334045] Process systemd-journal (pid: 65, stack limit = 0xc6c1e2f0)
[    6.340942] Stack: (0xc6c1fda0 to 0xc6c20000)
[    6.345520] fda0: c6ccac18 c6ccac1c 00000000 ffffffff c6cddf00
c79819c0 00500001 00000001
[    6.354064] fdc0: c790ee18 c0181ee3 c6ccac88 000a0101 0d72644d
00000000 c05b3a00 00000000
[    6.362640] fde0: c05b3a00 c790ee18 00000000 00000000 c6cddf00
c74d6b18 00000039 c0093789
[    6.371185] fe00: c790ee18 c6cddf00 00000000 c6cddf00 c790ee18
00000000 c00936bb 00000000
[    6.379730] fe20: c781de00 c74d6b18 00000039 c009037b 00000000
00000000 c6cddf00 c6c1fef8
[    6.388305] fe40: c6c1db40 00000000 00000022 00000000 00000039
c0090cff c6c1db40 00000022
[    6.396850] fe60: c790ee18 c6c1fef8 c790ee18 00000000 000a0101
c0099299 c7b10005 c6c1e000
[    6.405426] fe80: 00000016 c790ee18 c7402598 c6c1fef8 c6c1ff78
c7b10000 00000000 c6c1e000
[    6.413970] fea0: 00000000 00000000 00000039 c0099353 c6c1fecc
00000000 00000000 00000000
[    6.422546] fec0: 6e0a3815 c781de00 c74d6b18 00000000 c6c1ff78
00000001 c7b10000 ffffff9c
[    6.431091] fee0: c000cbe4 c6c1e000 00000000 c0099597 00000041
c6c1e000 c781de00 c74d6b18
[    6.439636] ff00: 05b6719b 00000007 c7b10005 00000000 c7550118
c790ee18 00000101 00000004
[    6.448211] ff20: 00000000 00000000 c781acc0 000000d0 000a0101
c04faeb4 c782a688 c782a680
[    6.456756] ff40: 00000000 000a0101 0000000d 000a0101 00000000
00000000 ffffff9c 0000000d
[    6.465332] ff60: ffffff9c c7b10000 00000001 c0090dbf 00000000
00080101 000a0101 00000000
[    6.473876] ff80: 00000022 00000100 000000a2 0001edd0 00080101
0001edd0 00000005 c000cbe4
[    6.482452] ffa0: c6c1e000 c000ca41 0001edd0 00080101 0001edd0
000a0101 00000000 00000000
[    6.490997] ffc0: 0001edd0 00080101 0001edd0 00000005 bea13e40
0002de69 0002de31 00000039
[    6.499542] ffe0: 0002b514 bea13db0 000191c0 4022cae0 60000010
0001edd0 00000055 00005af8
[    6.508148] [<c02e0a40>] (__mutex_lock_slowpath+0x1e/0x70) from
[<c0181ee3>] (tty_open+0x1bb/0x320)
[    6.517608] [<c0181ee3>] (tty_open+0x1bb/0x320) from [<c0093789>]
(chrdev_open+0xcf/0xf6)
[    6.526184] [<c0093789>] (chrdev_open+0xcf/0xf6) from [<c009037b>]
(__dentry_open+0x14f/0x210)
[    6.535217] [<c009037b>] (__dentry_open+0x14f/0x210) from
[<c0090cff>] (nameidata_to_filp+0x31/0x36)
[    6.544769] [<c0090cff>] (nameidata_to_filp+0x31/0x36) from
[<c0099299>] (do_last.clone.26+0x479/0x49c)
[    6.554626] [<c0099299>] (do_last.clone.26+0x479/0x49c) from
[<c0099353>] (path_openat+0x7f/0x230)
[    6.563995] [<c0099353>] (path_openat+0x7f/0x230) from [<c0099597>]
(do_filp_open+0x1b/0x4a)

This is the GDB backtrace:

(gdb) list *__mutex_lock_slowpath+0x1e
0xc02f5764 is in __mutex_lock_slowpath (include/linux/list.h:44).
39                                    struct list_head *next)
40      {
41              next->prev = new;
42              new->next = next;
43              new->prev = prev;
44              prev->next = new;
45      }
