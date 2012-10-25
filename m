Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2JYNS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:18:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:51516 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab2JYNJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:09:29 -0400
Message-Id: <20121025121617.617683848@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 25 Oct 2012 14:16:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 00/31] numa/core patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a re-post of the NUMA scheduling and migration improvement
patches that we are working on. These include techniques from
AutoNUMA and the sched/numa tree and form a unified basis - it
has got all the bits that look good and mergeable.

With these patches applied, the mbind system calls expand to
new modes of lazy-migration binding, and if the
CONFIG_SCHED_NUMA=y .config option is enabled the scheduler
will automatically sample the working set of tasks via page
faults. Based on that information the scheduler then tries
to balance smartly, put tasks on a home node and migrate CPU
work and memory on the same node.

They are functional in their current state and have had testing on
a variety of x86 NUMA hardware.

These patches will continue their life in tip:numa/core and unless
there are major showstoppers they are intended for the v3.8
merge window.

We believe that they provide a solid basis for future work.

Please review .. once again and holler if you see anything funny! :-)


