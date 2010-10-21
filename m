Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0JUCTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:19:34 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:38998 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756775Ab0JUCTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:19:32 -0400
Date: Thu, 21 Oct 2010 13:17:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
 information cache
Message-ID: <20101021021751.GH12506@dastard>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
 <20101019225839.12396.92630.stgit@paris.rdu.redhat.com>
 <20101019231747.GC12506@dastard>
 <1287574269.3488.11.camel@twins>
 <20101020220557.GN32255@dastard>
 <AANLkTikoPoV=OYjzX9+Rd5tWERS+n8sFejJuot7++ONP@mail.gmail.com>
 <1287614875.23812.7.camel@heimdal.trondhjem.org>
 <AANLkTi=HAQEqqswmueJHoc5ez3Bq1_3X2xZkO9sg8gzZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=HAQEqqswmueJHoc5ez3Bq1_3X2xZkO9sg8gzZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 05:58:19PM -0700, Linus Torvalds wrote:
> On Wed, Oct 20, 2010 at 3:47 PM, Trond Myklebust
> <Trond.Myklebust@netapp.com> wrote:
> >
> > That is a really interesting alternative to traditional locking. Could
> > we perhaps document it in Documentation/rbtree.txt?
> 
> Well, I'd actually suggest avoiding it unless you feel that you
> _really_ need it. So I wouldn't want to really suggest it as a generic
> locking model - you had better have looked at pretty much all other
> alternatives first.  And if that seqlock starts failing a lot under
> load, it ends up being _more_ expensive than just taking the lock in
> the first place.

Thanks for pointing out that caveat. I think that the XFS buffer
cache case won't have that problem - I'm seeing better than a 100:1
tree lookup (>1M/s) to modification rate (<10k inserts/s) under
workloads that are stressing the cache on an 8-way VM...

Still, as the only method I've heard of that allows RCU lookup on
rbtrees, perhaps it is still worth documenting along with all the
caveats of when not to use this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
