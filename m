Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab0EaIBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:01:04 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:52404 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab0EaIA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:00:58 -0400
Date: Mon, 31 May 2010 10:00:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
Message-ID: <20100531080049.GA435@elte.hu>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
 <1275059710.27810.9624.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275059710.27810.9624.camel@twins>
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

> On Fri, 2010-05-28 at 16:26 +0200, Frederic Weisbecker wrote:
> > We have various tracepoints that tell us when a task is going to
> > be enqueued in a runqueue: fork, wakeup, migrate.
> > 
> > But they don't always provide us the level of information necessary
> > to know what is actually in which runqueue, precisely because the
> > migrate event is only fired if the task is queued on another
> > cpu than its previous one. So we don't always know where a waking up
> > task goes.
> > 
> > And moreover we don't have events that tells a task goes to sleep,
> > and even that wouldn't cover every cases when a task is dequeued.
> > 
> > So bring these two new tracepoints to get informations about the
> > load of each runqueues.
> 
> NAK, aside from a few corner cases wakeup and sleep are the important 
> points.
> 
> The activate and deactivate functions are implementation details.

Frederic, can you show us a concrete example of where we dont know what is 
going on due to inadequate instrumentation? Can we fix that be extending the 
existing tracepoints?

	Ingo
