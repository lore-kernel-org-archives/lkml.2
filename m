Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1AJM5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:57:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1AJM5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:57:36 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Cd8IlHNGQIfiNYUOf-4A:9 a=k7j5S4YQdnJjzdFvAcUA:7 a=ZADWfKfBAgPfw-dk4d9RR_nbIpsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D2AEF7E.8060901@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
	 <1294325428.26623.187.camel@gandalf.stny.rr.com>
	 <4D2AEF7E.8060901@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 10 Jan 2011 07:57:32 -0500
Message-ID: <1294664252.26623.236.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 19:37 +0800, Lai Jiangshan wrote:

> After this patch applied, the topwaiter will not be deququed when the lock
> is released(any waiter is dequeued only when it really get the lock or give up).
> So the wait list will not be empty if someone is still waiting on.
> 
> I thought, in this code, this->task is waiting, so rt_mutex_next_owner()
> will not return NULL. As you found, my thought is wrong, we should just
> change the comment.

Yes, I've done that. I'll be posting my new port of your patch today
which has passed all my tests. I'm still looking to see what I can do
with the adaptive spinlocks, as I'm hitting a "hung task" when running
dbench 100 in a loop. But I just hit that same "hung task" with vanilla
2.6.33 (no -rt), so I think the bug is not with my code ;-)

-- Steve


