Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab0IEJFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 05:05:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64441 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0IEJFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 05:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oAPYBHRD8rheCu48ibK6qhbHZsqXmgoRe9/L79IWzsld886tLxVLCNOeT/09JyUf/R
         Ex9OzmQ7p6Q3cBBn9IwQNEiOuBJTS/FsIycoy6VSl4CpLvKuwfCMsoaoOswPion53HVp
         LAfatgF/a9nD07ytcMjRtWcFvNGadU6oboJiY=
MIME-Version: 1.0
In-Reply-To: <4C81E2CF.8070406@nokia.com>
References: <1283268367-3525-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTik-uLMUz2g2znaF0K43D8CONsGdjrRqxTCqpS_X@mail.gmail.com>
	<4C81E2CF.8070406@nokia.com>
Date: Sun, 5 Sep 2010 11:05:33 +0200
Message-ID: <AANLkTi=n=h=00QM-Tgy_3E425f+ZeTEkF=mfnUpt1+vS@mail.gmail.com>
Subject: Re: [PATCH] MMC: move regulator handling closer to core v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tony Lindgren <tony@atomide.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        "Lavinen Jarkko (Nokia-MS/Helsinki)" <jarkko.lavinen@nokia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/4 Adrian Hunter <adrian.hunter@nokia.com>:

> One of our contractors had a look at the patch and had this comment:
>
> One comment/question:
> /host/mmci.c in function
> "static int __devexit mmci_remove(struct amba_device *dev)" there is code:
>        if (regulator_is_enabled(host->vcc))
>            regulator_disable(host->vcc);
> should "ret = mmc_regulator_set_ocr(mmc, host->vcc, 0);" be added here?

Good catch!

Since it's in the remove() we can't do much about the return value from that
call but we should sure use the _set_ocr() so fixed it and pushed v3.

Yours,
Linus Walleij
