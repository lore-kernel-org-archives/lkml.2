Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0HBXCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:02:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab0HBXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:02:00 -0400
Date: Mon, 2 Aug 2010 16:01:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: igafb: introduce lost 'return'
Message-Id: <20100802160129.8ca0cf05.akpm@linux-foundation.org>
In-Reply-To: <1280594070-3328-1-git-send-email-segooon@gmail.com>
References: <1280594070-3328-1-git-send-email-segooon@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010 20:34:30 +0400
Kulikov Vasiliy <segooon@gmail.com> wrote:

> If iga_init() fails, code releases resources and continues to use it.
> It seems that after releasing resources 'return' should be.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/video/igafb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/igafb.c b/drivers/video/igafb.c
> index 15d2001..c4e6fc0 100644
> --- a/drivers/video/igafb.c
> +++ b/drivers/video/igafb.c
> @@ -531,6 +531,7 @@ int __init igafb_init(void)
>  		iounmap(info->screen_base);
>  		kfree(par->mmap_map);
>  		kfree(info);
> +		return -ENODEV;
>          }
>  
>  #ifdef CONFIG_SPARC

Fair enough.

We may as well do this, too:

--- a/drivers/video/igafb.c~drivers-video-igafbc-make-igafb_setup-and-igafb_init-static
+++ a/drivers/video/igafb.c
@@ -368,7 +368,7 @@ static int __init iga_init(struct fb_inf
 	return 1;
 }
 
-int __init igafb_init(void)
+static int __init igafb_init(void)
 {
         struct fb_info *info;
         struct pci_dev *pdev;
@@ -557,7 +557,7 @@ int __init igafb_init(void)
 	return 0;
 }
 
-int __init igafb_setup(char *options)
+static int __init igafb_setup(char *options)
 {
     char *this_opt;
 
_

