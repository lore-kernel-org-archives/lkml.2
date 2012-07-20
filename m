Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2GTPLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:11:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:14604 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab2GTPLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:11:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181410892"
Message-ID: <500974CD.7090804@linux.intel.com>
Date: Fri, 20 Jul 2012 08:10:05 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
References: <20120713180823.GA24972@redhat.com> <alpine.LFD.2.02.1207132032330.32033@ionos> <20120713185402.GA1707@redhat.com> <5008969F.5030901@linux.intel.com> <5008A847.4070006@linux.intel.com> <50090079.1000703@linux.intel.com> <20120720133501.GA30826@redhat.com>
In-Reply-To: <20120720133501.GA30826@redhat.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/20/2012 06:35 AM, Dave Jones wrote:
> On Thu, Jul 19, 2012 at 11:53:45PM -0700, Darren Hart wrote:
> 
>  
>  > >> I'll add a fix to that WARN_ON in my futex-fixes branch along with the
>  > >> fix for the bug Dan found.
>  > > 
>  > > I think I have root cause. futex_wait_requeue_pi() doesn't like having
>  > > uaddr == uaddr2. The handle_early_wakeup() doesn't detect a problem
>  > > because key2 IS the same as key1, I think. I've just discovered this and
>  > > quickly hacked in a "if (uaddr==uaddr2) return -EINVAL" fix and the test
>  > > continues to run (with just ops 0, 11, 12) for several minutes now
>  > > (typically fails in a few seconds). I'll let it run for a few hours and
>  > > contemplate the proper fix.
>  > 
>  > Dave, mind giving this a spin? It seems to be doing the trick here,
>  > at least for the *REQUEUE_PI futex op codes in trinity.
> 
> Yeah, looks like that does the trick!

It ran all night without an issue here too. I'll roll these up and send
them out shortly.

Dave, I love/hate trinity. ;-)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


