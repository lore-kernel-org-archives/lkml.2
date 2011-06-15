Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1FOWPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:15:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:29164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1FOWPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,371,1304319600"; 
   d="scan'208";a="15290112"
Message-ID: <4DF92F04.6000704@linux.intel.com>
Date: Wed, 15 Jun 2011 15:15:32 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tim Chen <tim.c.chen@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
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
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
References: <1308097798.17300.142.camel@schen9-DESK>	 <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins>	 <20110615161827.GA11769@tassilo.jf.intel.com>	 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>	 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>	 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
In-Reply-To: <1308173849.15315.91.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(needing to know the
> number of cpus to optimize locking sounds like a trainwreck all of its
> own, needing it _that_ often instead of just once at startup is even
> worse).

libdb does it only once per startup, it's just that it gets restarted 
for every
child (it's a library, not a server)

Really the kernel just needs to provide a faster way to get that.
Requiring /proc/stat for that is just insane.

I'll resend the sysconf patchkit I guess :-)

-Andi


