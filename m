Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab2FUDlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:41:44 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46394 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab2FUDlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:41:42 -0400
Date: Thu, 21 Jun 2012 09:10:59 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] sched: balance_cpu to consider other cpus in its
 group as target of (pinned) task
Message-ID: <20120621034059.GA9748@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FE06CDB.2060605@linux.vnet.ibm.com>
 <1340213901.21745.122.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1340213901.21745.122.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12062103-4790-0000-0000-00000354B368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-06-20 19:38:21]:

> On Tue, 2012-06-19 at 17:43 +0530, Prashanth Nageshappa wrote:
> > T2 will starve eternally in this case. The same
> > scenario can arise in presence of non-rt tasks as well (say we replace F1 with
> > high irq load or with a very high priority SCHED_OTHER task that can't move out
> > of C2). 
> 
> Uhm, no. In the case where both F1 and T2 are SCHED_OTHER starvation is
> impossible.
> 
> What can happen with pure SCHED_OTHER affinities is being less fair than
> desired.

Right ..sorry should have made that more explicit in the description.

> Anyway, I took the patch with a few minor edits

Thanks!

> -- ie. we don't need to
> reset loop_break, its never changed (same for the ALL_PINNED patch you
> sent).

Hmm ..I can see loop_break being incremented here:

                /* take a breather every nr_migrate tasks */
                if (env->loop > env->loop_break) {
                        env->loop_break += sched_nr_migrate_break;
                        env->flags |= LBF_NEED_BREAK;
                        goto out;
                }

As a result, when we redo with a different src_cpu, both loop and
loop_break could be at non-default values.  Am I missing something here?

- vatsa

