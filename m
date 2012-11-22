Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2KVTDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:03:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62370 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2KVTDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:03:21 -0500
Date: Thu, 22 Nov 2012 10:27:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Subject: Re: [PATCH V2 1/2] mfd: stmpe: Use devm_*() routines
Message-ID: <20121122102710.GD4328@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012, Viresh Kumar wrote:

> This patch frees stmpe driver from tension of freeing resources :)
> devm_* derivatives of multiple routines are used while allocating resources,
> which would be freed automatically by kernel.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> 
> V1->V2:
> ------
> - Rebased over latest for-next from Samuel
> - updated additional kzalloc with devm_kzalloc(), first one seen below.
> 
>  drivers/mfd/stmpe.c | 60 +++++++++++++++++++----------------------------------
>  1 file changed, 21 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index ba157d4..c0df4b9 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -1052,17 +1052,17 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
>  	int ret;
>  
>  	if (!pdata) {
> -		if (np) {
> -			pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> -			if (!pdata)
> -				return -ENOMEM;
> -
> -			stmpe_of_probe(pdata, np);
> -		} else
> +		if (!np)

I'm assuming you've reversed the semantics here for >80 chars reasons?

I see no harm in it though.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
