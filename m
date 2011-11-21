Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1KUWSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:18:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11085 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1KUWSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:18:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Nov 2011 14:18:47 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Igor Grinberg <grinberg@compulab.co.il>
Date: Mon, 21 Nov 2011 14:18:45 -0800
Subject: RE: [PATCH] pinctrl: GPIO direction support for muxing
Thread-Topic: [PATCH] pinctrl: GPIO direction support for muxing
Thread-Index: AcyoTYmBb+I5gvNPT1C+649ezKCXQQATQ1Fg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C25F@HQMAIL01.nvidia.com>
References: <1321880398-12605-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1321880398-12605-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, November 21, 2011 6:00 AM:
> When requesting a single GPIO pin to be muxed in, some controllers
> will need to poke a different value into the control register
> depending on whether the pin will be used for GPIO output or GPIO
> input. So create pinmux counterparts to gpio_direction_[input|output]
> in the pinctrl framework.

Just a few very minor typos below. Otherwise,

Acked-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
...
> +NOTE that platforms and individual driver shall *NOT* request GPIO pins to be
                                           ^s
> +muxed in. Instead, implement a proper gpiolib driver hand have that driver
                                                        ^ and

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
...
> @@ -360,7 +421,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
> 
>  	/* Try to allocate all pins in this group, one by one */
>  	for (i = 0; i < num_pins; i++) {
> -		ret = pin_request(pctldev, pins[i], func, NULL);
> +	  ret = pin_request(pctldev, pins[i], func, NULL);

Looks like a mistake.

> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h

> + * @gpio_set_direction: Since controllers may be needing different

s/be needing/need/

-- 
nvpublic

