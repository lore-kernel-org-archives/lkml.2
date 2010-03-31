Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab0CaNw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 09:52:58 -0400
Received: from www.tglx.de ([62.245.132.106]:34946 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933371Ab0CaNw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 09:52:56 -0400
Date: Wed, 31 Mar 2010 15:51:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 1/5] Debugobjects transition check
In-Reply-To: <20100331133100.GA25453@Krystal>
Message-ID: <alpine.LFD.2.00.1003311549250.32352@localhost.localdomain>
References: <20100329143405.252313609@efficios.com> <20100329143701.765545140@efficios.com> <alpine.LFD.2.00.1003301819060.32352@localhost.localdomain> <20100331133100.GA25453@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Mathieu Desnoyers wrote:

> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > On Mon, 29 Mar 2010, Mathieu Desnoyers wrote:
> > 
> > > Implement a basic state machine checker in the debugobjects.
> > 
> > Can you please add some real explanation how that checker works and
> > why we want to have it ?
> 
> We can add this to the changelog. Is it worth it to create a Documentation file
> for it ?

I meant the changelog. The "Implement ...." line was not really helpful :)
 
> 
> This state machine checker detects races and inconsistencies within the "active"
> life of a debugobject. The checker only keeps track of the current state; all
> the state machine logic is kept at the object instance level.
> 
> The checker works by adding a supplementary "unsigned int astate" field to the
> debug_obj structure. It keeps track of the current "active state" of the object.
> 
> The only constraints that are imposed on the states by the debugobjects system
> is that:
> 
> - activation of an object sets the current active state to 0,
> - deactivation of an object expects the current active state to be 0.
> 
> For the rest of the states, the state mapping is determined by the specific
> object instance. Therefore, the logic keeping track of the state machine is
> within the specialized instance, without any need to know about it at the
> debugobject level.
> 
> The current object active state is changed by calling:
> 
> debug_object_active_state(addr, descr, expect, next)
> 
> where "expect" is the expected state and "next" is the next state to move to if
> the expected state is found. A warning is generated if the expected is not
> found.

Does it only warn or is there a callback to fixup things as well ?

Thanks,

	tglx
