Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2AQMkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:40:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50971 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab2AQMkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:40:33 -0500
Date: Tue, 17 Jan 2012 13:40:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120117124023.GA13969@elte.hu>
References: <20120110174509.GA30802@redhat.com>
 <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com>
 <20120116074540.GE15641@elte.hu>
 <1326717070.7642.144.camel@gandalf.stny.rr.com>
 <20120116125329.GB31667@elte.hu>
 <1326729123.7642.146.camel@gandalf.stny.rr.com>
 <20120117100222.GH10397@elte.hu>
 <1326801811.7642.188.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326801811.7642.188.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2012-01-17 at 11:02 +0100, Ingo Molnar wrote:
> 
> > That is not true *AT ALL* in such an unqualified manner. Steve, 
> > stop being stupid.
> > 
> > The kernel syscall ABI may indeed sometimes expand *INPUT* 
> > structures (if via some mechanism it's possible to make sure 
> > that old ABI uses don't cause the kernel to read undefined 
> > data), but the trace events are *OUTPUT* structures.
> 
> The difference between syscalls and tracepoints is that a 
> tracepoint always reports the size of the structure that was 
> read, where a syscall does not. So I do consider this similar 
> to reading the /proc/stat file as the user can see how much 
> was read. The backwards compatibility should be easy to write. 
> Old tools should not break, because it wont be reading the new 
> fields, and new tools can determine which tracepoint is there 
> because it is trivial to see which version of the tracepoint 
> is there because of the size read.

Any tool that requests the signal trace event, and copies the 
full (and now larger) record it got in the ring-buffer, without 
expanding the target record's size accordingly will *BREAK*. 

I do not claim that tools will break in practice - i'm raising 
the *possibility* out of caution and i'm frustrated that you 
*STILL* don't understand how ABIs are maintained in Linux. 

You arguing about defined semantics is *MEANINGLESS*. What 
matters is what the apps do in practice. If the apps we know 
about do it robustly and adapt (or don't care) about the 
expansion, and if no-one reports a regression in tools we don't 
know about, then it's probably fine.

But your argument that expansion is somehow part of the ABI is 
patently false and misses the point. Seeing your arguments make 
me *very* nervous about applying any ABI affecting patch from 
you.

Thanks,

	Ingo
