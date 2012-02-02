Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2BBROU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:14:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57252 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab2BBROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:14:17 -0500
Date: Thu, 2 Feb 2012 09:14:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] blkcg: make CONFIG_BLK_CGROUP bool
Message-ID: <20120202171410.GD19837@google.com>
References: <1328129429-11823-1-git-send-email-tj@kernel.org>
 <1328129429-11823-2-git-send-email-tj@kernel.org>
 <4F2A3305.9050009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2A3305.9050009@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:53:57PM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> > Block cgroup core can be built as module; however, it isn't too useful
> > as blk-throttle can only be built-in and cfq-iosched is usually the
> > default built-in scheduler.  Scheduled blkcg cleanup requires calling
> > into blkcg from block core.  To simplify that, disallow building blkcg
> > as module by making CONFIG_BLK_CGROUP bool.
> > 
> > If building blkcg core as module really matters, which I doubt, we can
> > revisit it after blkcg API cleanup.
> > 
> > -v2: Vivek pointed out that IOSCHED_CFQ was incorrectly updated to
> >      depend on BLK_CGROUP.  Fixed.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/Kconfig.iosched |    4 ----
> >  block/blk-cgroup.c    |   17 -----------------
> >  block/blk-cgroup.h    |   10 ++--------
> >  init/Kconfig          |    2 +-
> >  4 files changed, 3 insertions(+), 30 deletions(-)
> > 
> 
> You can merge the following change with your patch.

Nice, will do.

> Moreover, some cgroup APIs were exported to allow blk-cgroup to be built
> as a module, and now they can be unexported.

Yeah, that would be nice too.  Let's think about that after this whole
block thing settles down.

Thanks.

-- 
tejun
