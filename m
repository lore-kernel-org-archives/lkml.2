Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1EBI0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:26:07 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53418 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab1EBI0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:26:05 -0400
Date: Mon, 2 May 2011 01:25:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 10/86] rcu: eliminate unused boosting
 statistics
Message-ID: <20110502082555.GV2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-10-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110501155317.GG14829@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501155317.GG14829@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 08:53:18AM -0700, Josh Triplett wrote:
> On Sun, May 01, 2011 at 06:20:50AM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > The n_rcu_torture_boost_allocerror and n_rcu_torture_boost_afferror
> > statistics are not actually incremented anymore, so eliminate them.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutorture.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 4d256db..62ec8ee6 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -1067,7 +1067,7 @@ rcu_torture_printk(char *page)
> >  	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
> >  	cnt += sprintf(&page[cnt],
> >  		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
> > -		       "rtmbe: %d rtbke: %ld rtbre: %ld rtbae: %ld rtbafe: %ld "
> > +		       "rtmbe: %d rtbke: %ld rtbre: %ld "
> >  		       "rtbf: %ld rtb: %ld nt: %ld",
> >  		       rcu_torture_current,
> >  		       rcu_torture_current_version,
> > @@ -1078,8 +1078,6 @@ rcu_torture_printk(char *page)
> >  		       atomic_read(&n_rcu_torture_mberror),
> >  		       n_rcu_torture_boost_ktrerror,
> >  		       n_rcu_torture_boost_rterror,
> > -		       n_rcu_torture_boost_allocerror,
> > -		       n_rcu_torture_boost_afferror,
> >  		       n_rcu_torture_boost_failure,
> >  		       n_rcu_torture_boosts,
> >  		       n_rcu_torture_timers);
> 
> Shouldn't you eliminate the variables entirely, if they no longer track
> anything?

I most certainly should!!!  Good catch!!!

							Thanx, Paul
