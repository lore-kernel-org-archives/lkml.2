Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0KEJLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:11:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:35680 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab0KEJLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:11:19 -0400
Date: Fri, 5 Nov 2010 10:11:17 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 40/49] fs/udf: Use vzalloc
Message-ID: <20101105091117.GA5033@quack.suse.cz>
References: <cover.1288925424.git.joe@perches.com>
 <a47fec6f62a102773e28984b86f34525fd42b540.1288925425.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a47fec6f62a102773e28984b86f34525fd42b540.1288925425.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-11-10 20:08:04, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/udf/super.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
  I've merged the patch into my tree.

							Honza

> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 4a5c7c6..6e07d99 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -959,9 +959,9 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
>  		(sizeof(struct buffer_head *) * nr_groups);
>  
>  	if (size <= PAGE_SIZE)
> -		bitmap = kmalloc(size, GFP_KERNEL);
> +		bitmap = kzalloc(size, GFP_KERNEL);
>  	else
> -		bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
> +		bitmap = vzalloc(size); /* TODO: get rid of vmalloc */
>  
>  	if (bitmap == NULL) {
>  		udf_error(sb, __func__,
> @@ -970,7 +970,6 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
>  		return NULL;
>  	}
>  
> -	memset(bitmap, 0x00, size);
>  	bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
>  	bitmap->s_nr_groups = nr_groups;
>  	return bitmap;
> -- 
> 1.7.3.1.g432b3.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
