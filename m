Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1GVKrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:47:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50543 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1GVKrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:47:41 -0400
Subject: Re: [PATCH] regulator: tps65910: Fix a memory leak in
 tps65910_probe error path
From: Liam Girdwood <lrg@kernel.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1310295127.4877.4.camel@phoenix>
References: <1310295127.4877.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 11:47:33 +0100
Message-ID: <1311331653.3312.10.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 18:52 +0800, Axel Lin wrote:
> Fix a memory leak if chip id is not matched.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps65910-regulator.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
> index fe8dc02..e15aac6 100644
> --- a/drivers/regulator/tps65910-regulator.c
> +++ b/drivers/regulator/tps65910-regulator.c
> @@ -909,6 +909,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
>  		break;
>  	default:
>  		pr_err("Invalid tps chip version\n");
> +		kfree(pmic);
>  		return -ENODEV;
>  	}
>  

Applied.

Thanks

Liam

