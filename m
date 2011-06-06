Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1FFVyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:54:36 -0400
Received: from r00tworld.com ([212.85.137.150]:38471 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845Ab1FFVyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:54:35 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 06 Jun 2011 23:53:09 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Reply-to: pageexec@freemail.hu
CC: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DED4C45.19293.146C9286@pageexec.freemail.hu>
In-reply-to: <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DED206E.20356.13C155EA@pageexec.freemail.hu>, <BANLkTi=choqfXPYmnivznYBbEFeg2UfbuA@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 23:53:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Jun 2011 at 5:40, Linus Torvalds wrote:

> On Tue, Jun 7, 2011 at 3:46 AM,  <pageexec@freemail.hu> wrote:
> >
> >> I'm happy with perhaps moving away from the fixed-address vdso,
> >
> > it's not about the vdso that has been mmap'ed and randomized for quite some
> > time now. it's about the amd64 specific vsyscall page.
> 
> Duh. What do you think that thing is? It's a special fixed-address
> vdso.

that we call the vsyscall page and not some random vdso thing, they're quite
different, that's why there's this whole patch series, duh.

> What I complain about in the patch series was (specifically) that I
> think the naming sucks and (non-specifically) that the whole series is
> annoying.
> 
> The config name is misleading and pointlessly scary - the whole thing
> is not in itself "unsafe", so calling it that is just wrong.

if it's safe to have the vsyscall page at a fixed address, then you surely
wouldn't object to have its replacement at a fixed address as well, would
you? yes/no? (if it's a 'yes' then you'd better have some non-security
arguments too ;)

> We *definitely* don't want to name it in a way that makes some random
> person just turn it off because it's scary, since the random person
> *shouldn't* turn it off today. Comprende?

actually you confused yourself and got it backwards. we want everyone sane
who cares an iota about security to turn off the legacy/fixed address vsyscall
as soon as possible else it's a pointless exercise. capito?

> If we can replace the vsyscall page with a page fault or int3 or
> whatever, and it's only used for the 'time()' system call, just do it. 

i agree fully, there's no real reason for a config option imho, i never
had one in PaX and noone ever complained let alone noticed it (except
perhaps for failed exploit attempts but that's by design).

