Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0ENDhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 23:37:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37909 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0ENDhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 23:37:34 -0400
Date: Thu, 13 May 2010 20:37:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: ratheesh k <ratheesh.ksz@gmail.com>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: preempt_disable and sleep()
Message-ID: <20100514033732.GA2418@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTinbwZK5Tp6aI4ja38XaiiB5aIyECzHPdMpvkaIy@mail.gmail.com>
 <1273776201.11899.23.camel@sven.thebigcorporation.com>
 <AANLkTilMrwdaLrTAUVETYZLYSpoqVFVXfKZ2lZit6uG3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilMrwdaLrTAUVETYZLYSpoqVFVXfKZ2lZit6uG3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 08:16:07AM +0530, ratheesh k wrote:
> On Fri, May 14, 2010 at 12:13 AM, Sven-Thorsten Dietrich
> <thebigcorporation@gmail.com> wrote:
> 
> > Why would you do this?
> I was reading some linux kernel journel about preempt_disable() . This
> a doubt came to me .
> 
> 
> > If you had tried this code, you would have seen the corresponding stack
> > dump on the console.
> 
> 
> Why it so .? could you explain a little more ? .sleep() will schedule
> () , which inturn give back control to kernel .

Sleeping in the kernel with preemption disabled is considered to be a
bug.  So the scheduler will print an error and a stack dump when this
happens.

In contrast, it is OK to do the following:

	preempt_disable();
	do_something();
	preempt_enable();
	schedule();
	preempt_disable();
	do_something_else();
	preempt_enable();

							Thanx, Paul

> Thank,
> Ratheesh
> 
> On Fri, May 14, 2010 at 12:13 AM, Sven-Thorsten Dietrich
> <thebigcorporation@gmail.com> wrote:
> > On Fri, 2010-05-14 at 00:02 +0530, ratheesh k wrote:
> >> I am running RT linux .
> >>
> >> /* code snippet */
> >>
> >> preempt_disable()
> >> ...........
> >> sleep(10);
> >> '............
> >> preempt_enable()
> >>
> >>
> >> will this sleep() will cause reschedule ?.
> >>
> >
> > Why would you do this?
> >
> > If you had tried this code, you would have seen the corresponding stack
> > dump on the console.
> >
> >> if an interrupt comes  while premption is disabled , how it is handled ?.
> >>
> >
> > Depends on the number of (idle) cores, the setting of CONFIG_PREEMPT_[]
> > and the type of interrupt.
> >
> > RT threaded IRQs would not run until preemption is enabled on a single
> > core system.
> >
> >
> >
> >> Thanks,
> >> Ratheesh
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
