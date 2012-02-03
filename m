Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab2BCWXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:23:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab2BCWXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:23:34 -0500
Date: Fri, 3 Feb 2012 17:23:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203222329.GG9683@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203194105.GA12616@redhat.com>
 <20120203205910.GB14209@google.com>
 <20120203214435.GC12616@redhat.com>
 <20120203214719.GE14209@google.com>
 <20120203215349.GF9683@redhat.com>
 <20120203221409.GF14209@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203221409.GF14209@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 02:14:09PM -0800, Tejun Heo wrote:
> On Fri, Feb 03, 2012 at 04:53:49PM -0500, Vivek Goyal wrote:
> > Hmm... then blkiocg_reset_stats() will run into lock ordering issue. Can't
> > hold queue lock inside blkcg lock. I guess you will do some kind of
> > locking trick again as you did for io context logic.
> 
> Ummm... I don't know the details yet but decisions like making
> policies per-queue are much higher level than locking details.  There
> are cases where implementation details become problematic enough and
> high level decisions are affected but I don't really think that would
> be the case here.  It's not like reset stats is a hot path.  In fact,
> I don't even understand why the hell we have it.  I guess it's another
> blkcg braindamage.

git commit of when it was added.

commit 84c124da9ff50bd71fab9c939ee5b7cd8bef2bd9
Author: Divyesh Shah <dpshah@google.com>
Date:   Fri Apr 9 08:31:19 2010 +0200

..
o add a separate reset_stats interface
..

> 
> If userland is interested in delta between certain periods, it's
> supposed to read values at the start and end of the period and
> subtract.  Allowing reset might make sense if there's single bearded
> admin looking at the raw numbers, but it breaks as soon as tools and
> automation are involved.  How would you decide who owns those
> counters?
> 

Personally I consider it to be a debugging aid. User space applications
should do what you suggested and that is take delta between certain
periods.

Frankly speaking I have found it useful though. If I am debugging something,
I don't have to reboot the system to reset the stats and calculating the
difference from zero is easier for humans.

Thanks
Vivek
