Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2FDLlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:41:40 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:33054 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2FDLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:41:37 -0400
Date: Mon, 4 Jun 2012 17:11:30 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604114130.GA3386@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
 <1338800454.2448.71.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338800454.2448.71.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060411-2000-0000-0000-000007CC109A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-06-04 11:00:54]:

> > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> Did vatsa write this patch?

I wrote the first version of the patch which Prashanth took, tested,
fixed a bug and is finally publishing it. So yes,

> If so, you forgot a From header, if not, wtf!?

it is missing the From header.

> OK, so previously we only pulled to ourselves,

That't not entirely true isn't it i.e this_cpu need not equal
smp_processor_id even before this change.

> now you make cpu x move
> from cpu y to cpu z. This changes the dynamic of the load-balancer, not
> a single word on that and its impact/ramifications.

The other possibility is for the right sibling cpus to do load balance
in the same domain (noting that it needs to pull a task from another
sched_group to itself and ignoring balance_cpu). That seemed like a more
invasive change than this patch. We'd be happy to try any other approach
you have in mind.

- vatsa

