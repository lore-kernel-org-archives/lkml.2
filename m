Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1EaMpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:45:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1EaMpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:45:53 -0400
Date: Tue, 31 May 2011 14:45:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531124537.GA10249@elte.hu>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306842211.2029.531.camel@i7.infradead.org>
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

> > Also, i prefer to type out the architecture due to:
> >  |                                              ...So if i get an ARM
> >  |  bugreport that gives me the appearance of a core kernel bug i will
> >  |  often start by converting that to an x86 .config via 'make
> >  |  ARCH=x86_64 oldconfig'. ]
> 
> So first you point out that it's automatic, and then you still specify
> it manually?

Currently it's not automatic so i prefer to type it out.

> > Could you please stop with this borderline taunting tone?
> >
> > You've been wrong so many times in this thread that i think 
> > toning down some of your shouting in favor of a bit more 
> > listening would be well advised ...
> 
> No, Ingo. I haven't been wrong. [...]

Of course you've been wrong more than once - and you are now forcing 
me to count them.

Lets start with your very first mail:

  Message-ID: <1306707270.2029.377.camel@i7.infradead.org>

    "Ingo's objection that he didn't actually want 'make 
     randconfig' to give him a random config"

You now know that your claim was wrong, right? :)

   " I still maintain that if you actually want a non-random 
     'randconfig', perhaps because you want it to be bootable on 
     certain test machines, then you're going to need to hard-code a 
     whole lot more than *one* config option — and you'd be better 
     off coming up with a proper mechanism to do *that* instead of 
     preserving the old 'ARCH=i386' and 'ARCH=x86_64' as a dirty hack 
     to achieve it only for the CONFIG_X86_32 option. "

Here you clearly didn't know about KCONFIG_CONFIG, so you incorrectly 
delegated ARCH=i386 / ARCH=x86_64 to a 'dirty hack'.

   Message-ID: <1306745835.2029.389.camel@i7.infradead.org>

    "I believe that this 'filtered randconfig' behaviour is now fairly much
     the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'."

You are wrong again - it isnt, as me and others pointed it out.

    " Other than that, we ought to finally be able to 'complete' the 
      merge of 32-bit and 64-bit support into ARCH=x86, and remove 
      the last traces of the obsolete ARCH={i386,x86_64} settings 
      completely? "

And you are wrong again - many people rely on it and it's useful so 
it's not "obsolete".

    " And as I said, it's still an incomplete solution if you 
      actually want a 'filtered randconfig' to do anything *useful*. 
    "

Wrong again: you miss KCONFIG_CONFIG.

   Message-ID: <1306750004.2029.413.camel@i7.infradead.org>

   " No, ARCH= is just for cross-compiling. If you're *on* an ARM or
     MIPS box, you don't need the ARCH= bit. "

That's wrong again: ARCH= can be used to just extract a config 
variant of an architecture (with no intention to cross-build - this 
will even work without *any* crosscompilers installed), *and* it can 
also be used for consistency if you use mixed environments where you 
might not necessarily always be aware of exactly which box you are 
on.

etc. etc.

How many times do you need to be proven wrong before you admit having 
been at least slightly wrong, hm?

Thanks,

	Ingo
