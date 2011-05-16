Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1EPKWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:22:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33790 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab1EPKWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DPWvU6gN7wG9KKJhpij1WKquiSLBOnfn0LSQ1nIDvrtzmPbVuKieaiLvKw0GWgpmjB
         TI69DKClMWglCv+Vs1AWbGRG4e0LWBqOTxe4NgnO4kdK0yHEhGCiLogsBFonwx3s+R/R
         agE4uCiYV7iwKq7XiWa3gVgH5eo5G2+l7MXAk=
MIME-Version: 1.0
In-Reply-To: <1305541234.3006.5.camel@phoenix>
References: <1305541234.3006.5.camel@phoenix>
Date: Mon, 16 May 2011 19:22:45 +0900
X-Google-Sender-Auth: -nVi8KygG9qRPVuYvnRXs9VA6lA
Message-ID: <BANLkTimuyKWANZ-_3JKG+R_o96HpsG7PhQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] regulator: Remove MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS
 macros
From: Kyungmin Park <kmpark@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Mon, May 16, 2011 at 7:20 PM, Axel Lin <axel.lin@gmail.com> wrote:
> In current implementation, the original macro implementation assumes the caller
> pass the parameter starting from 1 (to match the register names in datasheet).
> Thus we have unneeded plus one then minus one operations
> when using MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros.
>
> This patch removes these macros to avoid unneeded plus one then minus one operations
> without reducing readability.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> The (V1) original patch title was
> [PATCH] regulator: Simplify MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
> I change the patch title to meet the change.
>
> Regards,
> Axel
>
>  drivers/regulator/max8997.c         |   12 ++++++------
>  include/linux/mfd/max8997-private.h |    4 ----
>  2 files changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index b1c1444..10d5a1d 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -1032,11 +1032,11 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>
>        /* For the safety, set max voltage before setting up */
>        for (i = 0; i < 8; i++) {
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
>                                max_buck1, 0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
>                                max_buck2, 0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
>                                max_buck5, 0x3f);
>        }
>
> @@ -1113,13 +1113,13 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>
>        /* Initialize all the DVS related BUCK registers */
>        for (i = 0; i < 8; i++) {
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
>                                max8997->buck1_vol[i],
>                                0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
>                                max8997->buck2_vol[i],
>                                0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
>                                max8997->buck5_vol[i],
>                                0x3f);
>        }
> diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
> index 69d1010..5ff2400 100644
> --- a/include/linux/mfd/max8997-private.h
> +++ b/include/linux/mfd/max8997-private.h
> @@ -311,10 +311,6 @@ enum max8997_irq {
>        MAX8997_IRQ_NR,
>  };
>
> -#define MAX8997_REG_BUCK1DVS(x)        (MAX8997_REG_BUCK1DVS1 + (x) - 1)
> -#define MAX8997_REG_BUCK2DVS(x)        (MAX8997_REG_BUCK2DVS1 + (x) - 1)
> -#define MAX8997_REG_BUCK5DVS(x)        (MAX8997_REG_BUCK5DVS1 + (x) - 1)
> -
>  #define MAX8997_NUM_GPIO       12
>  struct max8997_dev {
>        struct device *dev;
> --
> 1.7.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
