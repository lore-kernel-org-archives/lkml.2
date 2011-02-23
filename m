Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1BWSaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:30:07 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:23783 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751717Ab1BWSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:30:06 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: mGKjh3oVM1n5GjlMYih.R7oyEeP5858x0vC4pNvULQPobkp
 tHglj5Y5bUCWWlnUL_qyCm2gJu4bnYwoGy9PNPhlEMWfQSDNu_P7NEDsA.m7
 B7fhhvw_SOcTOxLBTHyNTWybZfh7X.GNPL4FsOxvXuZ5ae0Z4AkJMzm1Ua5y
 iJcZB.Rtk8eOWAHqs0J1fzVaslEkcKhUuJrCsJN6q8Lr1MOshIlAdxHzwe0p
 v_sOFfaHYV6afx4xKGUsWFkPKS16LEQELJXDyyAoQ.YQn5RM-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Feb 2011 12:29:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
In-Reply-To: <1298485027.7666.98.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1102231225330.3906@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com>  <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>  <20110223161645.GA1819@nowhere>  <1298479302.7666.94.camel@gandalf.stny.rr.com>  <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl> 
 <alpine.DEB.2.00.1102231132140.562@router.home> <1298485027.7666.98.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Steven Rostedt wrote:

> On Wed, 2011-02-23 at 11:34 -0600, Christoph Lameter wrote:
>
> > > > True, but we could also argue that the multiple checks for being preempt
> > > > can also be an issue.
> > >
> > > At least on x86 preemption don't actually need to be disabled: selection
> > > of the right per-cpu memory location is done atomically with the rest of
> > > the instruction by the segment selector.
> >
> > Right.
>
> But a test still needs to be made. Because three access of this_cpu_*()
> that gets preempted and scheduled on another CPU can access a different
> CPU var for each access. This does not matter how atomic the
> this_cpu_*() code is.

Right if the kthread context can be rescheduled then either preemption
needs to be disabled to guarantee that all three access the same per cpu
area data or the code needs to be changed in such a way that a this_cpu
RMW instructions can do the mods in one go.

