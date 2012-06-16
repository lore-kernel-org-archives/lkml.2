Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2FPO5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 10:57:55 -0400
Received: from antcom.de ([188.40.178.216]:44728 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2FPO5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 10:57:54 -0400
Message-ID: <4FDC9EEC.1070509@antcom.de>
Date: Sat, 16 Jun 2012 16:57:48 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        sebastian.rasmussen@stericsson.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: mmci.c: Defer probe() in case of missing GPIOs
References: <1339856099-9313-1-git-send-email-stigge@antcom.de> <20120616142652.GC7628@n2100.arm.linux.org.uk>
In-Reply-To: <20120616142652.GC7628@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/12 16:26, Russell King - ARM Linux wrote:
> On Sat, Jun 16, 2012 at 04:14:59PM +0200, Roland Stigge wrote:
>> If the GPIOs used by the MMCI driver are not registered yet when the
>> driver is probe()d, they can't be used. This happens if the mmci driver
>> is probed before the respective GPIO controller (e.g. on the LPC32xx
>> EA3250 board, the PCA9532 GPIO controller would be initialized via DT
>> after mmci). Therefore, we defer mmci in this case.
> 
> This code is wrong.  There are platforms where plat->gpio_cd is negative
> (because there isn't an associated GPIO) and we still expect the driver
> to successfully bind.  In that case, the driver gets the CD and WP
> information via the status callback.
> 
> So this is an incompatible change with existing (and required) driver
> behaviour.

As someone just told me, in the case of no GPIO, we would have gpio_cd
== -ENODEV. Would it be sufficient to check for -ENODEV (in which case
we would do without GPIO), and otherwise return -EPROBE_DEFER?

Or is it necessary to flag DT-bound GPIOs somehow additionally to handle
this new case?

Thanks in advance,

Roland
