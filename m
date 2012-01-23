Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2AWPfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:35:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57447 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2AWPfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:35:01 -0500
Date: Mon, 23 Jan 2012 07:34:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] blkcg: make CONFIG_BLK_CGROUP bool
Message-ID: <20120123153454.GA12652@google.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-2-git-send-email-tj@kernel.org>
 <20120123150051.GC25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123150051.GC25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 23, 2012 at 10:00:51AM -0500, Vivek Goyal wrote:
> On Sat, Jan 21, 2012 at 07:25:09PM -0800, Tejun Heo wrote:
> > Block cgroup core can be built as module; however, it isn't too useful
> > as blk-throttle can only be built-in and cfq-iosched is usually the
> > default built-in scheduler.  Scheduled blkcg cleanup requires calling
> > into blkcg from block core.  To simplify that, disallow building blkcg
> > as module by making CONFIG_BLK_CGROUP bool.
> > 
> > If building blkcg core as module really matters, which I doubt, we can
> > revisit it after blkcg API cleanup.
> 
> I think not allowing compiling blk-cgroup as module is a good thing.

Sure, it's nice.  It just is mostly pointless at this point and
hinders API cleanup.  As written above, if this really matters, let's
add it back after cleanup is complete.

> >  config IOSCHED_CFQ
> >  	tristate "CFQ I/O scheduler"
> > -	# If BLK_CGROUP is a module, CFQ has to be built as module.
> > -	depends on (BLK_CGROUP=m && m) || !BLK_CGROUP || BLK_CGROUP=y
> > +	depends on BLK_CGROUP
> 
> You don't need above dependency now. Otherwise if BLK_CGROUP=n then one
> can't use CFQ. We just want cfq group scheduling to be dependent on
> BLK_CGROUP.

Ooh, right, will drop the line.

Thanks.

-- 
tejun
