Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2BBSST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:18:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46705 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2BBSSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:18:17 -0500
Date: Thu, 2 Feb 2012 10:18:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 32/41] rcu: Update stall-warning
 documentation
Message-ID: <20120202181805.GZ2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-32-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202055639.GS29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202055639.GS29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020218-1780-0000-0000-000002D28A4B
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110334; UDB=6.00027427; UTC=2012-02-02
 18:18:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 09:56:39PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:50AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > Add documentation of CONFIG_RCU_CPU_STALL_VERBOSE, CONFIG_RCU_CPU_STALL_INFO,
> > and RCU_STALL_DELAY_DELTA.  Describe multiple stall-warning messages from
> > a single stall, and the timing of the subsequent messages.  Add headings.
> 
> Don't some of these documentation changes go with earlier patches in
> this series?

Some could, but there is a fair amount of catch-up here.  Since we don't
need documentation to be bisectable, it makes sense to do a single
commit to update the documentation.

> Also, this commit message doesn't say anything about the removal of
> RCU_SECONDS_TILL_STALL_RECHECK:
> 
> > --- a/Documentation/RCU/stallwarn.txt
> > +++ b/Documentation/RCU/stallwarn.txt
> > @@ -14,12 +14,36 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
> >  	issues an RCU CPU stall warning.  This time period is normally
> >  	ten seconds.
> >  
> > -RCU_SECONDS_TILL_STALL_RECHECK
> [...]
> > -	This macro defines the period of time that RCU will wait after
> > -	issuing a stall warning until it issues another stall warning
> > -	for the same stall.  This time period is normally set to three
> > -	times the check interval plus thirty seconds.

It is now computed from CONFIG_RCU_CPU_STALL_TIMEOUT, which has an old
value for default, which is now fixed.  I will add the rationale for
removing CONFIG_RCU_SECONDS_TILL_STALL_RECHECK to the commit message.

							Thanx, Paul

