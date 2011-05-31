Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1EaKlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:41:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab1EaKlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:41:21 -0400
Date: Tue, 31 May 2011 12:41:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531104106.GD24172@elte.hu>
References: <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
 <20110531075306.GB20798@elte.hu>
 <1306832148.2029.484.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306832148.2029.484.camel@i7.infradead.org>
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

> On Tue, 2011-05-31 at 09:53 +0200, Ingo Molnar wrote:
> > I'll always prefer typing:
> >   make ARCH=x86_64 ...
> > To:
> >   make ARCH=x86 CONFIG_64BIT=y ...
> 
> Why else would you need to specify ARCH=x86 on the latter command line? 

Note that if we are consistent and implement the logical extension of 
your CONFIG_64BIT 'fix' then we could pick up the target architecture 
from the .config as well and not use the host architecture.

The very same arguments apply: the user provided an ARCH=arm .config, 
why does 'make oldconfig' switch it to x86_64 automatically?

Also, i prefer to type out the architecture due to:

 | [ Btw., 'override the architecture' usecase is not just theoretical:
 |  i sometimes use this form to convert existing .config's *between*
 |  architectures, not just from 32-bit to 64-bit. So if i get an ARM
 |  bugreport that gives me the appearance of a core kernel bug i will
 |  often start by converting that to an x86 .config via 'make
 |  ARCH=x86_64 oldconfig'. ]

But even if we leave out the 'ARCH=x86' portion, which ones are the 
two shortest commands to type, in your opinion:

	make ARCH=i386
	make ARCH=x86_64
	make CONFIG_64BIT=y

?

> You're not building on an x86 box? I always suspected you had some 
> alien technology! Does it run Linux?

Could you please stop with this borderline taunting tone?

You've been wrong so many times in this thread that i think toning 
down some of your shouting in favor of a bit more listening would be 
well advised ...

Thanks,

	Ingo
