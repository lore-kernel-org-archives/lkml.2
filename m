Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab1GTSyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:54:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:48947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1GTSym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:54:42 -0400
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ben Greear <greearb@candelatech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
In-Reply-To: <20110720184413.GD17977@elte.hu>
References: <20110720001738.GA16369@linux.vnet.ibm.com>
	 <201107192130.02080.edt@aei.ca> <201107192207.33813.edt@aei.ca>
	 <20110720044435.GB2400@linux.vnet.ibm.com>
	 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
	 <20110720133443.GG2400@linux.vnet.ibm.com>
	 <4E270A0E.6090902@candelatech.com>
	 <20110720171532.GB2313@linux.vnet.ibm.com> <20110720184413.GD17977@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 20:52:58 +0200
Message-ID: <1311187978.29152.58.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 20:44 +0200, Ingo Molnar wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > RCU boost is new and counts as strange for another few days at least.
> 
> I'd rather prefer a oneliner patch that turns it off in the Kconfig 
> for now.
> 
> We are awfully late in the -rc cycle and this diffstat:
> 
>  b/include/linux/sched.h   |    3 ++
>  b/kernel/rcutree_plugin.h |    6 +++--
>  b/kernel/sched.c          |   44 ++++++++++++++++++++++++++++++++++-----
>  b/kernel/signal.c         |   19 +++++++++++------
>  b/kernel/softirq.c        |   12 +++++++++-
>  kernel/rcutree_plugin.h   |   51 +++++++++++++++++++++++++++++++++-------------
>  6 files changed, 105 insertions(+), 30 deletions(-)
> 
> looks very scary to me.

A lot of that is also relevant to !BOOST.
