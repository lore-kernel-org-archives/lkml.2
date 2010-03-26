Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0CZTzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:55:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52893 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab0CZTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:55:31 -0400
Subject: Re: [PATCH] ext3: call blkdev_issue_flush on fsync
From: Surbhi Palande <Surbhi.Palande@canonical.com>
Reply-To: Surbhi.Palande@canonical.com
To: linux-ext4@vger.kernel.org
Cc: Stephen Tweedie <sct@redhat.com>, Andreas Dilger <adilger@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1269622243-26689-1-git-send-email-surbhi.palande@canonical.com>
References: <1269622243-26689-1-git-send-email-surbhi.palande@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Canonical Pvt. Ltd.
Date: Fri, 26 Mar 2010 21:55:20 +0200
Message-ID: <1269633320.30275.25.camel@subu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch! Sorry for this!

Warm Regards,
Surbhi.

On Fri, 2010-03-26 at 18:50 +0200, Surbhi Palande wrote:
> To ensure that bits are truly on-disk after an fsync,
> we should call blkdev_issue_flush if barriers are supported.
> 
> This code is seen in ext4 through commits
> d755fb384250d6bd7fd18a0930e71965acc8e72e and
> 5f3481e9a80c240f169b36ea886e2325b9aeb745.
> 
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
> ---
>  fs/ext3/fsync.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
> index d336341..2184a40 100644
> --- a/fs/ext3/fsync.c
> +++ b/fs/ext3/fsync.c
> @@ -29,6 +29,7 @@
>  #include <linux/jbd.h>
>  #include <linux/ext3_fs.h>
>  #include <linux/ext3_jbd.h>
> +#include <linux/blkdev.h>
>  
>  /*
>   * akpm: A new design for ext3_sync_file().
> @@ -46,6 +47,7 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
>  {
>  	struct inode *inode = dentry->d_inode;
>  	int ret = 0;
> +	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
>  
>  	J_ASSERT(ext3_journal_current_handle() == NULL);
>  
> @@ -87,5 +89,7 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
>  		ret = sync_inode(inode, &wbc);
>  	}
>  out:
> +	if (journal && (journal->j_flags & JFS_BARRIER))
> +		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
>  	return ret;
>  }


