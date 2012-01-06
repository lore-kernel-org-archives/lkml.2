Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224Ab2AFAgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:36:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964847Ab2AFAgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:36:47 -0500
Date: Fri, 6 Jan 2012 01:36:45 +0100
From: Jan Kara <jack@suse.cz>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
        Valerie Aurora <val@vaaconsulting.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 7/7] Documentation: Correct s_umount state for
 freeze_fs/unfreeze_fs
Message-ID: <20120106003645.GE3790@quack.suse.cz>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
 <1323367477-21685-8-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323367477-21685-8-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-12-11 10:04:37, Kamal Mostafa wrote:
> From: Valerie Aurora <val@vaaconsulting.com>
> 
> freeze_fs/unfreeze_fs ops are called with s_umount held for write, not read.
  Looks good. You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
> 
> BugLink: https://bugs.launchpad.net/bugs/897421
> Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
> Cc: Kamal Mostafa <kamal@canonical.com>
> Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/Locking |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
> index d819ba1..7e46a94 100644
> --- a/Documentation/filesystems/Locking
> +++ b/Documentation/filesystems/Locking
> @@ -134,8 +134,8 @@ evict_inode:
>  put_super:		write
>  write_super:		read
>  sync_fs:		read
> -freeze_fs:		read
> -unfreeze_fs:		read
> +freeze_fs:		write
> +unfreeze_fs:		write
>  statfs:			maybe(read)	(see below)
>  remount_fs:		write
>  umount_begin:		no
> -- 
> 1.7.5.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
