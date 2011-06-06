Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab1FFVqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:46:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55555 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1FFVqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:46:18 -0400
Date: Mon, 6 Jun 2011 23:45:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pageexec@freemail.hu, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110606214545.GA6492@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
 <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com>
 <4DED206E.20356.13C155EA@pageexec.freemail.hu>
 <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> We *definitely* don't want to name it in a way that makes some 
> random person just turn it off because it's scary, since the random 
> person *shouldn't* turn it off today. Comprende?

Agreed, and that's fixed now.

> And the annoying part about the whole patch series is how the whole 
> re-sending has gone on forever. Just pick some approach, do it, and 
> don't even bother making it a config option for now. If we can 
> replace the vsyscall page with a page fault or int3 or whatever, 
> and it's only used for the 'time()' system call, just do it.

Ok, we can certainly remove CONFIG_LEGACY_VTIME - that would further 
simplify things!

I was unsure how big of a problem the time() slowdown was and the 
config option was easy enough to provide. My preference would be to 
just remove the config option and simplify the code - complexity is 
the #1 enemy of security.

> The series is now extended with the cleanup patches so the end 
> result looks reasonable, but why have the whole "first implement 
> it, then clean it up" and sending it as a whole series. That's 
> annoying. Just send the cleaned-up end result to begin with.

Do you think x86/vdso is worth rebasing at this stage? Right now it 
has:

 feba7e97df8c: x86-64: Rename COMPAT_VSYSCALLS to LEGACY_VTIME and clarify documentation
 7dc0452808b7: x86-64: Clean up vsyscall emulation and remove fixed-address ret
 8d6316596441: x86-64: Fix outdated comments in vsyscall_64.c
 1593843e2ada: x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
 764611c8dfb5: x86-64, vdso, seccomp: Fix !CONFIG_SECCOMP build
 38172403a978: x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
 d55ed1d30b82: x86-64: Emulate legacy vsyscalls
 5dfcea629a08: x86-64: Fill unused parts of the vsyscall page with 0xcc
 bb5fe2f78ead: x86-64: Remove vsyscall number 3 (venosys)
 d319bb79afa4: x86-64: Map the HPET NX
 0d7b8547fb67: x86-64: Remove kernel.vsyscall64 sysctl
 9fd67b4ed071: x86-64: Give vvars their own page
 8b4777a4b50c: x86-64: Document some of entry_64.S
 6879eb2deed7: x86-64: Fix alignment of jiffies variable

it's reasonably tested by now. We'd keep about 80% of the commits 
after the rebase.

Thanks,

	Ingo
