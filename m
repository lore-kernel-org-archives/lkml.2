Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1DDHGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:06:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33779 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1DDHGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t3UQnr68Yt+K9Wxotr5B4Nf1BEWCBhhRLc49Ipq0WZM9T+UQvXht6uELcg9EW/quxi
         y6HoVp4BSWak94//0ugrtU9XLHYyWxZVqZL7z5g2vlW5l/+Og38MOutzOHVH9YLm3XO3
         W7YnoNH6XVHX+yqzrtr2YfWArtplFwbQJvTlo=
Subject: Re: [PATCH] ubifs: Use empty_iops and empty_fops consistently
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
References: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 10:04:16 +0300
Message-ID: <1301900656.2760.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 01:55 +0200, Sedat Dilek wrote:
> Follow the nomenclature as we did for empty_aops and rename
> to empty_iops and empty_fops.
> 
> This patch is on top of linux-2.6-block.git#for-linus.
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> CC: Artem Bityutskiy <dedekind1@gmail.com>
> CC: Adrian Hunter <adrian.hunter@nokia.com>
> CC: Jens Axboe <jaxboe@fusionio.com>
> ---
>  fs/ubifs/xattr.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
> index 3299f46..16f19f5 100644
> --- a/fs/ubifs/xattr.c
> +++ b/fs/ubifs/xattr.c
> @@ -80,8 +80,8 @@ enum {
>  	SECURITY_XATTR,
>  };
>  
> -static const struct inode_operations none_inode_operations;
> -static const struct file_operations none_file_operations;
> +static const struct inode_operations empty_iops;
> +static const struct file_operations empty_fops;
>  
>  /**
>   * create_xattr - create an extended attribute.
> @@ -131,8 +131,8 @@ static int create_xattr(struct ubifs_info *c, struct inode *host,
>  
>  	/* Re-define all operations to be "nothing" */
>  	inode->i_mapping->a_ops = &empty_aops;
> -	inode->i_op = &none_inode_operations;
> -	inode->i_fop = &none_file_operations;
> +	inode->i_op = &empty_iops;
> +	inode->i_fop = &empty_fops;
>  
>  	inode->i_flags |= S_SYNC | S_NOATIME | S_NOCMTIME | S_NOQUOTA;
>  	ui = ubifs_inode(inode);

Well, this re-naming looks strange for me. I could understand if you had
a global exported empty_*ops which you could share and shrink the .data
size a bit. But this re-naming just looks useles, if you take into
account the breakage and the men-hours we spend to write e-mails to this
thread - really did not worth it. Or I miss something?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

