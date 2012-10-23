Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab2JWPmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:42:32 -0400
Received: from mail.x86-64.org ([217.9.48.20]:53530 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab2JWPma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:42:30 -0400
Date: Tue, 23 Oct 2012 17:42:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] check the kzalloc return value
Message-ID: <20121023154226.GB16140@aftab.osrc.amd.com>
References: <1350921364-26366-1-git-send-email-kirjanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350921364-26366-1-git-send-email-kirjanov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 07:56:04PM +0400, Denis Kirjanov wrote:
> 

Needs a commit message.

> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> ---
>  drivers/edac/edac_mc_sysfs.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index ed0bc07..55ce016 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -1128,7 +1128,8 @@ int __init edac_mc_sysfs_init(void)
>  	}
>  
>  	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
> -
> +	if (!mci_pdev)
> +		return -ENOMEM;

This either needs to do

	edac_put_sysfs_subsys();

on the error-out path.

>  	mci_pdev->bus = edac_subsys;
>  	mci_pdev->type = &mc_attr_type;
>  	device_initialize(mci_pdev);

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
