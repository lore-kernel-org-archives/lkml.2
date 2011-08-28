Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1H1QdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 12:33:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37336 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1H1QdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 12:33:03 -0400
Subject: Re: [PATCH 1/3] regulator: tps65910: fix device initialisation
From: Liam Girdwood <lrg@kernel.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
In-Reply-To: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
References: <1313405127-2724-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Aug 2011 17:32:57 +0100
Message-ID: <1314549177.3666.3.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Mon, 2011-08-15 at 12:45 +0200, Johan Hovold wrote:
> Fix regression introduced by commit
> a320e3c3d6351814afa5182159df88d2637e0f6f (regulator: tps65911: Add new
> chip version) which broke probe for all devices:
> 
> 	"Invalid tps chip version"
> 
> Cc: stable@kernel.org
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  drivers/regulator/tps65910-regulator.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
> index 55dd4e6..bc5ed25 100644
> --- a/drivers/regulator/tps65910-regulator.c
> +++ b/drivers/regulator/tps65910-regulator.c
> @@ -898,9 +898,11 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
>  	case TPS65910:
>  		pmic->get_ctrl_reg = &tps65910_get_ctrl_register;
>  		info = tps65910_regs;
> +		break;
>  	case TPS65911:
>  		pmic->get_ctrl_reg = &tps65911_get_ctrl_register;
>  		info = tps65911_regs;
> +		break;
>  	default:
>  		pr_err("Invalid tps chip version\n");
>  		return -ENODEV;

Couldn't apply these as it seems there may already be fixes to some of
the issues fixed by your patches. Could you update and resend.

Thanks !

Liam

