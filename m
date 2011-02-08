Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1BHML5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:11:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38003 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab1BHML4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:11:56 -0500
Date: Tue, 8 Feb 2011 13:11:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /proc/<pid>/sched should contain cumulative data for all
 threads in process
Message-ID: <20110208121144.GA7550@elte.hu>
References: <4D50723B.7020400@genband.com>
 <1297156865.13327.57.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297156865.13327.57.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2011-02-07 at 16:29 -0600, Chris Friesen wrote:
> > Hi,
> > 
> > We've got a tool that gathers lots of scheduling data for each process
> > (not task/thread) on the system.
> > 
> > For /proc/<pid>/{stat,io} this is straightforward, as the per-thread
> > values are summed together for the process as a whole.
> > 
> > However, /proc/<pid>/sched only shows the data for the individual thread
> > with the same tid as the pid.  To get a per-process view we need to
> > manually scan all the threads and sum them--and this can get expensive
> > due to all the extra file operations, parsing, etc.
> > 
> > Was this a concious design decision, or just an oversight?  Would a
> > patch converting it to whole-process values be accepted or is it enough
> > of a standard interface that we can't break existing apps that expect
> > the current behaviour?
> 
> I'd as soon remove all that stuff than extend it, its an abi liability,
> esp since you're talking about tools parsing this stuff.

So assuming a tool would want to capture such stats of the system, what would be its 
options? Could we do all this via system-wide counters and perf stat alike cheap, 
transparent gathering without having to patch/rebuild the kernel?

Thanks,

	Ingo
