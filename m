Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2HOMXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:23:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2HOMXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:23:50 -0400
Date: Wed, 15 Aug 2012 14:23:47 +0200
From: Jan Kara <jack@suse.cz>
To: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: fix retun value on error path in
 udf_load_logicalvol
Message-ID: <20120815122347.GC29223@quack.suse.cz>
References: <c50410075da9d2f4cd7ebb42fadf11a67dcfa175.1344983600.git.npajkovs@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c50410075da9d2f4cd7ebb42fadf11a67dcfa175.1344983600.git.npajkovs@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-08-12 00:38:08, Nikola Pajkovsky wrote:
> In case we detect a problem and bail out, we fail to set "ret" to a
> nonzero value, and udf_load_logicalvol will mistakenly report success.
> 
> Signed-off-by: Nikola Pajkovsky <npajkovs@redhat.com>
  Thanks. I've added the patch to my tree and will send it to Linus soon.

								Honza

> ---
>  fs/udf/super.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index dcbf987..c96bd77 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1344,6 +1344,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
>  		udf_err(sb, "error loading logical volume descriptor: "
>  			"Partition table too long (%u > %lu)\n", table_len,
>  			sb->s_blocksize - sizeof(*lvd));
> +		ret = 1;
>  		goto out_bh;
>  	}
>  
> @@ -1388,8 +1389,10 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
>  						UDF_ID_SPARABLE,
>  						strlen(UDF_ID_SPARABLE))) {
>  				if (udf_load_sparable_map(sb, map,
> -				    (struct sparablePartitionMap *)gpm) < 0)
> +				    (struct sparablePartitionMap *)gpm) < 0) {
> +					ret = 1;
>  					goto out_bh;
> +				}
>  			} else if (!strncmp(upm2->partIdent.ident,
>  						UDF_ID_METADATA,
>  						strlen(UDF_ID_METADATA))) {
> -- 
> 1.7.10.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
