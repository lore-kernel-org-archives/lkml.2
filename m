Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1BBM0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:26:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1BBM0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:26:33 -0500
Date: Wed, 2 Feb 2011 13:26:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Eric Paris <eparis@parisplace.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, agl@google.com, fweisbec@gmail.com,
        tzanussi@gmail.com, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: Using ftrace/perf as a basis for generic seccomp
Message-ID: <20110202122620.GA11427@elte.hu>
References: <1294867725.3237.230.camel@localhost.localdomain>
 <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
 <4D494AB1.1040508@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D494AB1.1040508@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Hi Eric,
> 
> (2011/02/01 23:58), Eric Paris wrote:
> > On Wed, Jan 12, 2011 at 4:28 PM, Eric Paris <eparis@redhat.com> wrote:
> >> Some time ago Adam posted a patch to allow for a generic seccomp
> >> implementation (unlike the current seccomp where your choice is all
> >> syscalls or only read, write, sigreturn, and exit) which got little
> >> traction and it was suggested he instead do the same thing somehow using
> >> the tracing code:
> >> http://thread.gmane.org/gmane.linux.kernel/833556
> 
> Hm, interesting idea :)
> But why would you like to use tracing code? just for hooking?

What I suggested before was to reuse the scripting engine and the tracepoints.

I.e. the "seccomp restrictions" can be implemented via a filter expression - and the 
scripting engine could be generalized so that such 'sandboxing' code can make use of 
it.

For example, if you want to restrict a process to only allow open() syscalls to fd 4 
(a very restrictive sandbox), it could be done via this filter expression:

	'fd == 4'

etc. Note that obviously the scripting engine needs to be abstracted out somewhat - 
but this is the basic idea, to reuse the callbacks and reuse the scripting engine 
for runtime filtering of syscall parameters.

Thanks,

	Ingo
