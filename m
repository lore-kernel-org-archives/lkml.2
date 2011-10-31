Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767Ab1JaWxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:53:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934723Ab1JaWxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:53:18 -0400
Date: Mon, 31 Oct 2011 23:53:17 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] udf : fix metadata/mirror address print
Message-ID: <20111031225317.GC10107@quack.suse.cz>
References: <1320074740-1923-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320074740-1923-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 01-11-11 00:25:40, Namjae Jeon wrote:
> I found some bug in Skip-mirror-metadata-FE-loading-when-metadata-FE-is-ok patch
> So I try to fix metadata/mirror address print.
  Thanks. I've folded this patch into your previous one.

								Honza
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
> ---
>  fs/udf/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index b4921ab..dfe043a 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -860,7 +860,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
>  
>  	/* metadata address */
>  	udf_debug("Metadata file location: block = %d part = %d\n",
> -		  addr.logicalBlockNum, addr.partitionReferenceNum);
> +		  mdata->s_meta_file_loc, map->s_partition_num);
>  
>  	mdata->s_metadata_fe = udf_find_metadata_inode_efe(sb,
>  		mdata->s_meta_file_loc, map->s_partition_num);
> @@ -868,7 +868,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
>  	if (mdata->s_metadata_fe == NULL) {
>  		/* mirror file entry */
>  		udf_debug("Mirror metadata file location: block = %d part = %d\n",
> -			  addr.logicalBlockNum, addr.partitionReferenceNum);
> +			  mdata->s_mirror_file_loc, map->s_partition_num);
>  
>  		mdata->s_mirror_fe = udf_find_metadata_inode_efe(sb,
>  			mdata->s_mirror_file_loc, map->s_partition_num);
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
