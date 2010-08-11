Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0HKQfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:35:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41593 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0HKQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=Bmnw7TwRVv3agKxtpu3tkP0CHw3JAO+F2QtwfSPyiUR0cAPuMj3jCpF46+a/4t7ARh
         EBWEekabJlbCDo0Kfwf8NF8L/p2fxBjhXVgcY7D+/SyXMTOGXXEoNAzsyJP0vSYuhofo
         F9ge5X4nPVyVAsNjSEcIG47jHRrAxX0xm1wxw=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 12 Aug 2010 00:34:50 +0800
Message-ID: <AANLkTi=4_QnAyY+zcuXwVpPkESjpF7yfMb1RunMQaK7f@mail.gmail.com>
Subject: Linux Kernel GDB tracepoint module demo release
To: gdb@sourceware.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

GDB Tracepoint (http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html)
is new feature that make GDB can debug real-time program.
I think this feature is very fit for debug Linux Kernel.  So I make a
lkm to make kernel support it. You can get it in
https://code.google.com/p/kgtp/

I just release the demo for it.  It just support collect $reg in
x86_32.  I will add the other tracepoint support in the future.

For example:
tar vxjf gtp_20100811.tar.bz2
cd gtp
make
insmod gtp.ko
gdb ./vmlinux
GNU gdb (GDB) 7.2.50.20100720-cvs
Copyright (C) 2010 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i686-pc-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /vmlinux...done.
(gdb) target remote /proc/gtp
Remote debugging using /proc/gtp
0x00000000 in ?? ()
(gdb) trace vfs_readdir
Tracepoint 1 at 0xc01a1ac0: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 23.
(gdb) actions
Enter actions for tracepoint 1, one per line.
End with a line saying just "end".
>collect $reg
>end
(gdb) tstart
(gdb) shell ls
(gdb) tstop
(gdb) tfind
Found trace frame 0, tracepoint 1
#0  0xc01a1ac1 in vfs_readdir (file=0xc5528d00, filler=0xc01a1900 <filldir64>,
    buf=0xc0d09f90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
23	/home/teawater/kernel/linux-2.6/fs/readdir.c: No such file or directory.
	in /home/teawater/kernel/linux-2.6/fs/readdir.c
(gdb) info reg
eax            0xc5528d00	-984445696
ecx            0xc0d09f90	-1060069488
edx            0xc01a1900	-1072031488
ebx            0xfffffff7	-9
esp            0xc0d09f8c	0xc0d09f8c
ebp            0x0	0x0
esi            0x8061480	134616192
edi            0xc5528d00	-984445696
eip            0xc01a1ac1	0xc01a1ac1 <vfs_readdir+1>
eflags         0x286	[ PF SF IF ]
cs             0x60	96
ss             0x8061480	134616192
ds             0x7b	123
es             0x7b	123
fs             0x0	0
gs             0x0	0
(gdb) tfind
Found trace frame 1, tracepoint 1
0xc01a1ac1	23	in /home/teawater/kernel/linux-2.6/fs/readdir.c
(gdb) info reg
eax            0xc5528d00	-984445696
ecx            0xc0d09f90	-1060069488
edx            0xc01a1900	-1072031488
ebx            0xfffffff7	-9
esp            0xc0d09f8c	0xc0d09f8c
ebp            0x0	0x0
esi            0x8061480	134616192
edi            0xc5528d00	-984445696
eip            0xc01a1ac1	0xc01a1ac1 <vfs_readdir+1>
eflags         0x286	[ PF SF IF ]
cs             0x60	96
ss             0x8061480	134616192
ds             0x7b	123
es             0x7b	123
fs             0x0	0
gs             0x0	0
(gdb) tfind
Found trace frame 2, tracepoint 1
#0  0xc01a1ac1 in vfs_readdir (file=0xc5528300, filler=0xc01a19e0 <filldir>,
    buf=0xc6c2df90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
23	in /home/teawater/kernel/linux-2.6/fs/readdir.c
(gdb)
Found trace frame 3, tracepoint 1
0xc01a1ac1	23	in /home/teawater/kernel/linux-2.6/fs/readdir.c
(gdb)
Target failed to find requested trace frame.
(gdb) quit
A debugging session is active.

	Inferior 1 [Remote target] will be killed.

Quit anyway? (y or n) y

Thanks,
Hui
