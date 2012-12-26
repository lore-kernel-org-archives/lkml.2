Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2LZDxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 22:53:10 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:33352 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2LZDxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 22:53:08 -0500
Message-ID: <50DA7349.7080105@gmail.com>
Date: Wed, 26 Dec 2012 12:47:21 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8755: Fix mask for pchip->mphase
References: <1356487927.18626.1.camel@phoenix>
In-Reply-To: <1356487927.18626.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012년 12월 26일 11:12, Axel Lin 쓴 글:
> According to lp8755.h:
> enum lp8755_mphase_config {
>          MPHASE_CONF0,
>          MPHASE_CONF1,
>          MPHASE_CONF2,
>          MPHASE_CONF3,
>          MPHASE_CONF4,
>          MPHASE_CONF5,
>          MPHASE_CONF6,
>          MPHASE_CONF7,
>          MPHASE_CONF8,
>          MPHASE_CONF_MAX
> };
>
> MPHASE_CONF_MAX is 9, the mask for pchip->mphase should be 0x17.
> Otherwise, we cannot differentiate MPHASE_CONF0 and MPHASE_CONF8.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Daniel,
> I don't have the datasheet, can you check if this patch is correct?
>
> BTW, I'm Axel, not Alex.
>
> Regards,
> Axel
>   drivers/regulator/lp8755.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
> index 06a82e2..6d5a11d 100644
> --- a/drivers/regulator/lp8755.c
> +++ b/drivers/regulator/lp8755.c
> @@ -301,7 +301,7 @@ static int lp8755_init_data(struct lp8755_chip *pchip)
>   	ret = lp8755_read(pchip, 0x3D, &regval);
>   	if (ret < 0)
>   		goto out_i2c_error;
> -	pchip->mphase = regval & 0x07;
> +	pchip->mphase = regval & 0x17;
>   
>   	/* set default data based on multi-phase config */
>   	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++) {
Hi Axel.


According to the new datasheet, it has 9 multi-phase mode from 0 to 8 
and it takes 4bits in the register.

the mask for pchip->mphase should be 0x0F.

Thank you for your comments Axel.
