Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820Ab2FDPqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:46:17 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36475 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2FDPqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:46:16 -0400
Date: Mon, 4 Jun 2012 21:16:09 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
Message-ID: <20120604154609.GF25126@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1338810796.28282.32.camel@twins>
 <1338814063.7356.192.camel@marge.simpson.net>
 <20120604130740.GC25126@linux.vnet.ibm.com>
 <1338820234.7356.250.camel@marge.simpson.net>
 <20120604143802.GB26651@linux.vnet.ibm.com>
 <1338820895.7356.252.camel@marge.simpson.net>
 <20120604150040.GD25126@linux.vnet.ibm.com>
 <1338823271.28282.75.camel@twins>
 <20120604152522.GE26651@linux.vnet.ibm.com>
 <1338824014.28282.86.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1338824014.28282.86.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060415-5816-0000-0000-000002FFBFEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-06-04 17:33:34]:

> Now I'm not as opposed to this as Mike is, the load cpu_power thing can
> also happen due to excessive IRQ time,

Yes good point.

> Thing is, you can create an arbitrary hard problem by creating lots of
> tasks with tricky masks, we shouldn't bend over backwards trying to
> solve it just because.

Agreed. The change proposed here however seems simple enough to warrant
consideration?

> [ Also, I suspect I wrecked the ALL_PINNED muck, shouldn't we reset
> env.loop_break? ]

Yeah I think so. That was one of the bug we had in first version of the
patch (where we had not reset loop_break and redo was failing to pull task 
because of that).

- vatsa

