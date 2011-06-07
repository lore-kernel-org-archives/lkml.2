Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1FGJ5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:57:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1FGJ5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:57:01 -0400
Date: Tue, 7 Jun 2011 11:56:37 +0200
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
Message-ID: <20110607095637.GE4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED16C1.24309.139B86C7@pageexec.freemail.hu>
 <20110606191218.GB20123@elte.hu>
 <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>
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

> On 6 Jun 2011 at 21:12, Ingo Molnar wrote:
> 
> > * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > >
> > > and whoever enables them, what do you think they're more likely 
> > > to get in return? some random and rare old binaries that still 
> > > run for a minuscule subset of users or every run-of-the-mill 
> > > exploit working against *every* user, metasploit style (did you 
> > > know that it has a specific target for the i386 compat vdso)?
> > 
> > That's what binary compatibility means, yes.
> 
> so fedora is not binary compatible. did just admit that in real 
> life security won out? we're on the right track! ;)

No, you are wrong, and you are really confused about what binary 
compatibility of the kernel means.

The kernel itself will try hard to stay binary compatible, so that if 
someone with older userspace upgrades to a new kernel old user-space 
still works fine.

Fedora was able to disable the fixed-address vdso in its newer 32-bit 
distro kernels because it *upgraded glibc*. It has not disabled that 
option for its older versions with old glibcs. There was no breakage 
of binary compatibility.

So we were able to improve real life security *without* breaking 
binary compatibility.

Do you understand this distinction?

Thanks,

	Ingo
