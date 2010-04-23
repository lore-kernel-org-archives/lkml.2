Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0DWIFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:05:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53255 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab0DWIFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:05:25 -0400
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: Yong Zhang <yong.zhang@windriver.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <alpine.LFD.2.00.1004230907050.4151@localhost>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
	 <20100423025850.GA21328@windriver.com>
	 <alpine.LFD.2.00.1004230907050.4151@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 10:05:15 +0200
Message-ID: <1272009915.1646.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 09:24 +0200, John Kacur wrote:
> direct dependencies:                  8752 [max: 16384]
> I have
> stack-trace invocations: 10888
> from the same run.
> 
> Still trying to figure out what the meaning is of that though to be 
> honest.
> 
> Here is a portion of the lockdep_stats, with all of the new fields and the 
> redundant ones.
> 
> stack-trace invocations: 10888
>         LOCK_USED_IN_HARDIRQ: 15
>         LOCK_USED_IN_HARDIRQ_READ: 0
>         LOCK_ENABLED_HARDIRQ: 543
>         LOCK_ENABLED_HARDIRQ_READ: 28
>         LOCK_USED_IN_SOFTIRQ: 0
>         LOCK_USED_IN_SOFTIRQ_READ: 0
>         LOCK_ENABLED_SOFTIRQ: 543
>         LOCK_ENABLED_SOFTIRQ_READ: 28
>         LOCK_USED_IN_RECLAIM_FS: 5
>         LOCK_USED_IN_RECLAIM_FS_READ: 0
>         LOCK_ENABLED_RECLAIM_FS: 95
>         LOCK_ENABLED_RECLAIM_FS_READ: 8
>         LOCK_USED: 871 

8752+871+8+95+5+28+543+28+543+15=10888

So you get a stack-trace for each direct-dependency, and you get a
stack-trace for each LOCK_state, the sum seems to match the total
invocations.

Non of these numbers look strange.. 

