Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab1LFKc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:32:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38683 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146Ab1LFKcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:32:54 -0500
Message-ID: <1323167527.32012.61.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Date: Tue, 06 Dec 2011 11:32:07 +0100
In-Reply-To: <20111206100537.GA5203@zhy>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
	 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111205091924.GA28117@zhy> <20111205164505.GB2326@linux.vnet.ibm.com>
	 <20111206012635.GA32498@zhy> <1323165152.32012.51.camel@twins>
	 <20111206100537.GA5203@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 18:05 +0800, Yong Zhang wrote:
> On Tue, Dec 06, 2011 at 10:52:32AM +0100, Peter Zijlstra wrote:
> > On Tue, 2011-12-06 at 09:26 +0800, Yong Zhang wrote:
> > 
> > > Yeah, because we call might_sleep() in rt_mutex_lock() unconditionally.
> > > But in this case the 'BUG: sleeping function called from invalid context
> > > at *' is obviously false positive.
> > 
> > Why can't this mutex acquisition not block?
> 
> It could block. The issue it's legal to call rt_mutex_lock() with
> irqs disabled and we don't want might_sleep() bite us on this

Of course its legal (nobody will arrest you for it), but its also bloody
horrid.

> special case. When we are going to sleep, we re-enable irq in
> __rt_mutex_slowlock().
> 
> > 
> > > Maybe we could teach might_sleep() about this special case?
> > 
> > Sounds horrid.
> 
> Maybe, any alternative?

Maybe someone explain this mess first?
