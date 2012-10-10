Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab2JJMep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:34:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48525 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754898Ab2JJMem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:34:42 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19B/89rdE9Bs27+FcsgD59ooMSgOr0UrDA+j2uht5
	4Z+AFzgL8NDeYd
Message-ID: <50756B55.9040100@gmx.de>
Date: Wed, 10 Oct 2012 12:34:29 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Antonino Daplas <adaplas@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/video/savage/savagefb_driver.c: fix error
 return code
References: <1349268044-32616-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1349268044-32616-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 12:40 PM, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat


> 
> ---
>  drivers/video/savage/savagefb_driver.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/savage/savagefb_driver.c
> index 0d0f52c..f4f53b0 100644
> --- a/drivers/video/savage/savagefb_driver.c
> +++ b/drivers/video/savage/savagefb_driver.c
> @@ -2266,8 +2266,10 @@ static int __devinit savagefb_probe(struct pci_dev* dev,
>  	lpitch = info->var.xres_virtual*((info->var.bits_per_pixel + 7) >> 3);
>  	info->var.yres_virtual = info->fix.smem_len/lpitch;
>  
> -	if (info->var.yres_virtual < info->var.yres)
> +	if (info->var.yres_virtual < info->var.yres) {
> +		err = -ENOMEM;
>  		goto failed;
> +	}
>  
>  #if defined(CONFIG_FB_SAVAGE_ACCEL)
>  	/*
> 
> 

