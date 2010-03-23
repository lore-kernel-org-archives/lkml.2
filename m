Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0CWIFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:05:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0CWIFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:05:42 -0400
Date: Tue, 23 Mar 2010 09:05:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/18] Allow different tracers to be compiled independently
Message-ID: <20100323080526.GB4848@elte.hu>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
 <20100323010419.GA8292@nowhere>
 <DA3F0457-83D6-4A95-AC86-188BC1C9B2F0@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DA3F0457-83D6-4A95-AC86-188BC1C9B2F0@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@MIT.EDU> wrote:

> 
> On Mar 22, 2010, at 9:04 PM, Frederic Weisbecker wrote:
> > 
> > I don't know. Yeah this first looks like a good idea but once 
> > CONFIG_EVENT_TRACING is enabled, each tracepoint is a lightweight thing 
> > and induce a tiny overhead, probably hard to notice, and this is going to 
> > be even more the case after the jmp label optimization patches.
> > 
> > I liked the fact we had a general tracing kernel once the above config is 
> > selected. And we don't bother telling people that to use tool X you need 
> > CONFIG_EVENT_Y, and you need to rebuild your kernel, etc...
> 
> Indeed, a lot of the value of tracepoints goes away if people are compiling 
> kernels without them and we need to get a special "tracing kernel" installed 
> before we can debug a problem.
> 
> So I'd hope we can do the necessary optimization work so people don't feel 
> it's necessary to enable or disable tracepoints by subsystem....

Yeah, agreed. Ultra-embedded can disable them all, but other than that i think 
we should not make it too finegrained as a lot of tooling value is in the 
'critical mass' that tracepoints have achieved. The power events tracepoints 
are most useful when combined with scheduling events, etc.

	Ingo
