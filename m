Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab2BIJuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:50:08 -0500
Received: from mailhost-c5-p0.nerim.net ([195.5.209.11]:36447 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429Ab2BIJuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:50:05 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 04:50:05 EST
Date: Thu, 9 Feb 2012 10:40:19 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: remove plugging at buffered write time
Message-ID: <20120209094019.GA516@brouette>
References: <20120208110143.GA5550@localhost>
 <1328750089.5949.1.camel@sli10-conroe>
 <20120209080726.GB28465@localhost>
 <20120209092535.GA10272@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209092535.GA10272@brouette>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Done, thanks! Here is the updated patch with O_SYNC write fix.

> Got these errors with the updated patch on top of 3.3-rc3:

> fs/sync.c: In function 'vfs_fsync_range':
> fs/sync.c:167:18: error: storage size of 'plug' isn't known
> fs/sync.c:173:2: error: implicit declaration of function 'blk_start_plug' [-Werror=implicit-function-declaration]
> fs/sync.c:175:2: error: implicit declaration of function 'blk_finish_plug' [-Werror=implicit-function-declaration]
> fs/sync.c:167:18: warning: unused variable 'plug' [-Wunused-variable]

Adding a #include <linux/blkdev.h> at the top of fs/sync.c solved the
problem. Of course, this needs approval of a kernel developper before
being added to the patch and resubmitted because I know adding #includes
can have unwanted consequences sometimes or be seen as bloat...

-- 
Damien Wyart
