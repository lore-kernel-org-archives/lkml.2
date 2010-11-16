Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412Ab0KPMmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:42:21 -0500
Received: from daytona.panasas.com ([67.152.220.89]:28710 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab0KPMmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:42:20 -0500
Message-ID: <4CE27C28.5010902@panasas.com>
Date: Tue, 16 Nov 2010 14:42:16 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 16
References: <20101116134053.e830b8f0.sfr@canb.auug.org.au>
In-Reply-To: <20101116134053.e830b8f0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Nov 2010 12:42:18.0935 (UTC) FILETIME=[B4BBDC70:01CB858B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 04:40 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20101115:
> 
> The v4l-dvb tree still has its build failure, so I used the version from
> next-20101112.
> 
> The net tree lost its build failure but gained another, so I used the
> version from next-20101115.
> 
> The block tree lost its conflict.
> 
> The xen tree lost its conflict.
> 
> The tty tree still has its build failure for which I reverted a commit.
> 
> The bkl-config tree gained a build failure, so I used the version from
> next-20101115.
> 

Stephen hi

It is the 3rd Kernel-rc1 in a row that failed to compile or run UML, so I've
decided to watch like an auk the uml compilation in Linux next and make
sure to report or possibly fix things before they get into Linus tree.

So the compilation from the 16th
(from http://kisskb.ellerman.id.au/kisskb/buildresult/3530881/)
gives out:

  LD      init/built-in.o
  LD      .tmp_vmlinux1
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/lib/gcc/i386-unknown-linux-gnu/4.2.3/../../../../i386-unknown-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:231: parse error
collect2: ld returned 1 exit status
  KSYM    .tmp_kallsyms1.S
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/bin/i386-unknown-linux-gnu-nm: '.tmp_vmlinux1': No such file
No valid symbol.
make[1]: *** [.tmp_kallsyms1.S] Error 1
make: *** [sub-make] Error 2
make failed, trying to bisect ..

I know that Linus November 14 was the first version that compiled do to some
needed UM patch. But what's going on with the 16th tree? Here it all compiles
well, though I'm using an x86_64 environment.

Could you please check if perhaps something has broken with the build environment.

BTW: I have set a cron job that checks out linux-next at 4:00 am everyday and
compiles a UML allmodconfig. I want a second check here as well.

Thanks
Boaz

> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
> and sparc64 defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
> 
> Below is a summary of the state of the merge.
> 
> We are up to 179 trees (counting Linus' and 26 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Randy Dunlap for doing many randconfig builds.
> 
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
> 

