Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab0KPLQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:16:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0KPLQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:16:15 -0500
Date: Tue, 16 Nov 2010 12:16:11 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <josef@redhat.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101116111611.GA4757@quack.suse.cz>
References: <1289840723-3056-1-git-send-email-josef@redhat.com>
 <1289840723-3056-2-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289840723-3056-2-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-11-10 12:05:18, Josef Bacik wrote:
> diff --git a/fs/open.c b/fs/open.c
> index 4197b9e..ab8dedf 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -EINVAL;
>  
>  	/* Return error if mode is not supported */
> -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> +	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
  Why not just:
if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) ?

> diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> index 3c15510..851cba2 100644
> --- a/include/linux/falloc.h
> +++ b/include/linux/falloc.h
> @@ -2,6 +2,7 @@
>  #define _FALLOC_H_
>  
>  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
> +#define FALLOC_FL_PUNCH_HOLE	0X02 /* de-allocates range */
                                 ^ use lowercase 'x' please...


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
