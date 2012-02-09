Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2BIX7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:59:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33985 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab2BIX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:59:03 -0500
Date: Thu, 9 Feb 2012 15:58:45 -0800
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        oleg@redhat.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20120209235845.GH19392@google.com>
References: <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111223014043.GC12738@redhat.com>
 <20111222175834.66559c8b.akpm@linux-foundation.org>
 <20111223025629.GE12738@redhat.com>
 <20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111227175249.GE17712@google.com>
 <20111228091402.c45a08f6.kamezawa.hiroyu@jp.fujitsu.com>
 <20111228004102.GK17712@google.com>
 <20120105012842.GQ31746@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105012842.GQ31746@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Wed, Jan 04, 2012 at 05:28:42PM -0800, Tejun Heo wrote:
> On Tue, Dec 27, 2011 at 04:41:02PM -0800, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Dec 28, 2011 at 09:14:02AM +0900, KAMEZAWA Hiroyuki wrote:
> > > > This is essentially more specialized form of the mempool approach.  It
> > > > doesn't seem any simpler to me while being less generic.  I don't see
> > > > what the upside would be.
> > > 
> > > Hm, but this never causes -ENOMEM error, at all.
> > 
> > Ooh, I missed the part it falls back to the global counter if percpu
> > counters aren't allocated yet.  Yeah, this is an interesting approach.
> > I'll think more about it.
> 
> I've been staring at the blkcg stats code and commit logs and am
> wondering whether we can just scrap percpu counters there.  It seems
> the reason why it was introduced in the first place is to avoid
> stats->lock, which BTW is extremely heavy handed for gathering stats,
> overhead in fast paths and I think there can be easier ways to avoid
> stats->lock.

I could remove stats_lock without much trouble but couldn't get
blk-throtl fast path stat working. :(

I think I'll try to get KAMEZAWA's percpu counter working.  Any
objections?

Thanks.

-- 
tejun
