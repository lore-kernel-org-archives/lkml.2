Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2INFTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:19:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38523 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751317Ab2INFTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:19:05 -0400
Message-ID: <1347599944.9481.3.camel@joe2Laptop>
Subject: Re: [PATCH] pinctrl: use kasprintf() in pinmux_request_gpio()
From: Joe Perches <joe@perches.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 13 Sep 2012 22:19:04 -0700
In-Reply-To: <1347565754-9534-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1347565754-9534-1-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 21:49 +0200, Thomas Petazzoni wrote:
> Instead of using a temporary buffer, snprintf() and kstrdup(), just
> use kasprintf() that does the same thing in just oneline.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
>  drivers/pinctrl/pinmux.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index 3d5ac73..9301a7a 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -232,14 +232,11 @@ int pinmux_request_gpio(struct pinctrl_dev *pctldev,
>  			struct pinctrl_gpio_range *range,
>  			unsigned pin, unsigned gpio)
>  {
> -	char gpiostr[16];
>  	const char *owner;
>  	int ret;
>  
>  	/* Conjure some name stating what chip and pin this is taken by */
> -	snprintf(gpiostr, 15, "%s:%d", range->name, gpio);
> -
> -	owner = kstrdup(gpiostr, GFP_KERNEL);
> +	owner = kasprintf(GFP_KERNEL, "%s:%d", range->name, gpio);
>  	if (!owner)
>  		return -EINVAL;
>  

No not really.  It's a bit different because the first
snprintf is length limited but the kasprintf is not.


