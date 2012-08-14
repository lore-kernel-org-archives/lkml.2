Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab2HNNZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:25:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2HNNZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:25:08 -0400
Date: Tue, 14 Aug 2012 15:25:06 +0200
From: Jan Kara <jack@suse.cz>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Ashish Sangwan <ashish.sangwan2@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] UDF: During mount free lvid_bh before rescanning with
 different blocksize
Message-ID: <20120814132506.GB7122@quack.suse.cz>
References: <1342868717-1712-1-git-send-email-ashish.sangwan2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342868717-1712-1-git-send-email-ashish.sangwan2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 21-07-12 16:35:17, Ashish Sangwan wrote:
> If s_lvid_bh is not freed and set to NULL before re-scanning partition 
> with default block size, we might end up using wrong lvid in case
> s_lvid_bh is not updated in udf_load_logicalvolint during rescan.
> 
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
  Yeah, I don't think this happens in practice but in theory it could. BTW,
did you check whether we don't need to free other information (like VAT
inode etc.) when rescanning the filesystem? I think we do but currently I'm
catching up after a long vacation and this doesn't have high priority.

Anyway, I've added your patch to my tree. Thanks.

								Honza
> 
> ---
>  fs/udf/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index ac8a348..4a95c56 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1961,6 +1961,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
>  			if (!silent)
>  				pr_notice("Rescanning with blocksize %d\n",
>  					  UDF_DEFAULT_BLOCKSIZE);
> +			brelse(sbi->s_lvid_bh);
> +			sbi->s_lvid_bh = NULL;
>  			uopt.blocksize = UDF_DEFAULT_BLOCKSIZE;
>  			ret = udf_load_vrs(sb, &uopt, silent, &fileset);
>  		}
> -- 
> 1.7.2.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
