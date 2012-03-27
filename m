Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2C0M0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:26:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2C0M0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:26:11 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=NFM--E4xPHYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=iivZJ_HrVVKMCwYqsd4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332851167.23924.125.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        torvalds@linux-foundation.org
Date: Tue, 27 Mar 2012 08:26:07 -0400
In-Reply-To: <20120327051515.GO2450@linux.vnet.ibm.com>
References: <20120325205249.GA29528@linux.vnet.ibm.com>
	 <1332748484.16159.61.camel@twins>
	 <20120326183232.GK2450@linux.vnet.ibm.com>
	 <1332787630.16159.182.camel@twins>
	 <20120327051515.GO2450@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 22:15 -0700, Paul E. McKenney wrote:

> Hmmm...  I am not yet sure whether it is easier to make RCU use legal
> in switch_to() or to detect it.  I am inclined to take whatever course
> is easiest, which is likely to make it legal.  :-/

We could just declare that we do not allow tracepoints in arch specific
"switch_to" code. Then you shouldn't need to worry about RCU in
switch_to().

sched_rcu can still work there correct? That is, a synchronize_sched()
should not be affected. As that is needed for the function tracing, and
that may be called within a switch_to.

-- Steve


