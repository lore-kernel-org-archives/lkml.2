Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0KXTSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:18:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0KXTSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:18:47 -0500
Date: Wed, 24 Nov 2010 14:18:04 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
	label key entries
Message-ID: <20101124191804.GH2815@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com> <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com> <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com> <1290611702.30543.488.camel@gandalf.stny.rr.com> <20101124152118.GC2815@redhat.com> <1290614246.30543.536.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290614246.30543.536.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:57:26AM -0500, Steven Rostedt wrote:
> On Wed, 2010-11-24 at 10:21 -0500, Jason Baron wrote:
> 
> > The keys are simply the address of a variable or structure (so as to be
> > unique). We can put pointers or anything else in the variable.
> 
> Note, there is not a 1 to 1 with keys and places that need to be
> patched.
> 
> Doing the following objdump:
> 
>   objdump -dr vmlinux | grep 'jmpq.*<trace_kmalloc' | wc -l
> 375
> 
> That's 375 instances of kmalloc tracepoints[*] and one key. How do you
> handle this?
> 

so there is 1 key associated with a kmalloc, call it key 'a'.
Then, each time a trace_kmalloc is found in the text it generates a
entry in the jump label section:

[to be patched address i] [address to jump to j] [key a]
[to be patched address k] [address to jump to l] [key a]
.
.

So when we do jump_label_enable(key a), we patch all addresses
associated with key a. Does this make sense?


> -- Steve
> 
> 
> 
> 
> [*] this should be fixed, we probably should find a way to move the
> tracepoint into the kmalloc functions that are not inlined.
> 

I believe there are patches pending for this.

thanks,

-Jason
