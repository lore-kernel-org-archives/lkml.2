Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2AaMUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:20:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab2AaMUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:20:49 -0500
Date: Tue, 31 Jan 2012 13:20:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
Message-ID: <20120131122016.GF32010@elte.hu>
References: <1327545664.22710.78.camel@gandalf.stny.rr.com>
 <20120126102836.GD3853@elte.hu>
 <1327585945.22710.87.camel@gandalf.stny.rr.com>
 <20120126135504.GA13107@elte.hu>
 <1327586669.22710.89.camel@gandalf.stny.rr.com>
 <1327588606.22710.100.camel@gandalf.stny.rr.com>
 <20120126183946.GA14709@elte.hu>
 <87ehuldf0m.fsf@rustcorp.com.au>
 <1327924333.22710.157.camel@gandalf.stny.rr.com>
 <87sjiwjzew.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjiwjzew.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 30 Jan 2012 06:52:13 -0500, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2012-01-27 at 13:32 +1030, Rusty Russell wrote:
> > > On Thu, 26 Jan 2012 19:39:46 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > > > Ok, i like this one best. Rusty, does it look good to you too?
> > > 
> > > No, the if (module) test belongs in the inline wrapper (since gcc knows
> > > that at compile time).
> > 
> > For some reason though it still adds 5K when we keep the 
> > code as a static inline. Note, my test config does have all 
> > the necessary modules to boot the box as compiled in (not as 
> > modules). If necessary, I could compile with a distro config 
> > and see what the differences are with that.
> > 
> > Rusty, the final decision is yours. If you believe that the 
> > added code size is worth having the static inlines, then 
> > I'll go back to the previous version that had that.
> 
> Wow, we're really bikeshedding this!

Hey, I don't think this is bikesheddig: we are shedding 
*kilobytes* of code from pretty hot codepaths, that kind of 
topic does deserve some detailed attention :-)

> I was completely wrong with the "it's usually a constant" of 
> course; it's usually ->owner.
> 
> So let's just out-of-line the entire thing.  I changed the 
> type to bool and s/_THIS_IP_/_RET_IP_/ -- is that sufficient?
> 
> Doesn't save me much here, though.  What are your stats?

I suspect it depends on inlining options in the .config plus on 
event tracing?

> Saves only 400 bytes of text here, but I don't do preempt or 
> tracepoints.

Most distro kernels do tracepoints so I guess that's where the 
size delta comes from :-) In any case:

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
