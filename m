Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1H2Pv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:51:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52313 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1H2PvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:51:25 -0400
Subject: Re: [PATCH 16/32] nohz/cpuset: Wake up adaptive nohz CPU when a
 timer gets enqueued
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
Date: Mon, 29 Aug 2011 17:51:03 +0200
In-Reply-To: <1313423549-27093-17-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-17-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314633063.2816.103.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> Wake up a CPU when a timer list timer is enqueued there and
> the CPU is in adaptive nohz mode. Sending an IPI to it makes
> it reconsidering the next timer to program on top of recent
> updates.
> 

>  include/linux/sched.h    |    4 ++--
>  kernel/sched.c           |   33 ++++++++++++++++++++++++++++++++-
>  kernel/time/tick-sched.c |    5 ++++-
>  kernel/timer.c           |    2 +-
>  4 files changed, 39 insertions(+), 5 deletions(-) 

So here I would have expected timer_needs_cpu() and an addition to
tick_nohz_can_stop_tick(). Why does sched.c get touched at all?

Also, all the delta_jiffies stuff in the current
tick_nohz_stop_sched_tick() deals with this, why duplicate the logic?
