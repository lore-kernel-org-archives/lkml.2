Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2AWT50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:57:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2AWT5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:57:25 -0500
Date: Mon, 23 Jan 2012 14:57:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123195717.GM25986@redhat.com>
References: <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123182745.GK25986@redhat.com>
 <20120123184336.GI12652@google.com>
 <20120123193335.GK12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123193335.GK12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:33:35AM -0800, Tejun Heo wrote:
> On Mon, Jan 23, 2012 at 10:43:36AM -0800, Tejun Heo wrote:
> > Yeah, this is much more arguable.  I don't think it would be too
> > complex to keep per-policy granularity even w/ unified blkg managed by
> > blkcg core (we'll just need to point to separately allocated
> > per-policy data from the unified blkg and clear them selectively).
> > I'm just not convinced of its necessity.  With initial config out of
> > the way, elvs and blkcg policies don't get molested all that often.
> > 
> > I'll see how complex it actually gets.  If it isn't too much
> > complexity, yeah, why not...
> 
> Hmmm... while this isn't terribly complex, it involves considerable
> amount of churn as core layer doesn't currently know what policies are
> bound to which queues how - we'll have to add some part of that before
> shootdown change, use it there, and then later replace it with proper
> per-queue thing.  The conversion is already painful enough without
> adding another chunk to juggle around.  Given that clearing all on pol
> change isn't too crazy, how about the following?
> 
> * For now, clear unconditionally on pol/elv change.
> 
> * But structure things such that policy specific data are allocated
>   separately and on pol/elv change only those policy specific part is
>   flushed.
> 
> * Later, if deemed necessary, make the clearing of pol-specific part
>   selective.

It would be good if you add one more part to your series (say part4) to
make it happen. We probably don't want to get into mess that from kernel
version A to B we had x behavior, from B to C we broke changed it to y
and in kernel version D we restored it back to x. User space now go
figure what kernel version you are running and behave appropriately. For
distributions supporting these different kernels will become a mess.

So IMHO, if you can keep pol-specific clearing part a separate series
which gets committed in the same kernel version, would help a lot.

Thanks
Vivek
