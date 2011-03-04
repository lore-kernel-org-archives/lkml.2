Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab1CDEJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:09:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758512Ab1CDEJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:09:11 -0500
Date: Thu, 3 Mar 2011 23:09:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
Message-ID: <20110304040907.GB32404@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 01:17:26AM +0000, Jens Axboe wrote:
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> ---
>  mm/filemap.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 380776c..f9a29c8 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1243,12 +1243,15 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  	unsigned long seg = 0;
>  	size_t count;
>  	loff_t *ppos = &iocb->ki_pos;
> +	struct blk_plug plug;
>  
>  	count = 0;
>  	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
>  	if (retval)
>  		return retval;
>  
> +	blk_start_plug(&plug);
> +

Jens,

IIUC, read requests will be considered SYNC and it looks like that
__make_request() will dispatch all the SYNC requests immediately. If
that's the case then for read path blk_plug mechanism is not required?

Thanks
Vivek
