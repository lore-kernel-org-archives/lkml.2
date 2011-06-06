Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1FFMsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:48:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49338 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab1FFMsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:48:09 -0400
Date: Mon, 6 Jun 2011 14:47:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to
 COMPAT_VSYSCALLS
Message-ID: <20110606124743.GB22375@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>
 <20110606102419.GA837@elte.hu>
 <4DECB7E8.5549.12290923@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECB7E8.5549.12290923@pageexec.freemail.hu>
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 6 Jun 2011 at 12:24, Ingo Molnar wrote:
> 
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Mon, Jun 6, 2011 at 2:50 AM, Andy Lutomirski <luto@mit.edu> wrote:
> > > > CONFIG_UNSAFE_VSYSCALLS was added in the previous patch as a
> > > > temporary hack to avoid penalizing users who don't build glibc from
> > > > git.
> > > 
> > > I really hate that name.
> > > 
> > > Do you have *any* reason to call this "unsafe"?
> > 
> > No, there's no reason at all for that. That naming is borderline 
> > security FUD and last time i saw the series i considered renaming
> > it but got distracted :-)
> 
> security FUD? for real? ;) [...]

'Borderline' security FUD! :-)

> [...] does that mean that you guys would accept a patch that would 
> map the vdso at a fixed address for old times's sake? if not, on 
> what grounds would you refuse it? see, you can't have it both ways.

You can actually do that by enabling CONFIG_COMPAT_VDSO=y.

> the fixed address of the vsyscall page *is* a very real security 
> problem, it should have never been accepted as such and it's high 
> time it went away finally in 2011AD.

It's only a security problem if there's a security hole elsewhere.

The thing is, and i'm not sure whether you realize or recognize it, 
but these measures *are* two-edged swords.

Yes, the upside is that they reduce the risks associated with 
security holes - but only statistically so.

The downside is that having such a measure in place makes it somewhat 
less likely that those bugs will be found and fixed in the future: if 
a bug is not exploitable then people like Spender wont spend time 
exploiting and making a big deal out of them, right?

And yes, it might be embarrasing to see easy exploits and we might 
roll eyes at the associated self-promotion circus but it will be one 
more bug found, the reasons for the bug will be examined, potentially 
avoiding a whole class of similar bugs *for sure*.

Can you guarantee that security bugs will be found and fixed with the 
same kind of intensity even if we make their exploitation (much) 
harder? I don't think you can make such a guarantee.

So as long as we are trading bugs-fixed-for-sure against statistical 
safety we have to be mindful of the downsides of such a tradeoff ...

Thanks,

	Ingo
