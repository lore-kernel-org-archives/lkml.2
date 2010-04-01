Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab0DAQkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:40:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab0DAQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:39:57 -0400
Date: Thu, 1 Apr 2010 18:08:51 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in
 mmu_take_all_locks()
Message-ID: <20100401160851.GV5825@random.random>
References: <1270117906.1653.139.camel@laptop>
 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
 <4BB47FC3.1020606@redhat.com>
 <4BB480CC.2060503@redhat.com>
 <1270121264.1653.205.camel@laptop>
 <1270122194.1653.223.camel@laptop>
 <20100401154249.GQ5825@random.random>
 <4BB4C0F5.3070204@redhat.com>
 <1270137406.1598.78.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270137406.1598.78.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 05:56:46PM +0200, Peter Zijlstra wrote:
> I would much rather we make call_rcu_preempt() available at all times.

srcu is needed only for XPMEM to make the mmu notifier handlers
sleepable. Ignore it for now, it can be done later. The locks you're
changing are always taken _before_ the mmu notifier_range_start and
always after the mmu_notifier_range_end, so srcu can be done later...

It's orthogonal issue, but the moment these locks are sleepable it
simply worth to switch mmu notifiers to srcu to accommodate XPMEM.
