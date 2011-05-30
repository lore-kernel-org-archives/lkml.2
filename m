Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1E3KZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:25:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1E3KZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:25:09 -0400
Date: Mon, 30 May 2011 12:25:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530102502.GC17821@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530091536.GA2827@elte.hu>
 <1306747629.2029.397.camel@i7.infradead.org>
 <20110530095333.GA8461@elte.hu>
 <1306750004.2029.413.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306750004.2029.413.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2011-05-30 at 11:53 +0200, Ingo Molnar wrote:
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > > Good point. But shouldn't "make i386_defconfig" and "make
> > > x86_64_defconfig" do that?
> > 
> > Yeah, we could certainly fix (or extend?) kconfig to allow those 
> > forms too, if you would like to use them.
> 
> Those always worked. I actually *broke* it in my previous patch. [...]

Oh, that needs fixing then.

> [...] Before that, the 'i386_defconfig' never actually needed to 
> *specify* that it wanted CONFIG_64BIT=n, [...]

Also arguably 'make i386_defconfig' has 'i386' implicit in its name, 
so from a human workflow logic POV it would be rather silly to 
require it.

> [...] because that would never have been the default. Adding '# 
> CONFIG_64BIT is not set' to arch/x86/configs/i386_defconfig fixes 
> it.
>
> > I personally prefer 'make ARCH=i386 defconfig' and 'make ARCH=x86_64 
> > defconfig' because it's a nice conceptual equivalent to:
> > 
> > 	make ARCH=arm defconfig
> > 	make ARCH=mips defconfig
> 
> No, ARCH= is just for cross-compiling. If you're *on* an ARM or MIPS
> box, you don't need the ARCH= bit.

Still note that 'make ARCH=arm defconfig' will just work fine even 
without cross-building, so i often use just that if i want to see 
what default core kernel options ARM (or MIPS) has enabled these 
days.

> And it *doesn't* follow the pattern you seem to be looking for, 
> because it's *not* setting 32-bit or 64-bit compilation. [...]

Sure it is setting it implicitly: it is defaulting to some of the 
options, lacking any more specific input from the user.

Just like 'ARCH=x86 defconfig' defaults to the i386_defconfig.

> [...] ARM doesn't even *have* 64-bit support, but let's look at 
> MIPS:
> 
> If you want a 64-bit MIPS kernel, you do something like
> 	make bigsur_defconfig 
> 
> If you want a 32-bit MIPS kernel, you do something like
> 	make ar7_defconfig

And if i just want a MIPS defconfig i type 'make ARCH=mips defconfig' 
and get one.

ARCH=i386 and ARCH=x86_64 are two legacy architecture abbreviations 
that are well established, so it makes quite a bit of sense to keep 
those in addition to ARCH=x86. They also happen to work rather 
intuitively both with defconfig and with randconfig.

And note that while i already mentioned how 'randconfig' and 
'defconfig' works with ARCH=i386 and ARCH=x86_64 specifiers, 
'oldconfig' works consistently as well. For example i often switch 
over a 64-bit .config to 32-bit by doing this:

	make ARCH=i386 oldconfig

that's a lot easier to do than to edit the .config. Similarly, i use 
this:

	make ARCH=x86_64 oldconfig

to switch a .config over from 32-bit to 64-bit. Please make sure this 
still works with your patch applied.

Thanks,

	Ingo
