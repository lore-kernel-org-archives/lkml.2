Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2LWVsC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 16:48:02 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56986 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2LWVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 16:47:59 -0500
Message-ID: <1356299260.9057.8.camel@erika>
Subject: Re: [PATCH] brd: enable diskstats
From: Ryo Onodera <ryoqun@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Date: Mon, 24 Dec 2012 06:47:40 +0900
In-Reply-To: <1356298868.9057.3.camel@erika>
References: <1353309387.12210.0.camel@erika>
	 <CAOEQZHGe7_9xwvQK-O13WcU+9EdqMpi+VAD0ECq5ahUJ1-dnKg@mail.gmail.com>
	 <1356298868.9057.3.camel@erika>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm Ryo Onodera.

This is a resend for my earlier patch. Because I got no reply, I've
added other people as CC, picking from the commit history of the
relevant file.

I created this very tiny patch to enable /proc/diskstats for /dev/ramX.

I'm contacting Nick Piggin as the maintainer of ramdisk ram block. As
mentioned above, I'm also contacting some related people to get more
attention.

This is my first patch to the Linux kernel. Sorry if this is not the
expected way of submitting patches.

Regards

On Mon, 2012-12-24 at 06:41 +0900, Ryo Onodera wrote:
> Signed-off-by: Ryo Onodera <ryoqun@gmail.com>
> ---
>  drivers/block/brd.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 531ceb3..181b2d7 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -332,6 +332,7 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
>  	sector_t sector;
>  	int i;
>  	int err = -EIO;
> +	int cpu;
>  
>  	sector = bio->bi_sector;
>  	if (sector + (bio->bi_size >> SECTOR_SHIFT) >
> @@ -348,6 +349,12 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
>  	if (rw == READA)
>  		rw = READ;
>  
> +	cpu = part_stat_lock();
> +	part_stat_inc(cpu, &brd->brd_disk->part0, ios[rw]);
> +	part_stat_add(cpu, &brd->brd_disk->part0, sectors[rw],
> +					bio_sectors(bio));
> +	part_stat_unlock();
> +
>  	bio_for_each_segment(bvec, bio, i) {
>  		unsigned int len = bvec->bv_len;
>  		err = brd_do_bvec(brd, bvec->bv_page, len,


