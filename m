Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab0KQOLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 09:11:51 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58414 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0KQOLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:11:50 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20101117140002.GH27063@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org> <20101117132404.GF27063@elte.hu>
	 <1290001128.2109.785.camel@laptop>  <20101117140002.GH27063@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 15:11:50 +0100
Message-ID: <1290003110.2109.822.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:00 +0100, Ingo Molnar wrote:
> > But yes, it is functional.
> 
> I suspect that is what matters mostly - unless you think that it's impossible to 
> have a sane implementation of it, if the users come. 

I'm not sure, I raised the point several times, and I think Steve and
Tom though it was possible to implement sanely, but I'm not sure if it
was expression invariant (the fix that is).

It would be very good to have a definite answer on that.

The idea was to not let the filter engine work on the trace data (once
its gathered) but on the trace argument right at the beginning of the
tracepoint callchain, since some of the trace data is an expression of
the trace argument (say next->prio instead of next), the trace
expression wouldn't stay invariant, you'd have to write a different
filter for the same effect.

So I think it would be wise to make this change sooner rather than
later.
