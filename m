Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1FMNPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:15:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61474 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1FMNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:14:59 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=ZvcZoPE4s-wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Xo23XLrIUxkGQvnqsjUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove unreliable pointer in
 mutex_spin_on_owner()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <BANLkTi=_k25Hqj0Q+vydVQhqR9d0kBm8MQ@mail.gmail.com>
References: <BANLkTim9cr6H9fTik8-yQ4E0j1yFAOt-7g@mail.gmail.com>
	 <20110608125855.GE27245@home.goodmis.org>
	 <BANLkTi=0hmKeg_dj-x4osX3N_b-cKjyqcw@mail.gmail.com>
	 <1307545036.9218.36.camel@gandalf.stny.rr.com>
	 <BANLkTi=_k25Hqj0Q+vydVQhqR9d0kBm8MQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 09:14:57 -0400
Message-ID: <1307970897.9218.68.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-11 at 22:37 +0800, Hillf Danton wrote:

> Unlike spinner and owner that are well considered, there are waiters, please
> see the following homework.
> 
> Another question about CONFIG_MUTEX_SPIN_ON_OWNER, from the view angle of
> spinners, as you mentioned above, looks like that they are crowding on a bus
> as violently as they could, in contrast to the Japanese people in earthquake.
> 
> Then the result could be, out of our image, not as optimistic as it is, since
> a thread of lower priority could out-compete another of higher priority,
> when a bunch of spinners are simultaneously trying hard to acquire the mutex,
> though only one is allowed to get award.

Note, we don't care about priorities here. If you care about that, then
use the -rt patched kernel and enable "PREEMPT_RT". Because that changes
the mutex code to be priority driven (uses rt_mutex instead of mutex).
In a year or two (or three ;) the -rt patch will be part of the kernel
and you will be able to get these things for free.

-- Steve


