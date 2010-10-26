Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab0JZJFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:05:13 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:16500 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757877Ab0JZJFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:05:11 -0400
Message-ID: <001a01cb74ec$e3eb3ea0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Ralf Baechle" <ralf@linux-mips.org>, <linux-i2c@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Wang Qi\"" <qi.wang@intel.com>,
        "Wang Yong Y\"" <yong.y.wang@intel.com>, <kok.howg.ewe@intel.com>,
        <joel.clark@intel.com>, <andrew.chih.howe.khor@intel.com>
References: <4CC645A1.5010509@dsn.okisemi.com> <20101026102048.316d0c04@endymion.delvare>
Subject: Re: [PATCH v3] Topcliff: Update PCH_I2C driver to 2.6.36
Date: Tue, 26 Oct 2010 18:05:07 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 26, 2010 5:20 PM, Jean Delvare wrote:

> I don't like this driver name at all. For one thing, "pch" is too
> short. Many other vendors could come up with names with acronym "PCH".
>
> For another, Intel has many PCH (Platform Controller Hub) chips, some
> of them (5/3400 Series, Cougar Point, Patsburg) are or will be
> supported by the i2c-i801 driver, some of them (Moorestown) will be
> supported by the upcoming i2c-intel-mid driver (even though the name
> "PCH" is surprisingly missing from the source code) and your driver
> only supports one particular model.
Yes, this driver suppors only Topcliff(Intel Atom E6xx series) now.

>
> So please find a name which accurately represents the hardware your
> driver is for. i2c-topcliff would be fine with me, but you will have to
> check with Intel, as I know they are quite picky with the usage of code
> names.

Most drivers for Topcliff have been accepted with "pch_" prefix.
Only SPI driver, like you indicates, have accepted as spi_topcliff_pch.c.
If you request,  I can modify "pch_i2c.c" to "i2c-topcliff_pch.c".

>
> As for the driver code, I will not be able to review it, sorry. It's
> not in my area, I don't have the time and I don't have the hardware. I
> think it would make sense for Intel people to review and test it before
> it gets upstream.
No problem!
After reviewing by Intel(:CCed), we started posting to LKML and
we have already tested this patch on the EVA Board.

Tuhs, I want you to merge to this patch to 2.6.37 ASAP.

Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)

----- Original Message ----- 
From: "Jean Delvare" <khali@linux-fr.org>
To: "Tomoya" <tomoya-linux@dsn.okisemi.com>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>; "Wolfram Sang" <w.sang@pengutronix.de>; "Ralf Baechle"
<ralf@linux-mips.org>; <linux-i2c@vger.kernel.org>; "LKML" <linux-kernel@vger.kernel.org>; "Ben Dooks (embedded
platforms)" <ben-linux@fluff.org>; "Linus Walleij" <linus.walleij@stericsson.com>; "srinidhi kasagar"
<srinidhi.kasagar@stericsson.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; "Wang Qi"" <qi.wang@intel.com>;
"Wang Yong Y"" <yong.y.wang@intel.com>; <kok.howg.ewe@intel.com>; <joel.clark@intel.com>;
<andrew.chih.howe.khor@intel.com>
Sent: Tuesday, October 26, 2010 5:20 PM
Subject: Re: [PATCH v3] Topcliff: Update PCH_I2C driver to 2.6.36


> Hi Tomoya,
>
> On Tue, 26 Oct 2010 12:06:09 +0900, Tomoya wrote:
> > Could you merge this patch to 2.6.37 ?
> >
> > Change Summary
> >  - Change Author
> >  - Change Name of "Signed-off-by"
> >
> > Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)
> >
> > ---
> > I2C driver of Topcliff PCH
> >
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has I2C I/F. Using this I/F, it is able to access system
> > devices connected to I2C.
> >
> > Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> > Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
> >
> > ---
> >  drivers/i2c/busses/Kconfig   |    8 +
> >  drivers/i2c/busses/Makefile  |    1 +
> >  drivers/i2c/busses/i2c-pch.c |  908 ++++++++++++++++++++++++++++++++++++++++++
>
> I don't like this driver name at all. For one thing, "pch" is too
> short. Many other vendors could come up with names with acronym "PCH".
>
> For another, Intel has many PCH (Platform Controller Hub) chips, some
> of them (5/3400 Series, Cougar Point, Patsburg) are or will be
> supported by the i2c-i801 driver, some of them (Moorestown) will be
> supported by the upcoming i2c-intel-mid driver (even though the name
> "PCH" is surprisingly missing from the source code) and your driver
> only supports one particular model.
>
> So please find a name which accurately represents the hardware your
> driver is for. i2c-topcliff would be fine with me, but you will have to
> check with Intel, as I know they are quite picky with the usage of code
> names.
>
> As for the driver code, I will not be able to review it, sorry. It's
> not in my area, I don't have the time and I don't have the hardware. I
> think it would make sense for Intel people to review and test it before
> it gets upstream.
>
> -- 
> Jean Delvare
>

