Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2APP3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:29:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab2APP3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:29:00 -0500
Date: Mon, 16 Jan 2012 10:28:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20120116152853.GB9129@redhat.com>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Tejun, 

If you get rid of stats->lock, and also don't use per cpu data strucutres
how would we avoid races in case of concurrent update (IO submission?).

Thanks
Vivek
