Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab0EFNp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:45:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab0EFNp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:45:27 -0400
X-Authority-Analysis: v=1.1 cv=nrqrmdtKPnrEe5McJVoaEKFzY/lexCxOe+Stj/aSkNs= c=1 sm=0 a=t3i6yefhEEwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=hensROx0fS4SJqFM3KsA:9 a=bMJ-u1FBhFT9ZkueWAa1VZq2d5kA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
 from  preemption
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <n2maa79d98a1005060045ke0f87f4aw8b86da0440a019b3@mail.gmail.com>
References: <20100505150740.GB5686@lenovo> <20100505165731.GA6320@nowhere>
	 <20100505174234.GH5686@lenovo> <20100506064453.GI1172@elte.hu>
	 <w2vaa79d98a1005060039ua7dd1b0t952fcd8662d4d759@mail.gmail.com>
	 <20100506074231.GA8625@elte.hu>
	 <n2maa79d98a1005060045ke0f87f4aw8b86da0440a019b3@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 06 May 2010 09:45:24 -0400
Message-ID: <1273153525.22438.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 11:45 +0400, Cyrill Gorcunov wrote:
> On Thursday, May 6, 2010, Ingo Molnar <mingo@elte.hu> wrote:

> >> the thing are that p4 is only snippet here which is sensible to preemtion,
> >> and hw_perf_event_init is executing with preemtion off (but i could miss the
> >> details here, dont have code under my hands at moment, so PeterZ help is
> >> needed ;) but more important reason why i've saved get/put here is that
> >> otherwise i would not have rights to put tested-by tag, since it would not
> >> be the patch Steven has tested. We could make a patch on top of this one, or
> >> we could drop this one, make new with explicit preemt off in caller and use
> >> smp_processor_id in p4 schedule routine. What is preferred?
> >
> > We want the one with the least runtime overhead. These are instrumentation
> > routines, so we want to optimize them as much as possible.


Yeah, my point was either disable preemption or keep the checks. In
other words, if you don't disable preemption, do not use
raw_smp_procesor_id(), because then we will not catch it if it changes
in the future.


> ok, Ingo, dont apply this patch then for a while.

Send another patch, I'll test it again ;-)

-- Steve


