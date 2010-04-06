Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0DFJAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:00:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab0DFJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:00:34 -0400
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1270505417-8144-1-git-send-regression-fweisbec@gmail.com>
References: <1269736197-10958-1-git-send-regression-fweisbec@gmail.com>
	 <1270505417-8144-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 10:46:27 +0200
Message-ID: <1270543587.1597.742.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 00:10 +0200, Frederic Weisbecker wrote:
> Locking statistics are implemented using global atomic variables.
> This is usually fine unless some path write them very often.
> 
> This is the case for the function and function graph tracers
> that disable irqs for each entry saved (except if the function
> tracer is in preempt disabled only mode).
> And calls to local_irq_save/restore() increment hardirqs_on_events
> and hardirqs_off_events stats (or similar stats for redundant
> versions).
> 
> Incrementing these global vars for each function ends up in too
> much cache bouncing if lockstats are enabled.
> 
> To solve this, implement the debug_atomic_*() operations using
> per cpu vars.
> 
> 

So I really have to ask, why?

This is CONFIG_DEBUG_LOCKDEP code, so its default off, and used to debug
lockdep. Debug code should be as simple as possible, and preferably
should not care about performance where possible.

So why complicate this?

