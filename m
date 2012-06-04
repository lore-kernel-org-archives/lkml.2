Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab2FDNHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:07:51 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35991 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FDNHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:07:49 -0400
Date: Mon, 4 Jun 2012 18:37:41 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604130740.GC25126@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
 <1338801907.7356.163.camel@marge.simpson.net>
 <1338810796.28282.32.camel@twins>
 <1338814063.7356.192.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338814063.7356.192.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060413-9574-0000-0000-0000030A1FF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2012-06-04 14:47:43]:

> You need a good reason to run RT, and being able to starve others to
> death ain't it, so I don't see a good reason to care about the 95% case
> enough to fiddle with load balancing to accommodate the oddball case.

While starvation of SCHED_OTHER task was an extreme case, the point
remains that SCHED_OTHER tasks are better served by moving them away
from cpus running rt tasks that are partially cpu intensive. While the
current code has the nuts and bolts to recognize this situation
(scale_rt_power), it fails to effect SCHED_OTHER task movement because of how
one cpu from a sched_group is designated to pull tasks on behalf of its
siblings and that chosen balance_cpu may not be in the task's cpus_allowed mask
(but the task can run on one or more of its sibling cpus).

- vatsa

