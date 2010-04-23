Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0DWF0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:26:14 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34975 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755692Ab0DWF0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:26:11 -0400
Date: Fri, 23 Apr 2010 07:26:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davej@redhat.com" <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100423052601.GA1333@ucw.cz>
References: <20100418115949.7b743898@infradead.org>
 <201004191009.56859.tvrtko.ursulin@sophos.com>
 <20100419064617.519eb384@infradead.org>
 <201004191629.39339.tvrtko.ursulin@sophos.com>
 <20100419174702.635ddad1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419174702.635ddad1@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-04-19 17:47:02, Arjan van de Ven wrote:
> On Mon, 19 Apr 2010 16:29:39 +0100
> Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> 
> > On Monday 19 Apr 2010 14:46:17 Arjan van de Ven wrote:
> > > On Mon, 19 Apr 2010 10:09:55 +0100
> > > > Or in other words, does a pure IO workload benefit from now higher
> > > > selected frequency?
> > >
> > > no.
> > > Mixed workloads do.
> > > but pure IO workloads also don't suffer since while idle, the
> > > voltage goes down anyway.
> > 
> > You mean that higher frequency does not have effect on power use if
> > CPU is idle? Is that true for all/most processors?
> 
> this is true for most processors that I'm aware of.
> there's exceptions for things like where the idle time is really short,

Is not that exactly what will happen for 'cat /dev/<usb1>' case?

Plus I suspect that older cpus are slower at changing voltages, and
slower at powering down when idle...

> > How and where in the code and how to enable that behaviour? From my
> > experiments frequency goes down to minimum as soon as load goes away.
> > What I was talking about is gradual lowering over a configurable
> > period. It is not power efficient, but it could be good for latency
> > in some workloads.
> 
> it's not even good for that ;-(
> 
> it's better then to stay high longer... at least on modern machines the
> inbetween states are pretty much either useless or actually energy
> hurting compared to the higher state.

So what about hiding those from ondemand on modern hw?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
