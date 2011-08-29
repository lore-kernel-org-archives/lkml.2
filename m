Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1H2Rtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:49:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:47011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1H2Rt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:49:29 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 19:49:15 +0200
In-Reply-To: <20110829171155.GD9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
	 <1314627922.2816.65.camel@twins>
	 <20110829171155.GD9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314640155.2816.117.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 19:11 +0200, Frederic Weisbecker wrote:
> On Mon, Aug 29, 2011 at 04:25:22PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > To prepare for nohz / idle logic split, pull out the rcu dynticks
> > > idle mode switching to strict idle entry/exit areas.
> > > 
> > > So we make the dyntick mode possible without always involving rcu
> > > extended quiescent state. 
> > 
> > Why is this a good thing? I would be thinking that if we're a userspace
> > bound task and we disable the tick rcu would be finished on this cpu and
> > thus the extended quiescent state is just what we want?
> 
> But we can stop the tick from the kernel, not just userspace.

Humm!? I'm confused, I thought the idea was to only stop the tick when
we're 'stuck' in a user bound task. Now I get that we have to stop the
tick from kernel space (as in the interrupt will clearly run in kernel
space), but assuming the normal return from interrupt path doesn't use
rcu, and using rcu (as per a later patch) re-enables the tick again, it
doesn't matter, right?

Also, RCU needs the tick to drive the state machine, so how can you stop
the tick and not also stop the RCU state machine?


