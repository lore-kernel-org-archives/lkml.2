Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1GYAl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 20:41:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:49003 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1GYAl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 20:41:56 -0400
Date: Mon, 25 Jul 2011 10:41:29 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, baryluk@smp.if.uj.edu.pl,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm_nsc: Fix bugzilla 34572
In-Reply-To: <1311370760.565.4.camel@d941e-10>
Message-ID: <alpine.LRH.2.00.1107251039390.2203@tundra.namei.org>
References: <1311370760.565.4.camel@d941e-10>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011, Stefan Berger wrote:

> This patch fixes kernel bugzilla 34572. It applies to the tip of Linus's tree.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=34572
> 

A complete explanation of the patch should be included in the changelog 
here (as well as the subject line).

> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Tested-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>

I'll push it to Linus with the rest of the security tree. 

> 
> ---
>  drivers/char/tpm/tpm_nsc.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/drivers/char/tpm/tpm_nsc.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm_nsc.c
> +++ linux-2.6/drivers/char/tpm/tpm_nsc.c
> @@ -330,12 +330,12 @@ static int __init init_nsc(void)
>  	pdev->dev.driver = &nsc_drv.driver;
>  	pdev->dev.release = tpm_nsc_remove;
>  
> -	if ((rc = platform_device_register(pdev)) < 0)
> -		goto err_free_dev;
> +	if ((rc = platform_device_add(pdev)) < 0)
> +		goto err_put_dev;
>  
>  	if (request_region(base, 2, "tpm_nsc0") == NULL ) {
>  		rc = -EBUSY;
> -		goto err_unreg_dev;
> +		goto err_del_dev;
>  	}
>  
>  	if (!(chip = tpm_register_hardware(&pdev->dev, &tpm_nsc))) {
> @@ -382,10 +382,10 @@ static int __init init_nsc(void)
>  
>  err_rel_reg:
>  	release_region(base, 2);
> -err_unreg_dev:
> -	platform_device_unregister(pdev);
> -err_free_dev:
> -	kfree(pdev);
> +err_del_dev:
> +	platform_device_del(pdev);
> +err_put_dev:
> +	platform_device_put(pdev);
>  err_unreg_drv:
>  	platform_driver_unregister(&nsc_drv);
>  	return rc;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
