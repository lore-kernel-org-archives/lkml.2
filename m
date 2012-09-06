Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2IFRdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:33:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35223 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173Ab2IFRdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:33:01 -0400
Date: Thu, 6 Sep 2012 10:29:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 03/23] rcu: Move RCU grace-period cleanup
 into kthread
Message-ID: <20120906172912.GJ2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346938478.18408.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346938478.18408.4.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090617-3534-0000-0000-00000C5254C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:34:38PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> >  static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
> >         __releases(rcu_get_root(rsp)->lock)
> >  {
> > +       raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
> > +       wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
> >  } 
> 
> Could you now also clean up the locking so that the caller releases this
> lock?
> 
> I so dislike asymmetric locking like that..

Or I could inline the whole thing at the two callsites...

							Thanx, Paul

