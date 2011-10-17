Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1JQSux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:50:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1JQSuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:50:52 -0400
Date: Mon, 17 Oct 2011 20:49:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111017184916.GA5545@elte.hu>
References: <20111007070842.GA27555@hostway.ca>
 <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins>
 <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca>
 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <20111017045806.GA11561@elte.hu>
 <alpine.LFD.2.02.1110171101250.3240@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110171101250.3240@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

> > That simple time type could then trickle down as well: we could 
> > use it everywhere in kernel code and limit the hodge-podge of ABI 
> > time units to the syscall boundary. (and convert the internal 
> > time unit to whatever ABI unit there is close to the syscall 
> > boundary)
> > 
> > There's a point where micro-optimized 32-bit support related 
> > maintenance overhead (and the resulting loss of 
> > robustness/flexibility) becomes too expensive IMO.
> 
> That's not a micro optimization, it's a massive performance hit if 
> you force those 32bit archs to do 64/32 all over the place.

Do we have some hard data on this, which we could put into comments 
in include/linux/ktime.h and such? Older versions of GCC used to do a 
bad job of long long handling on 32-bit systems - that might be a 
factor in the performance figures.

But i suspect you are right that the cost is still very much there 
...

Thanks,

	Ingo
