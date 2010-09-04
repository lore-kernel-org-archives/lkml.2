Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab0IDGLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:11:35 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18055 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0IDGLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:11:34 -0400
Message-ID: <4C81E2CF.8070406@nokia.com>
Date: Sat, 04 Sep 2010 09:10:23 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH] MMC: move regulator handling closer to core v2
References: <1283268367-3525-1-git-send-email-linus.walleij@stericsson.com> <AANLkTik-uLMUz2g2znaF0K43D8CONsGdjrRqxTCqpS_X@mail.gmail.com>
In-Reply-To: <AANLkTik-uLMUz2g2znaF0K43D8CONsGdjrRqxTCqpS_X@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2010 06:10:24.0309 (UTC) FILETIME=[DCC4EE50:01CB4BF7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 2010/8/31 Linus Walleij <linus.walleij@stericsson.com>:
> 
>> After discovering a problem in regulator reference counting I
>> took Mark Brown's advice to move the reference count into the
>> MMC core by making the regulator status a member of
>> struct mmc_host.
> 
> This has an Reveiwed-by from the regulator maintainer and
> seems to address all comments, noone is objection so Andrew
> can you pick it up?

One of our contractors had a look at the patch and had this comment:

One comment/question:
/host/mmci.c in function
"static int __devexit mmci_remove(struct amba_device *dev)" there is code:
         if (regulator_is_enabled(host->vcc))
             regulator_disable(host->vcc);
should "ret = mmc_regulator_set_ocr(mmc, host->vcc, 0);" be added here?

> 
> Yours,
> Linus Walleij
> 

