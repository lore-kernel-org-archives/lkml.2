Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2KNJWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:22:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37149 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2KNJWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:22:04 -0500
Date: Wed, 14 Nov 2012 09:21:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Per Forlin <per.forlin@stericsson.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        Linus Walleij <linus.walleij@linaro.org>,
        fredrik.soderstedt@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt: platform: Extract device name from device tree blob
Message-ID: <20121114092158.GA12596@gmail.com>
References: <1352732343-1199-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352732343-1199-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Per Forlin wrote:

> Add support to extract device name from device tree blob.
> If the property "dev-name" is set in the DTS this name will
> be used when creating the device.
> The auxdata_lookup has precedence and will override
> the "dev-name" property.
> 
> Adding support to parse DTS "dev-name" will make it possible to
> replace these kind of structures with a dev-name in the DTS.
> OF_DEV_AUXDATA("compatible", BASE_ADDRESS, "dev-name", NULL)

This patch isn't required. The correct action is to make the driver
DT aware. Also, is naming devices "devname.id" a Linux only thing,
or do other OSes do the same? If the former is true, then we
definitely do not want to add this binding.

> OF_DEV_AUXDATA("st,nomadik-gpio", 0x8012e000, "gpio.0", NULL),
> OF_DEV_AUXDATA("st,nomadik-i2c", 0x80004000, "nmk-i2c.0", NULL),

In this case, once we have added common clk functionality to our
Device Trees, these will vanish.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
