Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1FOVwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:52:05 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63873 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1FOVwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:52:01 -0400
References: <1308097798.17300.142.camel@schen9-DESK> <1308101214.15392.151.camel@sli10-conroe> <1308138750.15315.62.camel@twins> <20110615161827.GA11769@tassilo.jf.intel.com> <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK> <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com> <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
User-Agent: K-9 Mail for Android
In-Reply-To: <1308173849.15315.91.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock to mutex
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 14:51:34 -0700
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>
CC: Andi Kleen <ak@linux.intel.com>, Shaohua Li <shaohua.li@intel.com>,
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
Message-ID: <87ea4bd7-8b16-4b24-8fcb-d8e9b6f421ec@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>removing
>that sysconf() wreckage closed the gap considerably (needing to know
>the
>number of cpus to optimize locking sounds like a trainwreck all of its
>own, needing it _that_ often instead of just once at startup is even
>worse).

Yeah, I think it's ridiculous to say that glibc is not doing something stupid and that it's a problem with kernel interfaces.

Do the proc file parsing once and cache the result in a static variable. Doing it over and over again is just crazy.

Adding new system calls because glibc is crazy is insane.

       Linus

