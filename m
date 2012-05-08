Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2EHSME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:12:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58582 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2EHSMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:12:02 -0400
Date: Tue, 8 May 2012 11:11:48 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
In-Reply-To: <20120508165819.GB10687@google.com>
Message-ID: <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils> <20120507175743.GC19417@google.com> <1336482202.16236.29.camel@twins> <20120508165819.GB10687@google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Tejun Heo wrote:
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

Sure, but I won't start the run until tonight, and it'll then take
a couple of days for us to be sure (sometimes it hit within the
hour, sometimes it would take half a day).

Certainly the principle, cleaning out the cache, looked sound.

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

Please send me the version of patch you'd like to put in
(lest I make it up myself and you don't like the result).

Hugh
