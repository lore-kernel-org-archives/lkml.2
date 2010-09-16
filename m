Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0IPOML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:12:11 -0400
Received: from fieldses.org ([174.143.236.118]:47185 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab0IPOMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:12:05 -0400
Date: Thu, 16 Sep 2010 10:10:48 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove BKL from fs/locks.c
Message-ID: <20100916141048.GB32378@fieldses.org>
References: <201009142206.54130.arnd@arndb.de>
 <1284501356.10782.139.camel@heimdal.trondhjem.org>
 <20100915204203.GA27837@fieldses.org>
 <201009161028.56837.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009161028.56837.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 10:28:56AM +0200, Arnd Bergmann wrote:
> On Wednesday 15 September 2010 22:42:03 J. Bruce Fields wrote:
> > Looking over the server code....  The only code I see under the BKL is:
> > 
> >         - a few lease callbacks in fs/nfsd/nfs4state.c, none of which
> >           sleep at this point, so all should be fine under a spinlock or
> >           whatever we want.
> >         - fs/nfsd/nfs4state.c:check_for_locks(), which explicitly takes
> >           the BKL itself.  All it does, though, is walk the lock list
> >           for a given file and check whether any of them have a given
> >           owner.  It would be trivial to put it under some other lock
> >           and/or move it to locks.c.
> 
> Ok. In the version of the patch I sent out yesterday, I came to the
> same conclusion and put both of these under lock_flocks(), which
> is still the BKL but can be converted to a spinlock after we have
> sorted out ceph and lockd. If you and others are fine with this patch,
> I'll add it to my bkl/config series.
> 
> Note that walking the i_flock list needs to use lock_flocks()
> (or the BKL), not a private lock. I guess that's what you are saying
> anyway, just making sure.

Yes, that's fine.

--b.
