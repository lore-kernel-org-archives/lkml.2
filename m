Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1FOVPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:15:35 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58551 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1FOVPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:15:34 -0400
Date: Wed, 15 Jun 2011 14:15:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from
 switching anon_vma->lock to mutex
Message-ID: <20110615211517.GI2267@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308097798.17300.142.camel@schen9-DESK>
 <1308134200.15315.32.camel@twins>
 <1308135495.15315.38.camel@twins>
 <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com>
 <20110615201216.GA4762@elte.hu>
 <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 02:05:46PM -0700, Linus Torvalds wrote:
> 
> 
> Ingo Molnar <mingo@elte.hu> wrote:
> >
> >I have this fix queued up currently:
> >
> >  09223371deac: rcu: Use softirq to address performance regression
> 
> I really don't think that is even close to enough.
> 
> It still does all the callbacks in the threads, and according to Peter, about half the rcu time in the threads remained..

I am putting together a patch that gets rid of the kthreads in the
!RCU_BOOST case.  The time will still be consumed, but in softirq
context, though of course with many fewer context switches.

							Thanx, Paul
