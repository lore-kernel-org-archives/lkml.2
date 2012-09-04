Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2IDAiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 20:38:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2IDAix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 20:38:53 -0400
Message-ID: <50454D97.2060002@gmail.com>
Date: Tue, 04 Sep 2012 10:38:47 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: yan <clouds.yan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] proc: return -ENOMEM when inode allocation failed
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com> <1346681648-21427-2-git-send-email-clouds.yan@gmail.com>
In-Reply-To: <1346681648-21427-2-git-send-email-clouds.yan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/12 00:14, yan wrote:
> Signed-off-by: yan <clouds.yan@gmail.com>
> ---
>  fs/proc/generic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index b3647fe..9e8f631 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -427,7 +427,7 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
>  		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
>  			pde_get(de);
>  			spin_unlock(&proc_subdir_lock);
> -			error = -EINVAL;
> +			error = -ENOMEM;

This seems incorrect. This function doesn't allocate anything, it looks
up an inode. From my reading it looks like -EINVAL is returned here if
the dentry name matches, but the inode cannot be found.

~Ryan

