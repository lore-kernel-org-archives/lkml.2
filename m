Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2APMx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:53:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab2APMx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:53:56 -0500
Date: Mon, 16 Jan 2012 13:53:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120116125329.GB31667@elte.hu>
References: <20120110174509.GA30802@redhat.com>
 <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com>
 <20120116074540.GE15641@elte.hu>
 <1326717070.7642.144.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326717070.7642.144.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2012-01-16 at 08:45 +0100, Ingo Molnar wrote:
> 
> > Looks good to me at a first (quick) sight, except this bit 
> > which changes the ABI:
> > 
> > > > 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> > > > 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
> > 
> > That's not how we change tracepoints generally - we add a new 
> > one and eventually phase out the old one. Which apps/tools rely 
> > on the old tracepoint? If it's exactly zero apps then we might 
> > be able to change it, but this needs to be investigated.
> 
> But this tracepoint wasn't changed, it was added on to. 
> There's a difference. Any tool that uses this (including 
> something like powertop) should be able to handle it. [...]

That's mostly true in theory - the question is, is it true in 
practice?

Say if an app relies on the smaller data structure, it sure 
might get surprised by the kernel writing a wider record ...

Thanks,

	Ingo
