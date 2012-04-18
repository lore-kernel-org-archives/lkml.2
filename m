Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2DRPnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:43:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38569 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2DRPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:43:34 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] fs/fuse: Convert to kstrtoul_from_user
References: <1334449227-12011-1-git-send-email-peterhuewe@gmx.de>
Date: Wed, 18 Apr 2012 17:43:46 +0200
In-Reply-To: <1334449227-12011-1-git-send-email-peterhuewe@gmx.de> (Peter
	Huewe's message of "Sun, 15 Apr 2012 02:20:27 +0200")
Message-ID: <8762cx9hal.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Huewe <peterhuewe@gmx.de> writes:

> This patch replaces the code for getting an number from a
> userspace buffer by a simple call to kstroul_from_user.
> This makes it easier to read and less error prone.

Thanks, applied.

Miklos

>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  fs/fuse/control.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 42593c5..03ff5b1 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -75,19 +75,13 @@ static ssize_t fuse_conn_limit_write(struct file *file, const char __user *buf,
>  				     unsigned global_limit)
>  {
>  	unsigned long t;
> -	char tmp[32];
>  	unsigned limit = (1 << 16) - 1;
>  	int err;
>  
> -	if (*ppos || count >= sizeof(tmp) - 1)
> -		return -EINVAL;
> -
> -	if (copy_from_user(tmp, buf, count))
> +	if (*ppos)
>  		return -EINVAL;
>  
> -	tmp[count] = '\0';
> -
> -	err = strict_strtoul(tmp, 0, &t);
> +	err = kstrtoul_from_user(buf, count, 0, &t);
>  	if (err)
>  		return err;
