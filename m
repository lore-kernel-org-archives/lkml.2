Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835Ab0KRXXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:23:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1549 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937Ab0KRXXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:23:30 -0500
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101117083020.GA11336@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <4CE2F747.4060406@linux.intel.com> <20101116221726.GB26243@nowhere>
	 <20101117083020.GA11336@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 15:23:26 -0800
Message-ID: <1290122606.1817.48.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 09:30 +0100, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > An idea is to reproduce the kernel file hierarchy in a "printk" event
> > subsystem, but this implies to allow subsystems nesting.
> > But may be the whole idea is just fancy and nobody will care, [...]
> I think it's an excellent idea, and it could also give us the framework to integrate 
> the dynamic_printk points.
[]
> > For example I'm currently working with dozens of trace_printk() and I would be 
> > very happy to turn some of them off half of the time.
> I guess we could try such a patch. If you send a prototype i'd be interested in 
> testing it out.

Another concept you might consider would be to
selectively compile trace points per compilation
unit.  This might help embedded users that might
want to use trace only in a few areas without the
additional text overhead.

Perhaps something like:

(default on)

#ifdef ENABLE_TRACE_COMPILATION
# normal tracepoint macro defines
#else
# static inline tracepoint functions {} or null macro defines
#endif


