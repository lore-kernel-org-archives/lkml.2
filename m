Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1D1Xas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 19:30:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:37698 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab1D1Xar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 19:30:47 -0400
Date: Fri, 29 Apr 2011 01:30:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vweaver1@eecs.utk.edu>
cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
In-Reply-To: <alpine.DEB.2.00.1104281811400.25779@cl320.eecs.utk.edu>
Message-ID: <alpine.LFD.2.02.1104290022590.3005@ionos>
References: <1303407662-15564-1-git-send-email-acme@infradead.org> <1303407662-15564-2-git-send-email-acme@infradead.org> <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu> <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu> <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu> <20110426073847.GB30630@elte.hu> <alpine.DEB.2.00.1104261648400.32482@cl320.eecs.utk.edu> <20110427065241.GF17079@elte.hu>
 <alpine.DEB.2.00.1104281811400.25779@cl320.eecs.utk.edu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

On Thu, 28 Apr 2011, Vince Weaver wrote:

> On Wed, 27 Apr 2011, Ingo Molnar wrote:
> 
> > Secondly, you are still quite wrong even with your revised opinion. Being able 
> > to type '-e cycles' and '-e instructions' in perf and get ... cycles and 
> > instructions counts/events, and the kernel helping that kind of approach is not 
> > 'abstraction to the extreme', it's called 'common sense'.
> 
> by your logic I should be able to delete a file by saying
>   echo "delete /tmp/tempfile" > /dev/sdc1
> because using unlink() is too low of an abstraction and confusing to the 
> user.

Your definition of 'common sense' seems to be rather backwards.

> > The fact that perfmon and oprofile works via magic vendor-specific event string 
> > incantations is one of the many design failures of those projects - not a 
> > virtue.
> 
> Well we disagree.  I think one of perf_events biggest failings (among 
> many) is that these generalized event definitions are shoved into the 

Put the failings on the table if you think there are any real
ones.

The generalized event definitions are debatable, but Ingo's argument
that they fulfil the common sense level is definitely a strong enough
one to keep them.

The problem at hand which ignited this flame war is definitely
borderline and I don't agree with Ingo that it should not made be
available right now in the raw form. That's an hardware enablement
feature which can be useful even if tools/perf has not support for it
and we have no generalized event for it. That's two different
stories. perf has always allowed to use raw events and I don't see a
reason why we should not do that in this case if it enables a subset
of the perf userbase to make use of it.

> kernel.  At least it bloats the kernel in an option commonly turned on by 

Well compared to the back then proposed perfmon kernel bloat, that's
really nothing you should whine about.

> vendors.  At worst it gives users a full sense of security in thinking 
> these counters are A). Portable across architectures and B). Actually 
> measure what they say they do.

Again, in the common sense approach they actually do what they
say. 

For real experts like you there are still the raw events to get the
real thing which is meaningful for those who understand what 'cycles'
and 'instructions' really mean. Cough, cough....

> I know it is fun to reinvent the wheel, but you ignored decades of 
> experience in dealing with perf-counters when you ran off and invented 
> perf_events.  It will bite you eventually.

Stop this whining already. I thoroughly reviewed the outcome of
"decades of experience" and I still shudder when I get reminded of
that exercise.

Yes, we invented perf_events because the proposed perfmon kernel
patches were an outright horror full of cobbled together experience
dump along with a nice bunch of unfixable security holes, locking
issues and permisson problems plus a completely nonobvious userspace
interface. Short a complete design failure.

So perf_events were not the reinvention of the wheel. It was a sane
design decision to make performance counters available _AND_ useful
for a broad audience and a broad range of use cases.

If the only substantial complaint about perf you can bring up is the
detail of generalized events, then we can agree that we disagree and
stop wasting electrons right now.

Thanks,

	tglx
