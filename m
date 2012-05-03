Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2ECDxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:53:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:10235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab2ECDxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:53:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148759364"
Date: Thu, 3 May 2012 11:53:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH] writeback: initialize global_dirty_limit
Message-ID: <20120503035313.GA14606@localhost>
References: <20120408010600.GA31377@localhost>
 <x494nst7z3v.fsf@segfault.boston.devel.redhat.com>
 <20120411161344.309f12ef.akpm@linux-foundation.org>
 <20120412013224.GA5859@localhost>
 <20120412022040.GA6800@localhost>
 <20120412142634.GA16559@quack.suse.cz>
 <20120413014026.GA9027@localhost>
 <20120503034311.GA14081@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503034311.GA14081@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents global_dirty_limit from remaining 0 (the initial value)
for long time, since it's only updated in update_dirty_limit() when
above the dirty freerun area.

It will avoid unexpected consequences when some random code use it as a
convenient approximation of the global dirty threshold.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next.orig/mm/page-writeback.c	2012-04-25 20:16:12.766859391 +0800
+++ linux-next/mm/page-writeback.c	2012-05-03 11:44:32.746272930 +0800
@@ -1568,6 +1568,7 @@ void writeback_set_ratelimit(void)
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	global_dirty_limits(&background_thresh, &dirty_thresh);
+	global_dirty_limit = dirty_thresh;
 	ratelimit_pages = dirty_thresh / (num_online_cpus() * 32);
 	if (ratelimit_pages < 16)
 		ratelimit_pages = 16;
