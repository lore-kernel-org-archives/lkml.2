Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1JUMhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:37:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1JUMhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:37:15 -0400
Message-ID: <4EA16779.7060006@suse.cz>
Date: Fri, 21 Oct 2011 14:37:13 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL
 to unhide debug options"
References: <20110930134245.GB21474@localhost.pp.htv.fi> <20110930150519.GA7980@leaf> <20110930155012.GC9049@localhost.pp.htv.fi> <20111010072946.GA29035@elte.hu> <20111010084811.GG4586@localhost.pp.htv.fi> <20111010102116.GA26901@elte.hu> <20111010121340.GA3731@localhost.pp.htv.fi> <20111012083801.GA27853@elte.hu> <20111020214149.GF9819@localhost.pp.htv.fi> <4EA12B11.5090809@suse.cz> <20111021092249.GG9819@localhost.pp.htv.fi>
In-Reply-To: <20111021092249.GG9819@localhost.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2011 11:22, Adrian Bunk wrote:
> On Fri, Oct 21, 2011 at 10:19:29AM +0200, Michal Marek wrote:
>> On 20.10.2011 23:41, Adrian Bunk wrote:
>>> Ingo, would you accept if I would go through the Kconfig files and 
>>> monitor future changes to Kconfig files in the kernel (or if Michal does 
>>> it, I don't insist that it has to be me if someone else wants to do it)?
>>
>> What kind of changes do you have in mind? Sorry, I haven't followed the
>> whole thread.
> 
> Checking the correctness and making things more robust.
> 
> An example:
> 
> config KVM
>         tristate "Kernel-based Virtual Machine (KVM) support"
> 	...
>         # for TASKSTATS/TASK_DELAY_ACCT:
>         depends on NET
> 	...
>         select TASKSTATS
>         select TASK_DELAY_ACCT
> 
> That breaks if anyone touches the dependencies of TASKSTATS
> or TASK_DELAY_ACCT.
> 
> It should be solved better, my first thought would be introducing
> something like a TASK_DELAY_ACCT_AVAILABLE variable.

Right, but that's a deficiency of the kconfig solver. Catalin Marinas
has patched it to at least print a warning if a dependency of a
select-ed symbol is not set. Ideally, we should get a better solver.

Michal

Michal

