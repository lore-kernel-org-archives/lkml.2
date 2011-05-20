Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429Ab1ETHnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:43:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39748 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933834Ab1ETHnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:43:15 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/ziPker2TzYPLg6QWuO+aqgYuSXMe4zGDsutY2D7
	LheNJBfe06lgzQ
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Fri, 20 May 2011 09:43:09 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
References: <201105191526.31904.toralf.foerster@gmx.de> <201105191834.56577.toralf.foerster@gmx.de> <BANLkTi=8NW9Q+8Q=kuUJY1L=FcQGapqDLA@mail.gmail.com>
In-Reply-To: <BANLkTi=8NW9Q+8Q=kuUJY1L=FcQGapqDLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105200943.10228.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard -rw- weinberger wrote at 08:44:39
> > * Starting local
> 
> What is this "Starting local",
> was UML crashing while starting your distro?
No, that the last init script of the Gentoo, I'm using within UML.

> I fear the backtrace is garbage.
yep, maybe this helps more : 

Program received signal SIGSEGV, Segmentation fault.
0x080a9f6b in futex_wake (uaddr=<value optimized out>, flags=<value optimized out>, nr_wake=<value optimized out>, 
    bitset=4294967295) at kernel/futex.c:958
958             plist_for_each_entry_safe(this, next, head, list) {
(gdb) bt
#0  0x080a9f6b in futex_wake (uaddr=<value optimized out>, flags=<value optimized out>, nr_wake=<value optimized out>, 
    bitset=4294967295) at kernel/futex.c:958
#1  0x080abb1d in do_futex (uaddr=0x81efe10, op=0, val=0, timeout=0x0, uaddr2=0x81efe0c, val2=0, val3=4294967295)
    at kernel/futex.c:2610
#2  0x080ac184 in sys_futex (uaddr=0x81efe10, op=129, val=1, utime=0x83f89b8, uaddr2=0x81efe0c, val3=134908072)
    at kernel/futex.c:2678
#3  0x08060d16 in handle_syscall (r=0x19545290) at arch/um/kernel/skas/syscall.c:35
#4  0x08074cf1 in handle_trap (regs=0x19545290) at arch/um/os-Linux/skas/process.c:201
#5  userspace (regs=0x19545290) at arch/um/os-Linux/skas/process.c:417
#6  0x0805e0cb in fork_handler () at arch/um/kernel/process.c:181
#7  0x00000000 in ?? ()

> 
> Can you reproduce the issue using the default config?
yes

> Are you using hostfs?
Yes, but the issue is independend from that.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
