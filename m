Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2IMGD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:03:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:60386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab2IMGD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:03:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,415,1344236400"; 
   d="scan'208";a="221528632"
Date: Thu, 13 Sep 2012 14:03:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120913060351.GA23682@localhost>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120912024249.GB17922@localhost>
 <87sjan3c27.fsf@devron.myhome.or.jp>
 <20120913003337.GA16363@localhost>
 <87a9wueayc.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9wueayc.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 02:41:31PM +0900, OGAWA Hirofumi wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> >> If used custom bdi with BDI_CAP_NO_WRITEBACK, wait_for_completion()
> >> (e.g. sync_inodes_sb()) will be blocked forever.
> >
> > The sync(2) block cannot be fixed by this patch?
> 
> This patch fixes block problem too.

Ah OK, my sight was somehow limited by the screen size and only saw
the first chunk...

> >> I tested by custom bdi with BDI_CAP_NO_WRITEBACK - sync(2) blocked
> >> forever by this reason.
> >
> > What's your test script? How do you create/use that custom bdi?
> 
> Ah, I wrote my kernel module to test. I guess there is no users in
> current kernel for now, because it doesn't work.

OK. Got it. So I'd suggest to change the first chunk to a VM_BUG_ON(),
which should be enough to catch new bad callers. The other two chunks
look fine.

Thanks,
Fengguang
