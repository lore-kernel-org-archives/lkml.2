Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1FFMiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:38:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39093 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1FFMiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:38:12 -0400
Date: Mon, 6 Jun 2011 14:37:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to
 COMPAT_VSYSCALLS
Message-ID: <20110606123738.GA22375@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
 <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
 <20110606102419.GA837@elte.hu>
 <20110606121937.GI7180@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606121937.GI7180@thunk.org>
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


* Ted Ts'o <tytso@mit.edu> wrote:

> On Mon, Jun 06, 2011 at 12:24:19PM +0200, Ingo Molnar wrote:
> >  
> > -What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
> > +What:	CONFIG_COMPAT_VSYSCALLS (x86_64)
> >  When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
> > -Why:	Having user-executable code at a fixed address is a security problem.
> > -	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
> > +Why:	Having user-executable syscall invoking code at a fixed addresses makes
> > +	it easier for attackers to exploit security holes.
> > +	Turning off CONFIG_COMPAT_VSYSCALLS mostly removes the risk but will
> >  	make the time() function slower on glibc versions 2.13 and below.
> >  Who:	Andy Lutomirski <luto@mit.edu>
> 
> I'd suggest 2013 or 2014, at least.  People using Ubuntu LTS and 
> RHEL 6 are stuck back at glibc 2.11, and many of those users do 
> like being able to upgrade to newer kernels.  And there are 
> probably are a large number of static binaries around.
> 
> Maybe in 2012 or so we change the to be 'no' (and I'd suggest 
> adding a comment in the feature-removal-schedule.txt file that this 
> will also break static binaries).

There is no breakage of binaries at all, just a small slowdown for 
time() calls - but even that is fixable via a simple, backportable 
few-liner glibc patch.

Thanks,

	Ingo
