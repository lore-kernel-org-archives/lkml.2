Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab2BBSEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:04:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37387 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab2BBSEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:04:41 -0500
Date: Thu, 2 Feb 2012 10:03:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH RFC tip/core/rcu 31/41] rcu: Add CPU-stall capability to
 rcutorture
Message-ID: <20120202180309.GY2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-31-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202055310.GR29058@leaf>
 <alpine.DEB.2.02.1202021014480.1928@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1202021014480.1928@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020218-7182-0000-0000-000000A780DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 10:15:45AM +0100, Julia Lawall wrote:
> 
> 
> On Wed, 1 Feb 2012, Josh Triplett wrote:
> 
> >On Wed, Feb 01, 2012 at 11:41:49AM -0800, Paul E. McKenney wrote:
> >>--- a/kernel/rcutorture.c
> >>+++ b/kernel/rcutorture.c
> >>+/* Spawn CPU-stall kthread, if stall_cpu specified. */
> >>+static int __init rcu_torture_stall_init(void)
> >>+{
> >>+	if (stall_cpu <= 0)
> >>+		return 0;
> >>+	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
> >>+	if (IS_ERR(stall_task)) {
> >>+		stall_task = NULL;
> >>+		return PTR_ERR(stall_task);
> >
> >This seems...unlikely to produce the desired result. :)
> >
> >A quick check turns up the same bug in rcutorture_onoff_init.
> >
> >This suggests a possible Coccinelle check, for uses of PTR_ERR(foo) after
> >foo = (any constant other than ERR_PTR(foo)).
> 
> Indeed, it seems to be a popular idiom :)  I'll send some patches
> later today.

I guess I am glad that I am not the only idiot out there...

							Thanx, Paul

