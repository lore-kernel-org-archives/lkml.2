Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1FFKko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:40:44 -0400
Received: from r00tworld.com ([212.85.137.150]:41543 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab1FFKkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:40:42 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Mon, 06 Jun 2011 12:39:36 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Reply-to: pageexec@freemail.hu
CC: Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
In-reply-to: <20110606093102.GW27166@one.firstfloor.org>
References: <cover.1307292171.git.luto@mit.edu>, <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>, <20110606093102.GW27166@one.firstfloor.org>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 12:40:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 11:31, Andi Kleen wrote:

> On Mon, Jun 06, 2011 at 05:46:41PM +0900, Linus Torvalds wrote:
> > On Mon, Jun 6, 2011 at 2:50 AM, Andy Lutomirski <luto@mit.edu> wrote:
> > > CONFIG_UNSAFE_VSYSCALLS was added in the previous patch as a
> > > temporary hack to avoid penalizing users who don't build glibc from
> > > git.

[didn't get your mail directly (yet?), so i'm replying here]

> > I really hate that name.
> > 
> > Do you have *any* reason to call this "unsafe"?

any userland executable code at a universally (read: across any and all 2.6+ linux
boxes) fixed address is not secure (no really, it's worse, it's simply insane design,
there's a reason the vdso got randomized eventually), it's the prime vehicle used by
both reliable userland and kernel exploits who need to execute syscalls and/or pop
the stack until something useful is reached, etc. not to mention the generic snippets
of both code and data (marketing word: ROP) that one may find in there.

> > Seriously. The whole patch series just seems annoying.

what is annoying is your covering up of security fixes on grounds that you don't want
to help script kiddies (a bullshit argument as it were) but at the same time question
proactive security measures (one can debate the implementation, see my other mail) that
would *actually* prevent the same kiddies from writing textbook exploits.

but hey, spouting security to journalists works so much better for marketing, doesn't it.

> and assumes everyone is using glibc which is just wrong.

the libc is irrelevant, they can all be fixed up to use the vdso entry points if they
haven't been doing it already. already deployed systems will simply continue to use
their flawed kernel and libc, they're not affected.

