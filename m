Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2FRCGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:06:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50652 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2FRCGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:06:34 -0400
Message-ID: <4FDE8D27.6030508@wwwdotorg.org>
Date: Sun, 17 Jun 2012 20:06:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpio: of_get_named_gpio_flags() return -EPROBE_DEFER
 if GPIO not yet available
References: <1339927893-8842-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339927893-8842-1-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2012 04:11 AM, Roland Stigge wrote:
> of_get_named_gpio_flags() and of_get_named_gpio() return -EPROBE_DEFER if the
> respective GPIO is not (yet) available. This is useful if driver's probe()
> functions try to get a GPIO whose controller isn't probed yet. Thus, the driver
> can be probed again later on.
> 
> The function still returns -EINVAL on other errors (parse error or node doesn't
> exist). This way, the case of an optional/intentionally missing GPIO is handled
> appropriately.

While I agree this is a correct change, it is going to break some
existing code - at least sound/soc/tegra/tegra_{wm8903.c,alc5632.c}. I'm
happy to send patches for those files though (is this going into 3.5 or
3.6?). However, have you audited all existing callers (including
indirect, e.g. through plain of_get_named_gpio()) for issues this will
cause?
