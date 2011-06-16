Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1FPBH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 21:07:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:21588 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab1FPBH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 21:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,372,1304319600"; 
   d="scan'208";a="15354059"
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <ak@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
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
In-Reply-To: <1308173849.15315.91.camel@twins>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins>
	 <20110615161827.GA11769@tassilo.jf.intel.com>
	 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
	 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
	 <1308172336.17300.177.camel@schen9-DESK>  <1308173849.15315.91.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jun 2011 18:08:28 -0700
Message-ID: <1308186508.17300.423.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 23:37 +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-15 at 14:12 -0700, Tim Chen wrote:
> > Thanks to Andi for providing the info.  We've used this workaround in
> > our testing so it will not mask true kernel scaling bottlenecks.
> 
> 
> http://programming.kicks-ass.net/sekrit/39-2.txt.bz2
> http://programming.kicks-ass.net/sekrit/tip-2.txt.bz2
> 
> tip+sirq+linus is still slightly faster than .39 here, although removing
> that sysconf() wreckage closed the gap considerably (needing to know the
> number of cpus to optimize locking sounds like a trainwreck all of its
> own, needing it _that_ often instead of just once at startup is even
> worse).
> 

Peter,

Fengguang's readahead fixes for tmpfs removed another bottleneck before
anon_vma->lock become dominant. https://lkml.org/lkml/2011/4/26/143)
We've found this issue when we were testing exim earlier.
It was merged in 3.0-rc2 but not in plain 2.6.39.  So with this patch on
2.6.39 we should get better comparison with 3.0-rc2.

Thanks.

Tim  


