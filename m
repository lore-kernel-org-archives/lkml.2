Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1ALRDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:03:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:03:17 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=3KrOCe59Vw4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=RP1BPatL3MTA6UPkNWYA:9 a=ZtfgCriIH3Ic1510EhsA:7 a=6F3G2jbExTtChciHlZkCakS9cpcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH V3] rtmutex: ensure only the top waiter or higher
 priority task can take the lock and remove unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D130D23.1040309@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D130D23.1040309@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 12 Jan 2011 12:03:10 -0500
Message-ID: <1294851790.26623.372.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 16:49 +0800, Lai Jiangshan wrote:
> In current rtmutex, the pending owner may be boosted by the tasks
> in the rtmutex's waitlist when the pending owner is deboosted
> or a task in the waitlist is boosted. This boosting is unrelated,
> because the pending owner does not really take the rtmutex.
> It is not reasonable.

Hi Lai,

Your patch looks like it is proving itself in -rt (after I fixed a bunch
of -rt stuff to get your stuff working ;).

Could you repost your patch with the following removed:


>         /*
> -        * This happens when we have stolen the lock and the original
> -        * pending owner did not enqueue itself back on the rt_mutex.
> -        * Thats not a tragedy. We know that way, that a lock waiter
> -        * is on the fly. We make the futex_q waiter the pending
> owner.
> -        */
> -       if (!new_owner)
> -               new_owner = this->task;
> -
> -       /*
> 
> 
I already have the comment changed, you can just omit this part.

Thanks!

-- Steve


