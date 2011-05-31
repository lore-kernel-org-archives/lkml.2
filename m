Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1EaUZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:25:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab1EaUZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:25:14 -0400
Date: Tue, 31 May 2011 22:24:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH v4 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110531202450.GA28731@elte.hu>
References: <cover.1306851090.git.luto@mit.edu>
 <1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
 <20110531183448.GA27166@one.firstfloor.org>
 <BANLkTinXSDJoT6Uege6zLZqSp87oURfh0w@mail.gmail.com>
 <20110531192833.GA23458@elte.hu>
 <20110531193602.GA26535@elte.hu>
 <BANLkTinQ-y-g_3OKOWwOJ-sWxjJgh_G-=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinQ-y-g_3OKOWwOJ-sWxjJgh_G-=Q@mail.gmail.com>
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> [Sorry, possible resend.]
> 
> On 5/31/11, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> [...] solution that filters the caller RIP at the generic syscall
> >> entry point and checks RCX against the 'expected' SYSCALL
> >> instruction address, which is the (per task) vdso-address +
> >> constant-offset.
> >
> > Note that this solution would allow the vsyscall page to be
> > 'filtered' to the 3 allowed system calls rather efficiently, via a
> > second level check.
> >
> > This second check does not affect the fastpath, and it could be put
> > behind a CONFIG_COMPAT_VSYSCALL deprecation define once glibc does
> > not put vsyscall references anywhere - but we could even keep it
> > around forever, as this way it's defanged permanently.
> >
> 
> Are you thinking about the 32-bit vDSO? I think that 64-bit code puts
> syscalls instructions all over the place.

Yeah, it does in a few dozen places so RCX filtering would only work 
if we 'knew' about glibc's syscall range (it's available from the 
vma) and restricted syscalls to that boundary.

... which makes this solution rather fragile so i think we can 
disregard it.

Thanks,

	Ingo
