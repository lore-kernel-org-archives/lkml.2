Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0JDIxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:53:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45726 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0JDIxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:53:38 -0400
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: mszeredi@suse.cz, fuse-devel@lists.sourceforge.net,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <alpine.DEB.2.00.1009302205420.3131@ayla.of.borg> (message from
	Geert Uytterhoeven on Thu, 30 Sep 2010 22:06:21 +0200 (CEST))
Subject: Re: [fuse-devel] [PATCH] fuse: Initialize total_len in fuse_retrieve()
References: <alpine.DEB.2.00.1009302205420.3131@ayla.of.borg>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1P2gnQ-0001hA-8R@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 04 Oct 2010 10:53:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010, Geert Uytterhoeven wrote:
> fs/fuse/dev.c:1357: warning: ‘total_len’ may be used uninitialized in this
> function
> 
> Initialize total_len to zero, else its value will be undefined.

Good catch, thanks.  Pushed to for-next branch of fuse tree.

Thanks,
Miklos


> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  fs/fuse/dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index d367af1..cde755c 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1354,7 +1354,7 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
>  	loff_t file_size;
>  	unsigned int num;
>  	unsigned int offset;
> -	size_t total_len;
> +	size_t total_len = 0;
>  
>  	req = fuse_get_req(fc);
>  	if (IS_ERR(req))
> -- 
> 1.7.0.4
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> 
> ------------------------------------------------------------------------------
> Start uncovering the many advantages of virtual appliances
> and start using them to simplify application deployment and
> accelerate your shift to cloud computing.
> http://p.sf.net/sfu/novell-sfdev2dev
> _______________________________________________
> fuse-devel mailing list
> fuse-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/fuse-devel
> 
> 
