Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab0KQDQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:16:15 -0500
Received: from THUNK.ORG ([69.25.196.29]:54447 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab0KQDQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:16:13 -0500
Date: Tue, 16 Nov 2010 22:16:09 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117031609.GE3290@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
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
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <20101117013700.GA3290@thunk.org>
 <1289958460.30543.13.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289958460.30543.13.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 08:47:40PM -0500, Steven Rostedt wrote:
> 
> Note, I just posted an RFC stable event patch set. I would like any tool
> that does general analysis, to use stable events and not random raw
> events created by the perspective maintainers.
> 
> The tool could tap into the raw events, but I don't like the "trace
> check" I think anything that the trace needs should be guaranteed there
> (with the stable tracepoints).
> 
> The tracepoints used for general analysis should be stable, anything
> else is just shear bonus.

Which is fine with me, so long as it is accepted that the 'trace' tool
is not targetted at kernel developers (who would probably like to use
a combination of stable and unstable tracepoints).

Do we all agree on what the intended target audience is for this
'trace' tool?

My one concern of having a tool that doesn't support the unstable
tracepoints is that if the kernel developers aren't using it for their
day-to-day use, it won't get attention/love, and it risks the fate of
'systemtap' --- ignored by kernel developers and treated as if it
doesn't exist.

Maybe the answer is there's a #ifdef, and there's one version of the
tool that is intended for use by kernel developers, and one which is
restricted to the stable interface that we give to the hoi polloi?

	      	  	 	   	   - Ted
