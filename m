Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0IWRXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:23:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56489 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0IWRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:23:42 -0400
Date: Thu, 23 Sep 2010 10:23:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/rcu 5/8] rcu: only one evaluation of arg in
 rcu_dereference_check() unless sparse
Message-ID: <20100923172337.GF2406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100923005033.GA22006@linux.vnet.ibm.com>
 <1285203053-22068-5-git-send-email-paulmck@linux.vnet.ibm.com>
 <201009231513.40126.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009231513.40126.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:13:39PM +0200, Arnd Bergmann wrote:
> On Thursday 23 September 2010, Paul E. McKenney wrote:
> > The current version of the __rcu_access_pointer(), __rcu_dereference_check(),
> > and __rcu_dereference_protected() macros evaluate their "p" argument
> > three times, not counting typeof()s.  This is bad news if that argument
> > contains a side effect.  This commit therefore evaluates this argument
> > only once in normal kernel builds.  However, the straightforward approach
> > defeats sparse's RCU-pointer checking, so when __CHECKER__ is defined,
> > the additional pair of evaluations of the "p" argument are performed in
> > order to permit sparse to detect misuse of RCU-protected pointers.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> 
> Sorry for not following up with the alternative approach yet. We can always
> do that later, for your patch should go into 2.6.36 to fix any problems
> arising from unintended macro side-effects.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

No problem, when you get me a better approach, I will happily queue it!

							Thanx, Paul
