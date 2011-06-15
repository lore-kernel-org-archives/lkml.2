Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab1FOQs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:48:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:21387 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1FOQs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:48:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,370,1304319600"; 
   d="scan'208";a="13897275"
Date: Wed, 15 Jun 2011 09:47:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shaohua Li <shaohua.li@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
Message-ID: <20110615164708.GB12162@tassilo.jf.intel.com>
References: <1308097798.17300.142.camel@schen9-DESK>
 <1308101214.15392.151.camel@sli10-conroe>
 <1308138750.15315.62.camel@twins>
 <20110615161827.GA11769@tassilo.jf.intel.com>
 <1308156337.2171.23.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308156337.2171.23.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 06:45:37PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-15 at 09:18 -0700, Andi Kleen wrote:
> 
> > And in general it looks like blind conversion from spinlock to mutex
> > is a bad idea right now.
> 
> For 4 socket machines, maybe. On 2 sockets I cannot reproduce anything.

With only one other guy active a lot of things are quite a bit easier. 
Basically 2S is a trivial case here.

> I wonder if its the fairness thing, the mutex spinners aren't fifo fair

The Intel 4S systems are fair, but ticketing still helps significantly 
because it has a lot nicer interconnect behaviour.

> like the ticket locks are. It could be significant with larger socket
> count since their cacheline arbitration is more sucky.

It gets a bit better with the patch I sent earlier to read the count
first, but yes it's a problem. However I'm not sure that even
with that fixed mutexes will be as good as plain ticket locks.

Also certainly it's no short term fix for 3.0. Right now 
we still have this terrible regression.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
