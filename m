Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2I0Nib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:38:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50286 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750747Ab2I0Ni3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:38:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+/EvN1Dn+/EsGQm7Q0nBWlYTZAX6HStgDBM9Lixv
	GAPRm/7mfvqf5D
Message-ID: <1348753100.7059.214.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 15:38:20 +0200
In-Reply-To: <20120927102050.GA967@liondog.tnic>
References: <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <20120926213723.GA27692@liondog.tnic>
	 <alpine.DEB.2.02.1209270013270.5162@asgard.lang.hm>
	 <20120927102050.GA967@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 12:20 +0200, Borislav Petkov wrote: 
> On Thu, Sep 27, 2012 at 12:17:22AM -0700, david@lang.hm wrote:
> > It seems to me that trying to figure out if you are going to
> > overload the L2 is an impossible task, so just assume that it will
> > all fit, and the worst case is you have one balancing cycle where
> > you can't do as much work and then the normal balancing will kick in
> > and move something anyway.
> 
> Right, and this implies that when the load balancer runs, it will
> definitely move the task away from the L2. But what do I do in the cases
> where the two tasks don't overload the L2 and it is actually beneficial
> to keep them there? How does the load balancer know that?

It doesn't, but it has task_hot().  A preempted buddy may be pulled, but
the next wakeup will try to bring buddies back together.

-Mike 


