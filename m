Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab1IYIPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 04:15:06 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:58395 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1IYIO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 04:14:56 -0400
Date: Fri, 23 Sep 2011 17:51:32 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 8/26]   x86: analyze instruction and
 determine fixups.
Message-ID: <20110923165132.GA23870@stefanha-thinkpad.localdomain>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120127.25326.71509.sendpatchset@srdronam.in.ibm.com>
 <20110920171310.GC27959@stefanha-thinkpad.localdomain>
 <20110920181225.GA5149@infradead.org>
 <20110920205317.GA1508@stefanha-thinkpad.localdomain>
 <4E7C7353.50802@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7C7353.50802@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 08:53:55PM +0900, Masami Hiramatsu wrote:
> (2011/09/21 5:53), Stefan Hajnoczi wrote:
> > On Tue, Sep 20, 2011 at 02:12:25PM -0400, Christoph Hellwig wrote:
> >> On Tue, Sep 20, 2011 at 06:13:10PM +0100, Stefan Hajnoczi wrote:
> > But this should be solvable so it would be possible to use perf-probe(1)
> > on a std.h-enabled binary.  Some distros already ship such binaries!
> 
> I'm not sure that we should stick on the current implementation
> of the sdt.h. I think we'd better modify the sdt.h to replace
> such semaphores with checking whether the tracepoint is changed from nop.

I like this option.  The only implication is that all userspace tracing
needs to go through uprobes if we want to support multiple consumers
tracing the same address.

> Or, we can introduce an add-hoc ptrace code to perftools for modifying
> those semaphores. However, this means that user always has to use
> perf to trace applications, and it's hard to trace multiple applications
> at a time (can we attach all of them?)...

I don't think perf needs to stay attached to the processes.  It just
needs to increment the semaphores on startup and decrement them on
shutdown.

Are you going to attempt either of these implementations?

Stefan
