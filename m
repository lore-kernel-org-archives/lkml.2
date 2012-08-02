Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2HBKak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:30:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2HBKai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:30:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH 2/5] clk: mmp: add clock definition for pxa168
Date: Thu, 2 Aug 2012 10:30:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1343716792-10399-1-git-send-email-xiechao.mail@gmail.com> <201207311154.42866.arnd@arndb.de> <CADApbegvdRQ5swDrO-Y631K4AhsTigAG4=Mm82mT-smSA7XzJw@mail.gmail.com>
In-Reply-To: <CADApbegvdRQ5swDrO-Y631K4AhsTigAG4=Mm82mT-smSA7XzJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208021030.19986.arnd@arndb.de>
X-Provags-ID: V02:K0:3xZ6Ka6CWJ/gvdjVvS0lTtxDXcHLZwnNgkcQvtPmckM
 9ryWMr9TxeLXefAJn5hrHO30gm2vsVHiiNqukZ8aM0DNLLE3L5
 JoMPQSvuQ9kG0XBnN1beE7BhDZpB9YFW5m8Nxb1M7uATarDbT6
 +t4vMslTi8GFkainajLY9SlCTWGzVO4cnsCgK8ce6EF3TLYeij
 qSUJMia9V/6GE5Xs28niSUI3r6PqkjlAo7+Bv04FTpzEIbYEuc
 45gI8y6zFmIEmukx4eLzUDIQu52hJ6tM2A2w+0V9Ycq3l7uP3O
 cds8hTvHBGdDkGB9dywdJBYsUfBGVCC+sEz1zV+rNsQeoPw+KZ
 7wnyvYjF+bnDpJGX2cig=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2012, Chao Xie wrote:
> > #define APBC_RTC       0x28
> >
> > apbc_clks[rtc_clk] = mmp_clk_register_apbc(rtc_clk, clk32k, APBC_RTC, 10, APBC_POWER_CTRL, mmp_clk_lock);
> > clk_register_clkdev(apbc_clks[rtc_clk], NULL, "sa1100-rtc");
> >
> >         Arnd
> >
> hi
> I would like to keep the mmp_clk_register_apbc to receive the "reg
> base" not "reg offset".
> It will be aligned with other kind of clock register APIs.
> To read out APBC base register from device tree can be added at the
> clock-pxa168.c, and it can map the registers and pass to the
> mmp_clk_register_apbc.

Right, my mistake.

The above should have been something like

#define APBC_RTC       0x28
apbc_clks[rtc_clk] = mmp_clk_register_apbc(rtc_clk, clk32k, clock_base + APBC_RTC, 10, APBC_POWER_CTRL, mmp_clk_lock);
clk_register_clkdev(apbc_clks[rtc_clk], NULL, "sa1100-rtc");

instead, with clock_base pointing to the __iomem token for the clock controller.

> Now, i have talked to Haojian who is doing device tree maintainer in
> pxa/mmp. This kind of support is not added.
> I suggest that after device tree support in clock can be added later
> after other functionality of the clock framework is fine.

You can do device tree support as a second step, but in this first step, you
should already start using ioremap to get the virtual address of the
clock controller, rather than hardcoding it.

	Arnd
