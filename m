Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2IFOWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:22:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab2IFOWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:22:33 -0400
Date: Thu, 6 Sep 2012 16:22:31 +0200
From: Jan Kara <jack@suse.cz>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] UDF: Fix incorrect error handling in udf_direct_IO()
Message-ID: <20120906142231.GA12539@quack.suse.cz>
References: <20120905190239.GK18051@quack.suse.cz>
 <1346926091-3654-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346926091-3654-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-09-12 11:08:11, Ian Abbott wrote:
> My recent patch to add DIRECT_IO support to the UDF filesystem handler
> contains a mistake in the error recovery if blockdev_direct_IO() fails.
> The test `rw && WRITE` should be `rw & WRITE`.  Fix it.
> 
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
  Thanks. I've folded the change into your patch.

								Honza

> ---
>  fs/udf/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index b905448..41d5830 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -156,7 +156,7 @@ static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
>  
>  	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
>  				  udf_get_block);
> -	if (unlikely(ret < 0 && (rw && WRITE)))
> +	if (unlikely(ret < 0 && (rw & WRITE)))
>  		udf_write_failed(mapping, offset + iov_length(iov, nr_segs));
>  	return ret;
>  }
> -- 
> 1.7.12
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
