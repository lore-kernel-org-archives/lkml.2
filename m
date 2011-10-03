Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1JCQj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:39:59 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:8786 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1JCQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:39:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1317659932!18107425!67
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Mon, 3 Oct 2011 11:39:44 -0500
Subject: RE: [PATCH] mmc: sdhci-tegra: Add #ifdef CONFIG_OF guard for
 of_find_property
Thread-Topic: [PATCH] mmc: sdhci-tegra: Add #ifdef CONFIG_OF guard for
 of_find_property
Thread-Index: AcyBgjMvKg2/SxmxTdyQJ52Sjqt4tQAaDgKw
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DC56AB6@AUSP01VMBX24.collaborationhost.net>
References: <1317614852.30838.1.camel@phoenix>
In-Reply-To: <1317614852.30838.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p93Ge4l7017135

On Sunday, October 02, 2011 9:08 PM, Axel Lin wrote:
>
> I got below build error with "make tegra_defconfig;make"
> Add #ifdef CONFIG_OF guard for of_find_property to fix below build error:
>
>   CC      drivers/mmc/host/sdhci-tegra.o
> drivers/mmc/host/sdhci-tegra.c: In function 'sdhci_tegra_dt_parse_pdata':
> drivers/mmc/host/sdhci-tegra.c:157: error: implicit declaration of function 'of_find_property'
> make[3]: *** [drivers/mmc/host/sdhci-tegra.o] Error 1
> make[2]: *** [drivers/mmc/host] Error 2
> make[1]: *** [drivers/mmc] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I got the build error on linux-next (20110930).
> Axel
>
>  drivers/mmc/host/sdhci-tegra.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 67176afc..3883602 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -154,8 +154,11 @@ static struct tegra_sdhci_platform_data * __devinit sdhci_tegra_dt_parse_pdata(
>  	plat->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
>  	plat->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
>  	plat->power_gpio = of_get_named_gpio(np, "power-gpios", 0);
> +
> +#ifdef CONFIG_OF
>  	if (of_find_property(np, "support-8bit", NULL))
>  		plat->is_8bit = 1;
> +#endif

I think this type of build error is going to be very common when CONFIG_OF
is not defined.  Wouldn't it be better to fix the issue in the <linux/of.h>
header?  It looks like some of the of_* calls are already handled properly
in that header.

Regards,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
