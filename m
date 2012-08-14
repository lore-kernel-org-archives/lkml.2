Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2HNTsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2HNTsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:48:53 -0400
Date: Tue, 14 Aug 2012 15:48:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v3 2/6] floppy: do put_disk on current dr if
 blk_init_queue fails
Message-ID: <20120814194835.GE5760@redhat.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
 <1344881787-6422-3-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344881787-6422-3-git-send-email-herton.krzesinski@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:16:23PM -0300, Herton Ronaldo Krzesinski wrote:
> If blk_init_queue fails, we do not call put_disk on the current dr
> (dr is decremented first in the error handling loop).
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> ---
>  drivers/block/floppy.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index c8d9e68..1e09e99 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4151,6 +4151,7 @@ static int __init do_floppy_init(void)
>  
>  		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
>  		if (!disks[dr]->queue) {
> +			put_disk(disks[dr]);
>  			err = -ENOMEM;
>  			goto out_put_disk;
>  		}

I think it will create conflict with patch 6. Will it not call put_disk()
twice on disks[dr].

Why are we retaining this patch given the fact that we will loop through
all the drives and queues in out_put_disk.

Thanks
Vivek
