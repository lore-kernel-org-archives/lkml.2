Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab0KOP2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:28:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab0KOP2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:28:05 -0500
Date: Mon, 15 Nov 2010 10:28:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: yummylln@yahoo.com.cn
Subject: Re: [PATCH] blk-throttle: Fix calculation of max number of WRITES to
 be dispatched
Message-ID: <20101115152802.GG30792@redhat.com>
References: <20101027172941.GD12981@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027172941.GD12981@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 01:29:41PM -0400, Vivek Goyal wrote:
> o Currently we try to dispatch more READS and less WRITES (75%, 25%) in one
>   dispatch round. ummy pointed out that there is a bug in max_nr_writes
>   calculation. This patch fixes it.
> 
> Reported-by: ummy y <yummylln@yahoo.com.cn>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

Hi Jens,

Do you have any concerns about this patch? If not, can you please apply
it.

Thanks
Vivek

>  block/blk-throttle.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/block/blk-throttle.c
> ===================================================================
> --- linux-2.6.orig/block/blk-throttle.c	2010-10-27 10:57:25.000000000 -0400
> +++ linux-2.6/block/blk-throttle.c	2010-10-27 11:02:33.733048194 -0400
> @@ -645,7 +645,7 @@ static int throtl_dispatch_tg(struct thr
>  {
>  	unsigned int nr_reads = 0, nr_writes = 0;
>  	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
> -	unsigned int max_nr_writes = throtl_grp_quantum - nr_reads;
> +	unsigned int max_nr_writes = throtl_grp_quantum - max_nr_reads;
>  	struct bio *bio;
>  
>  	/* Try to dispatch 75% READS and 25% WRITES */
