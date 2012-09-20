Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab2ITMwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:52:51 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:62019 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2ITMwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:52:50 -0400
X-Greylist: delayed 1090 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2012 08:52:50 EDT
Date: Thu, 20 Sep 2012 14:34:24 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 21/25] userns: Convert the qnx4 filesystem to use
 kuid/kgid where appropriate
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
	<1348141326-23355-21-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1348141326-23355-21-git-send-email-ebiederm@xmission.com>
	(from ebiederm@xmission.com on Thu Sep 20 13:42:02 2012)
X-Mailer: Balsa 2.3.14
Message-Id: <1348144464l.30734l.1l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-20 13:42:02, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Anders Larsen <al@alarsen.net>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Anders Larsen <al@alarsen.net>

> ---
>  fs/qnx4/inode.c |    4 ++--
>  init/Kconfig    |    1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
> index 552e994..5c3c7b0 100644
> --- a/fs/qnx4/inode.c
> +++ b/fs/qnx4/inode.c
> @@ -312,8 +312,8 @@ struct inode *qnx4_iget(struct super_block *sb, unsigned long ino)
>  	    (ino % QNX4_INODES_PER_BLOCK);
>  
>  	inode->i_mode    = le16_to_cpu(raw_inode->di_mode);
> -	inode->i_uid     = (uid_t)le16_to_cpu(raw_inode->di_uid);
> -	inode->i_gid     = (gid_t)le16_to_cpu(raw_inode->di_gid);
> +	i_uid_write(inode, (uid_t)le16_to_cpu(raw_inode->di_uid));
> +	i_gid_write(inode, (gid_t)le16_to_cpu(raw_inode->di_gid));
>  	set_nlink(inode, le16_to_cpu(raw_inode->di_nlink));
>  	inode->i_size    = le32_to_cpu(raw_inode->di_size);
>  	inode->i_mtime.tv_sec   = le32_to_cpu(raw_inode->di_mtime);
> diff --git a/init/Kconfig b/init/Kconfig
> index 390e629..b9d6be5 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -950,7 +950,6 @@ config UIDGID_CONVERTED
>  	depends on NFSD = n
>  	depends on NFS_FS = n
>  	depends on OCFS2_FS = n
> -	depends on QNX4FS_FS = n
>  	depends on QNX6FS_FS = n
>  	depends on REISERFS_FS = n
>  	depends on SQUASHFS = n
> -- 
> 1.7.5.4

