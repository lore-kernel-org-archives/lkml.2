Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2FPTEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 15:04:22 -0400
Received: from antcom.de ([188.40.178.216]:46881 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab2FPTEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 15:04:21 -0400
Message-ID: <4FDCD8B1.5000407@antcom.de>
Date: Sat, 16 Jun 2012 21:04:17 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, sebastian.rasmussen@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com
Subject: Re: [PATCH v2] mmc: mmci.c: Defer probe() in case of yet uninitialized
 GPIOs
References: <1339865375-22314-1-git-send-email-stigge@antcom.de> <201206161723.23768.arnd@arndb.de>
In-Reply-To: <201206161723.23768.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/12 19:23, Arnd Bergmann wrote:
> On Saturday 16 June 2012, Roland Stigge wrote:
>> +       if (of_get_property(np, "wp-gpios", NULL)) {
>> +               pdata->gpio_wp = of_get_named_gpio(np, "wp-gpios", 0);
>> +               if (pdata->gpio_wp == -ENODEV)
>> +                       pdata->gpio_wp = -EPROBE_DEFER;
>> +       } else {
>> +               pdata->gpio_wp = -ENODEV;
>> +       }
> 
> This is still very ugly and there is a certain danfer that we might
> have to duplicate this across more drivers. Can't we make
> of_get_named_gpio_flags return -EPROBE_DEFER in cases where we can't
> find the GPIO number yet but still have a chance of returning it at
> a later point?

OK, will post a new patch.

Roland
