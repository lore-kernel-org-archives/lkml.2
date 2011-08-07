Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1HGUCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 16:02:38 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34019 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754687Ab1HGUCi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 16:02:38 -0400
Date: Sun, 7 Aug 2011 13:02:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Amirali Shambayati <amirali.shambayati@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Subject: Re: Compile kernel for various times and problem of too long time
 consuming
Message-Id: <20110807130236.6ec8acb6.rdunlap@xenotime.net>
In-Reply-To: <CAC-yRPTFiU4AwtcpDNse3+eRjjprVPYng9WFbYJMf_Ebe8MGYQ@mail.gmail.com>
References: <CAC-yRPQS7r-MMh13Y1m0O+oLBu2OmQqmXS8iHFtCOS9YwrxrkA@mail.gmail.com>
	<20110807110429.57161269.rdunlap@xenotime.net>
	<CAC-yRPTFiU4AwtcpDNse3+eRjjprVPYng9WFbYJMf_Ebe8MGYQ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011 00:18:04 +0430 Amirali Shambayati wrote:

> Would you say how you rebuild kernel?

Sure, it's just a 'make' command:

$ make -j4 ARCH=i386 O=X32 all


> On Sun, Aug 7, 2011 at 10:34 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Sun, 7 Aug 2011 21:39:12 +0430 Amirali Shambayati wrote:
> >
> >> Hi all,
> >> Since I want to evaluate performance improvements by changing just one
> >> file in kernel(noop-iosched) and compiling kernel is too much
> >> time-consuming, I want to know that if I compile kernel for more than
> >> one time, does it take similar time to first time?
> >>
> >> I use following commands. If I don't use "make-kpkg clean" for next
> >> times, does it just compile the files which have been modified or it
> >> compile whole kernel package again?
> >>
> >> make-kpkg clean
> >> fakeroot make-kpkg --initrd --append-to-version=-some-string-here
> >> kernel-image kernel-headers
> >
> > Since I never use make-kpkg, I can only tell you that when I modified
> > block/noop-iosched.c and rebuilt the kernel, here is what was rebuilt:
> >
> >  GEN     /lnx/src/NEXT/linux-next-20110805/X32/Makefile
> >  CHK     include/linux/version.h
> >  Using /lnx/src/NEXT/linux-next-20110805 as source for kernel
> >  CHK     include/generated/utsrelease.h
> >  CALL    /lnx/src/NEXT/linux-next-20110805/scripts/checksyscalls.sh
> >  CHK     include/generated/compile.h
> >  CHK     kernel/config_data.h
> >  CC      block/noop-iosched.o
> >  LD      block/built-in.o
> >  LD      vmlinux.o
> >  MODPOST vmlinux.o
> >  GEN     .version
> >  CHK     include/generated/compile.h
> >  UPD     include/generated/compile.h
> >  CC      init/version.o
> >  LD      init/built-in.o
> >  LD      .tmp_vmlinux1
> >  KSYM    .tmp_kallsyms1.S
> >  AS      .tmp_kallsyms1.o
> >  LD      .tmp_vmlinux2
> >  KSYM    .tmp_kallsyms2.S
> >  AS      .tmp_kallsyms2.o
> >  LD      vmlinux
> >  SYSMAP  System.map
> >  SYSMAP  .tmp_System.map
> >  Building modules, stage 2.
> >  VOFFSET arch/x86/boot/voffset.h
> >  CC      arch/x86/boot/version.o
> >  OBJCOPY arch/x86/boot/compressed/vmlinux.bin
> >  LZMA    arch/x86/boot/compressed/vmlinux.bin.lzma
> >  MODPOST 575 modules
> >  MKPIGGY arch/x86/boot/compressed/piggy.S
> >  AS      arch/x86/boot/compressed/piggy.o
> >  LD      arch/x86/boot/compressed/vmlinux
> >  ZOFFSET arch/x86/boot/zoffset.h
> >  OBJCOPY arch/x86/boot/vmlinux.bin
> >  AS      arch/x86/boot/header.o
> >  LD      arch/x86/boot/setup.elf
> >  OBJCOPY arch/x86/boot/setup.bin
> >  BUILD   arch/x86/boot/bzImage
> > Setup is 14972 bytes (padded to 15360 bytes).
> > System is 1287 kB
> > CRC 64ecf4d
> > Kernel: arch/x86/boot/bzImage is ready  (#18)
> >
> >
> > so it's a minimal rebuild, not a full kernel rebuild.



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
