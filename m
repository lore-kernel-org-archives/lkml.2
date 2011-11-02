Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1KBJKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:10:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49800
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab1KBJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:10:21 -0400
Date: Wed, 2 Nov 2011 05:10:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Kara <jack@suse.cz>,
        Curt Wohlgemuth <curtw@google.com>, Michael Rubin <mrubin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Tang Feng <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com
Subject: Re: writeback tree status (for 3.2 merge window)
Message-ID: <20111102091012.GA25879@infradead.org>
References: <20111101074347.GA23644@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101074347.GA23644@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 03:43:47PM +0800, Wu Fengguang wrote:
> Hi,
> 
> There are 3 patchsets sitting in the writeback tree.
> 
>         1) IO-less dirty throttling v12
>         https://github.com/fengguang/linux/commits/dirty-throttling-v12
> 
>         2) writeback reasons tracing from Curt Wohlgemuth
>         https://github.com/fengguang/linux/commits/writeback-reason
> 
>         3) writeback queuing changes from Jan Kara and me
>         https://github.com/fengguang/linux/commits/requeue-io-wait
> 
> They have been merged into this branch testing in linux-next for a while:
> 
> https://github.com/fengguang/linux/commits/writeback-for-next
> 
> Since (3) still has an unresolved issue (detailed in the below
> links), it looks better to hold it back for this merge window.

Given that we have run into issues so much with it that's proably
the better idea.

To fix the originally reported issue with the missing file size updates
in XFS we plan to simply log all filesize changes in XFS.  Currently I
had this in the 3.3 queue, but in the worst case we might have to move
this forward to 3.2.

> The patches from (1,2) together with 2 tracing patches essential for
> debugging (1) have been pushed to the "writeback-for-linus" branch:
> 
>         http://git.kernel.org/?p=linux/kernel/git/wfg/linux.git;a=shortlog;h=refs/heads/writeback-for-linus
> 
> If no objections, I'll send a pull request to Linus soon.

Please do so.  I'm really looking forward to see the I/O-less
balance_dirty_pages in ASAP.

