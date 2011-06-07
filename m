Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab1FGXZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:25:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:52049 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758907Ab1FGXY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="10857724"
Date: Wed, 8 Jun 2011 07:24:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] writeback: introduce .tagged_writepages for the
 WB_SYNC_NONE sync stage
Message-ID: <20110607232456.GA19547@localhost>
References: <20110607213236.634026193@intel.com>
 <20110607213853.513366237@intel.com>
 <20110607160234.53de9f93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607160234.53de9f93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:02:34AM +0800, Andrew Morton wrote:
> On Wed, 08 Jun 2011 05:32:37 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > sync(2) is performed in two stages: the WB_SYNC_NONE sync and the
> > WB_SYNC_ALL sync. Identify the first stage with .tagged_writepages and
> > do livelock prevention for it, too.
> > 
> > Note that writeback_inodes_sb() is called by not only sync(), they are
> > treated the same because the other callers also need livelock prevention.
> > 
> > Impact:  It changes the order in which pages/inodes are synced to disk.
> > Now in the WB_SYNC_NONE stage, it won't proceed to write the next inode
> > until finished with the current inode.
> 
> What problem is this patch actually fixing?  It sounds like there's
> some livelock scenario in the WB_SYNC_NONE phase.  otoh the final
> paragraph implies that the WB_SYNC_NONE phase is failing to write some
> pages under some situations.

Problem is: the WB_SYNC_NONE phase has no livelock prevention _at all_.

Jan's commit f446daaea9 ("mm: implement writeback livelock avoidance
using page tagging") is a partial fix in that it only fixed the
WB_SYNC_ALL phase livelock.

Although ext4 is tested to no longer livelock with commit f446daaea9,
it may due to some "redirty_tail() after pages_skipped" effect which
is by no means a guarantee for _all_ the file systems.

> Suggest that the changelog be fleshed out to cover all of this.

OK, I'll add the above two paragraphs to the changelog.

Thanks,
Fengguang
