Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114Ab0IIHD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:03:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60771 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0IIHDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xJPBY+0bXdCfNKGHYfY2cTtg3v8lPgsfOpAhqpu3VNyzjsivqtwxuAxV3hQQOo9dGl
         8g+HjWuGtupzflI0IUlW1ADmpO3N8IPHqR2sRGocbPrDhioG3AxGtUWAkPoy9WKSCDcb
         Yn1qat8eimXX05Y9GOZB/aXI/8RSj7RJz8eM4=
MIME-Version: 1.0
In-Reply-To: <20100908155114.880463fc.akpm@linux-foundation.org>
References: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com>
	<20100908155114.880463fc.akpm@linux-foundation.org>
Date: Thu, 9 Sep 2010 09:03:17 +0200
Message-ID: <AANLkTinADjBaOcfdtGRZK0WdMs0xt+PLWGE7NUBndRr_@mail.gmail.com>
Subject: Re: [PATCH] MMC: move regulator handling closer to core v3
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/9 Andrew Morton <akpm@linux-foundation.org>:
> On Sun,  5 Sep 2010 11:05:38 +0200
> Linus Walleij <linus.walleij@stericsson.com> wrote:
>> +     if (host->vcc) {
>> +             int ret;
>> +
>> +             if (power_mode == MMC_POWER_UP)
>> +                     ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
>> +             else if (power_mode == MMC_POWER_OFF)
>> +                     ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
>> +     }
>
> There's no point in copying the return value into a local then ignoring
> it.  mmc_regulator_set_ocr() can return a negative errno so we should
> test for that, clean up and propagate the error.

OK I'll fix.

> The same comments apply to mmci_set_ios().

OK.

Yours,
Linus Walleij
