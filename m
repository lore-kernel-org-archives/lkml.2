Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab0LUNWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:22:35 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:43319 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0LUNWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fo//937g2PKIpWhv7+cfIh0qFpGpiv5jmwIbO6Q1vcYl5nsI0vpwbej07b9cq43vC9
         Re2b5EdV5VRDpy6C7/I4x/t0th8CjgFG3FvQaZKlHEsj4N+RX6JmPrzz/I++c0rV+Alr
         V7LCjTYezSWDcnkyhBFBaGfT3Ik7owT+5wuiA=
Date: Tue, 21 Dec 2010 14:22:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 04/15] nohz_task: Stop the tick when the nohz task
 runs alone
Message-ID: <20101221132226.GB1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-5-git-send-email-fweisbec@gmail.com>
 <1292860299.5021.8.camel@laptop>
 <20101220233659.GB1715@nowhere>
 <1292916958.5021.171.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292916958.5021.171.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 08:35:58AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 00:37 +0100, Frederic Weisbecker wrote:
> > On Mon, Dec 20, 2010 at 04:51:39PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > > Check from the timer interrupt that we are a nohz task running
> > > > alone in the CPU and stop the tick if this is the case.
> > > > 
> > > Does this verify that the tick has no other work to do?
> > > 
> > > I see no list of things the tick does and a checklist that everything it
> > > does is indeed superfluous.
> > 
> > In a subsequent patch we check if rcu also needs the tick.
> > For the rest, tick_nohz_stop_sched_tick() knows what to
> > do: keep the next tick or switch to nohz.
> > 
> > Hm?
> 
> No, and that worries me, you don't even seem to know what the tick does
> and yet you're working on stopping it.

Yeah, I've been focusing a lot on preemption and rcu because they seemed
to be the trickiest part of the thing, and I in the meantime I just forgot
the rest or tagged it too quickly as details to deal with later. And I
finally forgot them :)

Bah it's a first take, it can only improve ;)
