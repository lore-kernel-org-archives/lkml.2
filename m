Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0DOSiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:38:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52219 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0DOSiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:38:07 -0400
Date: Thu, 15 Apr 2010 11:37:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/5] Debugobjects transition check (updated changelog)
Message-ID: <20100415183758.GO2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100329143405.252313609@efficios.com>
 <20100329143701.765545140@efficios.com>
 <alpine.LFD.2.00.1003301819060.32352@localhost.localdomain>
 <20100331133100.GA25453@Krystal>
 <alpine.LFD.2.00.1003311549250.32352@localhost.localdomain>
 <20100331142736.GA26207@Krystal>
 <alpine.LFD.2.00.1004061013340.32352@localhost.localdomain>
 <20100406125302.GA22529@Krystal>
 <alpine.LFD.2.00.1004152028000.3625@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004152028000.3625@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 08:32:05PM +0200, Thomas Gleixner wrote:
> B1;2005;0cOn Tue, 6 Apr 2010, Mathieu Desnoyers wrote:
> > Implement a basic state machine checker in the debugobjects.
> > 
> > This state machine checker detects races and inconsistencies within the "active"
> > life of a debugobject. The checker only keeps track of the current state; all
> > the state machine logic is kept at the object instance level.
> > 
> > The checker works by adding a supplementary "unsigned int astate" field to the
> > debug_obj structure. It keeps track of the current "active state" of the object.
> > 
> > The only constraints that are imposed on the states by the debugobjects system
> > is that:
> > 
> > - activation of an object sets the current active state to 0,
> > - deactivation of an object expects the current active state to be 0.
> > 
> > For the rest of the states, the state mapping is determined by the specific
> > object instance. Therefore, the logic keeping track of the state machine is
> > within the specialized instance, without any need to know about it at the
> > debugobject level.
> > 
> > The current object active state is changed by calling:
> > 
> > debug_object_active_state(addr, descr, expect, next)
> > 
> > where "expect" is the expected state and "next" is the next state to move to if
> > the expected state is found. A warning is generated if the expected is not
> > found.
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Please feel free to pull that into the rcu branch where the users are
> going to be.

Thank you, Thomas!!!

							Thanx, Paul
