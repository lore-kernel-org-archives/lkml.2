Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1JJIsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:48:16 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:57444 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1JJIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:48:15 -0400
Date: Mon, 10 Oct 2011 11:48:11 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20111010084811.GG4586@localhost.pp.htv.fi>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
 <20110930150519.GA7980@leaf>
 <20110930155012.GC9049@localhost.pp.htv.fi>
 <20111010072946.GA29035@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111010072946.GA29035@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 09:29:48AM +0200, Ingo Molnar wrote:
> * Adrian Bunk <bunk@stusta.de> wrote:
>...
> I think you are wrong not just about that detail but about the whole 
> premise of your complaint as well:
> 
> >  config DEBUG_BUGVERBOSE
> > -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > +	bool "Verbose BUG() reporting (adds 70K)" if EXPERT
> > 
> > This part of the patch would have been the correct and complete 
> > solution for DEBUG_BUGVERBOSE.
> 
> Not really - it's a debugging-only option and when i turn on 
> CONFIG_DEBUG_KERNEL I expect to have full config control over all 
> debug options - with sane defaults provided.

Then you would have to remove the dependency on EXPERT from the prompt, 
and allow unsetting DEBUG_BUGVERBOSE with EXPERT=n, DEBUG_KERNEL=y.

Note that this is completely unrelated to the commit we are discussing,
since commit f505c553 has no effect in the EXPERT=n case you are 
discussing here.

> I definitely don't want a debugging option to depend on 
> CONFIG_EXPERT.

DEBUG_BUGVERBOSE does not depend on EXPERT.

But EXPERT is currently required for disabling it.

This part of our discussion boils down to the following options:
1. DEBUG_KERNEL allows a user to enable additional debugging
2. DEBUG_KERNEL gives a user full control over all debug options

Traditionally it was 1., to tell a user reporting a bug that he should 
enable additional debugging in his kernel - without him accidentally 
disabling useful debugging.

Again, this part of the discussion is unrelated to commit f505c553.

> CONFIG_EXPERT is a superset to all that: it implies config control 
> over all debug options *and* over many other kernel components as 
> well.

I don't see the advantage that EXPERT=y is now unconditionally enabling 
the DEBUG_KERNEL knob.

When I am an "expert", why can't I still decide myself globally if I 
want to enable more debugging or not?

Another problem is that we have code using "#ifdef CONFIG_DEBUG_KERNEL"
so enabling EXPERT for making your kernel smaller can make your kernel 
bigger, but such usages should anyway get own config options.

> This is a pretty easy model to think about.

There are many options in the kernel that only enable seeing other 
config options.

With that model, shouldn't EXPERT also have
	select MISC_FILESYSTEMS
and many other similar select's?

The point I am trying to make here is that there are many convenience 
config options that only exist to allow a user to hide a bunch of 
options he is not interested in, and DEBUG_KERNEL is one of them. [1]

> > The crazy select added in commit f505c553 is wrong.
> 
> Why? Your original message does not explain it.

It is not needed for what it was claimed it was needed for,
and it is a bad idea in general.

If I didn't explain that properly that was my fault,
I hope the explanation in this email is better.

> Thanks,
> 
> 	Ingo

cu
Adrian

[1] ignoring the buggy code using "#ifdef CONFIG_DEBUG_KERNEL"

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

