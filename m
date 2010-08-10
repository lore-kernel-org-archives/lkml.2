Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0HJNaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 09:30:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab0HJNaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 09:30:08 -0400
Date: Tue, 10 Aug 2010 15:29:18 +0200
From: Jan Kara <jack@suse.cz>
To: Neil Brown <neilb@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        Chris Mason <chris.mason@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 07/13] writeback: explicit low bound for vm.dirty_ratio
Message-ID: <20100810132918.GA3351@quack.suse.cz>
References: <20100805163401.e9754032.akpm@linux-foundation.org>
 <20100806124452.GC4717@localhost>
 <20100809235652.7113.A69D9226@jp.fujitsu.com>
 <20100810135712.0eb34759@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810135712.0eb34759@notabene>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-08-10 13:57:12, Neil Brown wrote:
> On Tue, 10 Aug 2010 12:12:06 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > Subject: writeback: explicit low bound for vm.dirty_ratio
> > > From: Wu Fengguang <fengguang.wu@intel.com>
> > > Date: Thu Jul 15 10:28:57 CST 2010
> > > 
> > > Force a user visible low bound of 5% for the vm.dirty_ratio interface.
> > > 
> > > This is an interface change. When doing
> > > 
> > > 	echo N > /proc/sys/vm/dirty_ratio
> > > 
> > > where N < 5, the old behavior is pretend to accept the value, while
> > > the new behavior is to reject it explicitly with -EINVAL.  This will
> > > possibly break user space if they checks the return value.
> > 
> > Umm.. I dislike this change. Is there any good reason to refuse explicit 
> > admin's will? Why 1-4% is so bad? Internal clipping can be changed later
> > but explicit error behavior is hard to change later.
> 
> As a data-point, I had a situation a while back where I needed a value below
> 1 to get desired behaviour.  The system had lots of RAM and fairly slow
> write-back (over NFS) so a 'sync' could take minutes.
> 
> So I would much prefer allowing not only 1-4, but also fraction values!!!
> 
> I can see no justification at all for setting a lower bound of 5.  Even zero
> can be useful - for testing purposes mostly.
  If you run on a recent kernel, /proc/sys/vm/dirty_background_bytes and
dirty_bytes is what was introduced exactly for these purposes. Not that I
would think that magic clipping at 5% is a good thing...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
