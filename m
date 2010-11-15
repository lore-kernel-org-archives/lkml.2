Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab0KOSRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 13:17:41 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3255 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab0KOSRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 13:17:40 -0500
Message-ID: <4CE1793B.2010109@xs4all.nl>
Date: Mon, 15 Nov 2010 19:17:31 +0100
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101106 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <m3lj52txaq.fsf@redhat.com> <4CD97A3D.1040602@xs4all.nl> <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com> <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz> <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <20101115113739.GH7269@basil.fritz.box> <4CE16F86.40808@xs4all.nl> <20101115174449.GW29412@tyan-ft48-01.lab.bos.redhat.com>
In-Reply-To: <20101115174449.GW29412@tyan-ft48-01.lab.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 06:44 PM, Jakub Jelinek wrote:
> On Mon, Nov 15, 2010 at 06:36:06PM +0100, Jim Bos wrote:
>> On 11/15/2010 12:37 PM, Andi Kleen wrote:
>> See attached, note this is the vanilla 2.6.36 i8k.c (without any patch).
>> And to be 100% sure, if I build this (make drivers/char/i8k.ko) it won't
>> work.
>>
>> [ The i8k.i is rather big, even gzipped 80k, not sure if it'll bounce ]
> 
> Please also say which exact gcc you are using.
> 
> Note, I've compiled it with current 4.5 branch and made the function
> always_inline and still didn't see any issues in the *.optimized dump,
> regs.eax after the inline asm has always been compared to the constant
> that has been stored into regs.eax before the inline asm.
> 
> 	Jakub
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

 # gcc -v
Reading specs from /usr/lib/gcc/i486-slackware-linux/4.5.1/specs
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/i486-slackware-linux/4.5.1/lto-wrapper
Target: i486-slackware-linux
Configured with: ../gcc-4.5.1/configure --prefix=/usr --libdir=/usr/lib
--mandir=/usr/man --infodir=/usr/info --enable-shared --enable-bootstrap
--enable-languages=ada,c,c++,fortran,java,objc --enable-threads=posix
--enable-checking=release --with-system-zlib
--with-python-dir=/lib/python2.6/site-packages
--disable-libunwind-exceptions --enable-__cxa_atexit --enable-libssp
--with-gnu-ld --verbose --with-arch=i486 --target=i486-slackware-linux
--build=i486-slackware-linux --host=i486-slackware-linux
Thread model: posix
gcc version 4.5.1 (GCC)

I'm re-reading this thread where I found the asm-> asm volatine suggestion:
  https://bbs.archlinux.org/viewtopic.php?pid=752099#p752099
but nobody there reported their gcc version (but apparently first
people started complaining May 1st).

_
Jim
