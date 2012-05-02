Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2EBKbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:31:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:48024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2EBKbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:31:44 -0400
Message-ID: <1335954690.13683.178.camel@twins>
Subject: Re: [RFC][PATCH 1/5] sched, fair: Let minimally loaded cpu balance
 the group
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: mingo@kernel.org, pjt@google.com, suresh.b.siddha@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org
Date: Wed, 02 May 2012 12:31:30 +0200
In-Reply-To: <20120502102541.GA22740@linux.vnet.ibm.com>
References: <20120501181430.007891123@chello.nl>
	 <20120501182610.745844312@chello.nl>
	 <20120502102541.GA22740@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 15:55 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-05-01 20:14:31]:
> 
> > @@ -3795,12 +3796,11 @@ static inline void update_sg_lb_stats(st
> > 
> >  		/* Bias balancing toward cpus of our domain */
> >  		if (local_group) {
> > -			if (idle_cpu(i) && !first_idle_cpu) {
> > -				first_idle_cpu = 1;
> > +			load = target_load(i, load_idx);
> > +			if (load < balance_load || idle_cpu(i)) {
> > +				balance_load = load;
> 
> Let's say load_idx != 0 (ex: a busy cpu doing this load balance). In
> that case, for a idle cpu, we could return non-zero load and hence this
> would fail to select such a idle cpu? 

Yep, such is the nature of !0 load_idx.

> IOW :
> 
> 		balance_load = 0 iff idle_cpu(i) ??

I think so, even for !0 load_idx, load will only reach zero when we're
idle, just takes longer.
