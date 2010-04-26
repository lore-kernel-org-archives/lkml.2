Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0DZXzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:55:49 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:57698 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239Ab0DZXzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:55:48 -0400
Date: Tue, 27 Apr 2010 09:55:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com
Subject: Re: Direct aio_write/truncate question
Message-ID: <20100426235503.GA9703@dastard>
References: <87633hdr6n.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87633hdr6n.fsf@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 03:29:36PM +0400, Dmitry Monakhov wrote:
> My be my question appeared to obvious for someone, but still
> 
> fd = open("a", O_DIRECT, )
> fd2 = open("b", O_DIRECT, )
> write(fd, buf ,size) /* allocate blocks for a file */
> fsync(fd) /* Now, it is guaranteed that blocks are allocated.*/
> /* Submit async rewrite request */ 
> io_prep_pwrite(io, fd, io->u.c.buf, size, 0);
> io_submit(myctx, 1, io); /* Io is in flight after this */
> /* Ok, truncate the file */
> ftruncate(fd, 0)
> /* Reuse truncated block blocks for a new file */
> write(fd2,buf ,size)     /* old a's blocks belongs to b now. */
> 
> What protect us from aio request to rewrite content of new file?

The filesystem is supposed to serialise truncate vs write races.
i.e. the truncate will occur either before the write is executed or
after it has completed, not while it is running.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
