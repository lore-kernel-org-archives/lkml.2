Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab1LVHCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:02:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60385 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1LVHCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:02:31 -0500
Date: Thu, 22 Dec 2011 07:02:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111222070214.GK23916@ZenIV.linux.org.uk>
References: <4EF0654B.4060904@linux.vnet.ibm.com>
 <4EF06C9B.4010703@linux.vnet.ibm.com>
 <4EF084A4.3000106@linux.vnet.ibm.com>
 <20111220140628.GD23916@ZenIV.linux.org.uk>
 <4EF09D34.1060607@linux.vnet.ibm.com>
 <20111220175919.GE23916@ZenIV.linux.org.uk>
 <4EF0DE04.6030604@linux.vnet.ibm.com>
 <20111220195806.GF23916@ZenIV.linux.org.uk>
 <4EF24C71.6000609@linux.vnet.ibm.com>
 <20111221141229.7f691c43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221141229.7f691c43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:12:29PM -0800, Andrew Morton wrote:
> off-topic, but the lockdep stuff in include/linux/lglock.h
> (LOCKDEP_INIT_MAP and DEFINE_LGLOCK_LOCKDEP) appears to be dead code.

Um?  See ..._lock_init(); it's used there.

> > + DEFINE_SPINLOCK(name##_cpu_lock);					\
> > + cpumask_t name##_cpus __read_mostly;					\
> >   DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
> >   DEFINE_LGLOCK_LOCKDEP(name);						\
> >  									\
> 
> also off-topic: we can't define a static lglock with this macro.

True...  I don't like the general STL feel of that code, TBH.  The only
thing that stops me from putting all that stuff into a struct and
getting rid of those macros from hell is that we'd need to use alloc_percpu()
and that means extra overhead, potentially quite painful on the "local"
side of those.  May be worth experimenting with later, but not at this
point in cycle...

Anyway, to Linus it goes.
