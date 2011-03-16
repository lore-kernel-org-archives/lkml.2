Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab1CPIFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:05:55 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35135 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1CPIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:05:50 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "M. Mohan Kumar" <mohan@in.ibm.com>, v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/9p: Use updated offset for writing
In-Reply-To: <1300252156-5002-1-git-send-email-mohan@in.ibm.com>
References: <1300252156-5002-1-git-send-email-mohan@in.ibm.com>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Wed, 16 Mar 2011 13:35:46 +0530
Message-ID: <874o73ij6t.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 10:39:16 +0530, "M. Mohan Kumar" <mohan@in.ibm.com> wrote:
> Use the updated offset given by generic_write_checks. Without this fix,
> even if a file is opened in O_APPEND mode, data will be written at current
> file position instead of end of file.
> 
> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
> ---
>  fs/9p/vfs_file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 6997eb6..51049cd 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -510,7 +510,7 @@ v9fs_file_write(struct file *filp, const char __user * data,
> 
>  	return v9fs_file_write_internal(filp->f_path.dentry->d_inode,
>  					filp->private_data,
> -					data, count, offset, 1);
> +					data, count, &origin, 1);
>  out:
>  	return retval;
>  }

You should also update offset on success.

-aneesh
