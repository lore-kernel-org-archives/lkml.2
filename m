Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1EFKXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:23:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59818 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1EFKXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:23:00 -0400
Date: Fri, 6 May 2011 12:22:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110506102232.GA11036@elte.hu>
References: <m2oc3jxgtt.fsf@firstfloor.org>
 <1304564090.2943.36.camel@work-vm>
 <1304574244.32152.666.camel@edumazet-laptop>
 <1304576495.2943.40.camel@work-vm>
 <1304604284.3032.78.camel@edumazet-laptop>
 <alpine.LFD.2.02.1105051630390.3005@ionos>
 <1304608095.3032.95.camel@edumazet-laptop>
 <alpine.LFD.2.02.1105051750540.3005@ionos>
 <20110505210118.GI2925@one.firstfloor.org>
 <alpine.LFD.2.02.1105061117220.3005@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105061117220.3005@ionos>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 5 May 2011, Andi Kleen wrote:
> 
> > > > Another idea would be to prime cache lines to be dirtied in cpu cache
> > > > before taking locks, and better pack variables to reduce number of cache
> > > > lines.
> > > 
> > > Most variables are packed already in struct timekeeper, which should
> > > be pretty cache hot anyway, so I don't know whether we gain much.
> > 
> > There's actually some potential here. I got a moderate speedup in a
> > database benchmark with this patch recently. The biggest win
> 
> Numbers please.

I'd suggest to create and publish a seqlock usage worst-case testcase, 
something that runs N threads on an N CPU system.

Then precise measurements have to be done on the source of cache misses, the 
total cost of the timer interrupt, etc.

I.e. this should be analyzed and improved properly, not just sloppily slapping 
a few prefetches here and there, which wont really *solve* anything ...

Thanks,

	Ingo
