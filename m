Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1HVJLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:11:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab1HVJLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:11:09 -0400
Message-ID: <4E521D0B.7030000@redhat.com>
Date: Mon, 22 Aug 2011 11:10:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
        Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] priority-boost urcu
References: <cover.1313478311.git.laijs@cn.fujitsu.com>  <4E4B7FEB.6050200@redhat.com> <4E4C971D.9020902@cn.fujitsu.com>  <20110818122828.GB31100@Krystal> <1313674225.15704.68.camel@gandalf.stny.rr.com>
In-Reply-To: <1313674225.15704.68.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 03:30 PM, Steven Rostedt wrote:
>>  In QEMU I added the manual-reset event and use it in the
>>  implementation of RCU.

That was me. :)

> Be careful with this. You better make sure that Microsoft does not hold
> any patents to this method, otherwise all your work will be in vain.

I found the synchronization primitive mentioned in a patent filed 1994, 
so I would be surprised if the primitive itself is younger than 20 years 
(or even younger than 30 years in fact).

The only possibly novel thing is the userspace-only path when there is 
no contention.  Windows events always do a system call, so there is some 
hope it isn't patented.

But if Microsoft did have a patent and it applied, both the 
userspace-RCU and QEMU code would have a problem.  The technique is the 
same independent of whether you call futex primitives directly, or you 
wrap them in an API.

Paolo
