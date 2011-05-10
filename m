Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab1EJI4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:56:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54114 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab1EJI43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:56:29 -0400
Date: Tue, 10 May 2011 01:56:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110510085623.GG2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110508151848.GA21906@linux.vnet.ibm.com>
 <20110509073636.GA18247@elte.hu>
 <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >
> >> Hello, Ingo,
> >>
> >> This pull request covers RCU chnages for 2.6.40.  The major new features
> >> are RCU priority boosting and the addition of kfree_rcu(), the latter
> >> courtesy of Lai Jiangshan.  These two features cover well over half
> >> of the commits.  There are a number of smaller features and bug fixes.
> >> All have been sent to LKML in the following batches:
> >>
> >> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
> >> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
> >> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
> >> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
> >>
> >> The kfree_rcu() uses in the pull request have Acked-by:s from the
> >> maintainers.  I have some additional kfree_rcu() requests that lack
> >> Acked-by:s, and I will deal with these later.
> >>
> >> These channges are available in the -rcu git repository at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> >
> > Pulled, thanks a lot Paul!
> >
> 
> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
> 
> after hard code to enable rcu_cpu_stall_suppress
> 
> Index: linux-2.6/kernel/rcutree.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcutree.c
> +++ linux-2.6/kernel/rcutree.c
> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
>  module_param(qhimark, int, 0);
>  module_param(qlowmark, int, 0);
> 
> -int rcu_cpu_stall_suppress __read_mostly;
> +int rcu_cpu_stall_suppress __read_mostly = 1;
>  module_param(rcu_cpu_stall_suppress, int, 0644);
> 
>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
> 
> will get system hang after pnp ACPI init.

Could you please send the stack traces from the RCU CPU stall?  Also,
you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?

							Thanx, Paul
