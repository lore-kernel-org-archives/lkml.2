Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2DNQ6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:58:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60071 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2DNQ63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120414161953.GA18140@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 09:58:07 -0700
X-Google-Sender-Auth: 8vAnJwh5_5Zo3rvFc7uaQBS7Pmk
Message-ID: <CA+55aFyR7Rt0-guH4TrrS83VQLsj-wrvQgOwvrf0UscRCxM-OA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/7] rcu: v2 Inlinable preemptible rcu_read_lock() and rcu_read_unlock()
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 9:19 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> This series is version two of the inlinable versions of preemptible
> RCU's __rcu_read_lock() and __rcu_read_unlock().  The first version may
> be found at https://lkml.org/lkml/2012/3/25/94.  The individual commits
> in this new series are as follows:

Ok, I'm looking at code generation changes for this now, and sadly (or
not) all the changes to the selinux code have actually  made the RCU
overhead that made me notice this issue originally much less
noticeable because we inline the right things etc, and that helped
with some of the problems that the rcu callsites had.

The fact that we don't have to indirect through "current" does seem to
make the code much simpler, though. So hopefully the actual rcu
unlocking code itself is better. But that was just under 1% of the
benchmark cost, so I was hoping that the call sites would be more
noticeable.

I'll see if it boots and what it does to my profiles and
microbenchmark, though.

                    Linus
