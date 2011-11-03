Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044Ab1KCEAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 00:00:32 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34906 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1KCEAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 00:00:31 -0400
X-Originating-IP: 217.70.178.147
X-Originating-IP: 50.43.15.19
Date: Wed, 2 Nov 2011 21:00:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH RFC tip/core/rcu 19/28] nohz: Allow rcu extended
 quiescent state handling seperately from tick stop
Message-ID: <20111103040003.GE2042@leaf>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-19-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320265849-5744-19-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 01:30:40PM -0700, Paul E. McKenney wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> It is assumed that rcu won't be used once we switch to tickless
> mode and until we restart the tick. However this is not always
> true, as in x86-64 where we dereference the idle notifiers after
> the tick is stopped.
> 
> To prepare for fixing this, add two new APIs:
> tick_nohz_idle_enter_norcu() and tick_nohz_idle_exit_norcu().
> 
> If no use of RCU is made in the idle loop between
> tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the arch
> must instead call the new *_norcu() version such that the arch doesn't
> need to call rcu_idle_enter() and rcu_idle_exit().

The _norcu names confused me a bit.  At first, I thought they meant
"idle but not RCU idle, so you can use RCU", but from re-reading the
commit message, apparently they mean "idle and RCU idle, so don't use
RCU".  What about something like _forbid_rcu instead?  Or,
alternatively, why not just go ahead and separate the two types of idle
entirely rather than introducing the _norcu variants first?

- Josh Triplett
