Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2B1JGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:06:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875Ab2B1JGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:06:49 -0500
Date: Tue, 28 Feb 2012 10:06:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.3] x86: Fix up CFI for the nested NMI
Message-ID: <20120228090638.GL21106@elte.hu>
References: <20120225173548.977089274@goodmis.org>
 <20120227073905.GB3397@elte.hu>
 <1330349016.25686.185.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330349016.25686.185.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hi Ingo,
> 
> On Mon, 2012-02-27 at 08:39 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > Ingo,
> > > 
> > > Jan posted a patch that fixes the CFI annotations. I recommend getting
> > > this into 3.3 as this is new code and it would be nice to have CFI
> > > correct. It also does a little simplification of it as well.
> > > 
> > > The second patch is comment changes only (very low impact on messing
> > > anything up). I realized that the comments had some references to
> > > previous approaches that I tried, and I fixed them to reflect what
> > > the final result was. I also added some more comments to describe
> > > the code a bit better.
> > > 
> > > Thanks,
> > > 
> > > -- Steve
> > > 
> > > Please pull the latest tip/x86/urgent tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > > tip/x86/urgent
> > > 
> > > Head SHA1: 79fb4ad63e8266ffac1f69bbb45a6f86570493e7
> > > 
> > > 
> > > Jan Beulich (1):
> > >       x86-64: Fix CFI annotations for NMI nesting code
> > > 
> > > Steven Rostedt (1):
> > >       x86: Fix the NMI nesting comments
> > > 
> > > ----
> > >  arch/x86/kernel/entry_64.S |   64 ++++++++++++++++++++++++--------------------
> > >  1 files changed, 35 insertions(+), 29 deletions(-)
> > 
> > I don't think we want a 30+ lines diffstat to this rather 
> 
> Some of that was just movement of code.

That's why I said 30+ lines, not 60.

> > non-trivial NMI codepath - and it changes real instructions, 
> > not just the CFI annotations.
> 
> The changes to the real code made the CFI code easier to fix. 
> But if you are nervous about the code change (which actually 
> simplifies the code), I can ask Jan (Cc'd) to break out the 
> patch into two changes if possible.
> 
> I'm not sure how the CFI can handle the current trampoline, 
> but perhaps we can just fix the main part of the code and 
> leave the trampoline part broken? Then we can add the rest of 
> the CFI changes and the movement of the trampoline back into 
> the function for the next release.
> 
> > 
> > Also, the 'update comments' commit does not belong into 
> > x86/urgent either.
> 
> Hmm, I didn't know that fixing comments was for a merge window 
> only. [...]

We try to avoid them for later -rc's, and we are now in -rc5 
territory already.

> [...] Some of the comments are currently wrong and I didn't 
> think we would want those in a main release. While reading the 
> code again I realized that I could also add more comments to 
> make it easier to understand. I would think that comments 
> would be fine for the -rc releases because they have almost no 
> chance of introducing bugs.

By that argument we could be doing mechanic API renames in later 
-rc's as well.

In general we don't want "noise" around the really relevant 
changes to make them *really* obvious regression fixes - even if 
this noise is obviously correct code.

This is also code that *everyone* uses so if it breaks then 
everyone suffers (and seeing people suffer, even hypothetically, 
makes me sad), so the maintenance filter is quite a bit 
stricter. I wouldn't worry nearly as much about 
drivers/some/obscure/piece/of/hw.c.

> > So either you do an obviously trivial patch that only adds 
> > CFI annotations and nothing else, or I can pull these bits 
> > into tip:x86/debug, for a v3.4 merge.
> 
> I'm fine with waiting for v3.4 before these changes get in.

Jan, is that fine with you?

Thanks,

	Ingo
