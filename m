Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0FXWCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 18:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab0FXWCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 18:02:15 -0400
Date: Fri, 25 Jun 2010 00:00:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100624220007.GB21360@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621205128.GI2354@linux.vnet.ibm.com> <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com> <20100623152421.GA8445@redhat.com> <20100624180726.GK2373@linux.vnet.ibm.com> <4C23A90A.9040303@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C23A90A.9040303@genband.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Chris Friesen wrote:
>
> On 06/24/2010 12:07 PM, Paul E. McKenney wrote:
>
> > 3.	The thread-group leader might do pthread_exit(), removing itself
> > 	from the thread group -- and might do so while the hapless reader
> > 	is referencing that thread.
> >
> > 	But isn't this prohibited?  Or is it really legal to do a
> > 	pthread_create() to create a new thread and then have the
> > 	parent thread call pthread_exit()?  Not something I would
> > 	consider trying in my own code!  Well, I might, just to
> > 	be perverse, but...  ;-)
>
> I believe SUS allows the main thread to explicitly call pthread_exit(),
> leaving the other threads to run.  If the main() routine just returns
> then it implicitly calls exit().

Correct.

But, to clarify, if the main thread does pthread_exit() (sys_exit,
actually), it won't be removed from the group. It will be zombie
until all other threads exit.

Oleg.

