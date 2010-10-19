Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0JSH5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:57:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0JSH5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fc+eVy2JuZdGMKglzbNGxwBVIYB4KPRnxTZ5dKSNEKiQ8JYuQgovHz1wTbCfv25+56
         PK/9Jy5BPWBR3wbCzaGbnuqOX8Mmr+DCW0rwK8x97lC3UKHRiHn5DUtUMIXdDGoPzb2+
         X84Gph45Xl0/ahUDIIHjscCU8X3MLfXL2iZ94=
Subject: Re: [PATCH] ext3: Check return value of sb_getblk()
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
References: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 16:57:29 +0900
Message-ID: <1287475049.1705.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-19 (화), 15:34 +0900, Namhyung Kim:
> Check return value of sb_getblk() is NULL. unlikely is addded here
> since it is called from a loop and we've been OK without the check
> until now.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/ext3/inode.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index ef1c23a..a7ac778 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -655,6 +655,12 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
>  		 * parent to disk.
>  		 */
>  		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
> +		if (unlikely(!bh)) {
> +			n--;
> +			err = -ENOMEM;
> +			goto failed;
> +		}
> +
>  		branch[n].bh = bh;
>  		lock_buffer(bh);
>  		BUFFER_TRACE(bh, "call get_create_access");

Maybe EIO would be more proper error code, I guess.


-- 
Regards,
Namhyung Kim


