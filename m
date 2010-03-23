Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0CWS1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:27:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0CWS1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:27:47 -0400
Date: Tue, 23 Mar 2010 19:27:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org, ant.starikov@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bugme-new] [Bug 15618] New: 2.6.18->2.6.32->2.6.33 huge
 regression in performance
Message-ID: <20100323182735.GA10897@elte.hu>
References: <bug-15618-10286@https.bugzilla.kernel.org/>
 <20100323102208.512c16cc.akpm@linux-foundation.org>
 <20100323173409.GA24845@elte.hu>
 <20100323111351.756c8752.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323111351.756c8752.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Mar 2010 18:34:09 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > It shows a very brutal amount of page fault invoked mmap_sem spinning 
> > overhead.
> > 
> 
> Yes.  Note that we fall off a cliff at nine threads on a 16-way.  As soon as 
> a core gets two threads scheduled onto it?

it's AMD Opterons so no SMT.

My (wild) guess would be that 8 cpus can still do cacheline ping-pong 
reasonably efficiently, but it starts breaking down very seriously with 9 or 
more cores bouncing the same single cache-line.

Breakdowns in scalability are usually very non-linear, for hardware and 
software reasons. '8 threads' sounds like a hw limit to me. From the scheduler 
POV there's no big difference between 8 or 9 CPUs used [this is non-HT] - with 
8 or 7 cores still idle.

	Ingo
