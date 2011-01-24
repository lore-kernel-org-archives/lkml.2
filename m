Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1AXR7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:59:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab1AXR7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:59:45 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 10/10] fs: make aio plug
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-11-git-send-email-jaxboe@fusionio.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 24 Jan 2011 12:59:29 -0500
In-Reply-To: <1295659049-2688-11-git-send-email-jaxboe@fusionio.com> (Jens
	Axboe's message of "Sat, 22 Jan 2011 01:17:29 +0000")
Message-ID: <x497hdugp32.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jaxboe@fusionio.com> writes:

> From: Shaohua Li <shaohua.li@intel.com>
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> ---
>  fs/aio.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index c5ea494..1476bed 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1660,6 +1660,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>  	long ret = 0;
>  	int i;
>  	struct hlist_head batch_hash[AIO_BATCH_HASH_SIZE] = { { 0, }, };
> +	struct blk_plug plug;
>  
>  	if (unlikely(nr < 0))
>  		return -EINVAL;
> @@ -1676,6 +1677,8 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>  		return -EINVAL;
>  	}
>  
> +	blk_start_plug(&plug);
> +
>  	/*
>  	 * AKPM: should this return a partial result if some of the IOs were
>  	 * successfully submitted?
> @@ -1698,6 +1701,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
>  		if (ret)
>  			break;
>  	}
> +	blk_finish_plug(&plug);
>  	aio_batch_free(batch_hash);

I'm pretty sure you want blk_finish_plug to run after aio_batch_free.

Cheers,
Jeff
