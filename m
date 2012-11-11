Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2KKQKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 11:10:54 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:59297 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2KKQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 11:10:52 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 3/3] fat: remove unneeded compare condition for __fat_write_inode
References: <1352642304-2766-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 12 Nov 2012 01:10:50 +0900
In-Reply-To: <1352642304-2766-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 11 Nov 2012 22:58:24 +0900")
Message-ID: <87zk2o6rxx.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> In calling of __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL),
> expression "wbc->sync_mode == WB_SYNC_ALL" will always be equivalent to value
> of wbc->sync_mode. So, remove this additional compare condition from function
> arguments.

Current style is better. I.e. easy to add new sync mode.

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 7b186a5..aa0138b 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -678,7 +678,7 @@ static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
>  		err = fat_clusters_flush(sb);
>  		mutex_unlock(&MSDOS_SB(sb)->s_lock);
>  	} else
> -		err = __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
> +		err = __fat_write_inode(inode, wbc->sync_mode);
>  
>  	return err;
>  }

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
