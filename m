Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2CFGEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:04:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43974 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2CFGEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:04:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of haojian.zhuang@gmail.com designates 10.220.8.195 as permitted sender) smtp.mail=haojian.zhuang@gmail.com; dkim=pass header.i=haojian.zhuang@gmail.com
MIME-Version: 1.0
In-Reply-To: <201203021355.21669.heiko@sntech.de>
References: <201203021355.21669.heiko@sntech.de>
Date: Tue, 6 Mar 2012 14:04:46 +0800
Message-ID: <CAN1soZwTR=j6=Xi-WKSTQwkGu+58pePb1syD+2q0UhHUJnfg_Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] Remove bq24022 driver superseeded by gpio-regulator
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 8:55 PM, Heiko Stübner <heiko@sntech.de> wrote:
> The bq24022 regulator is simply a more specialised variant of the now
> present gpio-regulator. Therefore it probably shouldn't stay around.
>
> This series converts the two users of bq24022 pxa/hx4700 and
> pxa/magician to use the gpio-regulator instead, and after this removes
> the then unused bq24022 driver.
>
> The series was compile-tested only, but the gpio-regulator itself is
> sucessfully used on my platform for the dcdc3 of a tps650240 (voltage
> regulator with one gpio) and for a bq24075 (current regulator with two
> gpios). So I'm quite sure it should work correctly but would welcome
> testers :-) .
>
> Heiko Stuebner (2):
>  pxa: magician/hx4700: Convert to gpio-regulator from bq24022
>  regulator: Remove bq24022 regulator driver
>
>  arch/arm/configs/magician_defconfig |    2 +-
>  arch/arm/mach-pxa/hx4700.c          |   33 ++++++--
>  arch/arm/mach-pxa/magician.c        |   33 ++++++--
>  drivers/regulator/Kconfig           |    8 --
>  drivers/regulator/Makefile          |    1 -
>  drivers/regulator/bq24022.c         |  162 -----------------------------------
>  include/linux/regulator/bq24022.h   |   24 -----
>  7 files changed, 55 insertions(+), 208 deletions(-)
>  delete mode 100644 drivers/regulator/bq24022.c
>  delete mode 100644 include/linux/regulator/bq24022.h
>
> --
Hi Mark,

I'm planning to merge this patch into arch-pxa tree since some changes
on hx4700.c and magician.c. Is it ok fot you?

Best Regards
Haojian
