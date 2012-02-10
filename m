Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab2BJGfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 01:35:36 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51478 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab2BJGff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 01:35:35 -0500
Message-ID: <20276.47790.447816.701234@ipc1.ka-ro>
Date: Fri, 10 Feb 2012 07:35:26 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] pinctrl: changes hog mechanism to be self-referential
In-Reply-To: <1328834868-25030-1-git-send-email-linus.walleij@linaro.org>
References: <1328834868-25030-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij writes:
> Instead of a specific boolean field to indicate if a map entry shall
> be hogged, treat self-reference as an indication of desired hogging.
> This drops one field off the map struct and has a nice Douglas R.
> Hofstadter-feel to it.
> 
> Suggested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt       |    8 ++++----
>  drivers/pinctrl/core.c          |    6 ++----
>  include/linux/pinctrl/machine.h |   18 ++++++------------
>  3 files changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 2e71323..acb9078 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -989,21 +989,21 @@ is registered. This means that the core will attempt to call pinctrl_get() and
>  pinctrl_enable() on it immediately after the pin control device has been
>  registered.
>  
> -This is enabled by simply setting the .hog_on_boot field in the map to true,
> -like this:
> +This is enabled by simply setting the .dev_name field in the map to the name
> +of the pin controller itself, like this:
>  
>  {
>  	.name = "POWERMAP"
>  	.ctrl_dev_name = "pinctrl-foo",
>  	.function = "power_func",
> -	.hog_on_boot = true,
> +	.dev_name = "pinctrl-foo",
>  },
>  
>  Since it may be common to request the core to hog a few always-applicable
>  mux settings on the primary pin controller, there is a convenience macro for
>  this:
>  
> -PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "power_func")
> +PIN_MAP_PRIMARY_SYS_HOG("POWERMAP", "pinctrl-foo". "power_func")
                                                    ^
Shouldn't this be a comma rather than a period?

Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
