Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2HBJxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 05:53:46 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:35382 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2HBJxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 05:53:38 -0400
Date: Thu, 2 Aug 2012 11:53:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: <swarren@nvidia.com>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: muxes: fix build break
Message-ID: <20120802115324.6ed7ce52@endymion.delvare>
In-Reply-To: <1343898737-24386-1-git-send-email-vbyravarasu@nvidia.com>
References: <1343898737-24386-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Thu, 2 Aug 2012 14:42:17 +0530, Venu Byravarasu wrote:
> Seems a new parameter is added to i2c_add_mux_adapter().
> All its references, except for the one present in
> i2c-mux-pinctrl.c, were updated.
> As this is causing build break, pushing current patch to fix it.

Thanks for the heads up. When I wrote the patch adding the parameter,
the i2c-mux-pinctrl driver wasn't upstream yet, that's why I missed it.

> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/i2c/muxes/i2c-mux-pinctrl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> index 46a6697..5f097f3 100644
> --- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
> +++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> @@ -221,7 +221,7 @@ static int __devinit i2c_mux_pinctrl_probe(struct platform_device *pdev)
>  				(mux->pdata->base_bus_num + i) : 0;
>  
>  		mux->busses[i] = i2c_add_mux_adapter(mux->parent, &pdev->dev,
> -						     mux, bus, i,
> +						     mux, bus, i, 0,
>  						     i2c_mux_pinctrl_select,
>  						     deselect);
>  		if (!mux->busses[i]) {

As the problematic patch isn't upstream yet, I've simply folded the
above into it:
http://khali.linux-fr.org/devel/linux-3/jdelvare-i2c/i2c-mux-support-class.patch

Thanks again,
-- 
Jean Delvare
