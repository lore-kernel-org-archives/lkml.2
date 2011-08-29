Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1H2OXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:23:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1H2OXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:23:32 -0400
Subject: Re: [PATCH 04/32] nohz: Separate idle sleeping time accounting from
 nohz switching
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
Date: Mon, 29 Aug 2011 16:23:19 +0200
In-Reply-To: <1313423549-27093-5-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-5-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314627800.2816.62.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> To prepare for having nohz mode switching independant from idle,
> pull the idle sleeping time accounting out of the tick stop API.
> 
> This implies to implement some new API to call when we
> enter/exit idle. 

I mean, I really love brevity, but you seem to just not state all the
important bits ;-)

So the goal is to disable the tick more often (say when running 1
userbound task), why does that need new hooks? If we already had the
tick disabled, the tick_nohz_stop_sched_tick() call on going idle will
simply not do anything.

If we go from idle to running something we want to enable the tick
initially because doing the task wakeup involves RCU etc.. Once we find
the task is indeed userbound and we've finished all our state we can
disable the thing again.


