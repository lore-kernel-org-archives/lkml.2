Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1JUJWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 05:22:53 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53372 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1JUJWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 05:22:52 -0400
Date: Fri, 21 Oct 2011 12:22:49 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20111021092249.GG9819@localhost.pp.htv.fi>
References: <20110930134245.GB21474@localhost.pp.htv.fi>
 <20110930150519.GA7980@leaf>
 <20110930155012.GC9049@localhost.pp.htv.fi>
 <20111010072946.GA29035@elte.hu>
 <20111010084811.GG4586@localhost.pp.htv.fi>
 <20111010102116.GA26901@elte.hu>
 <20111010121340.GA3731@localhost.pp.htv.fi>
 <20111012083801.GA27853@elte.hu>
 <20111020214149.GF9819@localhost.pp.htv.fi>
 <4EA12B11.5090809@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EA12B11.5090809@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 10:19:29AM +0200, Michal Marek wrote:
> On 20.10.2011 23:41, Adrian Bunk wrote:
> > Ingo, would you accept if I would go through the Kconfig files and 
> > monitor future changes to Kconfig files in the kernel (or if Michal does 
> > it, I don't insist that it has to be me if someone else wants to do it)?
> 
> What kind of changes do you have in mind? Sorry, I haven't followed the
> whole thread.

Checking the correctness and making things more robust.

An example:

config KVM
        tristate "Kernel-based Virtual Machine (KVM) support"
	...
        # for TASKSTATS/TASK_DELAY_ACCT:
        depends on NET
	...
        select TASKSTATS
        select TASK_DELAY_ACCT

That breaks if anyone touches the dependencies of TASKSTATS
or TASK_DELAY_ACCT.

It should be solved better, my first thought would be introducing
something like a TASK_DELAY_ACCT_AVAILABLE variable.

(I am also not sure if what KVM is doing here is the best possible
 solution or if there's an in-kernel interface that should be factored
 out instead - but that is a secondary discussion that might start when 
 you look at such cross-subsystem select's.)

> Michal

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

