Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2KSH0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:26:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33410 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KSH0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:26:19 -0500
MIME-Version: 1.0
In-Reply-To: <1353309387.12210.0.camel@erika>
References: <1353309387.12210.0.camel@erika>
Date: Mon, 19 Nov 2012 16:26:18 +0900
Message-ID: <CAOEQZHGe7_9xwvQK-O13WcU+9EdqMpi+VAD0ECq5ahUJ1-dnKg@mail.gmail.com>
Subject: Re: [PATCH] Enable /proc/diskstats for /dev/ramX
From: Ryo Onodera <ryoqun@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm Ryo Onodera. I created this very tiny patch to enable /proc/diskstats for
/dev/ramX.

I'm contacting Nick Piggin as the maintainer of ramdisk ram block.

This is my first patch to the Linux kernel. Sorry if this is not the expected
way of submitting patches.

Regards

Ryo Onodera

On Mon, Nov 19, 2012 at 4:16 PM, Ryo Onodera <ryoqun@gmail.com> wrote:
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
>         sector_t sector;
>         int i;
>         int err = -EIO;
> +       int cpu;
>
>         sector = bio->bi_sector;
>         if (sector + (bio->bi_size >> SECTOR_SHIFT) >
> @@ -348,6 +349,12 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
>         if (rw == READA)
>                 rw = READ;
>
> +       cpu = part_stat_lock();
> +       part_stat_inc(cpu, &brd->brd_disk->part0, ios[rw]);
> +       part_stat_add(cpu, &brd->brd_disk->part0, sectors[rw],
> +                                       bio_sectors(bio));
> +       part_stat_unlock();
> +
>         bio_for_each_segment(bvec, bio, i) {
>                 unsigned int len = bvec->bv_len;
>                 err = brd_do_bvec(brd, bvec->bv_page, len,
> --
> 1.7.9.5
>
>
>
