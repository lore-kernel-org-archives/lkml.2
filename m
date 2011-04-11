Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1DKG1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 02:27:11 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:65495 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab1DKG1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 02:27:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwDAIScok15LHHJgWdsb2JhbACmGBUBARYmJcA1DoVgBJN7
Date: Mon, 11 Apr 2011 16:27:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Q. locking order of dcache_lru_lock
Message-ID: <20110411062703.GC21395@dastard>
References: <9769.1302268831@jrobl>
 <1302369133.2388.1.camel@twins>
 <29946.1302498571@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29946.1302498571@jrobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 02:09:31PM +0900, J. R. Okajima wrote:
> 
> Peter Zijlstra:
> > On Fri, 2011-04-08 at 22:20 +0900, J. R. Okajima wrote:
> > >=20
> > > When spin_trylock(&dentry->d_lock) successfully acquired d_lock, does
> > > the violation of locking order happen (or a deadlock, in worse case)?=20
> >
> > No, since a trylock never actually blocks a deadlock cannot occur.
> 
> Ah, exactly. I had to be sleeping when I wrote about deadlock.
> How about the locking order? Do you think d_lock after dcache_lru_lock
> is a problem?

>From fs/dcache.c:

 * Ordering:
 * dentry->d_inode->i_lock
 *   dentry->d_lock
 *     dcache_lru_lock
 *     dcache_hash_bucket lock
 *     s_anon lock

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
