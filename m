Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2KJP5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 10:57:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42919 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2KJP5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 10:57:17 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fuse: remove unused variable in fuse_try_move_page()
References: <CAPgLHd8MSy-k8Vpdw7r8iP3XL8Od-3jVGBzs63gnCv75yM8KUQ@mail.gmail.com>
Date: Sat, 10 Nov 2012 16:59:33 +0100
In-Reply-To: <CAPgLHd8MSy-k8Vpdw7r8iP3XL8Od-3jVGBzs63gnCv75yM8KUQ@mail.gmail.com>
	(Wei Yongjun's message of "Thu, 18 Oct 2012 22:51:25 +0800")
Message-ID: <87haoxa1p6.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun <weiyj.lk@gmail.com> writes:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The variables mapping,index are initialized but never used
> otherwise, so remove the unused variables.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)

Thanks, applied.

Miklos

>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/fuse/dev.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 8c23fa7..53c294c 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -692,8 +692,6 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
>  	struct page *oldpage = *pagep;
>  	struct page *newpage;
>  	struct pipe_buffer *buf = cs->pipebufs;
> -	struct address_space *mapping;
> -	pgoff_t index;
>  
>  	unlock_request(cs->fc, cs->req);
>  	fuse_copy_finish(cs);
> @@ -724,9 +722,6 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
>  	if (fuse_check_page(newpage) != 0)
>  		goto out_fallback_unlock;
>  
> -	mapping = oldpage->mapping;
> -	index = oldpage->index;
> -
>  	/*
>  	 * This is a new and locked page, it shouldn't be mapped or
>  	 * have any special flags on it
