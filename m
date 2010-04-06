Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab0DFIRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:17:07 -0400
Received: from www.tglx.de ([62.245.132.106]:56588 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0DFIQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:16:58 -0400
Date: Tue, 6 Apr 2010 10:15:51 +0200 (CEST)
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
In-Reply-To: <20100331142736.GA26207@Krystal>
Message-ID: <alpine.LFD.2.00.1004061013340.32352@localhost.localdomain>
References: <20100329143405.252313609@efficios.com> <20100329143701.765545140@efficios.com> <alpine.LFD.2.00.1003301819060.32352@localhost.localdomain> <20100331133100.GA25453@Krystal> <alpine.LFD.2.00.1003311549250.32352@localhost.localdomain>
 <20100331142736.GA26207@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Mathieu Desnoyers wrote:
> > > where "expect" is the expected state and "next" is the next state to move to if
> > > the expected state is found. A warning is generated if the expected is not
> > > found.
> > 
> > Does it only warn or is there a callback to fixup things as well ?
> 
> For the moment, it only warns. I have not seen the need for a fixup callback
> yet. It might become useful at some point, but I prefer to proceed
> incrementally. This kind of callback could become quite big too, because it
> would have to deal with transitions "from each to each" states of the system,
> with, in the worse case scenario, different fixups for each situation.
> 
> Just for the specific case of "do RCU batch", when detecting that a non-queued
> rcu head is there for execution, there are a few cases to consider:
> 
> - List corruption
>   - Appears in two lists.
>   - Appears in the same list twice.
> - Race (two threads reading the list at the same time).
> - ...
> 
> I am probably forgetting about others. So one way to fixup this would be not to
> execute the callback, but even then, the lists might be corrupted. So it's not
> at all clear to me if we can do much better than reporting the inconsistency
> without increasing intrusiveness. But maybe I just need more imagination. ;)

Yes, that sounds tricky to implement and maybe not worth the
effort. Can you resend the debugobjects patch with a full changelog
please ?

Thanks,

	tglx
