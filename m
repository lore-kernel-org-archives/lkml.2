Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2FRLYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:24:11 -0400
Received: from antcom.de ([188.40.178.216]:46293 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2FRLYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:24:09 -0400
Message-ID: <4FDF0FD7.3060004@antcom.de>
Date: Mon, 18 Jun 2012 13:24:07 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpio: of_get_named_gpio_flags() return -EPROBE_DEFER
 if GPIO not yet available
References: <1339927893-8842-1-git-send-email-stigge@antcom.de> <4FDE8D27.6030508@wwwdotorg.org> <4FDEF293.9080305@antcom.de>
In-Reply-To: <4FDEF293.9080305@antcom.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 11:19 AM, Roland Stigge wrote:
>> While I agree this is a correct change, it is going to break some
>> existing code - at least sound/soc/tegra/tegra_{wm8903.c,alc5632.c}.
> 
> Can you please tell in which way the patch breaks those drivers?
> However, I can see that those drivers solved the same problem in a
> different way (deferring of_get_named_gpio(), via the sound init()). So
> they could be adjusted to take advantage of new -EPROBE_DEFER
> 
>> However, have you audited all existing callers (including
>> indirect, e.g. through plain of_get_named_gpio()) for issues this will
>> cause?
> 
> Thanks for the hint, I searched the code and found
> 
> drivers/spi/spi-pl022.c
> 
> to be using -ENODEV as indication to return -EPROBE_DEFER from probe().
> Will send a patch that adjusts to our of_get_named_gpio_flags() patch
> and if it's good, we should join the two.

Turned out that this is a fix for a yet-unapplied patch (to support dt
for pl022). Alexandre will merge my fix into his patch.

So I can't find immediate breakage from the gpiolib-of patch.

Thanks,

Roland
