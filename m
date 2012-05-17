Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967291Ab2EQPsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:48:14 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:2239 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967047Ab2EQPsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:48:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1337269657!12893350!46
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Shawn Guo <shawn.guo@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: =?iso-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Hans J. Koch" <hjk@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 May 2012 10:47:56 -0500
Subject: RE: [PATCH 1/2] gpio/generic: initialize basic_mmio_gpio shadow
 variables properly
Thread-Topic: [PATCH 1/2] gpio/generic: initialize basic_mmio_gpio shadow
 variables properly
Thread-Index: Ac0z/6jK8I8zjNWORjiHy0oTaEsWwAARFVSA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698AE0FBB@AUSP01VMBX24.collaborationhost.net>
References: <1337240103-4756-1-git-send-email-shawn.guo@linaro.org>
 <1337240103-4756-2-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1337240103-4756-2-git-send-email-shawn.guo@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2012 12:35 AM, Shawn Guo wrote:
> It fixes the issue in gpio-generic that commit fb14921 (gpio/mxc: add
> missing initialization of basic_mmio_gpio shadow variables) manged to
> fix in gpio-mxc driver, so that other platform specific drivers do not
> suffer from the same problem over and over again.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/gpio/gpio-generic.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> index e38dd0c..cfc9439 100644
> --- a/drivers/gpio/gpio-generic.c
> +++ b/drivers/gpio/gpio-generic.c
> @@ -394,6 +394,10 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
>  		return ret;
>  
>  	bgc->data = bgc->read_reg(bgc->reg_dat);
> +	if (bgc->gc.set == bgpio_set_set)
> +		bgc->data = bgc->read_reg(bgc->reg_set);
> +	if (bgc->reg_dir)
> +		bgc->dir = bgc->read_reg(bgc->reg_dir);
>  
>  	return ret;
>  }

This change is fine for ep93xx.

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

