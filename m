Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1IFAgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 20:36:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34984 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1IFAfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 20:35:55 -0400
Date: Tue, 6 Sep 2011 02:35:50 +0200
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
Subject: Re: [PATCH 06/32] nohz: Move idle ticks stats tracking out of nohz
 handlers
Message-ID: <20110906003547.GB28205@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-7-git-send-email-fweisbec@gmail.com>
 <1314628088.2816.68.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314628088.2816.68.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:28:08PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > Idle ticks time tracking is merged into nohz stop/restart
> > handlers. Pull it out into idle entry/exit handlers instead,
> > so that nohz APIs is more idle independant. 
> 
> Are you trying to say:
> 
> Currently idle time tracking is part of the nohz state tracking,
> separate this so that we can disable the tick while we're non-idle?

Right.

> 
> If so, how does idle time tracking work on a !NOHZ kernel, surely such
> things can be idle too..

In that case the tick calls account_process_tick() which delegates
to account_idle_time() if we are idle on tick.

That's also used in NOHZ kernels in fact.

In every tick we call account_process_tick(), but when the tick is stopped
we save its value in ts->idle_jiffies and when it is restarted we account
jiffies - ts->idle_jiffies.
