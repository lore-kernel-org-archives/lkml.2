Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0EUKV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:21:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46761 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0EUKV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OZpBPlogIG+KnMvXIJX/WO1mvnC92NXlQoCKcFNHghIaVBhrf2MA4GNGukbswXluVV
         Bzx86p5EyOur/o3vE//Wjr9rWOfSthZBoxoofhVUjHwCT7gIsZYzI9Cm1PY/JFMYKzVq
         NwPJ9TI+4loImJ44EXoPq9hLJaUrapJsfEcmY=
Date: Fri, 21 May 2010 12:21:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
	track events
Message-ID: <20100521102131.GE30108@nowhere>
References: <20100521090201.326791353@chello.nl> <20100521090710.473188012@chello.nl> <20100521094014.GA30108@nowhere> <1274436125.1674.1690.camel@laptop> <20100521101347.GC30108@nowhere> <1274437149.1674.1697.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274437149.1674.1697.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 12:19:09PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-05-21 at 12:13 +0200, Frederic Weisbecker wrote:
> > > I assumed that after probe unregister a tracepoint callback doesn't
> > > happen, which then guarantees we should never get !head.
> 
> > I'm not sure about this. The tracepoints are called under rcu_read_lock(),
> > but there is not synchronize_rcu() after we unregister a tracepoint, which
> > means you can have a pending preempted one somewhere.
> > 
> > There is a call_rcu that removes the callbacks, but that only protect
> > the callback themselves. 
> 
> Ah, ok, so we should do probe_unregister + synchronize_sched().
> That should ensure __DO_TRACE() doesn't call into it anymore.
> 
> /me goes make a patch
> 


Yep. But that also means we need to rcu_dereference_sched() to access
the per cpu list of events.

Thanks.

