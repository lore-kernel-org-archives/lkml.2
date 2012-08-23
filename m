Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab2HWUsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:48:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53084 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934314Ab2HWUsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:48:31 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+/BX5rYEu/vawEcnMN1pECjIAgeqC5mh64hNe+Yk
	7L7HD8K8Y/RIsn
Message-ID: <50369719.9050306@gmx.de>
Date: Thu, 23 Aug 2012 20:48:25 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/14] drivers/video/sunxvr2500.c: fix error return code
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr> <1345365870-29831-9-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1345365870-29831-9-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 08:44 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Initialize return variable before exiting on an error path.
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
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/sunxvr2500.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/video/sunxvr2500.c b/drivers/video/sunxvr2500.c
> index 5848436..7fbcba8 100644
> --- a/drivers/video/sunxvr2500.c
> +++ b/drivers/video/sunxvr2500.c
> @@ -181,8 +181,10 @@ static int __devinit s3d_pci_register(struct pci_dev *pdev,
>  	sp->fb_size = info->fix.line_length * sp->height;
>  
>  	sp->fb_base = ioremap(sp->fb_base_phys, sp->fb_size);
> -	if (!sp->fb_base)
> +	if (!sp->fb_base) {
> +		err = -ENOMEM;
>  		goto err_release_pci;
> +	}
>  
>  	err = s3d_set_fbinfo(sp);
>  	if (err)
> 
> 

