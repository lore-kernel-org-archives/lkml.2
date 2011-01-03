Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1ACKSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:18:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942Ab1ACKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:18:30 -0500
Date: Mon, 3 Jan 2011 02:17:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yangsheng <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Update atime from future.
Message-Id: <20110103021708.d5abf7bd.akpm@linux-foundation.org>
In-Reply-To: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010 21:58:41 +0800 yangsheng <sickamd@gmail.com> wrote:

> Signed-off-by: sickamd@gmail.com
> ---
>  fs/inode.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index da85e56..6c8effd 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>  		return 1;
>  
>  	/*
> -	 * Is the previous atime value older than a day? If yes,
> +	 * Is the previous atime value in future? If yes,
> +	 * update atime:
> +	 */
> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < 0)
> +		return 1;
> +	/*
> +	 * Is the previous atime value old than a day? If yes,
>  	 * update atime:
>  	 */
>  	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)

Why do you believe this change is needed?  Did you observe some problem
which it fixes?  If so, please fully describe that problem.

