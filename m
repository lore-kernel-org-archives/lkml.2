Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2AYOLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:11:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32831 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2AYOLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:11:35 -0500
Subject: Re: [PATCH v9 3.2 0/9] Uprobes patchset with perf probe support
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20120117093925.GC10397@elte.hu>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
	 <20120116083442.GA23622@elte.hu>
	 <20120116151755.GH10189@linux.vnet.ibm.com>
	 <20120117093925.GC10397@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 15:11:27 +0100
Message-ID: <1327500687.2614.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 10:39 +0100, Ingo Molnar wrote:

> I did not suggest anything complex or intrusive: just basically 
> unify the namespace, have a single set of callbacks, and call 
> into the uprobes and perf code from those callbacks - out of the 
> sight of MM code.
> 
> That unified namespace could be called:
> 
>     event_mmap(...);
>     event_fork(...);
> 
> etc. - and from event_mmap() you could do a simple:
> 
> 	perf_event_mmap(...)
> 	uprobes_event_mmap(...)
> 
> [ Once all this is updated to use tracepoints it would turn into 
>   a notification callback chain kind of thing. ]

We keep disagreeing on this. I utterly loathe hiding stuff in notifier
lists. It makes it completely non-obvious who all does what.

Another very good reason to not do what you suggest is that
perf_event_mmap() is a pure consumer, it doesn't have a return value,
whereas uprobes_mmap() can actually fail the mmap.



