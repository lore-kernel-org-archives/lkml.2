Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab1FQUf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:35:28 -0400
Received: from blu0-omc1-s27.blu0.hotmail.com ([65.55.116.38]:25555 "EHLO
	blu0-omc1-s27.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932162Ab1FQUf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:35:27 -0400
X-Originating-IP: [184.145.208.36]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP412269A37AB67397C52933966D0@phx.gbl>
Date: Fri, 17 Jun 2011 16:35:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH rcu/urgent] Banishing kthreads
References: <20110617000019.GA15881@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110617000019.GA15881@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:31:45 up 436 days,  6:21,  3 users,  load average: 0.09, 0.09,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Jun 2011 20:35:26.0010 (UTC) FILETIME=[16BC81A0:01CC2D2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> This patchset banishes RCU kthreads from non-RCU_BOOST kernel threads.
> The two patches are as follows:
> 
> 1.	Minimal patch that #ifdefs out the kthread code.
> 
> 2.	Code-movement patch that puts the code #ifdefed out above
> 	under existing #ifdefs in kernel/rcutree_plugin.h.

Hi Paul,

I'm wondering about the impact of this change: so I guess that before
the change, it was OK to go on a waitqueue (might_sleep()) within a
call_rcu callback, but since the execution now moves to a softirq
handler in non-RCU_BOOST kernels, it's not allowed anymore. I might be
missing something though: was sleeping within call_rcu handlers already
prohibited ? (never had to sleep in those, so I never had to check if it
was allowed)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
