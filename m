Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0HJHGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:06:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47871 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab0HJHGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:06:09 -0400
Date: Tue, 10 Aug 2010 09:05:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
Message-ID: <20100810070555.GA16638@elte.hu>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
 <87k4o08fv9.fsf@basil.nowhere.org>
 <1281336031.976.11.camel@leonhard>
 <20100809064441.GC29524@basil.fritz.box>
 <1281337485.976.24.camel@leonhard>
 <20100809072226.GD29524@basil.fritz.box>
 <4C604F54.2080506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C604F54.2080506@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/09/2010 12:22 AM, Andi Kleen wrote:
> > On Mon, Aug 09, 2010 at 04:04:45PM +0900, Namhyung Kim wrote:
> >>> It hides the value conversion from the compiler through asm()
> >>>
> >>> -Andi
> >>>
> >>
> >> Yes, indeed. But for what? __pa_symbol() is just used to get the address
> >> of some linker symbols in forms of unsigned long which has same bit
> >> representation as pointer in x86 (and all supported archs). So do we
> >> still need it or am I missing something?
> > 
> > The original reason was that the C standard allows the compiler
> > to make some assumptions on the pointer arithmetic that is done 
> > on symbol addresses (e.g. no wrapping). This is exploited
> > by the optimizer in the compiler to generate better code.
> > 
> > This lead to a miscompilation on PowerPC a couple of years back at 
> > least with the va->pa conversion.
> > 
> > After that RELOC_HIDE was introduced after funelling the
> > symbol address through an empty asm statement was recommended 
> > as the official way to do this by the gcc developers.
> > 
> > I think x86-64 does not normally wrap here, but it's 
> > still safer to do it this way.
> > 
> 
> We pass -fno-strict-overflow to the kernel now, which takes care of the
> underlying problem, at least for current versions of gcc.  Unfortunately
> we still have people who want to use very old gcc versions to compile
> the kernel, so it's probably better to leave it in at least until we
> formally kill off support for gcc 3.

Namhyung, mind sending a patch that adds a comment to __pa_symbol() to point 
out the connection to -fno-strict-overflow and that it can be removed once all 
supported versions of GCC understand -fno-strict-overflow?

That would make for one less piece of legacy voodoo code in the kernel ;-)

Thanks,

	Ingo
