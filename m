Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0DGXAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:00:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42684 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab0DGXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:00:13 -0400
Date: Wed, 7 Apr 2010 16:00:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/urgent] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100407230009.GK2481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100407171342.GF2481@linux.vnet.ibm.com>
 <20100407162620.GA11543@linux.vnet.ibm.com>
 <27310.1270659627@redhat.com>
 <27837.1270660848@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27837.1270660848@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 06:20:48PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > In other cases, there will be a reference counter or a "not yet fully
> > initialized" flag that can (and should) be tested.
> 
> Why would you be using rcu_access_pointer() there?  Why wouldn't you be using
> rcu_dereference_protected()?

Excellent question.  I am writing up the documentation now, and will
either (1) have a good use case or (2) remove the condition.

> Also, one other thing:  Should the default versions of these functions make
> some reference to 'c' to prevent compiler warnings?  Should:
> 
> 	#define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
> 
> for example, be:
> 
> 	#define rcu_dereference_check(p, c)	\
> 	({					\
> 		if (1 || !(c))			\
> 			rcu_dereference_raw(p);	\
> 	})
> 
> I'm not sure it's necessary, but it's possible to envisage a situation where
> someone calculates something specifically for use in 'c', which will cause an
> warning from the compiler if c isn't then checked.

I did try this.  The problem is that it breaks the build for non-lockdep
configurations due to the lockdep-check primitives not being defined.  :-(

							Thanx, Paul
