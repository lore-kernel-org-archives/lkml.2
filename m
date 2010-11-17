Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810Ab0KQPoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:44:11 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59390 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420Ab0KQPoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:44:09 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Ted Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1290006634.30543.61.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>
	 <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>
	 <1290003110.2109.822.camel@laptop>
	 <1290006634.30543.61.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 16:43:57 +0100
Message-ID: <1290008637.2109.967.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 10:10 -0500, Steven Rostedt wrote:
> 
> Right, the problem with filtering is what do we want to filter, and what
> about copying?
> 
> Currently, we copy the data into the buffer and then filter on that
> data. We could also easily filter on the parameters of the tracepoint,
> but sometimes those parameters do not match the final output (as the
> case with sched_switch). Do we copy the data into a separate "per cpu"
> temp buffer, and figure out the filter then? And if the filter is fine,
> then copy into the buffer. This obviously is slow, due to the multiple
> copies. We could do this only if the filtering is enabled.

Right, so what is the primary purpose of this filtering stuff? As it
stands it makes stuff terribly slow, so you add overhead but the win
(presumably) is less data output, is that a sane trade-off?

Most people I've heard -- both at LinuxCon.JP and LPC -- are asking for
lower overhead tracing (while at the same time demanding more features).

Who are actually using this and can they provide some input on this?

