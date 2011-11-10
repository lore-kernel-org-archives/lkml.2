Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1KJRds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:33:48 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54522 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab1KJRdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:33:47 -0500
Date: Thu, 10 Nov 2011 09:20:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111110172029.GB2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031123125.GA6162@localhost>
 <20111031123708.GA6839@localhost>
 <20111031221416.GQ6160@linux.vnet.ibm.com>
 <1320942925.13800.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320942925.13800.28.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111017-6078-0000-0000-0000043C617E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 05:35:24PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-10-31 at 15:14 -0700, Paul E. McKenney wrote:
> > Peter, I have been using "idle_cpu(smp_processor_id()))" to verify that
> > I really am running in the context of the idle task when RCU believes
> > that the current CPU has gone idle. 
> 
> I think this is sorted since, but just to clarify idle_cpu() was meant
> to test if the cpu was idle, this is something different from actually
> running the idle thread.

Thank you, and yes, looks like the ->pid==0 approach works well.

Should this be encapsulated, for example in an inline function something
as follows?

static inline void cpu_is_running_idle_task(struct task_struct *tsk)
{
	return tsk->pid == 0;
}

I am sure I could come up with a longer name, if you would prefer.  ;-)

I would be happy to create the patch and fix up the other open-coded
uses of ->pid==0 if this approach looks good to you.

							Thanx, Paul

