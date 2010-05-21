Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0EUKTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:19:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab0EUKTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:19:12 -0400
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521101347.GC30108@nowhere>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.473188012@chello.nl> <20100521094014.GA30108@nowhere>
	 <1274436125.1674.1690.camel@laptop>  <20100521101347.GC30108@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 12:19:09 +0200
Message-ID: <1274437149.1674.1697.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 12:13 +0200, Frederic Weisbecker wrote:
> > I assumed that after probe unregister a tracepoint callback doesn't
> > happen, which then guarantees we should never get !head.

> I'm not sure about this. The tracepoints are called under rcu_read_lock(),
> but there is not synchronize_rcu() after we unregister a tracepoint, which
> means you can have a pending preempted one somewhere.
> 
> There is a call_rcu that removes the callbacks, but that only protect
> the callback themselves. 

Ah, ok, so we should do probe_unregister + synchronize_sched().

That should ensure __DO_TRACE() doesn't call into it anymore.

/me goes make a patch

