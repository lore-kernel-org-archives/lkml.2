Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2CWORF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:17:05 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45064 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2CWORC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:17:02 -0400
Message-ID: <4F6C857A.3070307@linux.vnet.ibm.com>
Date: Fri, 23 Mar 2012 09:15:22 -0500
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Dan Smith <danms@us.ibm.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] AutoNUMA alpha6
References: <20120316182511.GJ24602@redhat.com> <87k42edenh.fsf@danplanet.com> <20120321021239.GQ24602@redhat.com> <87fwd2d2kp.fsf@danplanet.com> <20120321124937.GX24602@redhat.com> <87limtboet.fsf@danplanet.com> <20120321225242.GL24602@redhat.com>	<20120322001722.GQ24602@redhat.com> <873990buuy.fsf@danplanet.com>	<20120322142735.GE24602@redhat.com> <20120322184925.GT24602@redhat.com> <87limsa2hm.fsf@danplanet.com>
In-Reply-To: <87limsa2hm.fsf@danplanet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032314-1780-0000-0000-000004332CBF
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000263; HX=3.00000186; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00124524; UDB=6.00029794; UTC=2012-03-23
 14:16:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 01:56 PM, Dan Smith wrote:
> AA>  but now it's time to go back coding and add THP native
> AA>  migration. That will benefit everyone, from cpuset in userland to
> AA>  numa/sched.
>
> I dunno about everyone else, but I think the thing I'd like to see most
> (other than more interesting benchmarks)

We are working on the "more interesting benchmarks", starting with KVM 
workloads.  However, I must warn you all, more interesting = a lot more 
time to run.  These are a lot more complex in that they have real I/O, 
and they can be a lot more challenging because there are response time 
requirements (so fairness is an absolute requirement).  We are getting a 
baseline right now and re-running with our user-space VM-to-numa-node 
placement program, which in the past achieved manual binding performance 
or just slightly lower.  We can then compare to these two solutions.  If 
there's something specific to collect (perhaps you have a lot of stats 
or data in debugfs, etc) please let me know.

-Andrew Theurer
>   is a broken out and documented
> set of patches instead of the monolithic commit you have now. I know you
> weren't probably planning to do that until numasched came along, but it
> sure would help me digest the differences in the two approaches.
>

