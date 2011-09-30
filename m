Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab1I3PuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:50:18 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:41228 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1I3PuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:50:16 -0400
Date: Fri, 30 Sep 2011 18:50:12 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20110930155012.GC9049@localhost.pp.htv.fi>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
 <20110930150519.GA7980@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110930150519.GA7980@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:05:19AM -0700, Josh Triplett wrote:
> On Fri, Sep 30, 2011 at 04:42:45PM +0300, Adrian Bunk wrote:
>...
> > Let me point at the obvious fact that both CONFIG_DEBUG_BUGVERBOSE and 
> > CONFIG_DEBUG_RODATA do depend on DEBUG_KERNEL, and are contrary to the 
> > claim of the author of this patch never enabled with 
> > CONFIG_DEBUG_KERNEL=n. [1]
> 
> Not true:
> 
> ~/src/linux-2.6$ rm .config
> ~/src/linux-2.6$ make allnoconfig
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/kconfig/conf.o
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf --allnoconfig Kconfig
> #
> # configuration written to .config
> #
> ~/src/linux-2.6$ grep BUGVERBOSE .config
> CONFIG_DEBUG_BUGVERBOSE=y
> ~/src/linux-2.6$ grep DEBUG_KERNEL .config
> # CONFIG_DEBUG_KERNEL is not set
> 
> DEBUG_BUGVERBOSE does not depend on DEBUG_KERNEL; it just only shows up
> with DEBUG_KERNEL (and EXPERT) set.  The *description* has a conditional
> on DEBUG_KERNEL and EXPERT:
> 
> config DEBUG_BUGVERBOSE
>         bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
>...

Apologies, I was wrong on DEBUG_BUGVERBOSE
(but for DEBUG_RODATA I was right).

>...
> Also see Ingo Molnar's mail with Message-Id
> <20110605093445.GA19927@elte.hu>, which explicitly recommended this
> approach.

Ingo is an expert in a gazillion areas of the kernel and knows more 
about these than mere mortals like me will ever know.

Kconfig is (the?) one thing where he in not a good advisor.

Looking at the patch Frederic points at [1]:

 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
+	bool "Verbose BUG() reporting (adds 70K)" if EXPERT

This part of the patch would have been the correct and complete 
solution for DEBUG_BUGVERBOSE.

The crazy select added in commit f505c553 is wrong.

> - Josh Triplett

cu
Adrian

[1] http://lkml.org/lkml/2011/6/6/641

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

