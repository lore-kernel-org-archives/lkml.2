Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418Ab2EJAMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:12:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39101 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751951Ab2EJAMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:12:00 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+/yNoUOrG/5EOqpeW+QqXI0mRIwKuDGyDYf6gB0i
	tQKf1ho1go9rib
Message-ID: <4FAB07C8.9080409@gmx.de>
Date: Thu, 10 May 2012 00:11:52 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: fb_defio.c: local functions should not be exposed
 globally
References: <201205021723.40801.hartleys@visionengravers.com>
In-Reply-To: <201205021723.40801.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 12:23 AM, H Hartley Sweeten wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent them from being exposed globally.
> 
> Quiets the sparse warning:
> 
> warning: symbol 'fb_deferred_io_page' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jaya Kumar <jayalk@intworks.biz>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
> 
> diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
> index 070f26f..1ddeb11 100644
> --- a/drivers/video/fb_defio.c
> +++ b/drivers/video/fb_defio.c
> @@ -23,7 +23,7 @@
>  #include <linux/rmap.h>
>  #include <linux/pagemap.h>
>  
> -struct page *fb_deferred_io_page(struct fb_info *info, unsigned long offs)
> +static struct page *fb_deferred_io_page(struct fb_info *info, unsigned long offs)
>  {
>  	void *screen_base = (void __force *) info->screen_base;
>  	struct page *page;
> 

