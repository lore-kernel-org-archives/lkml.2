Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2DPOCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:02:40 -0400
Received: from twin.jikos.cz ([89.185.236.188]:37270 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab2DPOCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:02:39 -0400
Date: Mon, 16 Apr 2012 16:02:07 +0200
From: David Sterba <dave@jikos.cz>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Chris Mason <chris.mason@oracle.com>, kernel-janitors@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/btrfs/volumes.c: add missing free_fs_devices
Message-ID: <20120416140207.GB20982@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Julia Lawall <Julia.Lawall@lip6.fr>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1334395473-16667-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334395473-16667-1-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 11:24:33AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Free fs_devices as done in the error-handling code just below.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  fs/btrfs/volumes.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a872b48..5d246c3 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4334,8 +4334,10 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
>  
>  	ret = __btrfs_open_devices(fs_devices, FMODE_READ,
>  				   root->fs_info->bdev_holder);
> -	if (ret)
> +	if (ret) {
> +		free_fs_devices(fs_devices);
>  		goto out;
> +	}
>  
>  	if (!fs_devices->seeding) {
>  		__btrfs_close_devices(fs_devices);

Reviewed-by: David Sterba <dsterba@suse.cz>

thanks,
david
