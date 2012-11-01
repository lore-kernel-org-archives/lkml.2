Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185Ab2KAKE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 06:04:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab2KAKEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 06:04:53 -0400
Date: Thu, 1 Nov 2012 06:04:23 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] swapfile: fix name leak in swapoff
Message-ID: <20121101060423.665cdaa2@tlielax.poochiereds.net>
In-Reply-To: <1351762616-2060-1-git-send-email-xtfeng@gmail.com>
References: <1351762616-2060-1-git-send-email-xtfeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 17:36:55 +0800
Xiaotian Feng <xtfeng@gmail.com> wrote:

> there's a name leak introduced by commit 91a27b2, add the missing
> putname.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  mm/swapfile.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 71cd288..459fe30 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1608,6 +1608,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  out_dput:
>  	filp_close(victim, NULL);
>  out:
> +	if (pathname && !IS_ERR(pathname))
> +		putname(pathname);
>  	return err;
>  }
>  

Nice catch.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
