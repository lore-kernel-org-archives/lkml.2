Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1BBQqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:46:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1BBQqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:46:05 -0500
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, fweisbec@gmail.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp
Date: Wed, 02 Feb 2011 11:45:22 -0500
In-Reply-To: <20110202122620.GA11427@elte.hu>
References: <1294867725.3237.230.camel@localhost.localdomain>
	 <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
	 <4D494AB1.1040508@hitachi.com> <20110202122620.GA11427@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296665124.3145.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 13:26 +0100, Ingo Molnar wrote:
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> > Hi Eric,
> > 
> > (2011/02/01 23:58), Eric Paris wrote:
> > > On Wed, Jan 12, 2011 at 4:28 PM, Eric Paris <eparis@redhat.com> wrote:
> > >> Some time ago Adam posted a patch to allow for a generic seccomp
> > >> implementation (unlike the current seccomp where your choice is all
> > >> syscalls or only read, write, sigreturn, and exit) which got little
> > >> traction and it was suggested he instead do the same thing somehow using
> > >> the tracing code:
> > >> http://thread.gmane.org/gmane.linux.kernel/833556
> > 
> > Hm, interesting idea :)
> > But why would you like to use tracing code? just for hooking?
> 
> What I suggested before was to reuse the scripting engine and the tracepoints.
> 
> I.e. the "seccomp restrictions" can be implemented via a filter expression - and the 
> scripting engine could be generalized so that such 'sandboxing' code can make use of 
> it.
> 
> For example, if you want to restrict a process to only allow open() syscalls to fd 4 
> (a very restrictive sandbox), it could be done via this filter expression:
> 
> 	'fd == 4'
> 
> etc. Note that obviously the scripting engine needs to be abstracted out somewhat - 
> but this is the basic idea, to reuse the callbacks and reuse the scripting engine 
> for runtime filtering of syscall parameters.

Any pointers on what is involved in this abstraction?  I can work out
the details, but I don't know the big picture well enough to even start
to move forwards.....

-Eric

