Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2KFVhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:37:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60095 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2KFVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:37:19 -0500
Message-ID: <5099830C.4010703@wwwdotorg.org>
Date: Tue, 06 Nov 2012 14:37:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/5] gpiolib: separation of pin concerns
References: <1352215028-30381-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1352215028-30381-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 08:17 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The fact that of_gpiochip_add_pin_range() and
> gpiochip_add_pin_range() share too much code is fragile and
> will invariably mean that bugs need to be fixed in two places
> instead of one.
> 
> So separate the concerns of gpiolib.c and gpiolib-of.c and
> have the latter call the former as back-end. This is necessary
> also when going forward with other device descriptions such
> as ACPI.

> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c

> @@ -115,7 +114,6 @@ struct pinctrl_dev *of_pinctrl_add_gpio_range(struct device_node *np,
>  	if (!pctldev)
>  		return NULL;
>  
> -	pinctrl_add_gpio_range(pctldev, range);
>  	return pctldev;
>  }

I think that collapses to just:

	return pctldev;

Aside from that, the series,

Reviewed-by: Stephen Warren <swarren@nvidia.com>
