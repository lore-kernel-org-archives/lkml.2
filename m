Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2JPDMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 23:12:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51465 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab2JPDMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 23:12:52 -0400
Date: Tue, 16 Oct 2012 12:12:42 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
Message-ID: <20121016031240.GA4804@opensource.wolfsonmicro.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
 <CAFTL4hzLtYZsc_JCVCGW2gWbxp5APgq8P7F-D+76kVOyrTKvRA@mail.gmail.com>
 <1350333581.19292.10.camel@pippen.local.home>
 <201210152134.45672.arnd@arndb.de>
 <CAFTL4hzcJz1GgG8g0=CBy07UAQTYm-_YnWCJD_eEobs4LLLoGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzcJz1GgG8g0=CBy07UAQTYm-_YnWCJD_eEobs4LLLoGA@mail.gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:18:05AM +0200, Frederic Weisbecker wrote:
> 2012/10/15 Arnd Bergmann <arnd@arndb.de>:
> > On Monday 15 October 2012, Steven Rostedt wrote:
> >> On Mon, 2012-10-15 at 22:23 +0200, Frederic Weisbecker wrote:
> >> > 2012/10/15 Steven Rostedt <rostedt@goodmis.org>:
> >> > > On Mon, 2012-10-15 at 17:11 +0100, Catalin Marinas wrote:

> >> > > BTW, is there any rational reason that the include path lookup doesn't
> >> > > just check for the files in include/asm-generic after looking in
> >> > > arch/*/include/asm?

> >> > > Really, the best way would be just to add the default asm files into
> >> > > include/asm-generic and be done with it. I hate the fact that we need to
> >> > > touch every arch for every generic default file.

> >> > Agreed. I'm including Arnd in the conversation.

> >> As David Howells is doing user space header work, I'll include him too.
> >> Maybe someone can shed some light onto this.

I'll just add my vote there, I've *no* idea why asm-generic isn't in the
include path by default, I could never figure out what that was for.

> > A number of people have expressed the wish to do this through Makefile magic, but
> > so far nobody has been able to come up with the right incantation.
> >
> > I've spent a day trying to figure it out, and I think Mark Brown tried some of
> > the same things. It's probably not all that hard for someone who is more familiar
> > with the Kbuild internals.

I came up with stuff for it, though it needed prettyfying.

> This seems to do the trick:

> (It's the diff result of ln -s asm-generic include/asm)

That'd work, but I assume there is some reason why we've got this system
of explicitly adding each file.  It's not like cpp can test for the
presence of include files.  If we can't figure out why we're not doing
this I'd propose we start.
