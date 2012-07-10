Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2GJHKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:10:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47326 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2GJHK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:10:28 -0400
Date: Tue, 10 Jul 2012 09:10:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710071023.GA10456@gmail.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201207071927.13135.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 07 July 2012, Olof Johansson wrote:
> 
> > > ARM introduced AArch64 as part of the ARMv8 architecture
> > 
> > With the risk of bikeshedding here, but I find the name awkward. How
> > about just naming the arch port arm64 instead? It's considerably more
> > descriptive in the context of the kernel.  For reference, we didn't
> > name ppc64, nor powerpc, after what the IBM/power.org marketing people
> > were currently calling the architecture at the time either.
> 
> I agree the name sucks, [...]

So why not change it now, when it only bothers a few dozen 
people and it is only present in 36 patches? Why go full steam 
ahead to annoy thousands of people with it and why spread the 
naming madness to thousands of commits?

> [...] and I'd much prefer to just call it arm64 as well.

Then do it! :-)

arch/aarch64/ is a heck of a toungue twister, it's double typing 
all over the place and if everyone calls it arm64 anyway I'd 
suggest you change the code, not people!

> [...] The main advantage of the aarch64 name is that it's the 
> same as the identifier in the elf triplet, and it makes sense 
> to keep the same name for all places where we need to identify 
> the architecture. [...]

Doesn't really matter in practice: we have arch/x86/ which isnt 
the elf triplet either, and besides some minimal kbuild glue 
it's not an issue, and having a good short name matters quite a 
bit when trying to write good kernel code.

Wouldn't be the first time the GNU toolchain embarked on silly, 
user-hostile naming. i386-unknown-Linux, anyone?

So there's no valid technical reason there that I can see.

> [...] This also includes the rpm and dpkg architecture names, 
> and the string returned by the uname syscall. If everything 
> else is aarch64, we should use that in the kernel directory 
> too, but if everyone calls it arm64 anyway, we should probably 
> use that name for as many things as possible.

Yeah.

> > I guess it's a good chance to clean up some of it and start 
> > from a clean slate, if you can avoid the temptation of just 
> > moving over code.
> 
> Agreed. It's clear from the code that it started out as a copy 
> of the 32 bit ARM code base, which I think was a mistake, but 
> it has also moved on since then and many areas of the 64 bit 
> code are now much cleaner because they don't have to worry 
> about breaking legacy code. We're also more flexible with 
> trying out stuff without having to worry about breaking some 
> 10 year old board code.

Just for the record, you guys are repeating all the same 
arguments that led to the x86_64 fork a decade ago...

With the difference that the case for unifying platforms seems 
even *stronger* in the ARM space than it is in the x86 space: 
32-bit computing will probably stay around with us far longer in 
the gadget and appliance space than in the server space. 
Thinking that arm64 will only be limited to servers is rather 
short-sighted, IMO.

It all reminds me of what Sir John Templeton said: “The four 
most dangerous words in investing are, it’s different this 
time.”

Thanks,

	Ingo
