Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab2J0PIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:08:13 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38932 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab2J0PIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:08:11 -0400
Message-ID: <508BF95A.5000608@gmail.com>
Date: Sat, 27 Oct 2012 17:10:18 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
CC: lee.jones@linaro.org, arnd@arndb.de, anton.vorontsov@linaro.org,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 3/4] mfd: ab8500: add devicetree support for charger
References: <1351146654-9110-1-git-send-email-rajanikanth.hv@stericsson.com> <1351146654-9110-4-git-send-email-rajanikanth.hv@stericsson.com>
In-Reply-To: <1351146654-9110-4-git-send-email-rajanikanth.hv@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 08:30 AM, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> This patch adds device tree support for ab8500-charger
> driver
> 
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
[...]
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index 78a730c..956943e 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -23,6 +23,8 @@
>  #include <linux/err.h>
>  #include <linux/workqueue.h>
>  #include <linux/kobject.h>
> +#include <linux/of.h>
> +#include <linux/mfd/core.h>
>  #include <linux/mfd/abx500/ab8500.h>
>  #include <linux/mfd/abx500.h>
>  #include <linux/mfd/abx500/ab8500-bm.h>
> @@ -183,7 +185,6 @@ struct ab8500_charger_usb_state {
>   * @autopower		Indicate if we should have automatic pwron after pwrloss
>   * @parent:		Pointer to the struct ab8500
>   * @gpadc:		Pointer to the struct gpadc
> - * @pdata:		Pointer to the abx500_charger platform data
>   * @bat:		Pointer to the abx500_bm platform data
>   * @flags:		Structure for information about events triggered
>   * @usb_state:		Structure for usb stack information
> @@ -218,9 +219,9 @@ struct ab8500_charger {
>  	int vbat;
>  	int old_vbat;
>  	bool autopower;
> +	bool autopower_cfg;

autopower_cfg should be added in the description of the struct members
as well.

--
Francesco
