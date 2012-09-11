Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2IKNdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:33:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60780 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2IKNdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <CADApbejRM9RkEjX2VAPVG18gip=OH5WWeS_NwEoCKgOZ_PgmLA@mail.gmail.com>
References: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
	<20120825002151.18366.99434@nucleus>
	<CADApbehotHB7JSCHdo_eoTb08C5Pe6ewh7whwckQTyuCcMM=BQ@mail.gmail.com>
	<20120829182639.4450.99900@nucleus>
	<CADApbejRM9RkEjX2VAPVG18gip=OH5WWeS_NwEoCKgOZ_PgmLA@mail.gmail.com>
Date: Tue, 11 Sep 2012 21:33:15 +0800
Message-ID: <CAN1soZxYrQL05TdWT1083_L23b6iApfS_oX+BKxmtaBpe6k+NA@mail.gmail.com>
Subject: Re: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 1:54 PM, Chao Xie <xiechao.mail@gmail.com> wrote:
> On Thu, Aug 30, 2012 at 2:26 AM, Mike Turquette <mturquette@linaro.org> wrote:
>> Quoting Chao Xie (2012-08-26 18:19:02)
>>> On Sat, Aug 25, 2012 at 8:21 AM, Mike Turquette <mturquette@linaro.org> wrote:
>>> > Quoting Chao Xie (2012-08-19 19:55:10)
>>> >> From: Chao Xie <chao.xie@marvell.com>
>>> >>  arch/arm/mach-mmp/Kconfig    |    3 +
>>> >>  drivers/clk/Makefile         |    3 +
>>> >>  drivers/clk/mmp/Makefile     |    9 +
>>> >>  drivers/clk/mmp/clk-apbc.c   |  152 ++++++++++++++
>>> >>  drivers/clk/mmp/clk-apmu.c   |   97 +++++++++
>>> >>  drivers/clk/mmp/clk-frac.c   |  153 ++++++++++++++
>>> >>  drivers/clk/mmp/clk-mmp2.c   |  449 ++++++++++++++++++++++++++++++++++++++++++
>>> >>  drivers/clk/mmp/clk-pxa168.c |  346 ++++++++++++++++++++++++++++++++
>>> >>  drivers/clk/mmp/clk-pxa910.c |  320 ++++++++++++++++++++++++++++++
>>> >>  drivers/clk/mmp/clk.h        |   35 ++++
>>> >
>>> > Looks like you are not removing your arch/arm/mach-mmp/clock.c.  Is that
>>> > intentional?
>>> >
>>> > When I apply your series against v3.6-rc3 I find that compilation breaks
>>> > with mmp2_defconfig due to conflicting definitions for the clk api
>>> > (clk_enable, clk_set_rate, etc).  This is not surprising since your
>>> > legacy clock code is neither deleted nor removed from compilation
>>> > conditionally by checking for CONFIG_COMMON_CLK.
>>> >
>>> > Did I somehow manage to misapply your patches or should your patches
>>> > have removed the arch-specific clock framework as well?
>>> >
>>> hi, Mike
>>> Yes. There are some patches for seperate the original clock code in arch.
>>> I had sent these patches before, but it seems that too many patches
>>> sent, and haojian missed it.
>>> I will sent out the patches for arch today. Thanks.
>>>
>>
>> I pulled in the dependency series and the build goes through nicely now.
>> I'm happy to take these five patches into clk-next but of course mmp
>> will have problems building clk-next without the dependencies, which I
>> assume are going through arm-soc.
>>
>> Regards,
>> Mike
>>
>>> > Regards,
>>> > Mike
>>> >
>>> >>  10 files changed, 1567 insertions(+), 0 deletions(-)
>>> >>  create mode 100644 drivers/clk/mmp/Makefile
>>> >>  create mode 100644 drivers/clk/mmp/clk-apbc.c
>>> >>  create mode 100644 drivers/clk/mmp/clk-apmu.c
>>> >>  create mode 100644 drivers/clk/mmp/clk-frac.c
>>> >>  create mode 100644 drivers/clk/mmp/clk-mmp2.c
>>> >>  create mode 100644 drivers/clk/mmp/clk-pxa168.c
>>> >>  create mode 100644 drivers/clk/mmp/clk-pxa910.c
>>> >>  create mode 100644 drivers/clk/mmp/clk.h
>
> Thanks.
> I think Haojian who is the maintainer of pxa and mmp will help to
> integrate the dependency patches.

I've applied. Now I'm waiting for Arnd's pull into arm-soc tree.
