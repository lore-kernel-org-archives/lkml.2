Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1FJI6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:58:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57146 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1FJI6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c0oc5giCrotL4NKBEBDzcsDO6naGYPyxdgSp9C0YqqJw8QCE8z5cwXNd0GABWQbVWJ
         McU6JRQADDa5t4GEBcuA==
MIME-Version: 1.0
In-Reply-To: <20110607013630.GF17026@somewhere.redhat.com>
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
	<rcu-splat-split-printk@mdm.bga.com>
	<20110606181021.GL3066@linux.vnet.ibm.com>
	<20110607001905.GE17026@somewhere.redhat.com>
	<20110607004250.GZ3066@linux.vnet.ibm.com>
	<20110607013630.GF17026@somewhere.redhat.com>
Date: Fri, 10 Jun 2011 01:58:42 -0700
Message-ID: <BANLkTik8NFKjcCHZ0EoWqRve-+fCj53vP=_71a=q9A-7-Nmwow@mail.gmail.com>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent states
From: Michel Lespinasse <walken@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 6:36 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Ok but that only improves the rcu debugging. What about instead improving
> might_sleep() to also work in !PREEMPT, so that it profits to any detection
> of forbidden sleeping (sleep inside spinlock, preempt_disable, might_fault, etc...)
>
> We could define a new config:
>
> config PREEMPT_COUNT
>       default PREEMPT || DEBUG_SPINLOCK_SLEEP
>
> and build preempt_disable()/preempt_enable() on top of that instead
> of using CONFIG_PREEMPT directly.
>
> Does that look sane?

Yes, I think this would be helpful.

I actually sent out a patch for that about a year ago - message title
was "Stronger CONFIG_DEBUG_SPINLOCK_SLEEP without CONFIG_PREEMPT".
However that code has rotted since, and my attempt at a trivial port
ended up spewing complaints in dmesg at boot time...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
