Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1CAKhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 05:37:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab1CAKhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 05:37:15 -0500
Date: Tue, 1 Mar 2011 11:37:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Jeff Dike <jdike@addtoit.com>, heukelum@fastmail.fm, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:x86/asm] x86-64: Add CFI annotations to lib/rwsem_64.S
Message-ID: <20110301103701.GA21453@elte.hu>
References: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
 <tip-39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c@git.kernel.org>
 <20110228182642.GA7041@elte.hu>
 <4D6CBBD502000078000343DF@vpn.id2.novell.com>
 <20110301085630.GA16050@elte.hu>
 <4D6CCC8D020000780003442F@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6CCC8D020000780003442F@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 01.03.11 at 09:56, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Jan Beulich <JBeulich@novell.com> wrote:
> > 
> >> >>> On 28.02.11 at 19:26, Ingo Molnar <mingo@elte.hu> wrote:
> >> 
> >> > * tip-bot for Jan Beulich <JBeulich@novell.com> wrote:
> >> > 
> >> >> Commit-ID:  39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c
> >> >> Gitweb:     
> >> > http://git.kernel.org/tip/39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c 
> >> >> Author:     Jan Beulich <JBeulich@novell.com>
> >> >> AuthorDate: Mon, 28 Feb 2011 15:31:59 +0000
> >> >> Committer:  Ingo Molnar <mingo@elte.hu>
> >> >> CommitDate: Mon, 28 Feb 2011 18:06:21 +0100
> >> >> 
> >> >> x86-64: Add CFI annotations to lib/rwsem_64.S
> >> >> 
> >> >> These weren't part of the initial commit of this code.
> >> >> 
> >> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >> >> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
> >> >> LKML-Reference: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
> >> >> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >> >> ---
> >> >>  arch/x86/lib/rwsem_64.S |   56 ++++++++++++++++++++++++++++------------------
> >> >>  1 files changed, 34 insertions(+), 22 deletions(-)
> >> > 
> >> > this change breaks the UML build:
> >> > 
> >> >  tip/arch/um/sys-x86_64/../../x86/lib/rwsem_64.S:46: Error: no such 
> >> > instruction: `pushq_cfi %rdi'
> >> 
> >> Any reason why arch/um/Kconfig.x86 has X86_32 but not
> >> X86_64? That's resulting in asm/dwarf2.h producing the 32-bit
> >> (pushl_cfi & Co) macros instead of the 64-bit ones. And I
> >> wonder what other inconsistencies this may cause...
> > 
> > No idea - UML seems stale. I've Cc:-ed Jeff Dike just in case.
> > 
> >> If this is on purpose (i.e. simply adding X86_64 as a new config
> >> option there isn't the right solution), what would be the preferred
> >> way of fixing this in asm/dwarf2.h:
> >> - #ifndef CONFIG_X86_32,
> >> - #ifdef CONFIG_64BIT,
> >> - yet something else?
> > 
> > You could try it out - UML isnt that hard to build: "make ARCH=um" and then 
> > run the 
> > resulting binary. It will produce bootup messages then fails when mounting 
> > root. 
> > That's enough of a build & functionality test.
> 
> That wasn't my question. What I wanted to know was, if adding
> X86_64 to UML's Kconfig.x86 isn't acceptable for some reason,
> whether any of the possible alternative forms would be preferred
> (all of them should work).

It's probably fine as long as you test a basic UML build+boot sequence. (I described 
how to do that)

> Anyway, I'll wait for Jeff's response on whether adjusting the
> UML file is going to be acceptable.

Please submit the proposed fix so that we can unbreak x86/asm ASAP. If there's a 
better solution suggested by Jeff or others we can still do that as well.

> Will you want a re-submission or an incremental fix?

Incremental fix would be nice.

Thanks,

	Ingo
