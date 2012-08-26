Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2HZOFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 10:05:46 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60490 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2HZOFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 10:05:45 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 3/3] fat: simplify writeback_inode function.
References: <1345883026-6297-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 26 Aug 2012 23:05:42 +0900
In-Reply-To: <1345883026-6297-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 25 Aug 2012 04:23:46 -0400")
Message-ID: <874nnpwxxl.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Simplify writeback_inode function.

Looks cleanup without logic change.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/inode.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 973296b..4bbb24e 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -1457,18 +1457,14 @@ static int writeback_inode(struct inode *inode)
>  {
>  
>  	int ret;
> -	struct address_space *mapping = inode->i_mapping;
> -	struct writeback_control wbc = {
> -	       .sync_mode = WB_SYNC_NONE,
> -	      .nr_to_write = 0,
> -	};
> -	/* if we used WB_SYNC_ALL, sync_inode waits for the io for the
> -	* inode to finish.  So WB_SYNC_NONE is sent down to sync_inode
> +
> +	/* if we used wait=1, sync_inode_metadata waits for the io for the
> +	* inode to finish.  So wait=0 is sent down to sync_inode_metadata
>  	* and filemap_fdatawrite is used for the data blocks
>  	*/
> -	ret = sync_inode(inode, &wbc);
> +	ret = sync_inode_metadata(inode, 0);
>  	if (!ret)
> -	       ret = filemap_fdatawrite(mapping);
> +	       ret = filemap_fdatawrite(inode->i_mapping);
>  	return ret;
>  }

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
