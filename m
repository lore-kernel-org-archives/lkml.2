Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab2CZSiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:38:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57225 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab2CZSiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5Bw4fFOYSDyiE8o9AnnrzTOukJtA1JFbNBeMMzx-jBVvA@mail.gmail.com>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
	<1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
	<CAOMZO5DL8YQT2qb=vxdQtdN+zfZLK9H9_1qu5sS+1YAvSo5SAA@mail.gmail.com>
	<20120326181912.GV3852@pengutronix.de>
	<CAOMZO5Bw4fFOYSDyiE8o9AnnrzTOukJtA1JFbNBeMMzx-jBVvA@mail.gmail.com>
Date: Mon, 26 Mar 2012 15:38:19 -0300
Message-ID: <CAOMZO5Am-igTOwWhGRmd0PCihUaWMQPEMxWJk4YuezafMJStjA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM i.MX 3ds debugboard: register a dummy regulator
 for the smsc911x device
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Estevam Fabio-R49496 <r49496@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 3:25 PM, Fabio Estevam <festevam@gmail.com> wrote:
> On Mon, Mar 26, 2012 at 3:19 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
>> At least it did work when I sent the patches, but -EPROBE_DEFER did not
>> exist at that time. Do you have the fixed regulator enabled in your
>> config?
>
> Yes, I do. I am using imx_v6_v7_defconfig, which has fixed regulator
> enabled by default.

--- a/arch/arm/plat-mxc/3ds_debugboard.c
+++ b/arch/arm/plat-mxc/3ds_debugboard.c
@@ -151,8 +151,8 @@ static struct irq_chip expio_irq_chip = {
 };

If I do the change below, smsc driver is probed correctly:

 static struct regulator_consumer_supply dummy_supplies[] = {
-       REGULATOR_SUPPLY("vdd33a", "smsc911x"),
-       REGULATOR_SUPPLY("vddvario", "smsc911x"),
+       REGULATOR_SUPPLY("vdd33a", NULL),
+       REGULATOR_SUPPLY("vddvario", NULL),
 };

Is this OK?
