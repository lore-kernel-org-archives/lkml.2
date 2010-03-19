Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab0CSDGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:06:11 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39636 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0CSDGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fBQKnbovtngua5fVVUMvDlWAZ9MorkQXr00T4AnlvG1A4uuryuxEjvz94TwnFWOU3L
         R7/jYnyslxxAGQTYDSHDBiWkFUscPc82qbH4g4O0wlNA0/tPpn0D5vBxAVmvhs9LBAQ/
         iP0J6qG/eHFxbLjGJcBKU98VAMr6ikghjMBeo=
Date: Fri, 19 Mar 2010 04:06:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100319030611.GE22095@nowhere>
References: <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp> <20100318211633.GG5103@nowhere> <20100319010857.GC23020@Krystal> <20100319012337.GA22095@nowhere> <20100319013658.GB28456@Krystal> <20100319022659.GC22095@nowhere> <20100319024042.GB28941@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319024042.GB28941@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 10:40:42PM -0400, Mathieu Desnoyers wrote:
> Well, the use-case that drove the asm goto implementation _is_ the tracepoints.
> ;)
> 
> > 
> > But, looking at __DO_TRACE:
> > 
> > 	if (it_func) {						\
> > 		do {						\
> > 			((void(*)(proto))(*it_func))(args);	\
> > 		} while (*(++it_func));				\
> > 	}
> > 
> > I would expect the compiler not to load the parameters in the stack
> > before first checking the branch.
> 
> Note that you have to put that in its full context. It's a macro expanded within
> a static inline function. The initial parameters are passed to the static
> inline, not directly as "args" here. So parameters with side-effects have to be
> evaluated before their result can be passed to the static inline function, so in
> that sense their evaluation cannot be moved into the conditional branch.


Evaluation yeah, I agree. A function passed as an argument is
going to be evaluated indeed, or whatever thing that has a side effect.
But there is nothing here that need to setup the parameters to the stack
right before the true tracepoint call, not until we passed the branch check
once.

 
> > So, the fact that parameters are not loaded before we know we'll call
> > the tracepoint is something we already have or is it something that the jump
> > label brings in the package somehow?
> 
> It's standard compiler optimization behavior.


Sure. My doubt is: currently with the upstream version, does the
compiler tend to load the parameters to the stack before the branch is
checked? Or is this a magic that jmp labels bring for whatever reason?

Thanks.

