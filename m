Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2IIVa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 17:30:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51558 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2IIVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 17:30:26 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 9 Sep 2012 14:30:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4] linux/kernel.h: Fix DIV_ROUND_CLOSEST to support
 negative dividends
Message-ID: <20120909213025.GA2183@roeck-us.net>
References: <1346425339-17138-1-git-send-email-linux@roeck-us.net>
 <CAMuHMdWT2xKzOY9t05mYTMjmk=-V_XQQ8mZc69eQyrDN99hMuw@mail.gmail.com>
 <20120909161759.GA7998@roeck-us.net>
 <CAMuHMdUirbD8MjyZJfuHv6ht0iK5u2WJ3m0WanXsFQFWgcoPJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUirbD8MjyZJfuHv6ht0iK5u2WJ3m0WanXsFQFWgcoPJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 10:38:41PM +0200, Geert Uytterhoeven wrote:
> Hi Günter,
> 
> On Sun, Sep 9, 2012 at 6:17 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Sun, Sep 09, 2012 at 04:57:34PM +0200, Geert Uytterhoeven wrote:
> >> On Fri, Aug 31, 2012 at 5:02 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >> > DIV_ROUND_CLOSEST returns a bad result for negative dividends:
> >> >         DIV_ROUND_CLOSEST(-2, 2) = 0
> >> >
> >> > Most of the time this does not matter. However, in the hardware monitoring
> >> > subsystem, DIV_ROUND_CLOSEST is sometimes used on integers which can be
> >> > negative (such as temperatures).
> >>
> >> This seems to cause 3 new warnings in my m68k builds of v3.6-rc5:
> >>
> >> drivers/hwmon/mcp3021.c:76: warning: comparison is always true due to
> >> limited range of data type
> >> drivers/ide/ide-cd.c:1158: warning: comparison is always true due to
> >> limited range of data type
> >> drivers/ide/ide-cd.c:1159: warning: comparison is always true due to
> >> limited range of data type
> >>
> >> $ m68k-linux-gnu-gcc -v
> >> Using built-in specs.
> >> Target: m68k-linux-gnu
> >> Configured with: ../src/configure -v --enable-languages=c,c++
> >> --prefix=/usr --enable-shared --with-system-zlib --libexecdir=/usr/lib
> >> --without-included-gettext --enable-threads=posix --enable-nls
> >> --with-gxx-include-dir=/usr/m68k-linux-gnu/include/c++/4.1.2
> >> --program-suffix=-4.1 --enable-__cxa_atexit --enable-clocale=gnu
> >> --enable-libstdcxx-debug --disable-libssp --disable-werror
> >> --enable-checking=release --program-prefix=m68k-linux-gnu-
> >> --includedir=/usr/m68k-linux-gnu/include --build=x86_64-linux-gnu
> >> --host=x86_64-linux-gnu --target=m68k-linux-gnu
> >> Thread model: posix
> >> gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21)
> >>
> > The "always true" condition is on purpose to cause the compiler to optimize the
> > expression away. I don't see the warnings myself, on none of the targets I am
> > building (x86, ppc, arm, mips), but then I am using much more recent compiler
> > versions. Odd is that you only see the warnings on "u16" and not elsewhere.
> >
> > I don't immediately see the warnings with a more recent m68k compiler (4.6.3),
> > nor with any other target (x86, ppc, arm, mips) in my nightly builds.
> 
> I also don't see it in any of the linux-next builds of v3.6-rc5. So
> probably it's just
> a gcc 4.1.2 issue...
> 
> > Can you send me your configuration ?
> 
> The ide-cd one shows up in any config that enables ide-cd, incl. defconfig and
> allmodconfig.
> The mcp3021 one I only see in allmodconfig.
> 
I tried both and did not see the problem. I agree, it does look like a compiler
version problem.


> > Also, do you know where I can find the Ubuntu/Debian package for your compiler
> > version, by any chance ?
> 
> It's not from an official binary package. I built the cross-compiler
> from the then
> current gcc 4.1.1-21 sources in Ubuntu.
> 
Ok. 

Just in case you are interested, I installed the m68k cross-compiler from
	deb http://www.freewrt.org/~tg/debs68k/ cross main

For my other targets, I use Yocto builds.

I think I'll let this go as false positive for now, unless there are problems
with more recent compilers.

Thanks,
Guenter
