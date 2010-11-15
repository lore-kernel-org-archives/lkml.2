Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab0KOP1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:27:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0KOP1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:27:33 -0500
Date: Mon, 15 Nov 2010 10:27:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] fix amiga and atari floppy driver compile warning
Message-ID: <20101115152709.GF30792@redhat.com>
References: <20101028184223.GG30148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101028184223.GG30148@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 02:42:23PM -0400, Vivek Goyal wrote:
> Geert, my crosstool don't produce warning below. I guess this has to do
> something with compiler version.
> 
> - Geert noticed following warning during compilation.
> 
>   drivers/block/amiflop.c:1344: warning: ‘rq’ may be used uninitialized in
>   this function
>   drivers/block/ataflop.c:1402: warning: ‘rq’ may be used uninitialized in
>   this function
> 
> - Initialize rq to NULL to fix the warning. If we can't find a suitable request
>   to dispatch, this function should return NULL instead of a possibly garbage
>   pointer.
> 
> - Cross compile tested only. Don't have hardware to test it.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Jens,

Do you have any concerns about this patch? If not, can you please apply
it.

Thanks
Vivek

> ---
>  drivers/block/amiflop.c |    2 +-
>  drivers/block/ataflop.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/block/amiflop.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/amiflop.c	2010-10-28 14:32:25.000000000 -0400
> +++ linux-2.6/drivers/block/amiflop.c	2010-10-28 14:34:11.000000000 -0400
> @@ -1341,7 +1341,7 @@ static struct request *set_next_request(
>  {
>  	struct request_queue *q;
>  	int cnt = FD_MAX_UNITS;
> -	struct request *rq;
> +	struct request *rq = NULL;
>  
>  	/* Find next queue we can dispatch from */
>  	fdc_queue = fdc_queue + 1;
> Index: linux-2.6/drivers/block/ataflop.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/ataflop.c	2010-10-28 14:31:21.000000000 -0400
> +++ linux-2.6/drivers/block/ataflop.c	2010-10-28 14:33:58.000000000 -0400
> @@ -1399,7 +1399,7 @@ static struct request *set_next_request(
>  {
>  	struct request_queue *q;
>  	int old_pos = fdc_queue;
> -	struct request *rq;
> +	struct request *rq = NULL;
>  
>  	do {
>  		q = unit[fdc_queue].disk->queue;
