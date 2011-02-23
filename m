Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1BWTTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:19:22 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:30715 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755548Ab1BWTTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:19:21 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: b4mS.lUVM1m9djGYbTFq5JizTqducvUq2GMyQWwS3ZCkCKo
 ezIUcRHC9xQZ.2Jfo.yY5GItJL_.ngP0YAvlQ5IPHTw38asKzXCVjUb0O5Tl
 ysCR84Dj75kCwgr9dCs12Eqcfx8N2ISrqFSrChNUCtFnSZXV2Mhb9Ws6zQd5
 C41itILE2iPpuBpKNQOjZeMNjxI878ebfCGaBgbBp4Jc0yqMqWEW1aMk6717
 mBfEz_vYe4is-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Feb 2011 13:19:15 -0600 (CST)
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
In-Reply-To: <1298485965.7666.102.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1102231317550.4823@router.home>
References: <20110223013917.GA20996@linux.vnet.ibm.com>  <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>  <20110223161645.GA1819@nowhere>  <1298479302.7666.94.camel@gandalf.stny.rr.com>  <BLU0-SMTP65F733B8D1D704C7EA1F8796DB0@phx.gbl> 
 <alpine.DEB.2.00.1102231132140.562@router.home>  <1298485027.7666.98.camel@gandalf.stny.rr.com>  <alpine.DEB.2.00.1102231225330.3906@router.home> <1298485965.7666.102.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Steven Rostedt wrote:

> On Wed, 2011-02-23 at 12:29 -0600, Christoph Lameter wrote:
>
> > Right if the kthread context can be rescheduled then either preemption
> > needs to be disabled to guarantee that all three access the same per cpu
> > area data or the code needs to be changed in such a way that a this_cpu
> > RMW instructions can do the mods in one go.
>
> Are you suggesting a this_cpu_atomic_inc()?

this_cpu_inc is already percpu atomic. On x86 it is an instruction that
cannot be interrupted nor preempted while in progress.

There is also this_cpu_cmpxchg() which could be used to do some more
advanced tricks.

