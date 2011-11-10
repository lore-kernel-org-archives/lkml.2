Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1KJSdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:33:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36525 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1KJSdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:33:33 -0500
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 10 Nov 2011 19:33:12 +0100
In-Reply-To: <20111110172029.GB2354@linux.vnet.ibm.com>
References: <20111031082634.GA10348@localhost>
	 <20111031095152.GL6160@linux.vnet.ibm.com>
	 <20111031104325.GA25808@localhost> <20111031114142.GA32555@localhost>
	 <20111031123125.GA6162@localhost> <20111031123708.GA6839@localhost>
	 <20111031221416.GQ6160@linux.vnet.ibm.com>
	 <1320942925.13800.28.camel@twins>
	 <20111110172029.GB2354@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320949992.13800.36.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 09:20 -0800, Paul E. McKenney wrote:

> Should this be encapsulated, for example in an inline function something
> as follows?
> 
> static inline void cpu_is_running_idle_task(struct task_struct *tsk)
> {
> 	return tsk->pid == 0;
> }
> 
> I am sure I could come up with a longer name, if you would prefer.  ;-)

:-)

> I would be happy to create the patch and fix up the other open-coded
> uses of ->pid==0 if this approach looks good to you.

is_idle_task(p) would work for me.
