Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0HKVK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 17:10:58 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:54862 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab0HKVK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 17:10:57 -0400
Message-ID: <4C6311E0.5070909@vmware.com>
Date: Wed, 11 Aug 2010 14:10:56 -0700
From: Michael Snyder <msnyder@vmware.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>
CC: "gdb@sourceware.org" <gdb@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel GDB tracepoint module demo release
References: <AANLkTi=4_QnAyY+zcuXwVpPkESjpF7yfMb1RunMQaK7f@mail.gmail.com>
In-Reply-To: <AANLkTi=4_QnAyY+zcuXwVpPkESjpF7yfMb1RunMQaK7f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, this is kind of interesting.
Can your system set a tracepoint at any arbitrary location in the
kernel?  If so, I think that makes it more powerful than existing
systems such as LTTng, which can only trace statically pre-determined
locations.

Hui Zhu wrote:
> Hi,
> 
> GDB Tracepoint (http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html)
> is new feature that make GDB can debug real-time program.
> I think this feature is very fit for debug Linux Kernel.  So I make a
> lkm to make kernel support it. You can get it in
> https://code.google.com/p/kgtp/
> 
> I just release the demo for it.  It just support collect $reg in
> x86_32.  I will add the other tracepoint support in the future.
> 
> For example:
> tar vxjf gtp_20100811.tar.bz2
> cd gtp
> make
> insmod gtp.ko
> gdb ./vmlinux
> GNU gdb (GDB) 7.2.50.20100720-cvs
> Copyright (C) 2010 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "i686-pc-linux-gnu".
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>...
> Reading symbols from /vmlinux...done.
> (gdb) target remote /proc/gtp
> Remote debugging using /proc/gtp
> 0x00000000 in ?? ()
> (gdb) trace vfs_readdir
> Tracepoint 1 at 0xc01a1ac0: file
> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 23.
> (gdb) actions
> Enter actions for tracepoint 1, one per line.
> End with a line saying just "end".
>> collect $reg
>> end
> (gdb) tstart
> (gdb) shell ls
> (gdb) tstop
> (gdb) tfind
> Found trace frame 0, tracepoint 1
> #0  0xc01a1ac1 in vfs_readdir (file=0xc5528d00, filler=0xc01a1900 <filldir64>,
>     buf=0xc0d09f90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
> 23	/home/teawater/kernel/linux-2.6/fs/readdir.c: No such file or directory.
> 	in /home/teawater/kernel/linux-2.6/fs/readdir.c
> (gdb) info reg
> eax            0xc5528d00	-984445696
> ecx            0xc0d09f90	-1060069488
> edx            0xc01a1900	-1072031488
> ebx            0xfffffff7	-9
> esp            0xc0d09f8c	0xc0d09f8c
> ebp            0x0	0x0
> esi            0x8061480	134616192
> edi            0xc5528d00	-984445696
> eip            0xc01a1ac1	0xc01a1ac1 <vfs_readdir+1>
> eflags         0x286	[ PF SF IF ]
> cs             0x60	96
> ss             0x8061480	134616192
> ds             0x7b	123
> es             0x7b	123
> fs             0x0	0
> gs             0x0	0
> (gdb) tfind
> Found trace frame 1, tracepoint 1
> 0xc01a1ac1	23	in /home/teawater/kernel/linux-2.6/fs/readdir.c
> (gdb) info reg
> eax            0xc5528d00	-984445696
> ecx            0xc0d09f90	-1060069488
> edx            0xc01a1900	-1072031488
> ebx            0xfffffff7	-9
> esp            0xc0d09f8c	0xc0d09f8c
> ebp            0x0	0x0
> esi            0x8061480	134616192
> edi            0xc5528d00	-984445696
> eip            0xc01a1ac1	0xc01a1ac1 <vfs_readdir+1>
> eflags         0x286	[ PF SF IF ]
> cs             0x60	96
> ss             0x8061480	134616192
> ds             0x7b	123
> es             0x7b	123
> fs             0x0	0
> gs             0x0	0
> (gdb) tfind
> Found trace frame 2, tracepoint 1
> #0  0xc01a1ac1 in vfs_readdir (file=0xc5528300, filler=0xc01a19e0 <filldir>,
>     buf=0xc6c2df90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
> 23	in /home/teawater/kernel/linux-2.6/fs/readdir.c
> (gdb)
> Found trace frame 3, tracepoint 1
> 0xc01a1ac1	23	in /home/teawater/kernel/linux-2.6/fs/readdir.c
> (gdb)
> Target failed to find requested trace frame.
> (gdb) quit
> A debugging session is active.
> 
> 	Inferior 1 [Remote target] will be killed.
> 
> Quit anyway? (y or n) y
> 
> Thanks,
> Hui

