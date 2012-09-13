Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2IMAdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:33:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:7188 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab2IMAdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:33:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,413,1344236400"; 
   d="scan'208";a="221447563"
Date: Thu, 13 Sep 2012 08:33:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120913003337.GA16363@localhost>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120912024249.GB17922@localhost>
 <87sjan3c27.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjan3c27.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 05:00:48PM +0900, OGAWA Hirofumi wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> > On Wed, Sep 12, 2012 at 03:28:42AM +0900, OGAWA Hirofumi wrote:
> >> 
> >> If bdi has BDI_CAP_NO_WRITEBACK, bdi_forker_thread() doesn't start
> >> writeback thread. This means there is no consumer of work item made
> >> by bdi_queue_work().
> >> 
> >> This adds to checking of !bdi_cap_writeback_dirty(sb->s_bdi) before
> >> calling bdi_queue_work(), otherwise queued work never be consumed.
> >
> > Thanks for catching this! Does this bug have any side effects other
> > than memory leaking?
> >
> > It may be possible for some caller that actually expect it to do some
> > work to make progress, otherwise will eventually block.  If so, we'll
> > need to fix the caller.
> 
> If used custom bdi with BDI_CAP_NO_WRITEBACK, wait_for_completion()
> (e.g. sync_inodes_sb()) will be blocked forever.

The sync(2) block cannot be fixed by this patch?

> I tested by custom bdi with BDI_CAP_NO_WRITEBACK - sync(2) blocked
> forever by this reason.

What's your test script? How do you create/use that custom bdi?

Thanks,
Fengguang
