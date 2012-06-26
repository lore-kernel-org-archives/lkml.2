Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab2FZKai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:30:38 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57407 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2FZKah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:30:37 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1340706382-27297-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340706382-27297-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 26 Jun 2012 18:30:16 +0800
Message-ID: <CAF+7xWkj+aFc_Kq7PzAoYrUa0tCs1sq7K2=bc-tVXJH4x+7DRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: core: Only delay if we successfully set
 the voltage
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> There is no need to wait for the voltage to ramp if we didn't manage to
> set it.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 30ecb49..9f28f2f 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2131,7 +2131,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
>                best_val = _regulator_get_voltage(rdev);
>
>        /* Call set_voltage_time_sel if successfully obtained old_selector */
> -       if (_regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
                                                                  ^^^^^^^^
                                                                 We
already check ret ==0 here.
> +       if (ret == 0 &&
> +           _regulator_is_enabled(rdev) && ret == 0 && old_selector >= 0 &&
>            rdev->desc->ops->set_voltage_time_sel) {
>
>                delay = rdev->desc->ops->set_voltage_time_sel(rdev,
> --
> 1.7.10
>
