Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab1EaNor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:44:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:38739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1EaNoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:44:46 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Date: Tue, 31 May 2011 14:44:34 +0100
In-Reply-To: <20110531124537.GA10249@elte.hu>
References: <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <20110531075306.GB20798@elte.hu>
	 <1306832148.2029.484.camel@i7.infradead.org>
	 <20110531104106.GD24172@elte.hu>
	 <1306842211.2029.531.camel@i7.infradead.org>
	 <20110531124537.GA10249@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1306849477.2029.570.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 14:45 +0200, Ingo Molnar wrote:
> * David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > > Also, i prefer to type out the architecture due to:
> > >  |                                              ...So if i get an ARM
> > >  |  bugreport that gives me the appearance of a core kernel bug i will
> > >  |  often start by converting that to an x86 .config via 'make
> > >  |  ARCH=x86_64 oldconfig'. ]
> > 
> > So first you point out that it's automatic, and then you still specify
> > it manually?
> 
> Currently it's not automatic so i prefer to type it out.

No, you were right the first time. It *is* automatic.

If you take an ARM config and on your x86 box you 'make oldconfig', it
*will* be converted. There's absolutely no need to set ARCH= on the
command line.

> > > Could you please stop with this borderline taunting tone?
> > >
> > > You've been wrong so many times in this thread that i think 
> > > toning down some of your shouting in favor of a bit more 
> > > listening would be well advised ...
> > 
> > No, Ingo. I haven't been wrong. [...]
> 
> Of course you've been wrong more than once - and you are now forcing 
> me to count them.
> 
> Lets start with your very first mail:
> 
>   Message-ID: <1306707270.2029.377.camel@i7.infradead.org>
> 
>     "Ingo's objection that he didn't actually want 'make 
>      randconfig' to give him a random config"
> 
> You now know that your claim was wrong, right? :)

Absolutely not. To quote your reply:

  "...the problem with your patch was that your patch actually *broke*
   existing filtered-randconfig behavior, for example trying to get a
   64-bit randconfig:
  "make ARCH=x86_64 randconfig
  "... will today produce a 64-bit randconfig while with your old  change 
   applied it produced a 32-bit randconfig 50% of the time."

In the above quote, you *are* objecting that the value of CONFIG_64BIT
in the resulting config is *random*. You *are* objecting that it made
'randconfig' actually random.

We have $KCONFIG_ALLCONFIG/allrandom.conf/all.config which allow you to
override *various* settings in 'randconfig' so that they aren't
randomised, but you either weren't aware of that or you didn't want to
use it for some reason. I wasn't aware of it at the time either, so
didn't point it out to you.

>    " I still maintain that if you actually want a non-random 
>      'randconfig', perhaps because you want it to be bootable on 
>      certain test machines, then you're going to need to hard-code a 
>      whole lot more than *one* config option — and you'd be better 
>      off coming up with a proper mechanism to do *that* instead of 
>      preserving the old 'ARCH=i386' and 'ARCH=x86_64' as a dirty hack 
>      to achieve it only for the CONFIG_X86_32 option. "
> 
> Here you clearly didn't know about KCONFIG_CONFIG, so you incorrectly 
> delegated ARCH=i386 / ARCH=x86_64 to a 'dirty hack'.

You have done nothing to show that using ARCH=i386/ARCH=x86_64 to
override the value of CONFIG_64BIT should not be considered a 'dirty
hack'.

I've provided a clean, generic way to set config symbols from the
command line, and now it is just just a dirty hack but an *obsolete*
dirty hack.

I'm not sure how KCONFIG_CONFIG relates to that. Even if you mean
KCONFIG_ALLCONFIG, that just means that there was *already* a clean and
generic way to do it, so you're calling me wrong because I should
actually have said:

  "We *already* have a proper mechanism to do that instead of preserving
  the old 'ARCH=i386' and 'ARCH=x86_64' as a dirty hack..."

?

>    Message-ID: <1306745835.2029.389.camel@i7.infradead.org>
> 
>     "I believe that this 'filtered randconfig' behaviour is now fairly much
>      the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'."
> 
> You are wrong again - it isnt, as me and others pointed it out.

Not *so* wrong that all those other use cases couldn't be addressed in
the same, simple patch to allow CONFIG_FOO on the 'make' command line.

But yes, I agree that there were other ways in which people wanted to
override CONFIG_64BIT on the command line, that I did not list.

Some of them were even not covered by the existing KCONFIG_ALLCONFIG
facility.

>     " Other than that, we ought to finally be able to 'complete' the 
>       merge of 32-bit and 64-bit support into ARCH=x86, and remove 
>       the last traces of the obsolete ARCH={i386,x86_64} settings 
>       completely? "
> 
> And you are wrong again - many people rely on it and it's useful so 
> it's not "obsolete".

I strongly suspect that most people who set ARCH=i386 and ARCH=x86_64 on
the command line are only doing so to work around the original bug that
I set out to fix, where a simple 'make' would ignore your setting of
CONFIG_64BIT in the existing .config, and override it to match the build
host.

The arch/i386 and arch/x86_64 directories are dead; the ARCH= settings
to match them are obsolete — especially now that we have a cleaner way
for people to override the setting of CONFIG_64BIT on the command line.

>     " And as I said, it's still an incomplete solution if you 
>       actually want a 'filtered randconfig' to do anything *useful*. 
>     "
> 
> Wrong again: you miss KCONFIG_CONFIG.

I do think you mean KCONFIG_ALLCONFIG? So in this case you're saying I'm
wrong because I should have called the ARCH=x86_64 hack an incomplete
*and* *redundant* solution, rather than just 'incomplete'?

>    Message-ID: <1306750004.2029.413.camel@i7.infradead.org>
> 
>    " No, ARCH= is just for cross-compiling. If you're *on* an ARM or
>      MIPS box, you don't need the ARCH= bit. "
> 
> That's wrong again: ARCH= can be used to just extract a config 
> variant of an architecture (with no intention to cross-build - this 
> will even work without *any* crosscompilers installed),

Now you're just being silly. Yes, I was lazy and said 'cross-compiling'
when I could have said "cross-compiling or cross-configuring or
cross-header-installing or cross-module-installing or cross-linking
or ....". But the point I was making was exactly the same.


So yes, I was slightly wrong once when I underestimated the amount of
'valid' uses there still were for using 'ARCH=i386' or 'ARCH=x86_64' on
the command line. But as I said, not so wrong that we couldn't satisfy
*all* those with the same simple patch.

-- 
dwmw2

