Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab1FQSO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:14:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:41530 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1FQSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:14:25 -0400
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <BANLkTim3vo0vpovV=5sU=GLxkotheB=Ryg@mail.gmail.com>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins>
	 <20110615161827.GA11769@tassilo.jf.intel.com>
	 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
	 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
	 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
	 <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com>
	 <1308255972.17300.450.camel@schen9-DESK>
	 <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com>
	 <BANLkTi=GPtwjQ-bYDNUYCwzW5h--y86Law@mail.gmail.com>
	 <BANLkTim-dBjva9w7AajqggKT3iUVYG2euQ@mail.gmail.com>
	 <BANLkTimLV8aCZ7snXT_Do+f4vRY0EkoS4A@mail.gmail.com>
	 <BANLkTinUBTYWxrF5TCuDSQuFUAyivXJXjQ@mail.gmail.com>
	 <1308310080.2355.19.camel@twins>
	 <BANLkTim2bmPfeRT1tS7hx2Z85QHjPHwU3Q@mail.gmail.com>
	 <alpine.LSU.2.00.1106171040460.7018@sister.anvils>
	 <BANLkTim3vo0vpovV=5sU=GLxkotheB=Ryg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 20:18:08 +0200
Message-ID: <1308334688.12801.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 11:01 -0700, Linus Torvalds wrote:

> So I do think that "page_referenced_anon()" should do a trylock, and
> return "referenced" if the trylock fails. Comments?

The only problem I can immediately see with that is when a single
process' anon memory is dominant, then such an allocation will never
succeed in freeing these pages because the one lock will pin pretty much
all anon. Then again, there's always a few file pages to drop.

That said, its rather unlikely, and iirc people were working on removing
direct reclaim, or at least rely less on it.



