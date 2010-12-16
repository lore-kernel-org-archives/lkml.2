Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0LPN4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:56:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0LPN4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:56:36 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MUIVesnmWfVD_5JfckYA:9 a=9ReAfj7O9ntN0-1n4xEA:7 a=oyZPAtjUZ1C5L7qT9RWGuX0vWlMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <4D096806.7000807@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
	 <1292450002.5015.1903.camel@gandalf.stny.rr.com>
	 <4D096806.7000807@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Dec 2010 08:56:32 -0500
Message-ID: <1292507792.5015.1908.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 09:14 +0800, Lai Jiangshan wrote:

> It has called try_to_take_rt_mutex() in __rt_mutex_slowlock(),
> when timeout or got signal, it returns from __rt_mutex_slowlock()
> with lock->wait_lock still held, and then calls remove_waiter(),
> 
> so we don't need to call try_to_take_rt_mutex() in remove_waiter().
> It is strange that remove_waiter() do some "require lock" work.

Hmm yeah, I need to remember all the details here. There were so many
corner cases that had to be dealt with, but we have also
modified/simplified the code over time (hopefully your patch will add to
the simplification) that my worries may no longer exist, and the code in
-rt (needed for spinlock -> mutex) may have legacy code there too.

I'll spend more time analyzing this and make sure we in deed do not need
to worry about races between wakeups and lock releasing.

Thanks,

-- Steve


