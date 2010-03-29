Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab0C2DSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 23:18:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44993 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754730Ab0C2DSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 23:18:08 -0400
Date: Sun, 28 Mar 2010 23:18:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, adobriyan@gmail.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [RFC patch] extable and module add object is static
Message-ID: <20100329031804.GA12788@Krystal>
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal> <20100327232024.GB4685@Krystal> <20100327234314.GL2343@linux.vnet.ibm.com> <20100328000234.GA4924@Krystal> <4BB004ED.5060106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB004ED.5060106@cn.fujitsu.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:13:10 up 65 days,  5:50,  4 users,  load average: 0.11, 0.13,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > +static int core_object_is_static(void *obj)
> > +{
> [...]
> > +	if (addr >= (unsigned long)__per_cpu_start &&
> > +	    addr <= (unsigned long)__per_cpu_end)
> > +		return 1;
> 
> This may only correct for UP.
> You may need arch-special codes for SMP.
> 

looking at include/linux/percpu.h:

#ifndef PERCPU_ENOUGH_ROOM
#define PERCPU_ENOUGH_ROOM                                              \
        (ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) +      \
         PERCPU_MODULE_RESERVE)
#endif

I was under the impression that most architectures were keeping their per-cpu
data within the __per_cpu_start .. __per_cpu_end range. But I see that ia64
is the only one to redefine PERCPU_ENOUGH_ROOM. I'm not sure if it can be a
problem. Is that what you had in mind ?

(adding Tony and Fenghua in CC so they can confirm)

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
