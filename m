Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab0KOCHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:07:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50137 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab0KOCHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=S2SaCTITiTNl9ys4HQkTEtfmVes0yi2nQrju5qK2K4MZWsfwkWLwOuLl/iDEAcft1Y
         JP9FpS1QyBmL44MSPTXodUwTAj0hulPWVSJwLKPkO3UioGJOofdHOb74GVFunX7cm8po
         dDXy+RE145orXhfaTyQAQKt6qQYRBBPLNb3l0=
MIME-Version: 1.0
In-Reply-To: <1289627397.2837.44.camel@diamond.house>
References: <1289627397.2837.44.camel@diamond.house>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 15 Nov 2010 10:07:14 +0800
Message-ID: <AANLkTi=j41UA5ZeO8-AVXf53+OD+P2V=mEvZESWdVqka@mail.gmail.com>
Subject: Re: [PATCH] ARM: fix some trivial compiler warnings
To: Jason Chagas <jason.chagas@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 1:49 PM, Jason Chagas <jason.chagas@gmail.com> wrote:
>
> From acb6004dae483e61760714286a5e544c4a1d899c Mon Sep 17 00:00:00 2001
> From: Jason Chagas <jason.chagas@marvell.com>
> Date: Sat, 13 Nov 2010 00:01:44 -0500
> Subject: [PATCH] ARM: fix some trivial compiler warnings
>
> arch/arm/kernel/ptrace.c: In function 'get_branch_address':
> arch/arm/kernel/ptrace.c:429: warning: comparison between pointer and
> integer
> arch/arm/kernel/ptrace.c:429: warning: comparison between pointer and
> integer
>
> arch/arm/mach-mmp/mmp2.c:127: warning: 'clk_rtc' defined but not used
>
> drivers/i2c/busses/i2c-pxa.c: In function 'i2c_pxa_probe':
> drivers/i2c/busses/i2c-pxa.c:1004: warning: initialization discards
> qualifiers from pointer target type
>
> Signed-off-by: Jason Chagas <jason.chagas@marvell.com>
> ---
>  arch/arm/kernel/ptrace.c     |    2 +-
>  arch/arm/mach-mmp/mmp2.c     |    1 -
>  drivers/i2c/busses/i2c-pxa.c |    2 +-
>  3 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index cf16bca..7bb9a88 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -426,7 +426,7 @@ get_branch_address(struct task_struct *child,
> unsigned long pc, unsigned long in
>            break;
>        }
>
> -       if (alt >= (void*)CONFIG_VECTORS_BASE && alt <
> (void*)CONFIG_VECTORS_BASE + PAGE_SIZE)
> +       if (alt >= CONFIG_VECTORS_BASE && alt < CONFIG_VECTORS_BASE +
> PAGE_SIZE)
>                alt = get_user_reg(child, REG_LR);
>
>        return alt;
> diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
> index 7f5eb05..3028bb7 100644
> --- a/arch/arm/mach-mmp/mmp2.c
> +++ b/arch/arm/mach-mmp/mmp2.c
> @@ -124,7 +124,6 @@ static APBC_CLK(twsi3, MMP2_TWSI3, 0, 26000000);
>  static APBC_CLK(twsi4, MMP2_TWSI4, 0, 26000000);
>  static APBC_CLK(twsi5, MMP2_TWSI5, 0, 26000000);
>  static APBC_CLK(twsi6, MMP2_TWSI6, 0, 26000000);
> -static APBC_CLK(rtc, MMP2_RTC, 0, 32768);
>
>  static APMU_CLK(nand, NAND, 0xbf, 100000000);
>

Jason,

I've separated this into an individual patch with comment as follows:

commit f1064ce43b6c4e6aa4d122600db2e952c79bec91
Author: Jason Chagas <jason.chagas@marvell.com>
Date:   Mon Nov 15 09:50:12 2010 +0800

    ARM: mmp2: remove not used clk_rtc

    RTC clock will remain at 32KHz and powered on, there is no need for it
    at this moment.

    Signed-off-by: Jason Chagas <jason.chagas@marvell.com>

diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
index daf3993..2e3dd08 100644
--- a/arch/arm/mach-mmp/mmp2.c
+++ b/arch/arm/mach-mmp/mmp2.c
@@ -126,7 +126,6 @@ static APBC_CLK(twsi3, MMP2_TWSI3, 0, 26000000);
 static APBC_CLK(twsi4, MMP2_TWSI4, 0, 26000000);
 static APBC_CLK(twsi5, MMP2_TWSI5, 0, 26000000);
 static APBC_CLK(twsi6, MMP2_TWSI6, 0, 26000000);
-static APBC_CLK(rtc, MMP2_RTC, 0, 32768);

 static APMU_CLK(nand, NAND, 0xbf, 100000000);


> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index 020ff23..c94e51b 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1001,7 +1001,7 @@ static int i2c_pxa_probe(struct platform_device
> *dev)
>        struct pxa_i2c *i2c;
>        struct resource *res;
>        struct i2c_pxa_platform_data *plat = dev->dev.platform_data;
> -       struct platform_device_id *id = platform_get_device_id(dev);
> +       const struct platform_device_id *id = platform_get_device_id(dev);
>        int ret;
>        int irq;
>

This has been fixed in the latest tree by the commit below:

commit 21e2ecfe19df8f28408b5a607fef8704f51fa7f8
Author: Marc Kleine-Budde <mkl@pengutronix.de>
Date:   Tue Jun 15 10:56:45 2010 +0200

    i2c-pxa: fix compiler warning, due to missing const

    This patch adds the missing const to "struct platform_device_id" to fix
    this warning:

    /home/frogger/pengutronix/linux/linux-2.6/drivers/i2c/busses/i2c-pxa.c:
    In function 'i2c_pxa_probe':
    /home/frogger/pengutronix/linux/linux-2.6/drivers/i2c/busses/i2c-pxa.c:1004:
    warning: initialization discards qualifiers from pointer target type

    Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
    Cc: Eric Miao <eric.y.miao@gmail.com>
    Cc: Roel Kluin <roel.kluin@gmail.com>
    Cc: Pavel Machek <pavel@ucw.cz>
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 020ff23..c94e51b 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1001,7 +1001,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
        struct pxa_i2c *i2c;
        struct resource *res;
        struct i2c_pxa_platform_data *plat = dev->dev.platform_data;
-       struct platform_device_id *id = platform_get_device_id(dev);
+       const struct platform_device_id *id = platform_get_device_id(dev);
        int ret;
        int irq;
