Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0IFAoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:44:18 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11517 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab0IFAoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:44:17 -0400
Message-ID: <000a01cb4d5c$a1bcb520$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Crane Cai" <crane.cai@amd.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Linus Walleij" <linus.walleij@stericsson.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joe@perches.com>, <yong.y.wang@intel.com>, <qi.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Arnd Bergmann" <arnd@arndb.de>
References: <4C80CBC0.5050908@dsn.okisemi.com> <20100903133613.1c519c49@lxorguk.ukuu.org.uk>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
Date: Mon, 6 Sep 2010 09:43:08 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for your comments.
We will update and resubmit soon.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>; "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>;
"Crane Cai" <crane.cai@amd.com>; "Samuel Ortiz" <sameo@linux.intel.com>; "Linus Walleij" <linus.walleij@stericsson.com>;
"Ralf Baechle" <ralf@linux-mips.org>; "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>; <linux-i2c@vger.kernel.org>;
<linux-kernel@vger.kernel.org>; <joe@perches.com>; <yong.y.wang@intel.com>; <qi.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; "Arnd
Bergmann" <arnd@arndb.de>
Sent: Friday, September 03, 2010 9:36 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35


> > +config PCH_I2C_CH_COUNT
> > + int "PCH I2C the number of channel count"
> > + range 1 2
> > + depends on PCH_I2C
> > + help
> > +   This driver is for PCH(Platform controller Hub) I2C of Topcliff which
> > +   is an IOH(Input/Output Hub) for x86 embedded processor.
> > +   The number of I2C buses/channels supported by the PCH I2C controller.
> > +   PCH I2C of Topcliff supports only one channel.
>
> These sort of settings need to be runtime so one kernel can be built for
> many platform variants. In this case if I understand correctly the
> current device only has one channel so the define could just be moved
> into the driver for now and made a variable later as/when/if new hardware
> with more channels appears.
>
>
>
> > +static s32 pch_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
> > +{
> > + s32 ret;
> > + ret = wait_event_interruptible_timeout(pch_event,
> > + (adap->pch_event_flag != 0), msecs_to_jiffies(50));
> > + if (ret < 0) {
> > + pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
> > + return ret;
> > + }
>
> You are reporting a timeout when _interruptible can also be woken by a
> signal to the process (eg the user hitting ^C)
>
>


