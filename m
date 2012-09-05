Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab2IERJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:09:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:57743 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2IERJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:09:18 -0400
Message-ID: <1346864947.2600.33.camel@twins>
Subject: Re: lockdep WARNING for run_timer_softirq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Sep 2012 19:09:07 +0200
In-Reply-To: <1346854836.27919.51.camel@gandalf.local.home>
References: <20120831072149.GA7821@localhost>
	 <1346845644.2461.27.camel@laptop>
	 <1346854836.27919.51.camel@gandalf.local.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 10:20 -0400, Steven Rostedt wrote:
> Well, the branch tracer was active. That means all 'if()'s were being
> traced. It comes down to how you define 'if' ;-) 

Yeah, I tried making an argument for:

  we tell lockdep irqs are enabled hit an if() end up in lockdep code
through the branch tracer and find borken state, or vice-versa.

Just couldn't find it in the provided stack-trace. Might be I didn't
look hard enough, might be there's something else entirely.

All I know is I've never seen it on real hardware, then again, I hardly
ever have CONFIG_PARAVIRT or CONFIG_TRACE_BRANCH_PROFILING, let alone
both.


