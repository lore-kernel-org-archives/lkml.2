Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2EMUvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:51:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34427 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753110Ab2EMUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:51:00 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX198WpMMblB80mNG3m9OLPInBiKx3sSOTizJiNYcGb
	60xXh2Wj1Wfq2g
Message-ID: <4FB01EAA.8040504@gmx.de>
Date: Sun, 13 May 2012 20:50:50 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Maik Broemme <mbroemme@plusserver.de>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/intelfb/intelfbdrv.c: add missing agp_backend_release
References: <1334854553-30067-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1334854553-30067-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 04:55 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Release bridge, as done on all other paths out of the function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Looks good to me, applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/intelfb/intelfbdrv.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
> index 02fd226..bdcbfba 100644
> --- a/drivers/video/intelfb/intelfbdrv.c
> +++ b/drivers/video/intelfb/intelfbdrv.c
> @@ -680,6 +680,7 @@ static int __devinit intelfb_pci_register(struct pci_dev *pdev,
>  		 + dinfo->fb.size);
>  	if (!dinfo->aperture.virtual) {
>  		ERR_MSG("Cannot remap FB region.\n");
> +		agp_backend_release(bridge);
>  		cleanup(dinfo);
>  		return -ENODEV;
>  	}
> @@ -689,6 +690,7 @@ static int __devinit intelfb_pci_register(struct pci_dev *pdev,
>  					      INTEL_REG_SIZE);
>  	if (!dinfo->mmio_base) {
>  		ERR_MSG("Cannot remap MMIO region.\n");
> +		agp_backend_release(bridge);
>  		cleanup(dinfo);
>  		return -ENODEV;
>  	}
> 
> 

