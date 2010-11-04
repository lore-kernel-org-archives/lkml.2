Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0KDIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:16:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46344 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0KDIQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=enWoVCPJ64DZiqnE4c28OgAY5ntvZJRRtM74Fj+TYDmEdeHUxdpUNIo3njHmFafjZ+
         +G+mXdpdYy/OZ/W8Hjz4ywCvr6nuYRwVVQFe9gFBsVTe4ARa1Ar2ow/M/JheeuScHHVW
         Ikf19EcGrZWCNktZheBr3LJ2VGLs+XHgfXpSM=
From: randrianasulu@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.37-rc1 build failure
Date: Thu, 4 Nov 2010 12:16:05 +0000
User-Agent: KMail/1.9.10
Cc: Lin Ming <lin@ming.vg>, linux-kernel@vger.kernel.org, mingo@redhat.com
References: <201011030532.09986.randrianasulu@gmail.com> <201011040334.16833.randrianasulu@gmail.com> <20101103213439.01d2062d.randy.dunlap@oracle.com>
In-Reply-To: <20101103213439.01d2062d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011041216.07206.randrianasulu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от Thursday 04 November 2010 04:34:39 Randy Dunlap написал(а):
> On Thu, 4 Nov 2010 03:34:16 +0000 randrianasulu@gmail.com wrote:
> > В сообщении от Wednesday 03 November 2010 02:05:07 Lin Ming написал(а):
> > > On Wed, Nov 3, 2010 at 1:32 PM,  <randrianasulu@gmail.com> wrote:
> > > > Trying to make new kernel i run into this:
> > > >
> > > >  CC      arch/x86/lib/delay.o
> > > >  AS      arch/x86/lib/getuser.o
> > > >  AS      arch/x86/lib/putuser.o
> > > >  CC      arch/x86/lib/usercopy_32.o
> > > >  AR      arch/x86/lib/lib.a
> > > >  LD      vmlinux.o
> > > >  MODPOST vmlinux.o
> > > > WARNING: modpost: Found 2 section mismatch(es).
> > > > To see full details build your kernel with:
> > > > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> > > >  GEN     .version
> > > >  CHK     include/generated/compile.h
> > > >  UPD     include/generated/compile.h
> > > >  CC      init/version.o
> > > >  LD      init/built-in.o
> > > >  LD      .tmp_vmlinux1
> > > > kernel/built-in.o: In function `free_event':
> > > > perf_event.c:(.text+0x66eb3): undefined reference to `irq_work_sync'
> > > > kernel/built-in.o: In function `perf_output_put_handle':
> > > > perf_event.c:(.text+0x680e1): undefined reference to `irq_work_queue'
> > > > kernel/built-in.o: In function `__perf_event_overflow':
> > > > perf_event.c:(.text+0x6a75e): undefined reference to `irq_work_queue'
> > > > make: *** [.tmp_vmlinux1] Ошибка 1
> > > >
> > > > kernel.org git master up to
> > > >
> > > > commit eb8abb927ae2fd1730e24ea94cd9527f3c086292
> > > > Author: Theodore Ts'o <tytso@mit.edu>
> > > > Date:   Tue Nov 2 09:34:50 2010 -0400
> > > >
> > > >    ext4: Remove useless spinlock in ext4_getattr()
> > > >
> > > >
> > > >
> > > > this is my .config
> > >
> > > I build with you .config, but no error.
> > >
> > > Maybe you can make distclean and re-build.
> > >
> > > Lin Ming
> >
> > No, same error.
> >
> > I'm using (Linux/GNU Binutils) 2.20.51.0.8.20100412 , gcc (GCC) 4.4.4 on
> > Slackware -current box (glibc-2.12.1-i486-2). Not sure what else i can do
> > for debugging this.
> > --
>
> The build fails for me with the given .config file.
> It's due to selects and depends, finally comes down to HAVE_PERF_EVENTS not
> being enabled for M386 or M486.  Do you actually have a processor of that
> vintage?


No, i have AMD k7:

cat /proc/cpuinfo 
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 3
model name      : AMD Duron(tm) Processor
stepping        : 1
cpu MHz         : 950.014
cache size      : 64 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 mmx fxsr syscall mmxext 3dnowext 3dnow up
bogomips        : 1900.02
clflush size    : 32
cache_alignment : 32
address sizes   : 36 bits physical, 32 bits virtual
power management:


but i prefer to build kernel for i486 (i686 was giving me troubles on old k6-2 
machine some time ago, and i used variant of this config for LiveCD, 
sometimes for some QEMU tests ... i have real 486 box but it has too litle 
memory , 4mb, for being useful.)

Thanks for figuring  this out, i'll rebuild my kernel for i586 for now.

>
> We can probably fix the Kconfig files to prevent this build error...
>
> (Ingo: FYI)
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***


