Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab1FFUlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:41:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab1FFUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <4DED206E.20356.13C155EA@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu> <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
 <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com> <4DED206E.20356.13C155EA@pageexec.freemail.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Jun 2011 05:40:18 +0900
Message-ID: <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
To: pageexec@freemail.hu
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 3:46 AM,  <pageexec@freemail.hu> wrote:
>
>> I'm happy with perhaps moving away from the fixed-address vdso,
>
> it's not about the vdso that has been mmap'ed and randomized for quite some
> time now. it's about the amd64 specific vsyscall page.

Duh. What do you think that thing is? It's a special fixed-address
vdso. Stop the whole jumping from issue to issue and making up random
irrelevant arguments. First it was you jumping up and down about
"covering up security issues", now you start instead complaining about
some random word choice. Stop it.

What I complain about in the patch series was (specifically) that I
think the naming sucks and (non-specifically) that the whole series is
annoying.

The config name is misleading and pointlessly scary - the whole thing
is not in itself "unsafe", so calling it that is just wrong. If we
want to make it a legacy option that you can turn off (which sounds
sane in itself), then name it that way. But if so, the name and
explanation should be that it's about legacy stuff and that you can
only do so once it's no longer used. Not "UNSAFE", which it isn't.

We *definitely* don't want to name it in a way that makes some random
person just turn it off because it's scary, since the random person
*shouldn't* turn it off today. Comprende?

And the annoying part about the whole patch series is how the whole
re-sending has gone on forever. Just pick some approach, do it, and
don't even bother making it a config option for now. If we can replace
the vsyscall page with a page fault or int3 or whatever, and it's only
used for the 'time()' system call, just do it.

The series is now extended with the cleanup patches so the end result
looks reasonable, but why have the whole "first implement it, then
clean it up" and sending it as a whole series. That's annoying. Just
send the cleaned-up end result to begin with.

                     Linus

PS. The reason you don't see direct replies seems to be this from gmail:

     ----- The following addresses had permanent fatal errors -----
    <pageexec@freemail.hu>
       (reason: 553 sorry, that domain isn't in my list of allowed
rcpthosts (#5.7.1))

which is probably because some spamming or other bad behavior from
within the same domain.
