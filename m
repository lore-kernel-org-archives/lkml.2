Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab2DZS0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758745Ab2DZS0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:26:15 -0400
Date: Thu, 26 Apr 2012 14:26:13 -0400
From: Josef Bacik <josef@redhat.com>
To: Jim Meyering <jim@meyering.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: NUL-terminate path buffer in DEV_INFO ioctl result
Message-ID: <20120426182612.GC1890@localhost.localdomain>
References: <87pqauwitz.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqauwitz.fsf@rho.meyering.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 06:36:56PM +0200, Jim Meyering wrote:
> 
> A device with name of length BTRFS_DEVICE_PATH_NAME_MAX or longer
> would not be NUL-terminated in the DEV_INFO ioctl result buffer.
> 
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  fs/btrfs/ioctl.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 18cc23d..1578676 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2258,16 +2258,17 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
>  		goto out;
>  	}
> 
>  	di_args->devid = dev->devid;
>  	di_args->bytes_used = dev->bytes_used;
>  	di_args->total_bytes = dev->total_bytes;
>  	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
>  	strncpy(di_args->path, dev->name, sizeof(di_args->path));
> +	di_args->path[sizeof(di_args->path) - 1] = 0;
> 
>  out:
>  	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
>  		ret = -EFAULT;
> 
>  	kfree(di_args);
>  	return ret;
>  }
> --
> 1.7.10.336.gc5e31

This didn't merge quite right onto btrfs-next btw so I've fixed it up manually
(but left the log/author/signed off intact).  Thanks,

Josef
