Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0KAS6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:58:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37975 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0KAS6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=u/CqixMiUOC8VuJeRezlaO3XuVMRrrhgAqu8r8lfUH4IGpDmbfaBD7IIM3EaHMiXt0
         7Bkc/i0e62jAWB30La5ktMg9Wdx5+0fiDJyq21N3y+1hyb4cWEh6d1rMR5MZ08ncpN4L
         Ha8hvTyELoZhMfGmCmS4Krxkb/eFYa8L8hatc=
MIME-Version: 1.0
In-Reply-To: <1288636877-7964-6-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
	<1288636877-7964-6-git-send-email-tdent48227@gmail.com>
Date: Mon, 1 Nov 2010 20:58:49 +0200
X-Google-Sender-Auth: Ekd9okeiWZEpdHhb95h64JStv5c
Message-ID: <AANLkTikgq2uAW5ko0qG5fe+w-LGvwiV6z3Oi51V_QuiK@mail.gmail.com>
Subject: Re: [PATCH 05/29] Staging: yaffs2: yaffs_allocator: Add files
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
>  drivers/staging/yaffs2/yaffs_allocator.c |  408 ++++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_allocator.h |   30 +++
>  2 files changed, 438 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_allocator.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_allocator.h
>
> diff --git a/drivers/staging/yaffs2/yaffs_allocator.c b/drivers/staging/yaffs2/yaffs_allocator.c
> new file mode 100644
> index 0000000..024ee2a
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_allocator.c
> @@ -0,0 +1,408 @@
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
> +
> +
> +#include "yaffs_allocator.h"
> +#include "yaffs_guts.h"
> +#include "yaffs_trace.h"
> +#include "yportenv.h"
> +
> +#ifdef CONFIG_YAFFS_YMALLOC_ALLOCATOR
> +
> +void yaffs_deinit_raw_tnodes_and_objs(yaffs_dev_t *dev)
> +{
> +       dev = dev;
> +}
> +
> +void yaffs_init_raw_tnodes_and_objs(yaffs_dev_t *dev)
> +{
> +       dev = dev;
> +}
> +
> +yaffs_tnode_t *yaffs_alloc_raw_tnode(yaffs_dev_t *dev)
> +{
> +       return (yaffs_tnode_t *)YMALLOC(dev->tnode_size);
> +}
> +
> +void yaffs_free_raw_tnode(yaffs_dev_t *dev, yaffs_tnode_t *tn)
> +{
> +       dev = dev;
> +       YFREE(tn);
> +}

So you have your own dynamic memory allocator? What's wrong with kmalloc()?
