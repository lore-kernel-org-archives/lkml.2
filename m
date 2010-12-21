Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0LUHgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:36:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37571 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0LUHgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:36:03 -0500
Subject: Re: [RFC PATCH 04/15] nohz_task: Stop the tick when the nohz task
 runs alone
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101220233659.GB1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-5-git-send-email-fweisbec@gmail.com>
	 <1292860299.5021.8.camel@laptop>  <20101220233659.GB1715@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 08:35:58 +0100
Message-ID: <1292916958.5021.171.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 00:37 +0100, Frederic Weisbecker wrote:
> On Mon, Dec 20, 2010 at 04:51:39PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > Check from the timer interrupt that we are a nohz task running
> > > alone in the CPU and stop the tick if this is the case.
> > > 
> > Does this verify that the tick has no other work to do?
> > 
> > I see no list of things the tick does and a checklist that everything it
> > does is indeed superfluous.
> 
> In a subsequent patch we check if rcu also needs the tick.
> For the rest, tick_nohz_stop_sched_tick() knows what to
> do: keep the next tick or switch to nohz.
> 
> Hm?

No, and that worries me, you don't even seem to know what the tick does
and yet you're working on stopping it.
