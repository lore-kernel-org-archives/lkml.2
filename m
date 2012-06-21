Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2FUJSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:18:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63109 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab2FUJSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:18:39 -0400
Date: Thu, 21 Jun 2012 02:18:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, JJ Ding <dgdunix@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH RESEND] input: gpio_keys_polled: convert to dt
Message-ID: <20120621091833.GH2193@core.coreip.homeip.net>
References: <1340192062-10565-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340192062-10565-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Wed, Jun 20, 2012 at 08:34:21AM -0300, Alexandre Pereira da Silva wrote:
> Add device tree support to gpio_keys_polled.c
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Tested-by: Roland Stigge <stigge@antcom.de>
> ---
>  drivers/input/keyboard/gpio_keys_polled.c |  121 +++++++++++++++++++++++++++--
>  1 file changed, 113 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
> index 20c8ab1..a64b361 100644
> --- a/drivers/input/keyboard/gpio_keys_polled.c
> +++ b/drivers/input/keyboard/gpio_keys_polled.c
> @@ -25,6 +25,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
>  
>  #define DRV_NAME	"gpio-keys-polled"
>  
> @@ -38,7 +40,7 @@ struct gpio_keys_button_data {
>  struct gpio_keys_polled_dev {
>  	struct input_polled_dev *poll_dev;
>  	struct device *dev;
> -	struct gpio_keys_platform_data *pdata;
> +	struct gpio_keys_platform_data pdata;

I am not sure why this change is needed. Also it seems that the driver
leaks DT-created pdata on unload.

> +
> +#define gpio_keys_polled_of_match NULL

Please use of_match_ptr() instead.

Thanks.

-- 
Dmitry
