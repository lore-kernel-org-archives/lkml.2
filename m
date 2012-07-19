Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2GSP15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:27:57 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42385 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2GSP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:27:55 -0400
Subject: Re: [PATCH] PCDP: use early_ioremap/early_iounmap to access pcdp
 table
From: Khalid Aziz <khalid.aziz@hp.com>
To: Greg Pearson <greg.pearson@hp.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1342649974-6860-1-git-send-email-greg.pearson@hp.com>
References: <1342649974-6860-1-git-send-email-greg.pearson@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jul 2012 09:27:54 -0600
Message-ID: <1342711674.13917.106.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 16:19 -0600, Greg Pearson wrote:
> Signed-off-by: Greg Pearson <greg.pearson@hp.com>
> ---
>  drivers/firmware/pcdp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/pcdp.c b/drivers/firmware/pcdp.c
> index 51e0e2d..a330492 100644
> --- a/drivers/firmware/pcdp.c
> +++ b/drivers/firmware/pcdp.c
> @@ -95,7 +95,7 @@ efi_setup_pcdp_console(char *cmdline)
>  	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
>  		return -ENODEV;
>  
> -	pcdp = ioremap(efi.hcdp, 4096);
> +	pcdp = early_ioremap(efi.hcdp, 4096);
>  	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi.hcdp);
>  
>  	if (strstr(cmdline, "console=hcdp")) {
> @@ -131,6 +131,6 @@ efi_setup_pcdp_console(char *cmdline)
>  	}
>  
>  out:
> -	iounmap(pcdp);
> +	early_iounmap(pcdp, 4096);
>  	return rc;
>  }

This looks good to me.

Acked-by: Khalid Aziz <khalid.aziz@hp.com>

-- 
Khalid Aziz <khalid.aziz@hp.com>

