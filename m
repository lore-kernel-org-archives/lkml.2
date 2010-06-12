Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0FLHjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:39:35 -0400
Received: from smtp.nokia.com ([192.100.105.134]:57280 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0FLHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:39:34 -0400
Subject: Re: [PATCHv5 09/16] btrfs: remove junk sb_mark_dirty call
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1275835829-1478-10-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
	 <1275835829-1478-10-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Sat, 12 Jun 2010 10:36:47 +0300
Message-ID: <1276328207.19028.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Jun 2010 07:39:06.0802 (UTC) FILETIME=[5685E920:01CB0A02]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

could you please ack or nack this patch?

On Sun, 2010-06-06 at 17:50 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> BTRFS does not define '->write_super()' method, so it should not
> mark its superblock as dirty. This looks like some left-over.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> ---
>  fs/btrfs/inode.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index caa4ed9..1419d90 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2938,7 +2938,6 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>  	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
>  	ret = btrfs_update_inode(trans, root, dir);
>  	BUG_ON(ret);
> -	sb_mark_dirty(dir->i_sb);
>  
>  	btrfs_free_path(path);
>  	return 0;

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

