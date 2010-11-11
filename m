Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0KKETZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:19:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58828 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab0KKETY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:19:24 -0500
Date: Wed, 10 Nov 2010 20:19:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        houston.jim@comcast.net
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101111041920.GD3134@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
 <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289410271.2084.25.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 06:31:11PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 16:54 +0100, Frederic Weisbecker wrote:
> > run the sched tick and if there was nothing to do
> > for some time and we are in userspace, deactivate it. 
> 
> Not for some time, immediately, have the tick track if it was useful, if
> it was not, have it stop itself, like:
> 
> tick()
> {
>  int stop = 1;
> 
>  if (nr_running > 1)
>   stop = 0;
> 
>  if(rcu_needs_cpu())
>   stop = 0;
> 
>  ...
> 
> 
>  if (stop)
>   enter_nohz_mode();
> }

I am still holding out for a dyntick-hpc version of RCU that does not
need the tick.  ;-)

							Thanx, Paul
