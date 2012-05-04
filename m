Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab2EDQJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:09:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:57676 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970Ab2EDQJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:09:45 -0400
Message-ID: <1336147765.6509.41.camel@twins>
Subject: Re: [RFC][PATCH 1/5] sched, fair: Let minimally loaded cpu balance
 the group
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, efault@gmx.de, linux-kernel@vger.kernel.org
Date: Fri, 04 May 2012 18:09:25 +0200
In-Reply-To: <1336089945.28674.460.camel@sbsiddha-desk.sc.intel.com>
References: <20120501181430.007891123@chello.nl>
	 <20120501182610.745844312@chello.nl>
	 <20120502102541.GA22740@linux.vnet.ibm.com>
	 <1335954690.13683.178.camel@twins>
	 <20120502103453.GB22740@linux.vnet.ibm.com>
	 <1336089945.28674.460.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 17:05 -0700, Suresh Siddha wrote:
> On Wed, 2012-05-02 at 16:04 +0530, Srivatsa Vaddagiri wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-05-02 12:31:30]:
> > 
> > > > IOW :
> > > > 
> > > > 		balance_load = 0 iff idle_cpu(i) ??
> > > 
> > > I think so, even for !0 load_idx, load will only reach zero when we're
> > > idle, just takes longer.
> > 
> > Right ...so should we force it to select a idle_cpu by having
> > balance_load = 0 for a idle cpu (ignoring what target_load(i, load_idx)
> > told us as its load?
> 
> I think Peter is trying to find the leastly loaded among idle cpu's (in
> other words the longest idle cpu ;)

Nah, Peter isn't trying to do anything smart like that, he's just trying
to pick the least loaded when they're all busy or any idle otherwise.

Afaict the code as it is today is the worst possible choice, always
picking the same (first) will result in that one being the busiest at
all times.

I mean anything will converge (eventually) due to the lower levels
spreading load again, but by pulling to the idlest it should converge
faster.

Picking a random cpu would also work.
