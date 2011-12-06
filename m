Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab1LFM0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:26:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab1LFM0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:26:50 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7FkR-CEZipcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=PNydA2PQNY-S6bkLfvoA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
In-Reply-To: <1323167527.32012.61.camel@twins>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
	 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111205091924.GA28117@zhy> <20111205164505.GB2326@linux.vnet.ibm.com>
	 <20111206012635.GA32498@zhy> <1323165152.32012.51.camel@twins>
	 <20111206100537.GA5203@zhy>  <1323167527.32012.61.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 07:26:45 -0500
Message-ID: <1323174405.30977.86.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 11:32 +0100, Peter Zijlstra wrote:

> > > 
> > > > Maybe we could teach might_sleep() about this special case?
> > > 
> > > Sounds horrid.
> > 
> > Maybe, any alternative?
> 
> Maybe someone explain this mess first?

Me too, because this looks like a hack that's just like a lie. The first
lie to be said gets you out of a bit of trouble, but then something else
happens based on that lie, in which you need to make another bigger lie.
This new lie affects more people and requires new more ingenious lies to
control the chaos. But eventually the lies required to keep everything
going become so overwhelming that it all blows up in your face and you
end up looking like a jackass.

Why is rcu using rt_mutex_lock() in strange ways? It's lying about its
use. And now this patch is the bigger lie to get around the issues of
the first lie. Eventually this code will continue to expand largely
based on these lies and will explode in our faces, and I feel sorry for
the poor jackass that needs to fix it.

Perhaps the real answer is that we need to create an API for priority
inheritance, that things like RCU could use. Attach a task that another
task requires to finish something and boost the priority of that task.
Maybe even completions could use such a thing?

-- Steve


