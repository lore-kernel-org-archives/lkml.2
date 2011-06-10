Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab1FJLUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:20:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45595 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab1FJLUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:20:03 -0400
Date: Fri, 10 Jun 2011 13:19:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110610111932.GA30987@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED7222.28864.150079CE@pageexec.freemail.hu>
 <20110607095135.GD4133@elte.hu>
 <4DEEB31B.24457.19E64984@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEEB31B.24457.19E64984@pageexec.freemail.hu>
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

> let me tell you now a real distadvantage of your coverup: [...]

Our opinion is that the scheme you are suggesting is flawed and 
reduces security, so we refuse to use it. That is not a 'coverup', to 
the contrary, it *helps* security - see below.

> [...] you're hurting the good guys (the defenders) a lot more than 
> you're hurting the bad guys (the attackers). why? because of the 
> usual asymmetry of the situation we often face in security. an 
> attacker needs to find only a single commit silently fixing a 
> security bug (never mind finding the earlier commit that introduced 
> it) whereas the defenders would have to find all of them.
> 
> thanks to your policy you can guess which side has a distinct 
> advantage from the start and how well the other side fares.

Firstly, the assymetry is fundamental: attackers *always* have an 
easier way destroying stuff than the good guys are at building new 
things. This is the second law of thermodynamics.

Secondly, you are missing one fundamental aspect: the 'good guys' are 
not just the 'defenders'. The good guys are a *much* broader group of 
people: the 'bug fixers'.

Thirdly, you never replied in substance to our arguments that CVE 
numbers are woefully inadequate: they miss the majority of bugs that 
can have a security impact. In fact i argue that the way software is 
written and fixed today it's not possible to effectively map out 
'bugs with a security impact' at all: pretty much *any* bug that 
modifies the kernel image can have a security impact. Bug fixers are 
not at all concentrated on thinking like parasitic attackers, so 
security side effects often remain undiscovered. Why pretend we have 
a list of CVEs when we know that it's only fake?

Fourth, exactly how does putting CVE numbers make it harder for 
attackers? It makes it distinctly *easier*: people will update their 
systems based on a list of say 10 CVEs that affect them, totally 
blind to the 100+ other bugs that may (or may not) have an effect on 
them. An attacker will now only have to find an *already fixed* bug 
that has a security impact and which didn't get a CVE and attack a 
large body of systems that people think are safe.

With the current upstream kernel policy we do not deceive users: we 
say that the way to be most secure is to be uptodate. Attackers will 
have to find an entirely new, not yet fixed security hole, instead of 
just a bug that missed the CVE filter ...

I.e. our opinion is, on very good and honest grounds, that your 
scheme creates a false sense of security and actually harms real 
security and we simply refuse to support such a scheme.

Thanks,

	Ingo
