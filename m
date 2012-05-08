Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2EHRDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:03:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:51235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab2EHRDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:03:04 -0400
Message-ID: <1336496568.8226.34.camel@twins>
Subject: Re: linux-next oops in __lock_acquire for process_one_work
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 19:02:48 +0200
In-Reply-To: <20120508165819.GB10687@google.com>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
	 <20120507175743.GC19417@google.com> <1336482202.16236.29.camel@twins>
	 <20120508165819.GB10687@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 09:58 -0700, Tejun Heo wrote:
> On Tue, May 08, 2012 at 03:03:22PM +0200, Peter Zijlstra wrote:
> > I think there's a problem if indeed we do silly things like small copies
> > like Hugh saw (why would gcc ever generate small copies for objects that
> > are naturally aligned and naturally sized?).
> > 
> > Something like the below should fix that problem, but it doesn't explain
> > the observed issue..
> 
> Hmmm.... Hugh, can you please verify whether this patch makes the
> problem go away somehow?
> 
> > @@ -1810,7 +1810,7 @@ __acquires(&gcwq->lock)
> >  	 * lock freed" warnings as well as problems when looking into
> >  	 * work->lockdep_map, make a copy and use that here.
> >  	 */
> > -	struct lockdep_map lockdep_map = work->lockdep_map;
> > +	struct lockdep_map lockdep_map = lockdep_copy_map(&work->lockdep_map);
> 
> If this is the correct fix for whatever reason, maybe we want the copy
> interface to be a bit more conventional?  lockdep_copy_map(to, from)?

Sure why not.. still not quite understanding the whole issue though.


