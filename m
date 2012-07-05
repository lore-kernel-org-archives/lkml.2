Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab2GEWIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:08:37 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3706 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738Ab2GEWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:08:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkLAMgP9k95Lbce/2dsb2JhbABFpiqPXQOBJoEIghgBAQU6HCMQCAMYIwsUJQMJGBOHfQMKuhUUij9mCQyBCQgEhRQDlTaJJ4FdhQCCcYFEAQ
Date: Fri, 6 Jul 2012 08:08:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Brad Arrington <bradla8@yahoo.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ACL: increase the #define XFS_ACL_MAX_ENTRIES to 128
 The xfsprogs xfs_repair will have to be increased also if this is okay.
Message-ID: <20120705220832.GQ19223@dastard>
References: <1341520391-9704-1-git-send-email-bradla8@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341520391-9704-1-git-send-email-bradla8@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 01:33:11PM -0700, Brad Arrington wrote:
> 
> Signed-off-by: Brad Arrington <bradla8@yahoo.com>
> ---
>  fs/xfs/xfs_acl.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 39632d9..716d4d2 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -22,7 +22,7 @@ struct inode;
>  struct posix_acl;
>  struct xfs_inode;
>  
> -#define XFS_ACL_MAX_ENTRIES 25
> +#define XFS_ACL_MAX_ENTRIES 128

That's an on disk format change - you can't just increase it like
that without some kind of superblock feature bit to indicate that
the limit is 128 rather than 25 on that filesystem.

As it is, if we are going to change it, it will get changed to allow
the maximum number of ACLs an attribute can hold, not another
arbitrary number like 128....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
