Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2AQKCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:02:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2AQKCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:02:49 -0500
Date: Tue, 17 Jan 2012 11:02:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120117100222.GH10397@elte.hu>
References: <20120110174509.GA30802@redhat.com>
 <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com>
 <20120116074540.GE15641@elte.hu>
 <1326717070.7642.144.camel@gandalf.stny.rr.com>
 <20120116125329.GB31667@elte.hu>
 <1326729123.7642.146.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326729123.7642.146.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2012-01-16 at 13:53 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Say if an app relies on the smaller data structure, it sure 
> > might get surprised by the kernel writing a wider record ...
> 
> Ingo,
> 
> The kernel does this all the time. We have syscalls that may 
> extend the data structure. [...]

That is not true *AT ALL* in such an unqualified manner. Steve, 
stop being stupid.

The kernel syscall ABI may indeed sometimes expand *INPUT* 
structures (if via some mechanism it's possible to make sure 
that old ABI uses don't cause the kernel to read undefined 
data), but the trace events are *OUTPUT* structures.

The kernel ABI never ever expands output structures, unless the 
ABI itself is expanded in a safe way that makes it impossible 
for old apps to trigger the new output logic, i.e. which makes 
sure that all old apps work as well. We never ever write beyond 
an already existing 40 byte ABI structure and corrupt the 41th 
byte for an existing app!

In this case we simply don't know whether such an app exists. It 
might be OK to do it, or it might be not so ok.

Thanks,

	Ingo
