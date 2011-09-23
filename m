Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1IWOIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:08:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:33727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab1IWOIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:08:12 -0400
Subject: Re: [PATCH 19/21] tracing: Account for preempt off in
 preempt_schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 23 Sep 2011 16:07:49 +0200
References: <20110922220935.537134016@goodmis.org>
	 <20110922221029.678324653@goodmis.org>  <1316775648.9084.1.camel@twins>
	 <1316776749.29966.156.camel@gandalf.stny.rr.com>
	 <1316776936.9084.5.camel@twins>
	 <1316780676.29966.184.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316786869.9084.42.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 16:00 +0200, Peter Zijlstra wrote:
> 
> Wouldn't it be much more sensible to mark all that preempt/irq fiddling
> in the idle path with _notrace instead? And stick a comment near.
> 
> Having two things to do the same thing just doesn't make sense.

That is, it seems to me avoiding the idle path is seen as a non-preempt
region is cleaner than (mostly) fixing it up.
