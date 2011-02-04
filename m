Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1BDBvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:51:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab1BDBve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:51:34 -0500
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Eric Paris <eparis@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stefan Fritsch <sf@sfritsch.de>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, agl@google.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 03 Feb 2011 20:50:26 -0500
In-Reply-To: <20110203231051.GA1840@nowhere>
References: <1294867725.3237.230.camel@localhost.localdomain>
	 <1296665124.3145.17.camel@localhost.localdomain>
	 <20110203190643.GC1769@nowhere> <201102032306.34251.sf@sfritsch.de>
	 <20110203231051.GA1840@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296784230.3145.44.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 00:10 +0100, Frederic Weisbecker wrote:
> On Thu, Feb 03, 2011 at 11:06:33PM +0100, Stefan Fritsch wrote:
> > On Thursday 03 February 2011, Frederic Weisbecker wrote:

> Actually having seccomp as a user of filter expressions is a opportunity
> to improve it and bring new ideas.
> 
> > This would give something in the very near future that is way more 
> > usable than seccomp mode 1. I think only the following adjustments 
> > would need to be made to Adam Langley's patch:
> > 
> > - only allow syscalls in the mode (non-compat/compat) that the prctl 
> > call was made in
> > - deny exec of setuid/setgid binaries
> > - deny exec of binaries with filesystem capabilities
> > 
> > What do you think of this proposal? I have a patch lying around 
> > somewhere that already does the first two of these.
> 
> IMHO this is an unnecessary intermediate state. It will actually make
> things worse by bringing a new non-flexible ABI that we'll need to
> maintain forever.
> 
> I'm no expert in security but I think it's not flexible.

I'm not quite sure how I feel.  The only person who ask/semi-required
this flexibility is Ingo.  I agree it's a really great idea and maybe
one that people will someday use.  I'm going to try to work on it over
the next week or two.  I'm not certain if my use case really wants/needs
it or will even use the filter flexibility.  Now, there's no question
that what we have today is so inflexible it's basically useless.  It's
also obvious that we have at least 3 people who would use something like
the google solution.  (sounds like at least 3 of us have written a
google like solution by now)

So I'm going to take a stab at understanding everything you told me
today.  THANK YOU SO MUCH for the overview.  It was AMAZING and exactly
what I was hoping to hear.  But if I don't think I can come up with
something in a reasonable time frame I'm probably going to be back
pushing what we all wanted to start with    :)

-Eric

