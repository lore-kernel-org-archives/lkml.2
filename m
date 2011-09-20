Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1ITV6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:58:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2586 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1ITV6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:58:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 20 Sep 2011 14:58:06 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
CC: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 20 Sep 2011 14:58:05 -0700
Subject: RE: [PATCH 1/2] drivers: create a pin control subsystem v7
Thread-Topic: [PATCH 1/2] drivers: create a pin control subsystem v7
Thread-Index: Acx0aiGDcDUWcDhlRHKpTdK8lkwnLwDdOMAw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B7321751@HQMAIL01.nvidia.com>
References: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Friday, September 16, 2011 6:13 AM:
> This creates a subsystem for handling of pin control devices.
> These are devices that control different aspects of package
> pins.

I've read through the documentation and header files, but not the .c files,
and this looks almost perfect as far as I can tell right now. I'll try to
review the .c files sometime too.

I just have one comment:

> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
...
> +/* External interface to pinmux */
> +extern int pinmux_request_gpio(unsigned gpio);
> +extern void pinmux_free_gpio(unsigned gpio);
> +extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
> +extern void pinmux_put(struct pinmux *pmx);
> +extern int pinmux_enable(struct pinmux *pmx);
> +extern void pinmux_disable(struct pinmux *pmx);
> +extern int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data);

That definition of pinmux_config doesn't seem as useful as it could be;
I'd like the ability to execute pinmux_config on a /named/ group, and I
can certainly see a use-case for applying it to /named/ pins too.

The issues with applying pinmux_config to a mapping table entry are:

* When there are multiple mapping table entries referenced by one
pinmux_get, you don't necessarily want to apply the same configuration
to all of the groups; think of a bus with a combination of low-speed
output control signals and high-speed input data signals or something
like that.

* When muxing works in groups, you may want to apply the configuration
to individual pins rather than the whole groups using in the mapping
table.

-- 
nvpublic

