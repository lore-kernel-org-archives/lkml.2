Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab1JDXaC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:30:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677Ab1JDXaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:30:00 -0400
Date: Wed, 5 Oct 2011 01:29:58 +0200
From: Jan Kara <jack@suse.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext3/balloc.c: local functions should be static
Message-ID: <20111004232958.GA21205@quack.suse.cz>
References: <201109231355.52431.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109231355.52431.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23-09-11 13:55:52, H Hartley Sweeten wrote:
> This quites the sparse noise:
> 
> warning: symbol 'ext3_trim_all_free' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
  Thanks, merged into my tree.

								Honza
> 
> ---
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 6386d76..8e62ec5 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -1924,9 +1924,10 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
>   * reaches any used block. Then issue a TRIM command on this extent and free
>   * the extent in the block bitmap. This is done until whole group is scanned.
>   */
> -ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
> -				ext3_grpblk_t start, ext3_grpblk_t max,
> -				ext3_grpblk_t minblocks)
> +static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
> +					unsigned int group,
> +					ext3_grpblk_t start, ext3_grpblk_t max,
> +					ext3_grpblk_t minblocks)
>  {
>  	handle_t *handle;
>  	ext3_grpblk_t next, free_blocks, bit, freed, count = 0;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
