Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab2DTPtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:49:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54069 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2DTPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:49:38 -0400
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20120420154202.GB32324@google.com>
References: <20120420122120.097464672@linutronix.de>
	 <1334928098.2463.56.camel@laptop>  <20120420154202.GB32324@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 17:49:24 +0200
Message-ID: <1334936964.2463.66.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 08:42 -0700, Tejun Heo wrote:
> I'm still leaning towards restricting kthreadd and any PF_THREAD_BOUND
> threads in the root cgroup.  

I'd definitely agree with restricting those. 

> I'm not sure about !BOUND kthreads tho.
> It doesn't make sense for the most part but there are cases
> (e.g. crypto kthreads) which might make some sense.
> 
Agreed as well. There are a few nasty corner cases with unbound
workqueues vs allowing cgroups (as how to place new worker threads
correctly etc..). Sorting that is a 'fun' next problem.

Could we merge the kthreadd/PF_THREAD_BOUND restriction? You've got my
ACK and I'm fairly sure tglx will ACK it as well.

