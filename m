Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab1EBJdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:33:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35296 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756404Ab1EBJdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:33:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BFRE3F0iBPe5MOibda4gm+VXX+pZzJNWq83tF8j
	/nXx6FXVAi6fu7
Subject: Re: [PATCH tip/core/rcu 31/86] rcu: further lower priority in
 rcu_yield()
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <20110502081121.GT2297@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
	 <1304256126-26015-31-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1304272264.7417.20.camel@marge.simson.net>
	 <20110502081121.GT2297@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 11:33:06 +0200
Message-ID: <1304328786.26772.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 01:11 -0700, Paul E. McKenney wrote:
> On Sun, May 01, 2011 at 07:51:04PM +0200, Mike Galbraith wrote:
> > On Sun, 2011-05-01 at 06:21 -0700, Paul E. McKenney wrote:
> > > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > > 
> > > Although rcu_yield() dropped from real-time to normal priority, there
> > > is always the possibility that the competing tasks have been niced.
> > > So nice to 19 in rcu_yield() to help ensure that other tasks have a
> > > better chance of running.
> > 
> > But.. that just prolongs the pain of overhead you _have_ to eat, no?  In
> > a brief surge, fine, you can spread the cost out.. but how do you know
> > when it's ok to yield?
> 
> I modeled this code on the existing code in ksoftirqd.  But yes, this is
> a heuristic.  I do believe that it is quite robust, but time will tell.

(It probably is fine, but when I see 'yield', alarms and sirens go off)

