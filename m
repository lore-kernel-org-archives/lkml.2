Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0DFPPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:15:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0DFPPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:15:11 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raw: fsync method is now required
References: <20100404004523.GL5594@kryten>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 06 Apr 2010 11:14:42 -0400
In-Reply-To: <20100404004523.GL5594@kryten> (Anton Blanchard's message of
	"Sun, 4 Apr 2010 10:45:23 +1000")
Message-ID: <x49mxxgr4t9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard <anton@samba.org> writes:

> Commit 148f948ba877f4d3cdef036b1ff6d9f68986706a (vfs: Introduce new helpers for syncing after writing to O_SYNC file or IS_SYNC inode) broke the raw driver.
>
> We now call through generic_file_aio_write -> generic_write_sync ->
> vfs_fsync_range. vfs_fsync_range has:
>
>         if (!fop || !fop->fsync) {
>                 ret = -EINVAL;
>                 goto out;
>         }
>
> But drivers/char/raw.c doesn't set an fsync method. 
>
> We have two options: fix it or remove the raw driver completely. I'm happy
> to do either, the fact this has been broken for so long suggests it is
> rarely used.
>
> The patch below adds an fsync method to the raw driver. My knowledge of the
> block layer is pretty sketchy so this could do with a once over.
>
> If we instead decide to remove the raw driver, this patch might still be
> useful as a backport to 2.6.33 and 2.6.32.

Databases like to use the raw interface.  Thanks for fixing this!

> Signed-off-by: Anton Blanchard <anton@samba.org>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
