Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1BBTcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 14:32:13 -0500
Received: from mail.openrapids.net ([64.15.138.104]:55809 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754882Ab1BBTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 14:32:12 -0500
Date: Wed, 2 Feb 2011 14:32:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] Tracepoints: Fix section alignment using pointer
	array
Message-ID: <20110202193209.GA29590@Krystal>
References: <20110202180613.978219945@goodmis.org> <20110202180938.471738176@goodmis.org> <20110202183138.GB27022@Krystal> <1296673015.10797.66.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296673015.10797.66.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:32:01 up 71 days, 35 min,  3 users,  load average: 0.02, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2011-02-02 at 13:31 -0500, Mathieu Desnoyers wrote:
> 
> > > History:
> > > 
> > > commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
> > > variable attribute to the tracepoint structures to deal with gcc happily
> > > aligning statically defined structures on 32-byte multiples.
> > > 
> > > commit 15e3540ce2159705f18fad6147ffedf04445ad64 tried to use a 8-byte alignment
> > > for tracepoint structures by applying both the variable and type attribute to
> > > tracepoint structures definitions and declarations. It worked fine with gcc
> > > 4.5.1, but broke with gcc 4.4.4 and 4.4.5.
> > 
> > Small nit: this reference to commit 15e3540ce2159705f18fad6147ffedf04445ad64
> > should be changed to a non-commit-id-related explanation, because the commit has
> > been rolled back from -tip.
> 
> OK, I just did a git commit --amend to fix it. Here's the new text:
> 
> 
>     commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type a
>     variable attribute to the tracepoint structures to deal with gcc happily
>     aligning statically defined structures on 32-byte multiples.
>     
>     One attempt was to use a 8-byte alignment for tracepoint structures by apply
>     both the variable and type attribute to tracepoint structures definitions an
>     declarations. It worked fine with gcc 4.5.1, but broke with gcc 4.4.4 and 4.
>     
>     The reason is that the "aligned" attribute only specify the _minimum_ alignm
>     for a structure, leaving both the compiler and the linker free to align on
>     larger multiples. Because tracepoint.c expects the structures to be placed a
>     array within each section, up-alignment cause NULL-pointer exceptions due to
>     extra unexpected padding.
> 
> This version has just been pushed. I just changed the wording to leave
> out the reference to the reverted commit.

Looks good!

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
