Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab2FDLvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:51:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:55748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab2FDLvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:51:45 -0400
Message-ID: <1338810695.28282.30.camel@twins>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 13:51:35 +0200
In-Reply-To: <20120604114130.GA3386@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338800454.2448.71.camel@twins> <20120604114130.GA3386@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 17:11 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <peterz@infradead.org> [2012-06-04 11:00:54]:
> 
> > > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > 
> > Did vatsa write this patch?
> 
> I wrote the first version of the patch which Prashanth took, tested,
> fixed a bug and is finally publishing it. So yes,
> 
> > If so, you forgot a From header, if not, wtf!?
> 
> it is missing the From header.
> 
> > OK, so previously we only pulled to ourselves,
> 
> That't not entirely true isn't it i.e this_cpu need not equal
> smp_processor_id even before this change.
> 
> > now you make cpu x move
> > from cpu y to cpu z. This changes the dynamic of the load-balancer, not
> > a single word on that and its impact/ramifications.
> 
> The other possibility is for the right sibling cpus to do load balance
> in the same domain (noting that it needs to pull a task from another
> sched_group to itself and ignoring balance_cpu). That seemed like a more
> invasive change than this patch. We'd be happy to try any other approach
> you have in mind.

Thing is, first thing on Monday morning my brain don't work too fast. If
I then get to basically reverse engineer a patch because people forgot
to mention all the important bits, I get annoyed.

So don't do that ;-)
