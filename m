Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0KUOlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:41:32 -0500
Received: from daytona.panasas.com ([67.152.220.89]:58580 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0KUOlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:41:31 -0500
Message-ID: <4CE92F96.7000002@panasas.com>
Date: Sun, 21 Nov 2010 16:41:26 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 18
References: <20101118134256.fe132215.sfr@canb.auug.org.au>	<4CE54562.9030603@panasas.com> <20101119103300.243b17c8.sfr@canb.auug.org.au>
In-Reply-To: <20101119103300.243b17c8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2010 14:41:28.0248 (UTC) FILETIME=[2E1F3380:01CB898A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 01:33 AM, Stephen Rothwell wrote:
> Hi Boaz,
> 
> On Thu, 18 Nov 2010 17:25:22 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> The uml build from:
>>         http://kisskb.ellerman.id.au/kisskb/target/2979/
>>
>> is failing compilation like:
>>   LD      .tmp_vmlinux1
>> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/lib/gcc/i386-unknown-linux-gnu/4.2.3/../../../../i386-unknown-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:231: parse error
>> collect2: ld returned 1 exit status
>>   KSYM    .tmp_kallsyms1.S
>> /opt/crosstool/gcc-4.2.3-glibc-2.3.6/i386-unknown-linux-gnu/bin/i386-unknown-linux-gnu-nm: '.tmp_vmlinux1': No such file
>> No valid symbol.
>> make[1]: *** [.tmp_kallsyms1.S] Error 1
>> make: *** [sub-make] Error 2
>> make failed, trying to bisect ..
>>
>> It looks like a build environment setup problem because it's fine here
>> (for x86_64 at least.) Who is the person responsible for the above URL
>> compilation please?
> 
> I am (at least partially) responsible for that build environment.
> 
> We only started getting that build failure with next-20101115 (it may
> have been present before then but masked by other build failures), and
> our build system hasn't changed in quite some time ...  In fact, before
> next-20100915, the um i386 build used to succeed.
> 
> The build we are doing is 32 bit (not 64 bit).  We are in the process of
> getting a newer tool chain, but I am not sure when that will happen.

Hi Stephen, thank you for your reply

So... Every x86_64 box is also a potential of an x86_32 cross compilation
environment, right?. Almost because for instance in Fedora 12 I had to:
	yum install glibc-devel.i686
for it to work (On top of the regular Kernel development packages)

So I tried:
[]$ make ARCH=um SUBARCH=i386 KBUILD_OUTPUT=.build_i386_um defconfig
[]$ make ARCH=um SUBARCH=i386 KBUILD_OUTPUT=.build_i386_um

And it all worked very nice just as with x86_64.
What is you box environment? Distro, Arch, version of gcc-for-i386 ...?
I would like to help resolve it. Since I decided that I should be watching
out for ARCH=um, before breakage is put into Linus tree, like the last 4
Kernels.

Meanwhile I have setup a cron job for every-night to checkout linux-next
and "make". As a backup for above, until it is fixed.

Anything else I can contribute to this cause?

Thanks
Boaz
