Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1LVIJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:09:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49415 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab1LVIJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:09:09 -0500
Date: Thu, 22 Dec 2011 08:08:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111222080856.GM23916@ZenIV.linux.org.uk>
References: <4EF084A4.3000106@linux.vnet.ibm.com>
 <20111220140628.GD23916@ZenIV.linux.org.uk>
 <4EF09D34.1060607@linux.vnet.ibm.com>
 <20111220175919.GE23916@ZenIV.linux.org.uk>
 <4EF0DE04.6030604@linux.vnet.ibm.com>
 <20111220195806.GF23916@ZenIV.linux.org.uk>
 <4EF24C71.6000609@linux.vnet.ibm.com>
 <20111221141229.7f691c43.akpm@linux-foundation.org>
 <20111222070214.GK23916@ZenIV.linux.org.uk>
 <20111221232047.3c3c63d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221232047.3c3c63d3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:20:47PM -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 07:02:15 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Wed, Dec 21, 2011 at 02:12:29PM -0800, Andrew Morton wrote:
> > > off-topic, but the lockdep stuff in include/linux/lglock.h
> > > (LOCKDEP_INIT_MAP and DEFINE_LGLOCK_LOCKDEP) appears to be dead code.
> > 
> > Um?  See ..._lock_init(); it's used there.
> 
> oops, I had Andi's patch applied.
> 
> Wanna take a look at it while things are fresh in your mind?

a) tons of trivial conflicts with fs/namespace.c changes in my tree
b) more seriously, the question of overhead - see the mail you replied
to.

I really, really don't like templates, so in general I would prefer to do
something fairly close to what Andi seems to have done in that patch.
However, we *are* talking about some fairly hot paths and I'm really not
comfortable with doing that kind of changes that late in the cycle.
If somebody cares to take Andi's patch and see what it does to overhead,
I'd love to see the results; we might do that in the next merge window.
Again, the idea itself is obviously OK; the only problem is with the
performance issues.
