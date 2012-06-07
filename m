Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709Ab2FGK6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:58:34 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47507 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab2FGK6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:58:33 -0400
Message-ID: <4FD08957.5080901@slimlogic.co.uk>
Date: Thu, 07 Jun 2012 11:58:31 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT] regulator: palmas: Clear PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK
 bits in palmas_set_mode_smps
References: <1339060101.5274.5.camel@phoenix>
In-Reply-To: <1339060101.5274.5.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That looks like a C&P error on my part.

Thanks for noticing.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 07/06/12 10:08, Axel Lin wrote:
> Current code actually clears more bits than PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK bits.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Graeme,
>
> I'm wandering if we need to clear the status bits.
> Current code actually clears bit[7:4] and bit[1:0] and set bit[7:6] to bit[3:2].
> Looks like we only need to clear PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK bit[1:0] bits here.
> and this change makes the intent more clear.
>
> I don't have this hardware,
> I'd appreciate if you can test this patch if you think this change ok.
>
> Regards,
> Axel
>  drivers/regulator/palmas-regulator.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 92f475c..ae0951a 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -257,8 +257,7 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
>  	unsigned int reg;
>  
>  	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
> -	reg &= ~PALMAS_SMPS12_CTRL_STATUS_MASK;
> -	reg >>= PALMAS_SMPS12_CTRL_STATUS_SHIFT;
> +	reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
>  
>  	switch (mode) {
>  	case REGULATOR_MODE_NORMAL:

