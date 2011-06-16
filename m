Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422634Ab1FPWAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:00:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:17244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161002Ab1FPWAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:00:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="14491987"
Message-ID: <4DFA7D07.2010207@linux.intel.com>
Date: Thu, 16 Jun 2011 15:00:39 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
References: <1308097798.17300.142.camel@schen9-DESK> <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins> <20110615161827.GA11769@tassilo.jf.intel.com> <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK> <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com> <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins> <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com> <1308255972.17300.450.camel@schen9-DESK> <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com> <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com>
In-Reply-To: <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, I bet it doesn't make them a non-issue, but if doing this in
> anon_vma_clone() helped a lot, then doing the exact same pattern in
> unlink_anon_vmas() hopefully helps some more.
Hi Linus,

I did essentially the same thing (just in a less elegant, more paranoid 
way) in my old
batching patches.

http://comments.gmane.org/gmane.linux.kernel.mm/63130

They made it a bit better, but overall it's still much worse than 2.6.35 
(.36 introduced the
root chain locking). I guess we'll see if it can recover mutex though, 
but I'm not
optimistic.

-Andi
