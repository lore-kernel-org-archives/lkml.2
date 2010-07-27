Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0G0HYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:24:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61043 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab0G0HYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ApMxEfzJOf8sicrPzcHdaDQa9hjpq309cINSngBZrWt8jL9/dLAAnk5gSDgH1P8HN/
         z7MRecayx6jDgtBHYUdYpf5OnRnAhYYApQ8XgTZoULOP+OyYIByyc4ceNfY5sSAL49Z5
         0PviBDPAaNhKE2rGEUj1VDyAkyb3Cm1Kozf+0=
MIME-Version: 1.0
In-Reply-To: <20100727160708.722c39c1.sfr@canb.auug.org.au>
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
Date: Tue, 27 Jul 2010 12:54:22 +0530
Message-ID: <AANLkTi=ki084ymBzsnbgnFw952BSnSDzUyL+YH-4353b@mail.gmail.com>
Subject: Re: linux-next: Tree for July 27
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Tue, Jul 27, 2010 at 11:37 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20100726:
>
> The arm tree lost its conflict.
>
> The microblaze tree lost its conflict.
>
> The mips tree gained a build failure so I used the version from
> next-20100726.
>
> The xfs tree still has its build failure so I used the version from
> next-20100723.
>
> The ieee2394 tree gained a build failure so I used the version from
> next-20100726.
>
> The kvm tree still has its build failure.
>
> The async_tx tree gained a conflict against the arm tree.
>
> The devicetree tree lost its conflict, but gained another against the
> microblaze tree.
>
> The xen tree lost its build problems but gained a conflict against Linus'
> tree.
>
> The tip tree gained a conflict against the cpufreq tree.
>
> The tty tree gained a conflict against the genesis tree and a build
> failure for which I reverted 4 patches.
>
> The usb tree lost its conflicts.
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
>
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
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
> We are up to 167 trees (counting Linus' and 22 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
>
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
>
> Thanks to Jan Dittmer for adding the linux-next tree to his build tests
> at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
> Dunlap for doing many randconfig builds.
>
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
>

I am getting following compilation warnings in linux-next 20100727:

  CC [M]  arch/x86/kvm/mmu.o
arch/x86/kvm/mmu.c: In function ‘kvm_mmu_pte_write’:
arch/x86/kvm/mmu.c:2908: warning: suggest parentheses around operand
of ‘!’ or change ‘&’ to ‘&&’ or ‘!’ to ‘~’

 CC      lib/decompress_bunzip2.o
lib/decompress_bunzip2.c: In function ‘get_next_block’:
lib/decompress_bunzip2.c:511: warning: the frame size of 1968 bytes is
larger than 1024 bytes

  CC      drivers/scsi/constants.o
drivers/scsi/constants.c: In function ‘scsi_print_sense’:
drivers/scsi/constants.c:1407: warning: zero-length gnu_printf format string
drivers/scsi/constants.c:1413: warning: zero-length gnu_printf format string
drivers/scsi/constants.c: In function ‘scsi_print_result’:
drivers/scsi/constants.c:1456: warning: zero-length gnu_printf format string


  CC      drivers/scsi/sd.o
drivers/scsi/sd.c: In function ‘sd_print_sense_hdr’:
drivers/scsi/sd.c:2617: warning: zero-length gnu_printf format string
drivers/scsi/sd.c:2619: warning: zero-length gnu_printf format string
drivers/scsi/sd.c: In function ‘sd_print_result’:
drivers/scsi/sd.c:2625: warning: zero-length gnu_printf format string

Thanks,
--
Jaswinder Singh.
