Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1EULyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 07:54:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53799 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1EULyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 07:54:07 -0400
Subject: Re: [PATCH] regulator: Fix off-by-one value range checking for
 mc13xxx_regulator_get_voltage
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1305723405.6172.1.camel@phoenix>
References: <1305723405.6172.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 12:54:02 +0100
Message-ID: <1305978842.3317.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 20:56 +0800, Axel Lin wrote:
> We use val as array index,
> thus the valid value rangae for val should be 0 .. n_voltages-1.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/mc13xxx-regulator-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
> index 2bb5de1..bc27ab1 100644
> --- a/drivers/regulator/mc13xxx-regulator-core.c
> +++ b/drivers/regulator/mc13xxx-regulator-core.c
> @@ -174,7 +174,7 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
>  
>  	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
>  
> -	BUG_ON(val > mc13xxx_regulators[id].desc.n_voltages);
> +	BUG_ON(val >= mc13xxx_regulators[id].desc.n_voltages);
>  
>  	return mc13xxx_regulators[id].voltages[val];
>  }

Applied

Thanks

Liam

