Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2DWGT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:19:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35880 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753682Ab2DWGTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:19:54 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/T7HlFUi/TNNsEU6tF240qwYYkapA+7joiyJGRJt
	iRfKvtTGQ1EFKd
Message-ID: <4F94F480.2080500@gmx.de>
Date: Mon, 23 Apr 2012 06:19:44 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/mbx/mbxfb.c: correct ioremap_nocache test
References: <1334779631-4361-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1334779631-4361-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 08:07 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The test tested not the most recently allocated value but a previously
> allocated one.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/mbx/mbxfb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
> index 55bf619..ab0a8e5 100644
> --- a/drivers/video/mbx/mbxfb.c
> +++ b/drivers/video/mbx/mbxfb.c
> @@ -950,7 +950,7 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
>  
>  	mfbi->fb_virt_addr = ioremap_nocache(mfbi->fb_phys_addr,
>  					     res_size(mfbi->fb_req));
> -	if (!mfbi->reg_virt_addr) {
> +	if (!mfbi->fb_virt_addr) {
>  		dev_err(&dev->dev, "failed to ioremap frame buffer\n");
>  		ret = -EINVAL;
>  		goto err4;
> 
> 

