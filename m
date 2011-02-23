Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1BWFcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:32:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57822 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750939Ab1BWFcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:32:04 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+gdmB/pM6g1lmybMVG9gFLSIetws1LgjS3k7aGJp
	8FKCYEg4ewv2kW
Subject: Re: [PATCH 1/2] sched: allow SCHED_BATCH to preempt SCHED_IDLE
 tasks
From: Mike Galbraith <efault@gmx.de>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        richard.purdie@linuxfoundation.org
In-Reply-To: <1298434854.7856.24.camel@marge.simson.net>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
	 <1298408674-3130-2-git-send-email-dvhart@linux.intel.com>
	 <1298434854.7856.24.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 06:31:58 +0100
Message-ID: <1298439118.7856.80.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 05:20 +0100, Mike Galbraith wrote:
> On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
> > Perform the test for SCHED_IDLE before testing for SCHED_BATCH (and ensure idle
> > tasks don't preempt idle tasks) so the non-interactive, but still important,
> > SCHED_BATCH tasks will run in favor of the very low priority SCHED_IDLE tasks.
> 
> Yeah, that could be construed as a fairness fix for light SCHED_BATCH vs
> a heavy SCHED_IDLE.  It should lower latencies for both when mixed.

Hm.  Seems SCHED_IDLE _always_ being preempted is a potential terminal
starvation bug though, unless preempt_tick() checks spread to guarantee
that the preempted task will eventually get the CPU back, even in the
face of massive non-idle wakeup driven load.. which it does not.  (idle
task holds resource?)

Maybe my imagination has had too much java though.

	-Mike

