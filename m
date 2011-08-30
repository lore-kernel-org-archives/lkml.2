Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1H3PEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:04:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55699 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1H3PEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:04:37 -0400
Date: Tue, 30 Aug 2011 17:04:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 15/32] nohz/cpuset: Restart tick when switching to idle
 task
Message-ID: <20110830150430.GS9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-16-git-send-email-fweisbec@gmail.com>
 <1314632620.2816.100.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314632620.2816.100.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 05:43:40PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > Ideally if we are in adaptive nohz mode and we switch to the
> > the idle task, we shouldn't restart the tick since it's going
> > to stop the tick soon anyway.
> > 
> > That optimization requires some minor tweaks here and there
> > though, lets handle that later. 
> 
> You have a knack for confusing changelogs.. so basically you say:
> 
>   Restart the tick when we switch to idle.
> 
> Now all that needs is an explanation of why..

In the end we don't want to restart the tick when we switch to idle.
But to support that I'll need to tweak various things on idle time
accounting, otherwise the [cpu] time spent in idle is going to be
accounted as system time.

That's definetly headed to be temporary.

> Also, please drop the whole cpuset_nohz_ stuff, this really isn't about
> cpusets, cpusets simly provide the interface, the functionality lives in
> the tick_nohz_ namespace.

Agreed this sucks.
