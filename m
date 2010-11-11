Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0KKMxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:53:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:37562 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab0KKMxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:53:30 -0500
Message-ID: <4CDBE6FC.1010106@kernel.org>
Date: Thu, 11 Nov 2010 13:52:12 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/12] rcu: fix race condition in synchronize_sched_expedited()
References: <20101107020507.GA4974@linux.vnet.ibm.com> <1289095532-5398-11-git-send-email-paulmck@linux.vnet.ibm.com> <4CD94C0D.3030007@kernel.org> <4CDA5E40.3080205@cn.fujitsu.com> <20101111042014.GE3134@linux.vnet.ibm.com> <4CDBB309.9020406@kernel.org> <20101111123146.GF3134@linux.vnet.ibm.com>
In-Reply-To: <20101111123146.GF3134@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Nov 2010 12:52:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/11/2010 01:31 PM, Paul E. McKenney wrote:
> Actually, the memory barriers are still one source of discomfort to me.
> I am concerned about the path out of the function that skips the
> atomic_cmpxchg(), which seem to happen if some concurrent invocation
> advances the "done" counter past us before we get around to checking it.
> I agree on the atomic_inc_return() upon entry to the function, though.

Oooh, you're right.  It needs to be smp_mb().  We can put it right
before break but I don't think it would worth the ugliness.

> And this is going to need some serious testing either way.  ;-)

Definitely.  This is a scary piece of code.  :-)

-- 
tejun
