Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1JJHbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:31:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1JJHbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:31:23 -0400
Date: Mon, 10 Oct 2011 09:29:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20111010072946.GA29035@elte.hu>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
 <20110930150519.GA7980@leaf>
 <20110930155012.GC9049@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930155012.GC9049@localhost.pp.htv.fi>
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

* Adrian Bunk <bunk@stusta.de> wrote:

> On Fri, Sep 30, 2011 at 08:05:19AM -0700, Josh Triplett wrote:
> > On Fri, Sep 30, 2011 at 04:42:45PM +0300, Adrian Bunk wrote:
> >...
> > > Let me point at the obvious fact that both CONFIG_DEBUG_BUGVERBOSE and 
> > > CONFIG_DEBUG_RODATA do depend on DEBUG_KERNEL, and are contrary to the 
> > > claim of the author of this patch never enabled with 
> > > CONFIG_DEBUG_KERNEL=n. [1]
> > 
> > Not true:
> > 
> > ~/src/linux-2.6$ rm .config
> > ~/src/linux-2.6$ make allnoconfig
> >   HOSTCC  scripts/basic/fixdep
> >   HOSTCC  scripts/kconfig/conf.o
> >   HOSTCC  scripts/kconfig/zconf.tab.o
> >   HOSTLD  scripts/kconfig/conf
> > scripts/kconfig/conf --allnoconfig Kconfig
> > #
> > # configuration written to .config
> > #
> > ~/src/linux-2.6$ grep BUGVERBOSE .config
> > CONFIG_DEBUG_BUGVERBOSE=y
> > ~/src/linux-2.6$ grep DEBUG_KERNEL .config
> > # CONFIG_DEBUG_KERNEL is not set
> > 
> > DEBUG_BUGVERBOSE does not depend on DEBUG_KERNEL; it just only shows up
> > with DEBUG_KERNEL (and EXPERT) set.  The *description* has a conditional
> > on DEBUG_KERNEL and EXPERT:
> > 
> > config DEBUG_BUGVERBOSE
> >         bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> >...
> 
> Apologies, I was wrong on DEBUG_BUGVERBOSE
> (but for DEBUG_RODATA I was right).

I think you are wrong not just about that detail but about the whole 
premise of your complaint as well:

>  config DEBUG_BUGVERBOSE
> -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> +	bool "Verbose BUG() reporting (adds 70K)" if EXPERT
> 
> This part of the patch would have been the correct and complete 
> solution for DEBUG_BUGVERBOSE.

Not really - it's a debugging-only option and when i turn on 
CONFIG_DEBUG_KERNEL I expect to have full config control over all 
debug options - with sane defaults provided.

I definitely don't want a debugging option to depend on 
CONFIG_EXPERT.

CONFIG_EXPERT is a superset to all that: it implies config control 
over all debug options *and* over many other kernel components as 
well.

This is a pretty easy model to think about.

> The crazy select added in commit f505c553 is wrong.

Why? Your original message does not explain it.

Thanks,

	Ingo
