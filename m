Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab1LFQH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:07:59 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54847 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1LFQH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:07:58 -0500
Date: Tue, 6 Dec 2011 08:01:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, y@linux.vnet.ibm.com
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
Message-ID: <20111206160154.GB2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
 <20111205164505.GB2326@linux.vnet.ibm.com>
 <20111206012635.GA32498@zhy>
 <1323165152.32012.51.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323165152.32012.51.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120616-8974-0000-0000-000003F710C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 10:52:32AM +0100, Peter Zijlstra wrote:
> On Tue, 2011-12-06 at 09:26 +0800, Yong Zhang wrote:
> 
> > Yeah, because we call might_sleep() in rt_mutex_lock() unconditionally.
> > But in this case the 'BUG: sleeping function called from invalid context
> > at *' is obviously false positive.
> 
> Why can't this mutex acquisition not block?

Because its purpose in life is to pass its priority on to the lock
holder.

							Thanx, Paul

> > Maybe we could teach might_sleep() about this special case?
> 
> Sounds horrid.
> 

