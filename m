Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2AaNeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:34:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:4925 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab2AaNeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:34:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101523846"
Date: Tue, 31 Jan 2012 21:24:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rabin Vincent <rabin@rab.in>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, chanho0207@gmail.com
Subject: Re: [PATCHv2] backing-dev: fix wakeup timer races with
 bdi_unregister()
Message-ID: <20120131132403.GA20016@localhost>
References: <20120116025331.GA16516@localhost>
 <1326991820-31393-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326991820-31393-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 10:20:20PM +0530, Rabin Vincent wrote:
> While 7a401a972df8e18 ("backing-dev: ensure wakeup_timer is deleted")
> addressed the problem of the bdi being freed with a queued wakeup
> timer, there are other races that could happen if the wakeup timer
> expires after/during bdi_unregister(), before bdi_destroy() is called.
> 
> wakeup_timer_fn() could attempt to wakeup a task which has already has
> been freed, or could access a NULL bdi->dev via the wake_forker_thread
> tracepoint.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Reported-by: Chanho Min <chanho.min@lge.com>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---

Thanks. I just pushed it to linux-next, together with this related one:

        Subject: writeback: fix NULL bdi->dev in trace writeback_single_inode
        Date: Tue Jan 17 11:18:56 CST 2012

        bdi_prune_sb() resets sb->s_bdi to default_backing_dev_info when the
        tearing down the original bdi. Fix trace_writeback_single_inode to
        use sb->s_bdi=default_backing_dev_info rather than bdi->dev=NULL for a
        teared down bdi.

        Reported-by: Rabin Vincent <rabin@rab.in>
        Tested-by: Rabin Vincent <rabin@rab.in>
        Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
