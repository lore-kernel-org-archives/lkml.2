Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab0JSKRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:17:36 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:41951 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753467Ab0JSKRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:17:34 -0400
Message-ID: <4CBD703B.5060607@panasas.com>
Date: Tue, 19 Oct 2010 12:17:31 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: npiggin@kernel.dk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 33/35] fs: icache introduce inode_get/inode_get_ilock
References: <20101019034216.319085068@kernel.dk> <20101019034658.963540555@kernel.dk>
In-Reply-To: <20101019034658.963540555@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2010 10:17:33.0380 (UTC) FILETIME=[D82C5840:01CB6F76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 05:42 AM, npiggin@kernel.dk wrote:
> Factor open coded inode lock, increment, unlock into a function inode_get().
> Rename __iget to inode_get_ilock.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> ---

<>

> Index: linux-2.6/fs/exofs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/exofs/inode.c	2010-10-19 14:18:58.000000000 +1100
> +++ linux-2.6/fs/exofs/inode.c	2010-10-19 14:19:16.000000000 +1100
> @@ -1162,9 +1162,7 @@
>  	/* increment the refcount so that the inode will still be around when we
>  	 * reach the callback
>  	 */
> -	spin_lock(&inode->i_lock);
> -	inode->i_count++;
> -	spin_unlock(&inode->i_lock);
> +	inode_get(inode);
>  
>  	ios->done = create_done;
>  	ios->private = inode;
> Index: linux-2.6/fs/exofs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/exofs/namei.c	2010-10-19 14:18:58.000000000 +1100
> +++ linux-2.6/fs/exofs/namei.c	2010-10-19 14:19:00.000000000 +1100
> @@ -153,9 +153,7 @@
>  
>  	inode->i_ctime = CURRENT_TIME;
>  	inode_inc_link_count(inode);
> -	spin_lock(&inode->i_lock);
> -	inode->i_count++;
> -	spin_unlock(&inode->i_lock);
> +	inode_get(inode);
>  
>  	return exofs_add_nondir(dentry, inode);
>  }

Why won't you define an intermediate inode_get() in patch 08/35 and
change both puts and gets of all file_systems in one patch? Instead
of two tree sweeping patches. (At least for all the trivial places
like here)

Thanks
Boaz


