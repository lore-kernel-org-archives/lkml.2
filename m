Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2D3FI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:08:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37904 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2D3FI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:08:58 -0400
Date: Sun, 29 Apr 2012 21:55:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: Redundant assignment of dup_name in sysfs_rename
Message-ID: <20120430015531.GA13098@kroah.com>
References: <1335537062-7627-1-git-send-email-sasikanth.v19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335537062-7627-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 08:01:02PM +0530, Sasikantha babu wrote:
> It is redundant to assign "kstrdup" of "new_value" to "dup_name",
> Since we are overwriting "dup_name" with "sd->s_name"
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
> ---
>  fs/sysfs/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 35a36d3..4abd424 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -875,7 +875,7 @@ int sysfs_rename(struct sysfs_dirent *sd,
>  	/* rename sysfs_dirent */
>  	if (strcmp(sd->s_name, new_name) != 0) {
>  		error = -ENOMEM;
> -		new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
> +		new_name = kstrdup(new_name, GFP_KERNEL);
>  		if (!new_name)
>  			goto out;

Why not get rid of dup_name entirely now as it really isn't used at all?
That would make a more "complete" patch, care to redo this?

greg k-h
