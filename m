Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0C0XU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:20:27 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39148 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754049Ab0C0XU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:20:26 -0400
Date: Sat, 27 Mar 2010 19:20:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com
Subject: Re: [patch 0/6] rcu head debugobjects
Message-ID: <20100327232024.GB4685@Krystal>
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327231421.GA4685@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:18:57 up 64 days,  1:56,  3 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> > o	Patch 6/6: Would it be possible to use the object_is_on_stack()
> > 	function defined in include/linux/sched.h instead of passing
> > 	in the flag on_stack to bdi_work_init()?  It looks like
> > 	fs/fs-writeback.c already includes include/linux/sched.h, so
> > 	shouldn't be a problem from a #include-hell viewpoint.
> 
> Wow, that's cool! We learn about exciting internal API functions every day,
> isn't life great ? I will definitely change the fs-writeback.c code to make use
> of it.
> 
> We might event want to go further. A similar scheme could be used for the
> rcu_head debugobject activation fixup. Basically, I need a way to distinguish
> between:
> 
> A) objects on stack and allocated objects
> and
> B) objects statically initialized
> 
> So either we use something resembling:
> 
>   if (object_is_on_stack() || object_is_allocated())
> 
> or
> 
>   if (object_is_static())
> 
> I am not aware of the proper API members to do that though.
> 

Something close to "object_is_static()" would be "kernel_text_address()", but it
only considers the text section addresses. I'd need something that would be
broader than that, containing all core kernel and module bss and data sections.

Still looking...

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
