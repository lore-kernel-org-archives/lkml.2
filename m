Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab0DEUj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:39:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756351Ab0DEUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:39:52 -0400
Date: Mon, 5 Apr 2010 13:39:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raw: fsync method is now required
Message-Id: <20100405133902.082a6ef7.akpm@linux-foundation.org>
In-Reply-To: <20100404004523.GL5594@kryten>
References: <20100404004523.GL5594@kryten>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Apr 2010 10:45:23 +1000
Anton Blanchard <anton@samba.org> wrote:

> 
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

So if you run fsync() against a /dev/rawX fd you get -EINVAL?  erk.

> We have two options: fix it or remove the raw driver completely. I'm happy
> to do either, the fact this has been broken for so long suggests it is
> rarely used.

Well.  It shows that fsync() is rarely used.

> The patch below adds an fsync method to the raw driver. My knowledge of the
> block layer is pretty sketchy so this could do with a once over.
> 
> If we instead decide to remove the raw driver, this patch might still be
> useful as a backport to 2.6.33 and 2.6.32.

People go all whiny when I talk about removing raw.c.  I gave up.
