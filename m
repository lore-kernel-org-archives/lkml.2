Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab1ITDRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:17:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab1ITDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:17:49 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=Kp9ooNmR4kA3jbtXADwA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <1316488378.29966.35.camel@gandalf.stny.rr.com>
References: <20110919212040.745370781@goodmis.org>
	 <m2ehzcdkf2.fsf@firstfloor.org>
	 <1316488378.29966.35.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 19 Sep 2011 23:17:46 -0400
Message-ID: <1316488666.29966.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 23:12 -0400, Steven Rostedt wrote:

> Actually, that's part of the issue. RT has made spin_locks not migrate.
> But this has also increased the overhead of those same spinlocks. I'm
> hoping to do away with the big hammer approach (although Thomas is less
> interested in this). I would like to have areas that require per-cpu
> variables to be annotated, and not have every spinlock disable
> preemption.
> 

The point is, if I do make this change. It is even more essential that I
detect the preempt enable use of this_cpu() and friends. As the
spin_locks() will no longer be giving that guarantee.

-- Steve


