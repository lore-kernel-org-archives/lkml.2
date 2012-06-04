Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760803Ab2FDPdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:33:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55000 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760783Ab2FDPdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:33:46 -0400
Message-ID: <1338824014.28282.86.camel@twins>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 17:33:34 +0200
In-Reply-To: <20120604152522.GE26651@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338801907.7356.163.camel@marge.simpson.net>
	 <1338810796.28282.32.camel@twins>
	 <1338814063.7356.192.camel@marge.simpson.net>
	 <20120604130740.GC25126@linux.vnet.ibm.com>
	 <1338820234.7356.250.camel@marge.simpson.net>
	 <20120604143802.GB26651@linux.vnet.ibm.com>
	 <1338820895.7356.252.camel@marge.simpson.net>
	 <20120604150040.GD25126@linux.vnet.ibm.com>
	 <1338823271.28282.75.camel@twins>
	 <20120604152522.GE26651@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 20:55 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <peterz@infradead.org> [2012-06-04 17:21:11]:
> 
> > That is not to say you couldn't contrive a scenario where it would be
> > needed.. 
> 
> Right ..what if B0. B1 are pinned? !! I think most of the current
> weakness lies in handling tasks that have affinity set.

Yeah, affinity is a pain.. the whole group_imb crap is due to that as
well.

Now I'm not as opposed to this as Mike is, the load cpu_power thing can
also happen due to excessive IRQ time, and hopefully we'll get to have
an unpriv. SCHED_DEADLINE at some point as well.

But we should try to keep the stuff reasonably sane and very much
consider the worst case compute time of the load-balancer. All that redo
logic can be triggered on purpose.

Thing is, you can create an arbitrary hard problem by creating lots of
tasks with tricky masks, we shouldn't bend over backwards trying to
solve it just because.

[ Also, I suspect I wrecked the ALL_PINNED muck, shouldn't we reset
env.loop_break? ]


