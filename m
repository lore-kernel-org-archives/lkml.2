Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0LNV7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:59:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46067 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0LNV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:59:46 -0500
Date: Tue, 14 Dec 2010 13:59:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 18
Message-Id: <20101214135917.5b5a73e5.randy.dunlap@oracle.com>
In-Reply-To: <4CE92F96.7000002@panasas.com>
References: <20101118134256.fe132215.sfr@canb.auug.org.au>
	<4CE54562.9030603@panasas.com>
	<20101119103300.243b17c8.sfr@canb.auug.org.au>
	<4CE92F96.7000002@panasas.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 16:41:26 +0200 Boaz Harrosh wrote:

> On 11/19/2010 01:33 AM, Stephen Rothwell wrote:
> > Hi Boaz,
> > 
> > On Thu, 18 Nov 2010 17:25:22 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>
> >> The uml build from:
> >>         http://kisskb.ellerman.id.au/kisskb/target/2979/
> >>
> >> is failing compilation like:
> >>   LD      .tmp_vmlinux1
> >> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/lib/gcc/i386-unknown-linux-gnu/4.2.3/../../../../i386-unknown-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:231: parse error
> >> collect2: ld returned 1 exit status
> >>   KSYM    .tmp_kallsyms1.S
> >> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/bin/i386-unknown-linux-gnu-nm: '.tmp_vmlinux1': No such file
> >> No valid symbol.
> >> make[1]: *** [.tmp_kallsyms1.S] Error 1
> >> make: *** [sub-make] Error 2
> >> make failed, trying to bisect ..
> >>
> >> It looks like a build environment setup problem because it's fine here
> >> (for x86_64 at least.) Who is the person responsible for the above URL
> >> compilation please?
> > 
> > I am (at least partially) responsible for that build environment.
> > 
> > We only started getting that build failure with next-20101115 (it may
> > have been present before then but masked by other build failures), and
> > our build system hasn't changed in quite some time ...  In fact, before
> > next-20100915, the um i386 build used to succeed.
> > 
> > The build we are doing is 32 bit (not 64 bit).  We are in the process of
> > getting a newer tool chain, but I am not sure when that will happen.
> 
> Hi Stephen, thank you for your reply
> 
> So... Every x86_64 box is also a potential of an x86_32 cross compilation
> environment, right?. Almost because for instance in Fedora 12 I had to:
> 	yum install glibc-devel.i686
> for it to work (On top of the regular Kernel development packages)
> 
> So I tried:
> []$ make ARCH=um SUBARCH=i386 KBUILD_OUTPUT=.build_i386_um defconfig
> []$ make ARCH=um SUBARCH=i386 KBUILD_OUTPUT=.build_i386_um
> 
> And it all worked very nice just as with x86_64.
> What is you box environment? Distro, Arch, version of gcc-for-i386 ...?
> I would like to help resolve it. Since I decided that I should be watching
> out for ARCH=um, before breakage is put into Linus tree, like the last 4
> Kernels.
> 
> Meanwhile I have setup a cron job for every-night to checkout linux-next
> and "make". As a backup for above, until it is fixed.
> 
> Anything else I can contribute to this cause?


>From my small testing, it looks like ARCH=um "defconfig" is about the only
config that comes close to building reliably.  allmodconfig/allyesconfig and
several randconfig attempts all failed with many horrible errors.

Is that about right?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
