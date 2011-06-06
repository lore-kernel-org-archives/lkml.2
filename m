Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1FFPmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:42:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab1FFPmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:42:10 -0400
Date: Mon, 6 Jun 2011 17:41:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110606154146.GM30348@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <20110605193001.GB3971@elte.hu>
 <BANLkTikQB6=Te6=E7DRmeD5+G4TESuy--w@mail.gmail.com>
 <4DECA101.5994.11CF924E@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECA101.5994.11CF924E@pageexec.freemail.hu>
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

> > I can't see any problem, but exploit writers are exceedingly 
> > clever, and maybe someone has a use for a piece of the code that 
> > isn't a syscall.  Just as a completely artificial example, here's 
> > some buggy code:
> 
> what you're describing here is a classical ret2libc (in modern 
> marketing speak, ROP) attack. in general, having an executable ret 
> insn (with an optional pop even) at a fixed address is very useful, 
> especially for the all too classical case of stack overflows where 
> the attacker may already know of a 'good' function pointer 
> somewhere on the stack but in order to have the cpu reach it, he 
> needs to pop enough bytes off of it. guess what they'll use this 
> ret at a fixed address for...

Good point and i agree that we should get rid of the RETQ there. The 
do_intcc() code can fetch the return address without much fuss - this 
is much faster than doing a #PF.

Please keep reviewing these patches, the security-technical aspects 
of your reviews are extremely useful.

> imho, moving everything to and executing from the vdso page is the 
> only viable solution if you really want to fix the security aspect 
> of the vsyscall mess. it's worked fine for PaX for years now ;).

FYI, this probably means that no-one ever benchmared postgresql 
scalability on a PaX kernel i suspect? Past versions of postgresql 
would big time if you drive the vsyscall time() through through a
#PF ...

Thanks,

	Ingo
