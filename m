Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab1FOLxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 07:53:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:35072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1FOLxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 07:53:49 -0400
Subject: Re: REGRESSION: Performance regressions from switching
 anon_vma->lock to mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
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
        Namhyung Kim <namhyung@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1308101214.15392.151.camel@sli10-conroe>
References: <1308097798.17300.142.camel@schen9-DESK>
	 <1308101214.15392.151.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Jun 2011 13:52:30 +0200
Message-ID: <1308138750.15315.62.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 09:26 +0800, Shaohua Li wrote:

> On Wed, 2011-06-15 at 08:29 +0800, Tim Chen wrote:
> >          + 7.30% anon_vma_clone_batch

> what are you testing? I didn't see Andi's batch anon->lock for fork
> patches are merged in 2.6.39. 

Good spot that certainly isn't plain .39.

It looks like those (http://marc.info/?l=linux-mm&m=130533041726258) are
similar to Linus' patch, except Linus takes the hard line that the root
lock should stay the same. Let me try Linus' patch first to see if this
workload can trigger his WARN.

/me mutters something about patches in attachments and rebuilds.

OK, the WARN doesn't trigger, but it also doesn't improve things (quite
the opposite in fact):

-tip            260.092 messages/sec/core
    +sirq-rcu   271.078 messages/sec/core
    +linus      262.435 messages/sec/core

So Linus' patch makes the throughput drop from 271 to 262, weird.

/me goes re-test without the sirq-rcu bits mixed in just to make sure.
