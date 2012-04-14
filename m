Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab2DNR0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 13:26:01 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34226 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2DNR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 13:26:00 -0400
Date: Sat, 14 Apr 2012 10:25:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC 0/7] rcu: v2 Inlinable preemptible rcu_read_lock()
 and rcu_read_unlock()
Message-ID: <20120414172504.GH2452@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <CA+55aFyR7Rt0-guH4TrrS83VQLsj-wrvQgOwvrf0UscRCxM-OA@mail.gmail.com>
 <CA+55aFzrmg2Fqg9VD9zV==gxiimW_By2zM17AvJXKY5ecX-ang@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzrmg2Fqg9VD9zV==gxiimW_By2zM17AvJXKY5ecX-ang@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041417-7282-0000-0000-000008302D96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 10:08:54AM -0700, Linus Torvalds wrote:
> On Sat, Apr 14, 2012 at 9:58 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I'll see if it boots and what it does to my profiles and
> > microbenchmark, though.
> 
> Ok, I can't see any performance difference in the numbers - my
> benchmark noise is *much* bigger than anything this would show.

Might still be worthwhile on embedded CPUs that don't optimize
function calls as thoroughly as does x86, maybe?

> The profile looks fine, and obviously __rcu_read_lock() is entirely
> gone. The top user (avc_has_perm_flags()) looks fine. I note that you
> might want to look at the placement of the percpu data - I think it
> probably makes sense to put the RCU data close to 'current' etc to get
> as much cacheline sharing as possible, and it doesn't seem to be right
> now, but it looks reasonable.

Is there somewhere in non-architecture-specific code that would be a
good place to put this?  Or is the DEFINE_PER_CPU() for current_task
moving from arch/x86 to core code?

> But on the whole, I can't claim that it looks noticeable ;*(

Well, then, I guess I don't feel quite so bad about having prioritized
this so low for so long.  ;-)

							Thanx, Paul

