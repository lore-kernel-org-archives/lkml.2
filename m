Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2BAL3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:29:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab2BAL3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:29:00 -0500
Date: Wed, 1 Feb 2012 12:28:57 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] udf: Remove unnecessary OOM messages
Message-ID: <20120201112857.GB16714@quack.suse.cz>
References: <cover.1328049542.git.joe@perches.com>
 <49874be55a105675b5878a0381920f27d5717341.1328049542.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49874be55a105675b5878a0381920f27d5717341.1328049542.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 31-01-12 14:42:10, Joe Perches wrote:
> Per call site OOM messages are unnecessary.
> k.alloc and v.alloc failures use dump_stack().
  Thanks. Applied.

							Honza

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/udf/super.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index c09a84d..19111f9 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -948,11 +948,8 @@ static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
>  	else
>  		bitmap = vzalloc(size); /* TODO: get rid of vzalloc */
>  
> -	if (bitmap == NULL) {
> -		udf_err(sb, "Unable to allocate space for bitmap and %d buffer_head pointers\n",
> -			nr_groups);
> +	if (bitmap == NULL)
>  		return NULL;
> -	}
>  
>  	bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
>  	bitmap->s_nr_groups = nr_groups;
> -- 
> 1.7.8.111.gad25c.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
