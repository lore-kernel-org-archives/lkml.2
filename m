Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1H3LWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:22:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51478 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1H3LWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:22:09 -0400
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
Date: Tue, 30 Aug 2011 13:21:55 +0200
In-Reply-To: <20110829233521.GK9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
	 <1314627922.2816.65.camel@twins>
	 <20110829171155.GD9748@somewhere.redhat.com>
	 <1314640155.2816.117.camel@twins>
	 <20110829175954.GF9748@somewhere.redhat.com>
	 <1314641160.2816.128.camel@twins>
	 <20110829233521.GK9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314703315.2799.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 01:35 +0200, Frederic Weisbecker wrote:
> > That means it has to be in an extended grace period when we stop the
> > tick.
> 
> You mean extended quiescent state?

Yeah that :-)

> As a summary here is what we do:
> 
> - if we are in the kernel, we can't run into extended quiescent state because
> we may make use of rcu anytime there. But if we run nohz we don't have the tick
> to notice quiescent states to the RCU machinery and help completing grace periods
> so as soon as we receive an rcu IPI from another CPU (due to the grace period
> beeing extended because our nohz CPU doesn't report quiescent states), we restart
> the tick. We are optimistic enough to consider that we may avoid a lot of ticks
> even if there are some risks to be disturbed in some random rates.
> So even with the IPI we consider it as an upside.
> 
> - if we are in userspace we can run in extended quiescent state.

But you can only disable the tick/enter extended quiescent state while
in kernel-space. Thus the second clause is precluded from ever being
true.


