Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1LVISD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:18:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39576 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1LVIR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:17:59 -0500
Date: Thu, 22 Dec 2011 09:17:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than online CPUs
Message-ID: <20111222081757.GC11715@one.firstfloor.org>
References: <20111220140628.GD23916@ZenIV.linux.org.uk> <4EF09D34.1060607@linux.vnet.ibm.com> <20111220175919.GE23916@ZenIV.linux.org.uk> <4EF0DE04.6030604@linux.vnet.ibm.com> <20111220195806.GF23916@ZenIV.linux.org.uk> <4EF24C71.6000609@linux.vnet.ibm.com> <20111221141229.7f691c43.akpm@linux-foundation.org> <20111222070214.GK23916@ZenIV.linux.org.uk> <20111221232047.3c3c63d3.akpm@linux-foundation.org> <20111222080856.GM23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222080856.GM23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 08:08:56AM +0000, Al Viro wrote:
> On Wed, Dec 21, 2011 at 11:20:47PM -0800, Andrew Morton wrote:
> > On Thu, 22 Dec 2011 07:02:15 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > On Wed, Dec 21, 2011 at 02:12:29PM -0800, Andrew Morton wrote:
> > > > off-topic, but the lockdep stuff in include/linux/lglock.h
> > > > (LOCKDEP_INIT_MAP and DEFINE_LGLOCK_LOCKDEP) appears to be dead code.
> > > 
> > > Um?  See ..._lock_init(); it's used there.
> > 
> > oops, I had Andi's patch applied.
> > 
> > Wanna take a look at it while things are fresh in your mind?
> 
> a) tons of trivial conflicts with fs/namespace.c changes in my tree
> b) more seriously, the question of overhead - see the mail you replied
> to.
> 

The costly operations here are the atomics and nothing really changes
for them. So I don't expect any measurable difference.

I actually have an idea to remove them for the common case, but not in 
that patchkit or cycle :)

I can run a ftrace if you want, but I expect any difference to be below
the measurement inaccuracy.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
