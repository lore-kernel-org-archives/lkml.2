Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2JPPkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:40:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57907 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab2JPPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:40:11 -0400
Date: Tue, 16 Oct 2012 16:40:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise()
	declaration/default definition to arch headers
Message-ID: <20121016154009.GA2260@opensource.wolfsonmicro.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com> <CAFTL4hzcJz1GgG8g0=CBy07UAQTYm-_YnWCJD_eEobs4LLLoGA@mail.gmail.com> <20121016031240.GA4804@opensource.wolfsonmicro.com> <201210160925.11891.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210160925.11891.arnd@arndb.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:25:11AM +0000, Arnd Bergmann wrote:
> On Tuesday 16 October 2012, Mark Brown wrote:

> > That'd work, but I assume there is some reason why we've got this system
> > of explicitly adding each file.  It's not like cpp can test for the
> > presence of include files.  If we can't figure out why we're not doing
> > this I'd propose we start.

> We discussed renaming asm-generic to asm before, but some people objected
> to the use of #include_next. There is a smaller problem with opening the
> asm/*.h namespace to header files that are not relevant for architctures,
> so I'd prefer to have a well-defined list of headers that are implicitly
> shared, but it's not a technical argument.

Perhaps what we need here is a more elegantly named
asm-default-implementation which is for the headers which almost every
architecture should be using (like clk and gpio) since the APIs should
be at least stubbed in order to avoid making the architecture terminally
annoying.

Alternatively we go to the gpiolib approach where I just made
architectures that want to do fun stuff select a Kconfig symbol and
otherwise the default is directly in the linux/ header.  This was
massively easier to deploy all round.

The case where the current situation is really annoying is the case
where we want to allow some sort of performance optimisation in
something that's normally there and probably doesn't need it; right now
the cost is on the API users to convince every single architecture
maintainer to adopt the API.
