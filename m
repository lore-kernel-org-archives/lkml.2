Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0KDEfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 00:35:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60428 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0KDEfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:35:23 -0400
Date: Wed, 3 Nov 2010 21:34:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: randrianasulu@gmail.com
Cc: Lin Ming <lin@ming.vg>, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: 2.6.37-rc1 build failure
Message-Id: <20101103213439.01d2062d.randy.dunlap@oracle.com>
In-Reply-To: <201011040334.16833.randrianasulu@gmail.com>
References: <201011030532.09986.randrianasulu@gmail.com>
	<AANLkTi=NYWGQB_O78dn=opzPYFngeBnJ2qrF7k5Le_ma@mail.gmail.com>
	<201011040334.16833.randrianasulu@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010 03:34:16 +0000 randrianasulu@gmail.com wrote:

> В сообщении от Wednesday 03 November 2010 02:05:07 Lin Ming написал(а):
> > On Wed, Nov 3, 2010 at 1:32 PM,  <randrianasulu@gmail.com> wrote:
> > > Trying to make new kernel i run into this:
> > >
> > >  CC      arch/x86/lib/delay.o
> > >  AS      arch/x86/lib/getuser.o
> > >  AS      arch/x86/lib/putuser.o
> > >  CC      arch/x86/lib/usercopy_32.o
> > >  AR      arch/x86/lib/lib.a
> > >  LD      vmlinux.o
> > >  MODPOST vmlinux.o
> > > WARNING: modpost: Found 2 section mismatch(es).
> > > To see full details build your kernel with:
> > > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > >  GEN     .version
> > >  CHK     include/generated/compile.h
> > >  UPD     include/generated/compile.h
> > >  CC      init/version.o
> > >  LD      init/built-in.o
> > >  LD      .tmp_vmlinux1
> > > kernel/built-in.o: In function `free_event':
> > > perf_event.c:(.text+0x66eb3): undefined reference to `irq_work_sync'
> > > kernel/built-in.o: In function `perf_output_put_handle':
> > > perf_event.c:(.text+0x680e1): undefined reference to `irq_work_queue'
> > > kernel/built-in.o: In function `__perf_event_overflow':
> > > perf_event.c:(.text+0x6a75e): undefined reference to `irq_work_queue'
> > > make: *** [.tmp_vmlinux1] Ошибка 1
> > >
> > > kernel.org git master up to
> > >
> > > commit eb8abb927ae2fd1730e24ea94cd9527f3c086292
> > > Author: Theodore Ts'o <tytso@mit.edu>
> > > Date:   Tue Nov 2 09:34:50 2010 -0400
> > >
> > >    ext4: Remove useless spinlock in ext4_getattr()
> > >
> > >
> > >
> > > this is my .config
> >
> > I build with you .config, but no error.
> >
> > Maybe you can make distclean and re-build.
> >
> > Lin Ming
> 
> No, same error.
> 
> I'm using (Linux/GNU Binutils) 2.20.51.0.8.20100412 , gcc (GCC) 4.4.4 on 
> Slackware -current box (glibc-2.12.1-i486-2). Not sure what else i can do for 
> debugging this.
> --

The build fails for me with the given .config file.
It's due to selects and depends, finally comes down to HAVE_PERF_EVENTS not being
enabled for M386 or M486.  Do you actually have a processor of that vintage?

We can probably fix the Kconfig files to prevent this build error...

(Ingo: FYI)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
