Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab2HJCF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:05:27 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53648 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754024Ab2HJCF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:05:26 -0400
Date: Thu, 9 Aug 2012 22:05:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney.cavm@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracepoints: Move the work out of line from
	hotpath sections
Message-ID: <20120810020523.GA18832@Krystal>
References: <1344544823.6935.82.camel@gandalf.stny.rr.com> <20120809205053.GB15109@Krystal> <1344551131.6935.90.camel@gandalf.stny.rr.com> <502444CC.8030906@linux.intel.com> <50244D9A.2070000@gmail.com> <1344562886.6935.93.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344562886.6935.93.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2012-08-09 at 16:54 -0700, David Daney wrote:
> > On 08/09/2012 04:16 PM, H. Peter Anvin wrote:
> > > On 08/09/2012 03:25 PM, Steven Rostedt wrote:
> > >>>
> > >>> It might be better to improve gcc to move really cold branches out of
> > >>> line (really, really far away), and use the compiler to do this, rather
> > >>> than to use an extra indirection that adds bloat and complexity to the
> > >>> kernel.
> > 
> > Oh, you mean like: -freorder-blocks-and-partition
> 
> Actually, what would be really nice is to place a block in a section of
> your choice. Something like:
> 
> 
> 	if (unlikely(x)) __attribute__((section(".unlikely"))) {
> 		/* code here will be in the ".unlikely" section */
> 	}

In your example, is the attribute attached to the if() or the following
basic block ? Attaching it to the basic block allows a nice level of
genericity:

if (unlikely(x)) __attribute__((section(".unlikely"))) {
        ...
} else __attribute__((section(".likely"))) {
        ...
}

or

switch (x) {
        case 0:
        case 1:
        case 6:
        __attribute__((section(".likely"))) {
                ...
                break;
        }
        default:
        __attribute__((section(".unlikely"))) {
                ...
                break;
        }
}

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
