Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2HYAWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 20:22:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34026 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2HYAWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 20:22:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
User-Agent: alot/0.3.2+
To: Chao Xie <xiechao.mail@gmail.com>, haojian.zhuang@gmail.com,
        viresh.linux@gmail.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        chao.xie@marvell.com, arnd@arndb.de
References: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
Message-ID: <20120825002151.18366.99434@nucleus>
Subject: Re: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
Date: Fri, 24 Aug 2012 17:21:51 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chao Xie (2012-08-19 19:55:10)
> From: Chao Xie <chao.xie@marvell.com>
>  arch/arm/mach-mmp/Kconfig    |    3 +
>  drivers/clk/Makefile         |    3 +
>  drivers/clk/mmp/Makefile     |    9 +
>  drivers/clk/mmp/clk-apbc.c   |  152 ++++++++++++++
>  drivers/clk/mmp/clk-apmu.c   |   97 +++++++++
>  drivers/clk/mmp/clk-frac.c   |  153 ++++++++++++++
>  drivers/clk/mmp/clk-mmp2.c   |  449 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/mmp/clk-pxa168.c |  346 ++++++++++++++++++++++++++++++++
>  drivers/clk/mmp/clk-pxa910.c |  320 ++++++++++++++++++++++++++++++
>  drivers/clk/mmp/clk.h        |   35 ++++

Looks like you are not removing your arch/arm/mach-mmp/clock.c.  Is that
intentional?

When I apply your series against v3.6-rc3 I find that compilation breaks
with mmp2_defconfig due to conflicting definitions for the clk api
(clk_enable, clk_set_rate, etc).  This is not surprising since your
legacy clock code is neither deleted nor removed from compilation
conditionally by checking for CONFIG_COMMON_CLK.

Did I somehow manage to misapply your patches or should your patches
have removed the arch-specific clock framework as well?

Regards,
Mike

>  10 files changed, 1567 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/mmp/Makefile
>  create mode 100644 drivers/clk/mmp/clk-apbc.c
>  create mode 100644 drivers/clk/mmp/clk-apmu.c
>  create mode 100644 drivers/clk/mmp/clk-frac.c
>  create mode 100644 drivers/clk/mmp/clk-mmp2.c
>  create mode 100644 drivers/clk/mmp/clk-pxa168.c
>  create mode 100644 drivers/clk/mmp/clk-pxa910.c
>  create mode 100644 drivers/clk/mmp/clk.h
