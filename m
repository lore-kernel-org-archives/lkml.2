Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab0CaCDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:03:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0CaCDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:03:38 -0400
X-Authority-Analysis: v=1.0 c=1 a=111p4j47RSwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=fVwSa5jvIF5zXvDajboA:9 a=rJyA-rgNxtdWvFOJQrlXYbtuyy4A:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] modules fix incorrect percpu usage
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, stable <stable@kernel.org>
In-Reply-To: <20100330202421.GA28800@Krystal>
References: <20100330135208.GC20673@Krystal>
	 <20100330125304.53f079db.akpm@linux-foundation.org>
	 <20100330202421.GA28800@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 30 Mar 2010 22:03:33 -0400
Message-ID: <1270001013.19685.6677.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 16:24 -0400, Mathieu Desnoyers wrote:

> > Why do you beleive this should be backported to -stable?  What are the
> > user-visible effects of this change?
> > 
> 
> As for the user-visible impact of this specific patch, I guess nobody noticed
> any problem because we've been lucky enough that the compiler did not generate
> the inappropriate optimization pattern there.
> 
> This inappropriate use of per_cpu_ptr() elsewhere (in __module_ref_addr() from
> module.h) caused a NULL pointer exception on Randy's machine.
> 
> So either we consider that the code is better left untouched, or we apply this
> patch to module.c in order to prevent compiler optimizations from subtly
> breaking the generated assembly with specific configurations of the current or
> future versions of the compiler. At that level, it becomes a policy question
> about what should go in -stable, for which I will defer to Greg and you. I would
> perfectly understand if you consider that it does not belong to -stable, because
> there is no perceived user impact so far.

I don't know. A possible "NULL pointer dereference" seems to me to be a
pretty big user visible impact.

I guess the question is, what's the risk of adding this change?

-- Steve


