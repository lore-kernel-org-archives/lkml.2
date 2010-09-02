Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0IBKbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:31:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62751 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0IBKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:31:45 -0400
Subject: Re: [PATCH] Input: wm97xx-core - use platform_device_del instead
 of platform_device_unregister for error handling
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
In-Reply-To: <1283416029.19272.3.camel@mola>
References: <1283416029.19272.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 11:31:41 +0100
Message-ID: <1283423501.3084.39.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 16:27 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/input/touchscreen/wm97xx-core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
> index cbfef1e..770537c 100644
> --- a/drivers/input/touchscreen/wm97xx-core.c
> +++ b/drivers/input/touchscreen/wm97xx-core.c
> @@ -684,8 +684,7 @@ static int wm97xx_probe(struct device *dev)
>   touch_reg_err:
>  	platform_device_put(wm->touch_dev);
>   touch_err:
> -	platform_device_unregister(wm->battery_dev);
> -	wm->battery_dev = NULL;
> +	platform_device_del(wm->battery_dev);
>   batt_reg_err:
>  	platform_device_put(wm->battery_dev);
>   batt_err:

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

