Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0JUJUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:20:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37599 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab0JUJUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:20:41 -0400
Message-ID: <4CC005F3.3080500@fusionio.com>
Date: Thu, 21 Oct 2010 11:20:51 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Nicolas Kaiser <nikai@nikai.net>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: return error on error condition
References: <20101020165047.09150171@absol.kitzblitz>
In-Reply-To: <20101020165047.09150171@absol.kitzblitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-20 16:50, Nicolas Kaiser wrote:
> It's intended to return an error, right?
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  fs/pipe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 279eef9..37eb1eb 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -382,7 +382,7 @@ pipe_read(struct kiocb *iocb, const struct iovec *_iov,
>  			error = ops->confirm(pipe, buf);
>  			if (error) {
>  				if (!ret)
> -					error = ret;
> +					ret = error;
>  				break;
>  			}
>  

Thanks, that is indeed a bug. I'll commit and mark for stable.

-- 
Jens Axboe

