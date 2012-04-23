Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2DWPI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:08:29 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:9843 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2DWPI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:08:28 -0400
Message-ID: <4F957065.60308@hp.com>
Date: Mon, 23 Apr 2012 10:08:21 -0500
From: Mike Miller <mike.miller@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/cciss.c: correct size computation
References: <1335017299-30356-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1335017299-30356-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 09:08 AM, Julia Lawall wrote:
> From: Julia Lawall<Julia.Lawall@lip6.fr>
>
> The size argument to remap_pci_mem should be the size of desired structure,
> not the pointer to it.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @expression@
> expression *x;
> @@
>
> x =
>   <+...
> -sizeof(x)
> +sizeof(*x)
> ...+>
> //</smpl>
>
> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>
Acked-by: Mike Miller <mike.miller@hp.com>
>
> ---
>   drivers/block/cciss.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index b0f553b..9f50d7d 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -4209,7 +4209,7 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
>   	if (rc)
>   		return rc;
>   	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
> -		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
> +		cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
>   	if (!h->cfgtable)
>   		return -ENOMEM;
>   	rc = write_driver_ver_to_cfgtable(h->cfgtable);
>

