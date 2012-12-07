Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424484Ab2LGU73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:59:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424420Ab2LGU72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:59:28 -0500
Date: Fri, 7 Dec 2012 21:59:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tj@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, amit.kucheria@linaro.org,
        rostedt@goodmis.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"
	atomic readers to prevent CPU offline
Message-ID: <20121207205935.GA17608@redhat.com>
References: <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com> <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com> <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com> <20121206161850.GA6710@redhat.com> <50C0E88E.9050909@linux.vnet.ibm.com> <20121207195629.GA13238@redhat.com> <50C250CA.8070209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C250CA.8070209@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Srivatsa S. Bhat wrote:
>
> On 12/08/2012 01:26 AM, Oleg Nesterov wrote:
> > Not sure I undestand... I simply meant that, say,
> > get_online_cpus_atomic() under task->pi_lock can obviously deadlock
> > with take_cpu_down() which can want the same task->pi_lock after
> > disable_atomic_reader().
>
> Right, I mistook your point for something else (i.e., ability for
> the writer to do get_online_cpus_atomic() safely, which I fixed in
> v3).
>
> So, your point above is very valid. And yes, we can't do much
> about it, we'll just have to teach lockdep to catch such usages.

Afaics, this is simple. Just add the "fake" lockdep_map as, say,
lglock does. Except, you need rwlock_acquire_read(map, 0, 1, IP)
because this lock is recursive.

But. There is another email from you about the possible deadlock.
I'll write the reply in a minute...

Oleg.

