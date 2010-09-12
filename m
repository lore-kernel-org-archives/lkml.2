Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0ILVGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 17:06:17 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57396 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753725Ab0ILVGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 17:06:16 -0400
Date: Sun, 12 Sep 2010 23:06:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100912210607.GE27440@elf.ucw.cz>
References: <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <20100912064612.GA1582@ucw.cz>
 <4C8D13CD.1060802@redhat.com>
 <20100912184843.GB11165@elte.hu>
 <20100912191429.GA27440@elf.ucw.cz>
 <20100912203258.GC16751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912203258.GC16751@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-09-12 22:32:58, Ingo Molnar wrote:
> * Pavel Machek <pavel@ucw.cz> wrote:
> > On Sun 2010-09-12 20:48:43, Ingo Molnar wrote:

> > > > >  1- Most (least abstract) specific code: a block of bytecode in the form
> > > > >     of a simplified, executable, kernel-checked x86 machine code block -
> > > > >     this is also the fastest form. [yes, this is actually possible.]
> > > > >Well... if we want to be a bit x86-entric.... can we just reuse ACPI
> > > > >interpretter?
> > > > 
> > > > I hope this was a joke, ACPI won the academy awards for ugliness, 
> > > > ..., bad specification, non-generality, and 
> > 
> > As did i386 instruction set :-).
> 
> Are you kidding? The i386 instruction set may be ugly, but it's 
> implemented in hardware, which has obvious upsides.

I was partly joking. But you have to admit that i386 set is ugly and
badly specified.

And yes, it is implemented in hardware on _i386_, which, true, has
some advantages on i386.(And what about x86-64, btw? Would same
bytecode run natively in both 32 and 64 bit mode?)

And... we'd have to maintain "is this bytecode safe" checker for i386,
and normal emulator for all other architectures.

> The ACPI AML code is just plain ugly.

Yep, but we already have interpreter in the kernel... How many
interpreters is too many? Does it really matter that AML is "ugly"?

You propose adding checker of similary ugly bytecode, and then
interpreter of the same bytecode.

So... let's drop the "use i386 instructions as bytecode idea", ok?

And now... is maintaining ugly interpreter and non-ugly interpreter
preferable to maintaining just the ugly interpreter? Maybe, if it has
significant speed advantages. But does it? What bytecode do you
propose?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
