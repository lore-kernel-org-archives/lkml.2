Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab0KRPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:25:26 -0500
Received: from daytona.panasas.com ([67.152.220.89]:45604 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0KRPZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:25:24 -0500
Message-ID: <4CE54562.9030603@panasas.com>
Date: Thu, 18 Nov 2010 17:25:22 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 18
References: <20101118134256.fe132215.sfr@canb.auug.org.au>
In-Reply-To: <20101118134256.fe132215.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 15:25:23.0725 (UTC) FILETIME=[D1BFD3D0:01CB8734]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 04:42 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20101117:
> 
> The ceph tree lost its build failure.
> 
> The v4l-dvb tree still has its build failure, so I used the version from
> next-20101112.
> 
> The wireless tree lost its build failure.
> 
> The bluetooth tree gained the build failure from yesterday's wireless
> tree so I reverted the same commit.
> 
> The usb tree lost its build failure.
> 
> The bkl-config tree gained a conflict against Linus' tree.
> 

Stephen Hi

The uml build from:
        http://kisskb.ellerman.id.au/kisskb/target/2979/

is failing compilation like:
  LD      .tmp_vmlinux1
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/lib/gcc/i386-unknown-linux-gnu/4.2.3/../../../../i386-unknown-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:231: parse error
collect2: ld returned 1 exit status
  KSYM    .tmp_kallsyms1.S
/opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/bin/i386-unknown-linux-gnu-nm: '.tmp_vmlinux1': No such file
No valid symbol.
make[1]: *** [.tmp_kallsyms1.S] Error 1
make: *** [sub-make] Error 2
make failed, trying to bisect ..

It looks like a build environment setup problem because it's fine here
(for x86_64 at least.) Who is the person responsible for the above URL
compilation please?

Thanks in advance
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

