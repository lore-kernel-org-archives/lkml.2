Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0DFPeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:34:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab0DFPe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:34:26 -0400
Date: Tue, 6 Apr 2010 17:34:37 +0200
From: Jan Kara <jack@suse.cz>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raw: fsync method is now required
Message-ID: <20100406153437.GB4420@quack.suse.cz>
References: <20100404004523.GL5594@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404004523.GL5594@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 04-04-10 10:45:23, Anton Blanchard wrote:
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
  Thanks for catching this. The patch looks fine.
 
> If we instead decide to remove the raw driver, this patch might still be
> useful as a backport to 2.6.33 and 2.6.32.
  Oracle databases still use raw devices so I don't think we should remove
them.

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
--
Jan Kara <jack@suse.cz>
SUSE Labs, CR
