Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab2KIJmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:42:16 -0500
Received: from smtp-out-195.synserver.de ([212.40.185.195]:1220 "EHLO
	smtp-out-195.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2KIJmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:42:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 24208
Message-ID: <509CCFF3.60706@metafoo.de>
Date: Fri, 09 Nov 2012 10:42:11 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivres/power/jz4740-battery.c: Use devm_request_and_ioremap
References: <1352243472-14951-1-git-send-email-marcos.souza.org@gmail.com> <1352243472-14951-3-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1352243472-14951-3-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 12:11 AM, Marcos Paulo de Souza wrote:
> No functional changes. Just a cleanup.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Looks good to me:

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

One minor comment though:

> ---
>  drivers/power/jz4740-battery.c |   33 +++++++--------------------------
>  1 file changed, 7 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 59900c6..e4ec7eb 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
>[...]
> -	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
> -				resource_size(jz_battery->mem));
> +	jz_battery->base = devm_request_and_ioremap(&pdev->dev, mem);
>  	if (!jz_battery->base) {
> -		ret = -EBUSY;
> -		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
> -		goto err_release_mem_region;
> +		dev_err(&pdev->dev, "Failed to request/ioremap mmio memory\n");

devm_request_and_ioremap will print its own error messages if it fails, so
strictly speaking this is not necessary, but I don't think it is worth doing
resend just for this.

Anton, maybe you can just remove the line when applying the patch.

Thanks,
- Lars

> +		return -EBUSY;
>  	}
>  
[...]

