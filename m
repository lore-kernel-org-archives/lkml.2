Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0CQPvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:51:06 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50208 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0CQPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:51:04 -0400
Date: Wed, 17 Mar 2010 08:51:49 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Neil Brown <neilb@suse.de>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
In-Reply-To: <20100317182136.0f2ab805@notabene.brown>
Message-ID: <Pine.LNX.4.64.1003170847110.25675@cobra.newdream.net>
References: <20100317154145.bd9fca16.sfr@canb.auug.org.au>
 <20100317182136.0f2ab805@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010, Neil Brown wrote:

> On Wed, 17 Mar 2010 15:41:45 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Greg,
> > 
> > After merging the driver-core tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > fs/ceph/msgpool.c: In function 'ceph_msgpool_put':
> > fs/ceph/msgpool.c:173: error: implicit declaration of function 'kref_set'
> > 
> > Caused by commit 10c5d9fdc9ba89606b34f01cbe6ea287abba7395 ("kref: remove
> > kref_set") from the driver-core tree interacting with commit
> > c2e552e76e2c6907ca50cd9a4b747a2e2e8c615e ("ceph: use kref for ceph_msg")
> > from the ceph tree.
> > 
> > I applied the following patch for today (which may not be correct):
> 
> I would say this is correct.

Yeah, the fix is good, thanks Stephen!  I'll add it to my tree shortly.

> It is a pity that this code cannot use mempool_t....
> What if mempool_t were changed to only re-alloc the vector of pointers when
> it grew, or when it shrank to less than 1/2 it's current size.  Would that
> reduce the frequency of allocations enough for you to be comfortable with it? 
> i.e. always make the vector a power-of-2 size (which is what is probably
> allocated anyway) while the pool size might be less.
> ??

That would improve the situation, but still mean potentially large 
allocations (the pools can grow pretty big) that aren't strictly 
necessary.  I can imagine a more modular mempool_t with an ops vector for 
adding/removing from the pool to cope with situations like this, but I'm 
not sure it's worth the effort?

sage
