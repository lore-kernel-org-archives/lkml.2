Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab0KATPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:15:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20760 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab0KATPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:15:50 -0400
Date: Mon, 1 Nov 2010 20:05:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tracey Dent <tdent48227@gmail.com>
cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 15/29] Staging: yaffs2: yaffs_mtdif2: Add files
In-Reply-To: <1288636877-7964-16-git-send-email-tdent48227@gmail.com>
Message-ID: <alpine.LNX.2.00.1011012002350.12889@swampdragon.chaosbits.net>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-16-git-send-email-tdent48227@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Tracey Dent wrote:

> Adding files to yaffs2 directory.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yaffs_mtdif2.c |  256 +++++++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_mtdif2.h |   29 ++++
>  2 files changed, 285 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_mtdif2.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_mtdif2.h
> 
> diff --git a/drivers/staging/yaffs2/yaffs_mtdif2.c b/drivers/staging/yaffs2/yaffs_mtdif2.c
> new file mode 100644
> index 0000000..1c60a44
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_mtdif2.c
...
> +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 17))
> +	ops.mode = MTD_OOB_AUTO;
> +	ops.ooblen = (dev->param.inband_tags) ? 0 : packed_tags_size;
> +	ops.len = dev->param.total_bytes_per_chunk;
> +	ops.ooboffs = 0;
> +	ops.datbuf = (__u8 *)data;
> +	ops.oobbuf = (dev->param.inband_tags) ? NULL : packed_tags_ptr;
> +	retval = mtd->write_oob(mtd, addr, &ops);
> +
> +#else
...
> +#if (LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 17))
> +	if (dev->param.inband_tags || (data && !tags))
> +		retval = mtd->read(mtd, addr, dev->param.total_bytes_per_chunk,
> +				&dummy, data);
> +	else if (tags) {
> +		ops.mode = MTD_OOB_AUTO;
> +		ops.ooblen = packed_tags_size;
> +		ops.len = data ? dev->data_bytes_per_chunk : packed_tags_size;
> +		ops.ooboffs = 0;
> +		ops.datbuf = data;
> +		ops.oobbuf = yaffs_dev_to_lc(dev)->spare_buffer;
> +		retval = mtd->read_oob(mtd, addr, &ops);
> +	}
> +#else
...

If/when this code gets merged it will definitely be into a kernel with a 
version greater than 2.6.17, so I believe you should just get rid of the 
#ifdef and the code in the #else parts.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

