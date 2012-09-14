Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2INLPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:15:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:14121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095Ab2INLOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="222122231"
Date: Fri, 14 Sep 2012 19:14:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
Message-ID: <20120914111429.GA19509@localhost>
References: <87wr002z39.fsf@devron.myhome.or.jp>
 <20120913063906.GA24974@localhost>
 <871ui6e4tl.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ui6e4tl.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> @@ -120,6 +120,9 @@ __bdi_start_writeback(struct backing_dev
> >>  {
> >>  	struct wb_writeback_work *work;
> >>  
> >> +	if (!bdi_cap_writeback_dirty(bdi))
> >> +		return;
> >
> > Will someone in the current kernel actually call
> > __bdi_start_writeback() on a BDI_CAP_NO_WRITEBACK bdi?
> >
> > If the answer is no, VM_BUG_ON(!bdi_cap_writeback_dirty(bdi)) looks better.
> 
> I guess nobody call it in current kernel though. Hmm.., but we also have
> check in __mark_inode_dirty(), nobody should be using it, right?
> 
> If we defined it as the bug, I can't see what BDI_CAP_NO_WRITEBACK wants
> to do actually.  We are not going to allow to disable the writeback task?

> I was going to use this to disable writeback task on my developing FS...

That sounds like an interesting use case. Can you elaborate a bit more?
Note that even if you disable __bdi_start_writeback() here, the kernel
may also start writeback in the page reclaim path, the fsync() path,
and perhaps more.

Thanks,
Fengguang
