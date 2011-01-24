Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1AXV2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:28:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35589 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1AXV2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:28:52 -0500
Date: Mon, 24 Jan 2011 22:28:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>, tardyp@gmail.com,
        jean.pihet@newoldbits.com, acme@ghostprotocols.net,
        linux-perf-users@vger.kernel.org, mathieu.desnoyers@efficios.com,
        linux-trace-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Perf ABI versioning
Message-ID: <20110124212838.GB13724@elte.hu>
References: <201101241704.01021.trenn@suse.de>
 <20110124203449.GC2318@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124203449.GC2318@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This may be generally useful to help dealing with tracepoint ABI changes.
> 
> But instead of a global tracing ABI number, I would rather suggest one number per 
> tracepoint subsystem (sched, power, etc...).

Nooooooooooo ... !!! :-)

Please lets stop this madness before it gets too serious: we dont do ABI version 
numbering in Linux, full stop.

We use 'natural' ABIs where the lack of an ABI component triggers some sort of 
clean, finegrained error. Like a -EINVAL on a not-yet-implemented ABI component, a 
non-existent file entry, or -ENOSYS on a non-existent syscall.

Such a design is arbitrarily backportable or forward portable, it's extensible and 
it is actually maintainable.

In the ABI version numbering direction lies Windows madness ...

Thanks,

	Ingo
