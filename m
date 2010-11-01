Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0KATBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:01:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52434 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab0KATBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CqsAXmyE6ne/CU7b6M8nybKUZ/hNcs7UJxp8UbHqRenzubktcX4RuO7wje9N0w0go9
         rur6Hc9TvovyJA/f1qdOeM0QO0aBkR7Hr9Vl7Uaw6QHZVKV0SLuVkKZHD/CrY1L5byZd
         CXoOPpULkmeHfgzxVFfgX7BN6sGj9OFgztwpw=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-7-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-7-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 21:01:39 +0200
X-Google-Sender-Auth: W88TkAvv6dcvCZ7sObcYI1fji9s
Message-ID: <AANLkTimrnj-xfS8_xGjAXk1Ee-vnOXrdj6vB163h60kw@mail.gmail.com>
Subject: Re: [PATCH 06/29] Staging: yaffs2: yaffs_bitmap: Add files
From: Pekka Enberg <penberg@kernel.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 8:40 PM, Tracey Dent <tdent48227@gmail.com> wrote:
> Adding files to yaffs2 directory.
>
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yaffs_bitmap.c |  105 +++++++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_bitmap.h |   33 ++++++++++
>  2 files changed, 138 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_bitmap.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_bitmap.h
>
> diff --git a/drivers/staging/yaffs2/yaffs_bitmap.c b/drivers/staging/yaffs2/yaffs_bitmap.c
> new file mode 100644
> index 0000000..85c8c1d
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_bitmap.c
> @@ -0,0 +1,105 @@
> +/*
> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
> + *
> + * Copyright (C) 2002-2010 Aleph One Ltd.
> + *   for Toby Churchill Ltd and Brightstar Engineering
> + *
> + * Created by Charles Manning <charles@aleph1.co.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "yaffs_bitmap.h"
> +#include "yaffs_trace.h"
> +/*
> + * Chunk bitmap manipulations
> + */
> +
> +static Y_INLINE __u8 *yaffs_block_bits(yaffs_dev_t *dev, int blk)
> +{
> +       if (blk < dev->internal_start_block || blk > dev->internal_end_block) {
> +               T(YAFFS_TRACE_ERROR,
> +                       (TSTR("**>> yaffs: BlockBits block %d is not valid" TENDSTR),
> +                       blk));
> +               YBUG();
> +       }
> +       return dev->chunk_bits +
> +               (dev->chunk_bit_stride * (blk - dev->internal_start_block));
> +}

We have <linux/bitmap.h>. You should probably use it.
