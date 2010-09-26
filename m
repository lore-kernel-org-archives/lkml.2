Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0IZQYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 12:24:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0IZQYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 12:24:10 -0400
Date: Sun, 26 Sep 2010 18:23:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
Message-ID: <20100926162349.GA21557@elte.hu>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
 <1284116817.402.33.camel@laptop>
 <20100910172805.a4fe5c7f.akpm@linux-foundation.org>
 <20100926084233.GA28809@elte.hu>
 <20100926125945.GA2597@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100926125945.GA2597@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Sun, Sep 26, 2010 at 10:42:33AM +0200, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > Maybe.  Or maybe it papers over a scheduler bug by gratuitously adding 
> > > additional code which no present callsites actually need.
> > 
> > Hm, indeed.
> > 
> > We now have the scheduler bug fixed upstream. Do we really need this 
> > patch?
> 
> General consensus was that it is good if smp_call_function_single() 
> and __smp_call_function_single() would behave the same if remote cpu 
> == current cpu.
> 
> If you're not applying this patch then at least at a WARN_ON() which 
> triggers when remote cpu == current cpu. I don't want to debug 
> something like this again.

Would be nice to hear from Andrew whether he's still opposed to this 
patch. I've got the patch queued up, but dont want to send it to Linus 
against Andrew's objections.

> > > The patch didn't update the __smp_call_function_single() 
> > > kerneldoc. Compare it with smp_call_function_single() and note the 
> > > subtle difference between "a specific CPU" and the now incorrect 
> > > "on another CPU".
> > 
> > In any case this feedback didnt get addressed AFAICS.
> 
> It did get addressed in an updated patch which is the one which you 
> applied: http://lkml.org/lkml/2010/9/10/245

Indeed :-)

Thanks,

	Ingo
