Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab1E3Lke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:40:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54249 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab1E3Lkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:40:31 -0400
Date: Mon, 30 May 2011 12:40:25 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Joe Perches <joe@perches.com>
Cc: Jaya Kumar <jayalk@intworks.biz>, Paul Mundt <lethal@linux-sh.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiri Kosina <trivial@kernel.org>, linux-fbdev@vger.kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [TRIVIAL PATCH next 12/15] video: Convert vmalloc/memset to
 vzalloc
Message-ID: <20110530114025.GP5044@csn.ul.ie>
References: <cover.1306603968.git.joe@perches.com>
 <77538de911b8af99f68b7bcfbaaedce8e40db04f.1306603968.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <77538de911b8af99f68b7bcfbaaedce8e40db04f.1306603968.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 10:36:32AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/video/arcfb.c        |    5 ++---
>  drivers/video/broadsheetfb.c |    4 +---
>  drivers/video/hecubafb.c     |    5 ++---
>  drivers/video/metronomefb.c  |    4 +---
>  drivers/video/xen-fbfront.c  |    3 +--
>  5 files changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
> index 3ec4923..86573e2 100644
> --- a/drivers/video/arcfb.c
> +++ b/drivers/video/arcfb.c
> @@ -515,11 +515,10 @@ static int __devinit arcfb_probe(struct platform_device *dev)
>  
>  	/* We need a flat backing store for the Arc's
>  	   less-flat actual paged framebuffer */
> -	if (!(videomemory = vmalloc(videomemorysize)))
> +	videomemory = vmalloc(videomemorysize);
> +	if (!videomemory)
>  		return retval;
>  
> -	memset(videomemory, 0, videomemorysize);
> -
>  	info = framebuffer_alloc(sizeof(struct arcfb_par), &dev->dev);
>  	if (!info)
>  		goto err;

This is the first commit I saw and stopped reading at this point
because this hunk is not using vzalloc. I imagine grep for ^+ and
vmalloc throughout the series would be helpful?

-- 
Mel Gorman
SUSE Labs
