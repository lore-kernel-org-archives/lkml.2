Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2KZTSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:18:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2KZTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:17:59 -0500
X-Authority-Analysis: v=2.0 cv=cuMZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0Dr-bvbIo-YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=r0ZjosXJyycA:10 a=LV9a3cBYMbjkfArauI4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353957477.6276.51.camel@gandalf.local.home>
Subject: Re: [PATCH V2 Resend 0/4] Create sched_select_cpu() and use it for
 workqueues and timers
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Viresh Kumar <viresh.kumar@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Date: Mon, 26 Nov 2012 14:17:57 -0500
In-Reply-To: <20121126190354.GJ2474@linux.vnet.ibm.com>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	 <CAKohponTxs983vVQV=6Q8zyesC1W1FhFkzfmpAVeEwU-cQXohA@mail.gmail.com>
	 <1353948027.6276.38.camel@gandalf.local.home>
	 <20121126170358.GE2474@linux.vnet.ibm.com>
	 <1353951352.6276.43.camel@gandalf.local.home>
	 <20121126190354.GJ2474@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 11:03 -0800, Paul E. McKenney wrote:
> On Mon, Nov 26, 2012 at 12:35:52PM -0500, Steven Rostedt wrote:
> > On Mon, 2012-11-26 at 09:03 -0800, Paul E. McKenney wrote:
> > 
> > 
> > > If I understand correctly (though also suffering turkey OD), the idea is
> > > to offload work to more energy-efficient CPUs.
> > 
> > This is determined by a CPU that isn't running the idle task? Is it
> > because a CPU that just woke up may be running at a lower freq, and thus
> > not as efficient? But pushing off to another CPU may cause cache misses
> > as well. Wouldn't that also be a factor in efficiencies, if a CPU is
> > stalled waiting for memory to be loaded?
> 
> Two different microarchitectures -- same instruction set (at user level,
> anyway), but different power/performance characteristics.  One set is
> optimized for performance, the other for energy efficiency.  For example,
> ARM's big.LITTLE architecture.
> 

But I don't see anything in the patch set that guarantees that we will
be moving something off to one of the "big" cores. The only heuristic
that is used is if the CPU is idle or not. In fact, if the big core was
idle we may be pushing work off to a "LITTLE" CPU.

Again, work is only run on the CPU it was queued on (which this patch
set is trying to change). Thus, only work that would be queued on a
LITTLE CPU is by something that ran on that CPU.

I'm still having a bit of trouble understanding where the benefit comes
from.

-- Steve


