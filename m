Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1FOUzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:55:54 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51475 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1FOUzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:55:53 -0400
References: <1308097798.17300.142.camel@schen9-DESK> <1308134200.15315.32.camel@twins> <1308135495.15315.38.camel@twins> <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com> <20110615122435.386731e0.akpm@linux-foundation.org> <20110615201611.GB4762@elte.hu>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110615201611.GB4762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock to mutex
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 13:55:25 -0700
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Hugh Dickins <hughd@google.com>,
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
Message-ID: <d3013ec4-8102-46a9-9e0d-e7253859ea38@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar <mingo@elte.hu> wrote:
>
>perf record -g will go a long way towards such a tool already - but i 
>think it would be useful to create a more top-alike view as well. 

perf record -g doesn't help when the issue is that we're recording a single process and the actual work is being done in another unrelated process that is just being woken up.

Sure, you can do a system wide recording, but that shows all kinds of unrelated noise and requires root permissions.

So those rcu threads really need to go.

      Linus
