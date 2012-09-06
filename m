Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab2IFPVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:21:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:46714 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab2IFPU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:20:58 -0400
Message-ID: <1346944758.18408.35.camel@twins>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 17:19:18 +0200
In-Reply-To: <1346944049.1680.23.camel@gandalf.local.home>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346943414.18408.31.camel@twins>
	 <1346944049.1680.23.camel@gandalf.local.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 11:07 -0400, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 16:56 +0200, Peter Zijlstra wrote:
> > On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> > > 
> > > If a given CPU avoids the idle loop but also avoids starting a new
> > > RCU grace period for a full minute, RCU can issue spurious RCU CPU
> > > stall warnings.  This commit fixes this issue by adding a check for
> > > ongoing grace period to avoid these spurious stall warnings. 
> > 
> > How would it avoid starting a new period for over a minute? fqs should
> > happen, right? And holding rcu_read_lock() for over a minute surely is a
> > bug.
> 
> I can see this happening in test cases, but it would seem weird on a
> normal system. That is, for preempt rcu, having a process scheduled out
> holding an rcu_read_lock() for over a minute could happen on a really
> stressed out system. But for such a case, I don't think a warning is out
> of question.

One would hope that fqs would boost things.. but yeah, if your app is
spinning above the rcu boost prio you're still toast. But in that case
you're right, a warning is fully deserved.
