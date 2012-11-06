Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2KFXEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:04:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab2KFXEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:04:30 -0500
Date: Wed, 7 Nov 2012 00:04:27 +0100
From: Jan Kara <jack@suse.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Jan Kara <jack@suse.cz>, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] fs/ext3/inode.c: drop if around WARN_ON
Message-ID: <20121106230427.GB16836@quack.suse.cz>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
 <1351974625-10282-5-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351974625-10282-5-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 03-11-12 21:30:21, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Just use WARN_ON rather than an if containing only WARN_ON(1).
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) WARN_ON(1);
> + WARN_ON(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
  Thanks. Added into my tree.

							Honza

> ---
>  fs/ext3/inode.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 7e87e37..b176d42 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1071,8 +1071,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
>  	 * mapped. 0 in case of a HOLE.
>  	 */
>  	if (err > 0) {
> -		if (err > 1)
> -			WARN_ON(1);
> +		WARN_ON(err > 1);
>  		err = 0;
>  	}
>  	*errp = err;
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
