Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1HHQol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:44:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35481 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1HHQok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:44:40 -0400
Subject: Re: [PATCH] regulator: Ensure enough enable time for max8649
From: Liam Girdwood <lrg@kernel.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1312260896.6161.1.camel@phoenix>
References: <1312260896.6161.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:44:36 +0100
Message-ID: <1312821876.3316.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-02 at 12:54 +0800, Axel Lin wrote:
> Integer division may truncate the result, thus max8649_enable_time() may return
> slightly shorter enable time. This patch fixes it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/max8649.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
> index 30eb9e5..1062cf9 100644
> --- a/drivers/regulator/max8649.c
> +++ b/drivers/regulator/max8649.c
> @@ -221,7 +221,7 @@ static int max8649_enable_time(struct regulator_dev *rdev)
>  	ret = (ret & MAX8649_RAMP_MASK) >> 5;
>  	rate = (32 * 1000) >> ret;	/* uV/uS */
>  
> -	return (voltage / rate);
> +	return DIV_ROUND_UP(voltage, rate);
>  }
>  
>  static int max8649_set_mode(struct regulator_dev *rdev, unsigned int mode)

Applied.

Thanks

Liam

