Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2LIHDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 02:03:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33617 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab2LIHDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 02:03:36 -0500
MIME-Version: 1.0
In-Reply-To: <1355024486.16481.1.camel@phoenix>
References: <1355024486.16481.1.camel@phoenix>
Date: Sun, 9 Dec 2012 15:03:35 +0800
Message-ID: <CAN1soZy8ze=rnJ=hUTThY9H2-WSbaPjMZeUNypExiv49wUWntA@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: 88pm8607: Update update_bit for BUCK2 in pm8607_set_voltage_sel
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 9, 2012 at 11:41 AM, Axel Lin <axel.lin@ingics.com> wrote:
> BUCK2 has the update_bit setting, but current code does not set update_bit
> in pm8607_set_voltage_sel.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Haojian,
> I don't have the datasheet, can you check if this patch is correct or not?
> Thanks,
> Axel
>  drivers/regulator/88pm8607.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
> index 2b55711..5c4879a 100644
> --- a/drivers/regulator/88pm8607.c
> +++ b/drivers/regulator/88pm8607.c
> @@ -236,6 +236,7 @@ static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
>                 return ret;
>         switch (info->desc.id) {
>         case PM8607_ID_BUCK1:
> +       case PM8607_ID_BUCK2:
>         case PM8607_ID_BUCK3:
>                 ret = pm860x_set_bits(info->i2c, info->update_reg,
>                                       1 << info->update_bit,
> --
> 1.7.9.5
>
>
>
It's unnecessary since BUCK2 is designed to control voltage of CP
domain. If CP wants to scale frequency,
it could change BUCK2. Linux won't run in CP side. It only runs in AP
side. So we don't need to control
BUCK2 in AP side.
