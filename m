Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2FDOiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:38:14 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40947 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2FDOiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:38:13 -0400
Date: Mon, 4 Jun 2012 20:08:02 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604143802.GB26651@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
 <1338801907.7356.163.camel@marge.simpson.net>
 <1338810796.28282.32.camel@twins>
 <1338814063.7356.192.camel@marge.simpson.net>
 <20120604130740.GC25126@linux.vnet.ibm.com>
 <1338820234.7356.250.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338820234.7356.250.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060414-3864-0000-0000-0000032E29D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-06-04 16:30:34]:

> Yeah, this is true, it is a latency source and a fairness violation.
> Slow path balance consideration does make some sense to me.
> 
> But, if you have an RT requirement, you can't afford to mix unknown
> entities, nor over-commit etc.  A realtime application will assign all
> resources, so the load balancer becomes essentially unemployed.  No?
> Non critical worker-bees may be allowed to bounce around in say a
> cpuset, but none of the CPUs which do critical work will ever be
> over-committed, else application just lost the war.  In that regard,
> twiddling the load balancer to accommodate strange sounding case still
> seems wrong to me.

Btw the patch should help non-rt case as well (where a high
priority SCHED_OTHER is hogging cpu while low-priority SCHED_OTHER task
on that same cpu suffers as we choose not to move it to another
cpu (because of the way balance_cpu based load balance is written).

- vatsa

