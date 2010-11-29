Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab0K2Izg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:55:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43225 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0K2Ize (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:55:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fICuLq+ZPREFxOSClGseyJW+jh5pW6r5lK5i0SgzL1hEHjACGKwsDlIETriUg30/RR
         tYuFwW8tbFM8KbwYlYHrOIYgb1Wi4PD5075edn8uNe966/FojcODWAY1Rk4iheoOqUtz
         A2Y0ry/X6v7daHfLxpIxJMNn4vibuUU68GM3U=
Subject: Re: [hellogcc] Re: [PATCH] Built kernel without -O2 option
From: Steven <mqyoung@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: hellogcc@freelists.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org
In-Reply-To: <AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	 <20101129081619.GD5218@cr0.nay.redhat.com>
	 <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
	 <4CF36741.9000808@loongson.cn>
	 <AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 16:55:29 +0800
Message-ID: <1291020929.1817.11.camel@steven>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I replace -O2 with -O0 in Makefile of kernel source code root directory?
I just do it and my gdb works well with this method.

You mean it is not enough?

Steven

On Mon, 2010-11-29 at 16:47 +0800, Hui Zhu wrote:
> In this way, you will got a lot of error.
> 
> Hui
> 
> On Mon, Nov 29, 2010 at 16:41, 乔崇 <qiaochong@loongson.cn> wrote:
> > does not need change kernel,just write a shell mycc as bellow:
> >
> > #!/bin/sh
> > gcc "$@" -O0
> >
> > then
> >
> > make CC=./mycc vmlinux
> >
> > Hui Zhu said
> >
> > On Mon, Nov 29, 2010 at 16:16, Américo Wang <xiyou.wangcong@gmail.com>
> > wrote:
> >
> >
> > On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
> >
> >
> > Hi,
> >
> > Now, there are a lot of ways to debug the Linux kernel with GDB, like
> > qemu, kgtp or kgdb and so on.
> > But the developer more like add a printk. It have a lot of reason, a big one
> > is:
> > (gdb) p ret
> > $3 = <value optimized out>
> > And the code execution order is not right.
> >
> > This is becuase the Kernel is bult with gcc -O2.  Gcc will not
> > generate enough debug message with file with -O2.
> > So GDB cannot work very well with Linux kernel.
> >
> > So I make a patch that add a option in "Kernel hacking" called "Close
> > GCC optimization".  It will make kernel be built without -O2.
> >
> > I built and use it in i386 and x86_64.  I will try to make it OK in other
> > arch.
> >
> >
> >
> > The problem is that some functions _have to_ be inlined and gcc without -O2
> > doesn't inline them. Have check all the cases? I doubt.
> >
> >
> > If they really need O2, I set  them to O2.
> > Actually, this is the main work, find out the file that need the O2.  :)
> >
> > For example:
> > ifdef CONFIG_CC_CLOSE_OPTIMIZATION
> > CFLAGS_fpu.o                           += -O2
> > CFLAGS_aesni-intel_glue.o              += -O2
> > CFLAGS_ghash-clmulni-intel_glue.o      += -O2
> > endif
> >
> > And I will try to find more of these type files.
> >
> >
> >
> > Also, what is size of vmlinux before applying your patch and after that?
> > Does it increase too much?
> >
> >
> >
> > Before the patch:
> > ls -alh vmlinuz-2.6.37-rc3+
> > -rw-r--r-- 1 root root 4.1M 2010-11-25 12:02 vmlinuz-2.6.37-rc3+
> > ls -alh b26no/vmlinux
> > -rwxr-xr-x 1 teawater teawater 135M 2010-11-25 13:31 b26no/vmlinux
> >
> > After the patch:
> > ls -alh vmlinuz-2.6.37-rc3debug+
> > -rw-r--r-- 1 root root 4.6M 2010-11-25 14:02 vmlinuz-2.6.37-rc3debug+
> > ls -alh b26/vmlinux
> > -rwxr-xr-x 1 teawater teawater 140M 2010-11-25 11:14 b26/vmlinux
> >
> > Thanks,
> > Hui
> >
> >
> >
> >
> > --
> >
> > 乔崇 qiaochong@loongson.cn
> >
> > 2010年 11月 29日 星期一 16:35:38 CST

