Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab0DEOEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:04:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:43484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0DEOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:04:47 -0400
Date: Mon, 5 Apr 2010 15:04:43 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Wolfram Sang <w.sang@pengutronix.de>
cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 23/24] video/matrox: fix dangling pointers
In-Reply-To: <1269094385-16114-24-git-send-email-w.sang@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1004051504200.16108@casper.infradead.org>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-24-git-send-email-w.sang@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Mar 2010, Wolfram Sang wrote:

> Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> structure it points to. Also fix drivers which do this _after_ the structure
> was freed already.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
> ---

Acked-by: James Simmons <jsimmons@infradead.org>
 
> Found using coccinelle, then reviewed. Full patchset is available via
> kernel-janitors, linux-i2c, and LKML.
> ---
>  drivers/video/matrox/matroxfb_maven.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
> index 91af915..e7b0ec3 100644
> --- a/drivers/video/matrox/matroxfb_maven.c
> +++ b/drivers/video/matrox/matroxfb_maven.c
> @@ -1254,6 +1254,7 @@ static int maven_probe(struct i2c_client *client,
>  		goto ERROR4;
>  	return 0;
>  ERROR4:;
> +	i2c_set_clientdata(client, NULL);
>  	kfree(data);
>  ERROR0:;
>  	return err;
> -- 
> 1.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
