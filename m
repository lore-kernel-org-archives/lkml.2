Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1I3Tpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:45:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36460 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab1I3Tpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:45:31 -0400
Date: Fri, 30 Sep 2011 12:45:41 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: ext4_mkdir should dirty dir_block with the
	parent inode
Message-ID: <20110930194541.GW12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110817033954.GP20655@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817033954.GP20655@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 08:39:54PM -0700, Darrick J. Wong wrote:
> ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
> Unfortunately, dir_block belongs to the newly created directory (which is
> "inode"), not the parent directory (which is "dir").  Fix the incorrect
> association.

Any thoughts about this one, Ted?

--D
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  fs/ext4/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 2b5c34b..a2c2855 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1866,7 +1866,7 @@ retry:
>  	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
>  	inode->i_nlink = 2;
>  	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
> -	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
> +	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
>  	if (err)
>  		goto out_clear_inode;
>  	err = ext4_mark_inode_dirty(handle, inode);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
