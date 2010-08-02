Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0HBLRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 07:17:40 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63664 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab0HBLRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 07:17:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABtFVkx5Ld2l/2dsb2JhbACgDHK/AYU5BA
Date: Mon, 2 Aug 2010 19:59:47 +1000
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/19] perf record: Release resources at exit
Message-ID: <20100802095947.GA9427@amd>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
 <1280711334-30000-12-git-send-email-acme@infradead.org>
 <20100802073009.GB7841@amd>
 <20100802075422.GA24085@elte.hu>
 <20100802080353.GA8713@amd>
 <20100802091714.GA6781@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802091714.GA6781@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 11:17:14AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Mon, Aug 02, 2010 at 09:54:22AM +0200, Ingo Molnar wrote:
> > > 
> > > * Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > That's certainly true but there's no valgrind crappiness here: valgrind simply 
> > > can do a better job of finding leaks if there's a well defined "all resources 
> > > the app still knows about are freed now" point.
> > 
> > "noise" sounds like false positives though. [...]
> 
> Every predictive bug detection scheme is open to the potential of false 
> positives. I've yet to see a complex one that is 100% false positive free.

So long as false positive noise can be easily avoided in running
of the automated testing -- ie. not worked around in the software --
then this is totally fine of course.

 
> > [...] Certainly if this is instead allows valgrind to run in a particular 
> > mode that assumes no application resources consumed at exit(2) time, I 
> > wouldn't call it crappy :)
> 
> Most apps free their stuff before they exit - i do it in all my own C apps.
> 
> That is generally useful: for example it makes it easier to thread a program 
> later on - when exit() becomes pthread_exit() and a silent leak turns into a 
> real leak.
> 
> Hence Valgrind checking for exit() by default looks useful to me.

Sure, most of the time I would too (in fact, all the time seeing as
I don't write non-trivial user programs). But when you're doing last
pass optimisations, it would be very reasonable to avoid things like
teardown of complex data structures.

 
> > But you could equally sprinkle in other valgrind specific annotations or 
> > semantics at various points in the code to improve its coverage, no?
> 
> Yeah, and exit() sounds like a pretty convenient point, right? That's the 
> point where all resources are inactive hence a scan for leaks is expected to 
> be the most efficient in finding real leaks.

