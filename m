Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab0ITTOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:14:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab0ITTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:14:08 -0400
Date: Mon, 20 Sep 2010 15:13:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Yang Ruirui <ruirui.r.yang@tieto.com>, hch@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
Subject: Re: -mm: xfs lockdep warning
Message-ID: <20100920191355.GA28443@infradead.org>
References: <201009161546.16909.ruirui.r.yang@tieto.com>
 <20100917005227.GJ24409@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917005227.GJ24409@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:52:27AM +1000, Dave Chinner wrote:
> Christoph, this implies an inode that has been marked for reclaim
> that has not passed through xfs_fs_evict_inode() after being
> initialised. If it went through the eviction process, the iolock
> would have been re-initialised to a different context. Can you think
> of any path that can get here without going through ->evict? I can't
> off the top of my head...

I think this could happen if the init_inode_always during
re-initialization of an inode in reclaim fails in iget.  I have a patch
to add that I'll run through xfsqa.  It should only happen very rarely.

