Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1KIQ2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:28:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12633 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1KIQ2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:28:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 09 Nov 2011 08:28:16 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Date: Wed, 9 Nov 2011 08:28:14 -0800
Subject: RE: [PATCH] pinctrl: Add explicit gpio_disable_free pinmux_op
Thread-Topic: [PATCH] pinctrl: Add explicit gpio_disable_free pinmux_op
Thread-Index: AcyQHulnhVOvaslFSkG/NSzwGF1zaAO3W98Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17408050C7@HQMAIL01.nvidia.com>
References: <1319221553-15128-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1319221553-15128-1-git-send-email-swarren@nvidia.com>
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

Stephen Warren wrote at Friday, October 21, 2011 12:26 PM:
> Some pinctrl drivers (Tegra at least) program a pin to be a GPIO in a
> completely different manner than they select which function to mux out of
> that pin. In order to support a single "free" pinmux_op, the driver would
> need to maintain a per-pin state of requested-for-gpio vs. requested-for-
> function. However, that's a lot of work when the core already has explicit
> separate paths for gpio request/free and function request/free.
>
> So, add a gpio_disable_free op to struct pinmux_ops, and make pin_free()
> call it when appropriate.

LinusW,

Does this patch look good?

> When doing this, I noticed that when calling pin_request():
> 
>     !!gpio == (gpio_range != NULL)
> 
> ... and so I collapsed those two parameters in both pin_request(), and
> when adding writing the new code in pin_free().
> 
> Also, for pin_free():
> 
>     !!free_func == (gpio_range != NULL)
> 
> However, I didn't want pin_free() to know about the GPIO function naming
> special case, so instead, I reworked pin_free() to always return the pin's
> previously requested function, and now pinmux_free_gpio() calls
> kfree(function). This is much more balanced with the allocation having
> been performed in pinmux_request_gpio().
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

