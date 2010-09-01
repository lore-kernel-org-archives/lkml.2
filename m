Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0IAFIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 01:08:40 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:45932 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab0IAFIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 01:08:39 -0400
Message-ID: <001e01cb4993$bc0d75d0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Joe Perches" <joe@perches.com>
Cc: "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Crane Cai" <crane.cai@amd.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Wang Yong Y\"" <yong.y.wang@intel.com>,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Andrew\"" <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Arnd Bergmann" <arnd@arndb.de>
References: <4C7DB9CF.5000905@dsn.okisemi.com> <1283309032.1797.123.camel@Joe-Laptop>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
Date: Wed, 1 Sep 2010 14:08:32 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

I have a question.
Current our I2C driver  has the following 2 patterns dev_err().

(1) dev_err(adap->pch_adapter.dev.parent, "...");

(2) dev_err(&pdev->dev, "...");


> #define pch_err(adap, fmt, arg...) \
> dev_err(adap->pch_adapter.dev.parent, fmt, ##arg)

In case of using the above code, pattern (1) can apply, but (2) can't.

As to (2),
Should we use as dev_err or define another macro?

Thanks, Ohtake(OKISemi)

----- Original Message ----- 
From: "Joe Perches" <joe@perches.com>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>; "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>;
"Crane Cai" <crane.cai@amd.com>; "Samuel Ortiz" <sameo@linux.intel.com>; "Linus Walleij" <linus.walleij@stericsson.com>;
"Ralf Baechle" <ralf@linux-mips.org>; "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>; <linux-i2c@vger.kernel.org>;
<linux-kernel@vger.kernel.org>; "Wang Yong Y"" <yong.y.wang@intel.com>; "Wang Qi"" <qi.wang@intel.com>; "Andrew""
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; "Arnd
Bergmann" <arnd@arndb.de>
Sent: Wednesday, September 01, 2010 11:43 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35


> On Wed, 2010-09-01 at 11:26 +0900, Masayuki Ohtak wrote:
> > I2C driver of Topcliff PCH
> > +++ b/drivers/i2c/busses/i2c-pch.c
> []
> > +static void pch_init(struct i2c_algo_pch_data *adap)
> []
> > + if (pch_i2c_speed == FAST_MODE_CLK) {
> > + reg_value |= FAST_MODE_EN;
> > + dev_dbg(adap->pch_adapter.dev.parent, "Fast mode enabled\n");
> > + }
>
> Just a suggestion below, ignore it at your pleasure...
>
> These dev_<level> calls might be easier to read if you had
> some #defines like:
>
> #define pch_dbg(adap, fmt, arg...) \
> dev_dbg(adap->pch_adapter.dev.parent, fmt, ##arg)
> #define pch_err(adap, fmt, arg...) \
> dev_err(adap->pch_adapter.dev.parent, fmt, ##arg)
> #define pch_info(adap, fmt, arg...) \
> dev_info(adap->pch_adapter.dev.parent, fmt, ##arg)
>
> then the last dev_dbg becomes:
>
> pch_dbg(adap, "Fast mode enabled\n");
>
> Many modules use similar wrapper #defines.
>
> > + dev_dbg(adap->pch_adapter.dev.parent,
> > + "%s: I2CCTL=%x pch_i2cbc=%x pch_i2ctmr=%x Enable interrupts\n",
> > + __func__, ioread32(p + PCH_I2CCTL),
> > + pch_i2cbc, pch_i2ctmr);
>
> pch_dbg(adap, etc...)
>
> etc.
>
> cheers, Joe
>


