Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3ADVMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:12:08 -0500
Received: from fieldses.org ([174.143.236.118]:48850 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab3ADVMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:12:06 -0500
Date: Fri, 4 Jan 2013 16:12:05 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: ycnian@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] nfsd: Remove write permission from file content
Message-ID: <20130104211204.GA14712@fieldses.org>
References: <1357299935-9321-1-git-send-email-ycnian@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357299935-9321-1-git-send-email-ycnian@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 07:45:35PM +0800, ycnian@gmail.com wrote:
> From: Yanchuan Nian <ycnian@gmail.com>
> 
> The write function doesn't be implemented in file content, and it's meaningless
> to write data into this file directly. Remove write permission from it.

So does it really matter either way?

OK, applying, but I wonder.

--b.

> 
> Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
> ---
>  net/sunrpc/cache.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
> index 9afa439..9f84703 100644
> --- a/net/sunrpc/cache.c
> +++ b/net/sunrpc/cache.c
> @@ -1614,7 +1614,7 @@ static int create_cache_proc_entries(struct cache_detail *cd, struct net *net)
>  			goto out_nomem;
>  	}
>  	if (cd->cache_show) {
> -		p = proc_create_data("content", S_IFREG|S_IRUSR|S_IWUSR,
> +		p = proc_create_data("content", S_IFREG|S_IRUSR,
>  				cd->u.procfs.proc_ent,
>  				&content_file_operations_procfs, cd);
>  		cd->u.procfs.content_ent = p;
> -- 
> 1.7.4.4
> 
