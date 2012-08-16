Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2HPWAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:00:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2HPWAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:00:22 -0400
X-Authority-Analysis: v=2.0 cv=Hun06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=07ZCQtT27sEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZRzJ3tYFNvQA:10 a=meVymXHHAAAA:8 a=9Ga2Su1Zm6dkM_46A5sA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345154418.3708.13.camel@gandalf.local.home>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 16 Aug 2012 18:00:18 -0400
In-Reply-To: <20120816214103.GE16308@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <20120816141253.0142ddd0@lwn.net>
	 <20120816205539.GA16308@aftab.osrc.amd.com>
	 <1345151613.3708.4.camel@gandalf.local.home>
	 <20120816214103.GE16308@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 23:41 +0200, Borislav Petkov wrote:
> On Thu, Aug 16, 2012 at 05:13:33PM -0400, Steven Rostedt wrote:
> > BTW, we already have a persistent buffering in the kernel. It's used
> > by ftrace. What about having perf use that buffering for persistent
> > events? Or is there some other issues about using it.
> 
> Not that I know of.
> 
> I coded this with the perf ring buffer now. If only there was one ring
> buffer in the kernel.. /me ducks and hides.

:)

> 
> Ok, with perf I can read out the events programmatically by mmaping the
> per-CPU buffer with perf_mmap. How do you do that in ftrace? Any code
> pointers I can stare at?

Do these need to be mmapped, or are they copied into another location
(disk or network)? I had code to allow the ftrace ring buffers to be
mmapped, but stopped that work a while ago.


> 
> > I'm currently working on having perf read ftrace data, so in the near
> > future, I plan on having some RFC patches to have perf reading from
> > this buffer anyway.
> 
> Are you saying the ftrace buffer would be mmappable too now?

No, the ftrace buffer was optimized for the splice command. I would have
perf do what trace-cmd does. That is, write directly into a file as it
reads it, without ever needing the info to come into userspace. I wasn't
planning on replacing perf buffers, I was just planning on giving perf a
tracing boost.

Another alternative, which would be a bit slower, would be to copy the
pages, either into userspace (as a read) or into a location to mmap the
buffers.

I could also continue the work on allowing ftrace buffers to be mmapped.
But if the best thing to do is just use the perf buffers, then we could
just stick with that.

> 
> Btw, I wanted to hear your opinion on patch 1/4 since it touches
> ftrace/trace_events code. Can you please look at it and tell me if its
> ok?
> 

I'll take a look.

-- Steve


