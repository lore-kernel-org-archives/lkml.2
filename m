Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1F0XDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:03:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33180 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab1F0XB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:01:58 -0400
Date: Mon, 27 Jun 2011 17:01:54 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: vr41xx_giu: use resource_size()
Message-ID: <20110627230154.GI20865@ponder.secretlab.ca>
References: <201106061352.19881.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106061352.19881.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:52:19PM -0700, H Hartley Sweeten wrote:
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Thanks.  I've already merged a patch that makes this change.

g.

> 
> ---
> 
> diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
> index a365be0..98723cb 100644
> --- a/drivers/gpio/vr41xx_giu.c
> +++ b/drivers/gpio/vr41xx_giu.c
> @@ -518,7 +518,7 @@ static int __devinit giu_probe(struct platform_device *pdev)
>  	if (!res)
>  		return -EBUSY;
>  
> -	giu_base = ioremap(res->start, res->end - res->start + 1);
> +	giu_base = ioremap(res->start, resource_size(res));
>  	if (!giu_base)
>  		return -ENOMEM;
>  
