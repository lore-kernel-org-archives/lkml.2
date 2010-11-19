Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0KSTqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:46:31 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:41366 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0KSTqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:46:30 -0500
Subject: Re: [RFC][PATCH v2 5/7] taskstats: Improve cumulative CPU time
 accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20101118171001.GB3249@redhat.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170815.404670062@linux.vnet.ibm.com>
	 <20101113183810.GA9021@redhat.com>
	 <1289926635.1940.100.camel@holzheu-laptop>
	 <20101118171001.GB3249@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 19 Nov 2010 20:46:25 +0100
Message-ID: <1290195985.2000.18.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Thu, 2010-11-18 at 18:10 +0100, Oleg Nesterov wrote:
> > 2. Because of reparent to init, there are situations where it is
> >    not clear to which tasks the CPU time of dead tasks between
> >    two snapshots has been accounted. This is a problem for example 2.
> 
> Yes, I see.
> 
> But I must admit, _personally_ I am not sure this problem worth the
> trouble.

I think you are right...

For that function, the introduced overhead, additional code and
especially the possible confusion with two process hierarchies is not
worth the effort. Maybe we have a chance to solve the reparent problem
by introducing task exit event filters (e.g. give me all exit events for
processes that have init as parent).

So I will send no more patches with the parallel hierarchy:
Good news for you :-)

But for the second problem with the forgotten CPU time, I would like
send you a new patch set, separated as you have requested. Although I
personally think that also there we probably have no good chances to get
them accepted upstream, because the signal_struct size is increased and
some cycles are added to the task exit processing.

It would be nice, if you find some time to look at the patches,
but no hurry!

Michael





