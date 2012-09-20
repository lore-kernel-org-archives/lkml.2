Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2ITMUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:20:40 -0400
Received: from natasha.panasas.com ([67.152.220.90]:40122 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2ITMUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:20:36 -0400
Message-ID: <505B09FE.1050907@panasas.com>
Date: Thu, 20 Sep 2012 15:20:14 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Benny Halevy <bhalevy@tonian.com>
Subject: Re: [PATCH 12/25] userns: Convert exofs to use kuid/kgid where appropriate
References: <877grox6ql.fsf@xmission.com> <1348141326-23355-1-git-send-email-ebiederm@xmission.com> <1348141326-23355-12-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1348141326-23355-12-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 02:41 PM, Eric W. Biederman wrote:

> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Benny Halevy <bhalevy@tonian.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>


Acked-by: Boaz Harrosh <bharrosh@panasas.com>

> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/exofs/inode.c |    8 ++++----
>  init/Kconfig     |    1 -
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
> index 5badb0c..190c3d6 100644
> --- a/fs/exofs/inode.c
> +++ b/fs/exofs/inode.c
> @@ -1163,8 +1163,8 @@ struct inode *exofs_iget(struct super_block *sb, unsigned long ino)
>  
>  	/* copy stuff from on-disk struct to in-memory struct */
>  	inode->i_mode = le16_to_cpu(fcb.i_mode);
> -	inode->i_uid = le32_to_cpu(fcb.i_uid);
> -	inode->i_gid = le32_to_cpu(fcb.i_gid);
> +	i_uid_write(inode, le32_to_cpu(fcb.i_uid));
> +	i_gid_write(inode, le32_to_cpu(fcb.i_gid));
>  	set_nlink(inode, le16_to_cpu(fcb.i_links_count));
>  	inode->i_ctime.tv_sec = (signed)le32_to_cpu(fcb.i_ctime);
>  	inode->i_atime.tv_sec = (signed)le32_to_cpu(fcb.i_atime);
> @@ -1376,8 +1376,8 @@ static int exofs_update_inode(struct inode *inode, int do_sync)
>  	fcb = &args->fcb;
>  
>  	fcb->i_mode = cpu_to_le16(inode->i_mode);
> -	fcb->i_uid = cpu_to_le32(inode->i_uid);
> -	fcb->i_gid = cpu_to_le32(inode->i_gid);
> +	fcb->i_uid = cpu_to_le32(i_uid_read(inode));
> +	fcb->i_gid = cpu_to_le32(i_gid_read(inode));
>  	fcb->i_links_count = cpu_to_le16(inode->i_nlink);
>  	fcb->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
>  	fcb->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
> diff --git a/init/Kconfig b/init/Kconfig
> index 51084b0..39e55d6 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -941,7 +941,6 @@ config UIDGID_CONVERTED
>  	depends on CEPH_FS = n
>  	depends on CIFS = n
>  	depends on CODA_FS = n
> -	depends on EXOFS_FS = n
>  	depends on FUSE_FS = n
>  	depends on GFS2_FS = n
>  	depends on HFS_FS = n


