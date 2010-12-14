Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0LNE7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:59:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:8875 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986Ab0LNE7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:59:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,340,1288594800"; 
   d="scan'208";a="686874325"
Date: Tue, 14 Dec 2010 12:59:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, "Wu, Fengguang" <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/35] IO-less dirty throttling v4
Message-ID: <20101214045948.GA12454@localhost>
References: <20101213144646.341970461@intel.com>
 <AANLkTinFeu7LMaDFgUcP3r2oqVHE5bei3T5JTPGBNvS9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinFeu7LMaDFgUcP3r2oqVHE5bei3T5JTPGBNvS9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 11:26:29AM +0800, Yan, Zheng wrote:
> got error "global_dirty_limits" [fs/nfs/nfs.ko] undefined! when
> compiling dirty-throttling-v4

Thanks! This should fix it. The fix will show up in the git tree after a while.

Thanks,
Fengguang
---
Subject: writeback: export global_dirty_limits() for NFS
Date: Tue Dec 14 12:55:18 CST 2010

"global_dirty_limits" [fs/nfs/nfs.ko] undefined!

Reported-by: Yan Zheng <zheng.z.yan@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next.orig/mm/page-writeback.c	2010-12-14 12:54:57.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-14 12:55:11.000000000 +0800
@@ -419,6 +419,7 @@ void global_dirty_limits(unsigned long *
 	*pbackground = background;
 	*pdirty = dirty;
 }
+EXPORT_SYMBOL_GPL(global_dirty_limits);
 
 /**
  * bdi_dirty_limit - @bdi's share of dirty throttling threshold
